## Infrastructure

TODO: add uml

## Build Machines

### general build machine

These steps are common for all build machines

    sudo apt-get install git unzip lib32stdc++6 lib32z1 mailutils openjdk-7-jdk

- install jenkins
(* - add plugin https://wiki.jenkins-ci.org/display/JENKINS/Cors+Filter+Plugin *)
- add plugin nodejs
- add cors plugin
- add android plugin

- enable remote builds
- add file parameter

A job can be triggered with CURL:

    curl -X POST http://glassic-jenkins.at.struktu.ro:8080/job/build-android/build --form file0=@CoolBeans-glassic.zip --form json='{"parameter": [{"name":"generated.zip", "file":"file0"}]}'

### node build machine

Used for the desktop app. When packaging will be a thing, this will
probably need to be separated per OS.

### android build machine

Used for building the android app.

- ./android update sdk --no-ui
