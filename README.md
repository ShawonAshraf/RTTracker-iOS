# RT Tracker app for iOS
> Simulates movement on a map

## API?
- Uses Google API for map updates based on hardcoded coordinates.
- Doesn't use devices location services.
- The `REST API` that does the job can be found [here](https://github.com/ShawonAshraf/RTTracker-API)

## Pods in use
- GoogleMaps
- Alamofire
- PusherSwift

## Building and Usage
- Clone the repo
- `cd` into the directory
- Make sure you have [Cocoapods](https://cocoapods.org) installed and updated.
- Run the following command
```bash
pod install
```
- Open `RT Tracker iOS.xcworkspace`
- Get a Google Maps API key for iOS
- Update the API key in `AppDelegate.swift`
- Build and Run