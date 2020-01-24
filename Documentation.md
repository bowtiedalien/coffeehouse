### Documentation 

#### Project Files

- `./lib/resources/data.dart`
- `./lib/resources/models.dart`
- `./lib/test/homepage.dart`
- `./lib/test/shopping_cart.dart`
- `./lib/test/profile_page.dart`
- `./lib/test/sign_in.dart`
- `./lib/test/sign_up.dart`
- `./lib/test/widget_test.dart`
- `./lib/main.dart`
- `./assets/images/` 
#### Screens & Widgets - their purposes

path: `./lib/test/`
- `main` method calls `MyApp()`
- `MyApp()` does the Splash Screen then calls `HomePage()`
- `HomePage()` does the routing between the three screens of the application (`HomePage()`, `ShoppingCart()` and `ProfilePage()`) according to the choice in the BottomNavigationBar
- `ShoppingCart()` acts only as the Provider of `MyShoppingCart()`. 
- `MyShoppingCart()` either calls its inner body; the screen where you view the order, enter address info and choose payment method - or calls `OrderInfoFinalised()` where the previous info appear as read-only 
and a confirmation message is shown at the bottom of the screen.
- `ProfilePage()` does routing between `MyProfilePage()` and `SignInSignUp()` screens. 
- `MyProfilePage()` shows the registered information of the user from Cloud Firestore and allows them to edit all info. 
It has a _Sign Out_ button to redirect to `SignIn()`.
- `SignInSignUp()` does routing between `SignUp()`, `SignIn()` or `MyProfilePage()`.
- `SignUp()` shows the Sign Up screen, with a button to redirect to `Sign In()`
- `SignIn()` shows the Sign In screen, with a button to redirect to `Sign Up()`

#### Methods, Lists and Variables in data.dart

path: `./lib/resources/data.dart`

- `void getCupSizes()` fills up the _cupSizes_ list, which feeds into the _items_ property of the first DropDownButton in `MyHomePage()`. 
- `void getFlavours()` fills up the _flavours_ list, which feeds into the _items_ property of the second DropDownButton in `MyHomePage()`.
- `void getUsers()` gets the list of users from Cloud Firestore. Gives value to `userDocID` which stays visible throughout the app, storing the document ID on Cloud Firestore of the current logged in user.
- `coffeeNames`, `coffeeImages`, `coffeePrices`, `coffeeDesc`, `coffeeIng` are all lists that store the data displayed in `MyHomePage()`.

#### Methods and helping Widgets in profile_page.dart

- `void updateProfileInfo()` works when user edits their profile information,
it sends the new data to Cloud Firestore.
- `Future getUserInfo()` retrieves all user information from Cloud Firestore and feeds them into global variables to be used in the profile page display.
- `_getCurrentLocation()` retrieves latitude and logitude of the user's current position. 
- `Widget userInfoBoxEditable()` shows TextFields in the profile page when user clicks _Edit my profile_ button.
- `Widget userInfoBox()` shows read-only version (text in containers) of the user info in the profile page.
- `Widget displayName()` displays the "Hello, User" header in the profile page.

#### Methods and helping Widgets in shopping_cart.dart

- `Future getOrderList()` retrieves the list of orders from Cloud Firestore and puts them in _orders_ list.
- `Stateful Widget orderTiles()` displays the order listview in the very top of the shopping cart screen, with the quantity buttons.
- `Stateful Widget OrderInfoFinalised()` is the state of the shopping cart after all information is submitted. It is a read-only view of the payment method, the address, the orders, and shows a confirmation text at the bottom.

#### What's inside models.dart

- `dropDownButtonDecoration` is a variable that stores the decoration for the DropDownButtons
- `Widget coffeeButton` builds buttons of the same styling across the app. 
- `curvedEdge` is a variable that stores the decoration of the curved-edge Container that I like.