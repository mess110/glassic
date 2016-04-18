var app = angular.module('app', ['ngMaterial', 'ngStorage']);

String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
};

app.config(function($mdThemingProvider) {
    $mdThemingProvider.theme('default')
        .accentPalette('deep-purple');
});

app.directive("fileread", ['$mdToast', function ($mdToast) {
    return {
        scope: {
            fileread: "="
        },
    link: function (scope, element, attributes) {
        // TODO: extract to module
        showToast = function (s) {
            $mdToast.show($mdToast.simple().content(s).position('top right').hideDelay(3000));
        };

        element.bind("change", function (changeEvent) {
            var reader = new FileReader();
            reader.onload = function (loadEvent) {
                if (loadEvent.target.result.split('/')[1].split(';')[0] === 'png') {
                    scope.$apply(function () {
                        scope.fileread = loadEvent.target.result;
                    });
                } else {
                    showToast('png file required');
                }
            }
            reader.readAsDataURL(changeEvent.target.files[0]);
        });
    }
    }
}]);

app.directive('javaPackageName', function() {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function(scope, element, attr, ngModel) {
            function customValidator(ngModelValue) {
                var pkgs = ngModelValue.split('.')
                var contains3Dots = pkgs.length >= 3;
                var doesNotStartWithDot = ngModelValue.indexOf('.') != 0;
                var doesNotEndWithDot = !ngModelValue.endsWith('.')
                var reg = /^[a-z0-9\.]+$/.test(ngModelValue)
                // TODO: better validation

                var valid = contains3Dots && doesNotStartWithDot && doesNotEndWithDot && reg;
                ngModel.$setValidity('packageName', valid);
                return valid ? ngModelValue : undefined;
            }
            ngModel.$formatters.unshift(customValidator);
            ngModel.$parsers.unshift(customValidator);
        }
    };
});

app.controller('AppCtrl', ['$scope', '$mdToast', '$mdDialog', '$http', '$localStorage', '$interval', '$timeout', function($scope, $mdToast, $mdDialog, $http, $localStorage, $interval, $timeout) {
    $scope.page = {
      loading: false,
      view: 'build',
      progress: ''
    };

    $localStorage.beta = $localStorage.beta || false;
    $scope.androidIconSizes = ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi'];
    $scope.screenOrientations = ['unspecified', 'landscape', 'portrait'];
    $scope.windowSoftInputModes = ['stateUnspecified', 'stateUnchanged', 'stateHidden',
                                 'stateAlwaysHidden', 'stateVisible', 'stateAlwaysVisible',
                                 'adjustUnspecified', 'adjustResize', 'adjustPan'];

    function DialogController($scope, $mdDialog) {
        $scope.hide = function () {
            $mdDialog.hide();
        };
        $scope.cancel = function () {
            $mdDialog.cancel();
        };
        $scope.generate = function () {
            $mdDialog.hide({ noEmail: true });
        }
        $scope.answer = function (answer) {
            $mdDialog.hide($scope.config);
        };
    }

    $scope.config = {
        name: 'Glassic Reddit',
    url: 'https://m.reddit.com/',
    desktop: {
        width: 800,
      height: 600,
      fullscreen: false,
      resizable: false
    },
    android: {
        packageName: 'fallen.software.glassicreddit',
      screenOrientation: 'unspecified',
      windowSoftInputMode: 'stateUnspecified',
      offline: false,
      fullscreen: false
    },
    ios: {
        fullscreen: false
    }
    };

    $scope.isBeta = function () {
        return $localStorage.beta === true;
    };

    $scope.$watch('config.name', function (newValue, oldValue) {
        if (newValue == undefined) {
            return;
        }
        $scope.config.android.packageName = "fallen.software." + newValue.toLowerCase().replace(/\W+/g, '');
    });

  $scope.build = function (ev) {
      $mdDialog.show({
          controller: DialogController,
      templateUrl: 'build.tmpl.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose:true
      }).then(function(answer) {
          if (answer.noEmail == true) {
              $scope.generate();
          } else {
              $scope.config.email = answer.email;
              $scope.cloudBuild();
          }
      }, function() {
          $scope.status = 'You cancelled the dialog.';
      });
  };

  $scope.showHelp = function (ev) {
      $mdDialog.show({
          controller: DialogController,
      templateUrl: 'help.tmpl.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose:true
      }).then(function(answer) {
          $scope.status = 'You said the information was "' + answer + '".';
      }, function() {
          $scope.status = 'You cancelled the dialog.';
      });
  };

  showToast = function (s) {
      $mdToast.show($mdToast.simple().content(s).position('top right').hideDelay(3000));
  };

  generateGUID = function () {
      function s4() {
          return Math.floor((1 + Math.random()) * 0x10000)
              .toString(16)
          .substring(1);
      }
      return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
  }

  $scope.cloudBuild = function () {
      $scope.page.loading = true
      var guid = generateGUID()
      var fd = new FormData();
      fd.append('file0', zipFile());
      jsonParams = {
          parameter: [
              { name: 'generated.zip', file: 'file0' },
            { name: 'guid', value: guid }
          ]
      };
      fd.append('json', JSON.stringify(jsonParams));

      var config = {
          headers: {
              'Content-Type': undefined
          }
      };

      $http.post('http://glassic-jenkins.at.struktu.ro:8080/job/build-android/build', fd, config).then(function (data) {
          showToast($scope.config.name + " is queued");
          $scope.page.progress = 'queued';
          $scope.page.view = 'building'

          var queueInterval = $interval(function () {
              $http.get('http://glassic-jenkins.at.struktu.ro:8080/queue/api/json').then(function (data) {
                  var arr = data.data.items;
                  $scope.buildQueue = arr
                  $scope.page.progress = 'position in queue: ' + (arr.length)
                  if (arr.length > 0) {
                      for (var i = 0, l = arr.length; i < l; i++) {
                          var foundItem = arr[i];
                          var queueGuid = foundItem.actions[0].parameters[1].value;
                          if (queueGuid === guid) {
                              $interval.cancel(queueInterval);
                              var startInterval = $interval(function () {
                                  $http.get('http://glassic-jenkins.at.struktu.ro:8080/' + foundItem.url + '/api/json').then(function (data) {
                                      var result = data.data;
                                      if (result.blocked == false && ('executable' in result)) {
                                          $interval.cancel(startInterval)
                                          $scope.page.progress = 'starting build';
                                          var buildInterval  = $interval(function () {
                                              var jobUrl = result.executable.url + 'api/json';
                                              $http.get(jobUrl).then(function (data) {
                                                  var status = data.data;
                                                  if (status.building == true) {
                                                      $scope.page.progress = 'building';
                                                  } else {
                                                      $interval.cancel(buildInterval);
                                                      $scope.page.progress = status.result;
                                                      $scope.page.loading = false
                                                      $scope.page.view = 'result'
                                                  }
                                              }, function(error) {
                                                  console.log(error);
                                              });
                                          }, 2000)
                                      } else {
                                          // TODO build failed
                                      };
                                  }, function (error) {
                                      console.log(error);
                                  });
                              }, 2000);
                          }
                          var v = arr[i];
                      }
                  }
              }, function (error) {
                  console.log(error);
              });
          }, 2000)

      $scope.building = true
    }, function (data) {
        console.log(data);
    });
  };

  <!-- $timeout(function () { -->
      <!-- $scope.cloudBuild(); -->
  <!-- }) -->

  $scope.generate = function () {
      saveAs(zipFile(), $scope.config.name + '-glassic.zip');
      showToast("Extract the archive and run start.sh");
  };

  zipFile = function() {
      var zip = new JSZip();
      var folderName = 'app-glassic'
      zip.folder(folderName);
      zip.file(folderName + '/generated-config.json', angular.toJson($scope.config, true));
      var startCommands = [
          '#!/usr/bin/env sh',
      '',
      'node --version',
      'if [ $? -ne 0 ]; then',
      '  echo "ERROR: node.js not installed" 1>&2',
      '  exit 1',
      'fi',
      '',
      'git --version',
      'if [ $? -ne 0 ]; then',
      '  echo "ERROR: git not installed" 1>&2',
      '  exit 1',
      'fi',
      '',
      'git status',
      'if [ $? -ne 0 ]; then',
      '  git clone https://github.com/mess110/glassic',
      '  cp -rf glassic/* .',
      '  cp -rf glassic/.* .',
      '  rm -rf glassic/',
      '  mv generated-config.json config.json',
      'fi',
      '',
      'npm run glassic'
      ]
      zip.file(folderName + '/start.sh', startCommands.join('\n'));
      zip.folder(folderName + '/assets');

      var defaultIcon = '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';
      try {
          zip.file(folderName + '/assets/favicon.png', $scope.desktopIcon.split(',')[1], {base64: true});
      } catch (TypeError) {
          zip.file(folderName + '/assets/favicon.png', defaultIcon, {base64: true});
      }

      $scope.androidIconSizes.forEach(function(entry) {
          try {
              zip.file(folderName + '/assets/' + entry + '.png', $scope['androidIcon' + entry].split(',')[1], {base64: true});
          } catch (TypeError) {
              zip.file(folderName + '/assets/favicon.png', defaultIcon, {base64: true});
          }
      });

      return zip.generate({type: 'blob'});
  }
}]);
