## TLDR

Convert website into application for different platforms.

## How does it work?

- Template apps are created per technology (ex: android, ios, nw.js)
- A config file will be used to tweak different aspects of the templates
- The templates will have several customizable parameters
- The source code of the generated applications can be found in **templates/**

## Commands

Here is an overview of what the commands do.

    npm run help

      - prints help

    npm install

      - updates glassic
      - installs dependencies
      - compiles according to **config.json**
      - prints help

    npm run glassic

      - alias for npm install

    npm run demo:linux

      - installs linux dependencies
      - runs the application

    npm run demo:android

      - installs android dependencies
      - runs the clean task
      - compiles the application
      - prints android help

## TODO

- web
- build server
  - https
- package apps
  - https://github.com/nwjs/nw.js/wiki/how-to-package-and-distribute-your-apps
- android app
  - document android version
  - document build howto
- dekstop app
  - windows runner
  - mac runner
- iphone app
  - name
  - fullscreen
- include and respect licenses
- improve instructions from email
