# swiftTMDB

An iOS use case app in searching, fetching and displaying movies using the Movie Database API.

This project explores MVVM in architecture, showcasing the separation of concerns between the view and the view model, abstraction and data encapsulation.

Written in Swift 6 and using UIKit and SwiftUI (defaults to SwiftUI, use the related target to build each version).

##### Note:

**You cannot run the app directly. **

In DataAPI class there is a token value that needs a Bearer Token which is personalized to the Movie Database Developer account.

In order to get the Bearer token, create a free account in [the Movie Database](https://www.themoviedb.org) and get your Read Access token from account settings and add in DataAPI().

If, on the other hand, you don't want to register in the Movie Database but want to check the app, click on the [Testflight](https://testflight.apple.com/join/1cfsc72Z) link on an iPhone/iPad/Mac and follow the instructions on the page.

### Coming next:

- Unit Tests
