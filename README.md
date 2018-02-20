# AZPeerToPeerConnection Controller


[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)
[![Swift version](https://img.shields.io/badge/swift%20-4.0-orange.svg)](https://img.shields.io/badge/swift%20-4.0-orange.svg)
[![Support Dependecy Manager](https://img.shields.io/badge/support-CocoaPods-red.svg?style=flat.svg)](https://img.shields.io/badge/support-CocoaPods-red.svg?style=flat.svg)
[![Version](https://img.shields.io/cocoapods/v/AZPeerToPeerConnection.svg?style=flat)](https://cocoapods.org/pods/AZPeerToPeerConnection)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat.svg)](https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat.svg)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://cocoapods.org/pods/AZPeerToPeerConnection)


<p align="center">
<a href="https://i.imgur.com/e1tKOoW.gif">
<img src="https://i.imgur.com/e1tKOoW.gif" height="480">
</a>
</p>


## Features

* Multipeer Connectivity
* Connection via Bluetooth or Wifi
* No need write all session, browser, services delegate

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate AZ PeerToPeerConnection into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
pod 'AZPeerToPeerConnection'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

#### Step 1

* With P2PServiceHandler.sharedInstance setup connection and make sure to implement it's delegate

```swift
    let connection = P2PServiceHandler.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        connection.delegate = self
        connection.setupConnection(serviceName: "AZP2Ptest")

        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        textField.delegate = self
        
    }
```
#### Step 2

* Next you need to connect to other devices, to do taht you just need to open McBrowser
* You can pass your own McBrowser or just nil, it will present browser

```swift
    connection.joinSession(vc: self, mcBrowser: nil) // nil == default mcbrowsr

```
#### Step 3

* Send data to other devices
* To send data it is better to send in form of Dictionary

```swift
connection.sendData(data: ["message": textField.text ?? "defaultValue"]) // send data of type [String: Any]

```
#### Step 4

* To receive data you have to implement delegate method 

```swift
    func didRecieve(_ serviceHandler: P2PServiceHandler, data: [String : Any]) {
    
        DispatchQueue.main.async {
            if let val = data["message"] {
                print(val)// data recieved
            }
        }
    }
```


#### Done
Thats it, you successfully integrate AZPeerToPeerConnection


## License

AZPeerToPeerConnection is available under the MIT license. See the LICENSE file for more info.

## Author

**Afroz Zaheer** - (https://github.com/AfrozZaheer)


