# swiftTMDB

An iOS usecase app in searching, fetching and displaying movies using the Movie Database API.

This project explores MVVM in architecture, showcasing the separation of concerns between the view and the view model, testability by using abstraction and data encapsulation.

Written in Swift 6 and using UIKit.



### Note:

You cannot run the app directly. Xcode will produce a compileation error since there is a string placeholder in DataAPI() class where the token string should be.
The token is private and you need to create a free account in [the Movie Database](https://www.themoviedb.org) and get your API Read Access token key from account settings and add in in DataAPI().

If you want to simply check the code without registering for a token, click on the [Testflight](https://testflight.apple.com/join/1cfsc72Z) link on an iPhone/iPad/Mac and follow the instructions in the page.


### Coming next:

- SwiftUI 
- Unit Tests
