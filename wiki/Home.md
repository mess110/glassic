## TLDR

Convert website into application for different platforms.

## How does it work?

- Template apps are created per technology (ex: android, ios, nw.js)
- A config file will be used to tweak different aspects of the templates
- The templates will have several customizable parameters
- The source code of the generated applications can be found in **templates/**

## Commands

Here is an overview of what the commands do.

    npm install

      - updates glassic
      - installs dependencies
      - compiles according to **config.json**
      - prints help

    npm run help

      - prints this help

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

- config file format
  - url
  - icon
  - name
  - fullscreen (android only)
  - keyboard overlay (android only)
- dekstop app as GUI (nw.js)
- android app
  - loading icon
  - document android version
  - document build howto
- dekstop app
  - windows runner
  - linux runner
  - mac runner
- include and respect licenses
- iphone app
