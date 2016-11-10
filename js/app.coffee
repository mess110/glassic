app = angular.module('app', [])

app.controller 'MainController', ($scope) ->
  $scope.count = 0

  $scope.click = ->
    $scope.count += 1

  $scope.yell = ->
    alert('hello')
