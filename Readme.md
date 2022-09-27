# MovieList

## Installation

```sh
pod install
```

## Architecture

As an architecture pattern I do prefer MVVM+C, I'm always forcing to use Coordinators as convenient navigation pattern, it also gives you an ability to understand navigation from code. I don't mind to use different architure pattern at the same project, for example we can use MVC+C for Details screen if there is no special business logic.

## Networking
About Networking Layer, I like to use my own solution for some reasons:
- It gives me an ability to create a custom mapper for different perposes
- same for Error handling, we can use different API and have different error types, It very important to be able to parse error by different ways. 
- Another cool feature is qucikly replace RequestManager, In case if we used third party framework which is no longer supported, or we would like to use few frameworks at the same time(it can be useful for Apollo GraphQL)


## Features I also would like to add
 - XcodeGen/Tuist - Project/Workspace generators, helps me to avoid a lot of conflicts from .xcodeproj files, split project for feature frameworks, and easily to observe not default build settings.
 - L10n/R.swift - Code generator for resources (strings/images/colors/fonts)
