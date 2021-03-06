# BPS-iOS

This is the iOS app repository for BPS.

## Getting Started

This project use [Carthage](https://github.com/carthage/carthage) and [CocoaPods](https://github.com/CocoaPods/CocoaPods) for managing the installed frameworks.

**Carthage Setup**

1. Install Carthage

 ```
 brew install carthage
 ```
 
2. Install the required frameworks (listed in `Cartfile.resolved`)

 ```
 carthage bootstrap
 ````
 
Optional: Run `carthage update --pathform iOS` to update the frameworks to the latest (listed in `Cartfile`)

**CocoaPods Setup**

 1. Install the dependencies
 
  ```
  pod install
  ```

## TODOs
**SDKs**
- [x] Add [Estimote SDK](https://github.com/Estimote/iOS-SDK)
- [x] Add [Parse SDK](https://github.com/ParsePlatform/Parse-SDK-iOS-OSX)
- [x] Add [CalendarKit](https://github.com/richardtop/CalendarKit)
- [x] Add [Stripe SDK](https://github.com/stripe/stripe-ios)
- [ ] Add [Parse Live Query SDK](https://github.com/ParsePlatform/ParseLiveQuery-iOS-OSX)

**Workflows**
- [x] Sign up & Sign in
- [x] Check-in parking space
- [x] Check-out parking space
- [x] Online payment
- [ ] Release timeslots (car park owner)
 
**UI Design**
- [x] Sign up & Sign in page
- [x] Show brief car park information in home view
- [x] Hour picker in check in
- [x] Floor plan web view
- [ ] Show a Google map button to display the car park location
