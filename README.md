# Movie Challenge Take-Home Project

## Overview

This app is a movie catalog viewer for the take-home project. 

This project has been setup from scratch using [Apollo](https://www.apollographql.com/docs/ios/) version 1.0.3, SwiftUI, and [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture).

GraphQL endpoint: https://podium-fe-challenge-2021.netlify.app/.netlify/functions/graphql

<img src="https://user-images.githubusercontent.com/67702957/201158784-1db59dad-b399-4bcd-875c-1ff48dd6836d.PNG" width="200"> <img src="https://user-images.githubusercontent.com/67702957/201159114-c028c0fd-9646-4e56-bb09-43d8e455e0ea.PNG" width="200"> <img src="https://user-images.githubusercontent.com/67702957/201159190-0d6d07c7-ee25-4409-9c6e-627181bb483f.PNG" width="200">

## Setup

### Requirements

- Xcode 14
- iOS 16 if running on physical device

### Build steps

1. Clone the repo
2. Open `Movie Challenge.xcodeproj`
3. Run

### Code generation

When changes are made to the `.graphql` queries perform the following steps.

Code generation is currently done manually using [Apollo Codegen CLI](https://www.apollographql.com/docs/ios/code-generation/codegen-cli) and is one of the first things I would improve moving forward. I recognize step 3 is clunky.

1. `cd MovieAPI`
2. `apollo-ios-cli generate`
3. Move generated `.graphql.swift` files from `/MovieAPI` to `/MovieAPI/GraphQL`

## Discussion

### Architecture

- GraphQL with Apollo 1.0.3
	- Local Swift Package for separation of concerns
	- Async/await wrapping of Apollo queries
	- Conversion of generated Apollo models to standardized models for app consumption
- Composable Architecture
	- Clear state management removing all logic from the view
- SwiftUI
	- iOS 16
	- NavigationStack with NavigationLink
- SPM for dependencies

### Objectives

When building this app it was important to me to create a solid app architecture that wouldn't just support the features I completed but would also be a good foundation for an expansion of further features. Also important was to show a clean app design that highlights the important data and doesn't get in the way or distract the user.

### Supported features

- Get Top 5 movies based on rating
- Browse all available movies
- Browse by genre
- Movie lists can be sorted by popularity, rating, title, and release date
- Movie detail screen showing:
	- Poster
	- Title
	- Release date
	- Rating
	- Popularity
	- Overview
	- Director
	- Cast with photos, name, and role
	- Genres
- View movie poster in fullscreen modal from movie detail screen
- Local caching of movie poster
- Lazy loading lists for performance
- Dynamic Type support
- Dark mode support

### Where to go next

These are some of the things I would add next if I were to continue developing this app.

#### Code gen

- Improve code generation by adding a build phase to generate changes automatically.
- Fix issue where the generated GraphQL queries are moved up one directory from `/MovieAPI/GraphQL`.

#### Testing

- Add test coverage for model conversion.
- Add test coverage for reducers to cover state changes based off actions.

#### Documentation

- Add documentation for `APIService` and query methods.
- Add documentation for MovieAPI models.

#### MovieAPI

- Add `Movie.Lightweight` and `Movie.Complete` models to replace current `Movie` model. `Lightweight` would be used for Top 5 and Movies List views and would include only the required data. `Complete` would include all available data. Converting between the models would be needed too. This would reduce the number of optionals and simplify the view code.

#### App refinement

- Local caching of data for improved offline experience
- Query pagination for infinite scrolling - important if data set was larger
- Add view placeholders when data is loading and not yet present so the view doesn't jump around when the data is loaded. This also acts as a loading indicator.
- Add subtle error notice when unable to fetch data

#### New features

- Accessibility support with Voice Over
- Search title, director, and cast

---

Still reading? Thanks for taking the time to thoroughly review my work! I hope we get an opportunity to discuss it together.
