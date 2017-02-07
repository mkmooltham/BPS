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
 ```
 pod install
 ```

## TODOs
**SDKs**
- [x] Add [Estimote SDK](https://github.com/Estimote/iOS-SDK)
- [x] Add [Parse SDK](https://github.com/ParsePlatform/Parse-SDK-iOS-OSX)
- [x] Add [CalendarKit](https://github.com/richardtop/CalendarKit)
- [ ] Add [Stripe SDK](https://github.com/stripe/stripe-ios)
- [ ] Add [Parse Live Query SDK](https://github.com/ParsePlatform/ParseLiveQuery-iOS-OSX)

**Workflows**
- [ ] Sign up & Sign in
- [ ] Check-in parking space
- [ ] Check-out parking space
- [ ] Online payment

**UI Design**
- [x] Sign up & Sign in page
- [ ] Show brief car park information in home view
- [ ] Hour picker in check in
- [ ] Floor plan web view
