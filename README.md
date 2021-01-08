<div>
  <br/><br />
  <p align="center">
    <a href="https://bambuser.com" target="_blank" align="center">
        <img src="https://brand.bambuser.net/current/logo/bambuser-black-512.png" width="280">
    </a>
  </p>
  <br /><br />
  <h1>React Native component for Bambuser broadcasting SDK</h1>
</div>

## Requirements

Version `0.0.9` and above of this React Native component requires React Native `0.60` or higher.
Version `0.0.18` and above of this React Native component requires version `1.0.0` or higher of the iOS libbambuser SDK.

## Installation

1. Add `react-native-bambuser-broadcaster` to your React Native project.  
    `$ yarn add react-native-bambuser-broadcaster --save`
2. Android SDK from https://dashboard.bambuser.com/developer
3. Android only: Head over to https://bambuser.com/docs/broadcasting/android/ and follow the Android sections [Add the broadcast SDK](https://bambuser.com/docs/broadcasting/android/#add-the-broadcast-sdk) and [Add required Android app permissions and features](https://bambuser.com/docs/broadcasting/android/#add-required-android-app-permissions-and-features) for the Android project within your React Native project.
    **Important note:** when adding the libbambuser subproject, make sure you name it **libbambuser**, the React Native component will look for this subproject when building your React Native app.
4. iOS only: Go to https://bambuser.com/docs/broadcasting/ios-objc/ and follow the sections [Installing dependencies using CocoaPods](https://bambuser.com/docs/broadcasting/ios-objc/#install-dependencies-using-cocoapods).


### To automatically link this React Native module to your Xcode/Android projects run the following command:

If you are using React Native `0.60` or above run: `cd ios && pod install && cd ..`.
If you are using an older version of React Native please refer back to README.md in this repository for specific version.


### If you want to manually add this React Native module to your Xcode/Android Studio projects, then follow these steps:


For Xcode:
1. In Xcode, in the project navigator, right click the `Libraries` directory, and choose `Add Files to your [your projects name]`.
2. Go to `node_modules` ➜ `react-native-bambuser-broadcaster` and add `RNBambuserBroadcaster.xcodeproj`.
3. In Xcode, in the project navigator, select your project. Add `libRNBambuserBroadcaster.a` to your projects `Build Phases` ➜ `Link Binary With Libraries`.


For Android:
1. Open up `android/app/src/main/java/.../MainActivity.java`.
2. Add `import com.bambuserbroadcaster.BambuserBroadcasterViewPackage` to the imports at the top.
3. Add `new BambuserBroadcasterViewPackage()` to the return array in the `getPackages()` method. Your `getPackages()` method should look something like this:  
    ```java
    ...
    @Override
    protected List<ReactPackage> getPackages() {
        return Arrays.<ReactPackage>asList(
            new MainReactPackage(),
            new BambuserBroadcasterViewPackage()
        );
    }
    ...
    ```

4. Add the following lines to `android/settings.gradle`:  
    ```
    include ':react-native-bambuser-broadcaster'
    project(':react-native-bambuser-broadcaster').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-bambuser-broadcaster/android')
    ```

5. Insert the following lines inside the dependencies block in `android/app/build.gradle`:  
    ```
    compile project(':react-native-bambuser-broadcaster')
    ```


## Usage

In order to use this React Native component and our SDKs you'll need to generate an `applicationId` over at https://dashboard.bambuser.com/developer.

```javascript
import RNBambuserBroadcaster from 'react-native-bambuser-broadcaster';

...
<RNBambuserBroadcaster applicationId={yourApplicationId} />
```

### Props
```javascript
applicationId: String
// This applicationId should be fetched from your backend, rather than being hardcoded within your Reacty Native app. Read more here https://bambuser.com/docs/key-concepts/application-id/

audioQuality: String
// RNBambuserBroadcaster.AUDIO_QUALITY.HIGH || RNBambuserBroadcaster.AUDIO_QUALITY.LOW || RNBambuserBroadcaster.AUDIO_QUALITY.MUTE

author: String
// Populates the author field in your broadcasts metadata.

title: String
// Populates the title field in your broadcasts metadata.

customData: Object
// Populates the customData field in your broadcasts metadata.

aspect: Object
// By setting this prop you can modify the next broadcasts video aspect ratio. By setting {width: 1, height: 1} by example you get a square broadcast.

localCopy: Boolean
// If you set this to true the next broadcast will also be saved to the broadcasting device.

localCopyFilename: String
// If localCopy is true, then you can choose to set a specific name for the output file on this broadcast. If you don't provide a localCopyFilename then the output filename will have a automatically generated value.

sendPosition: Boolean
// This prop decides if the broadcasters location should be sent on the next broadcast.

saveOnServer: Boolean
// Set this prop to false if you do not want to save the next broadcast online.

zoom: Number
// Provide a value between 0(no zoom) and 1(maximum zoom).

talkback: Boolean
// Set false if you don't want to allow the talkback feature for your broadcast.

onCurrentViewerCountUpdate: function(viewers)
// Callback when current viewer count is updated.

onTotalViewerCountUpdate: function(viewers)
// Callback when total viewer count is updated.

onMessageReceived: function(message)
// Callback when the broadcaster recieves a chat message.

onBroadcastStarted: function()
// Callback when the broadcast started broadcasting.

onBroadcastStopped: function()
// Callback when the broadcast stopped broadcasting

onBroadcastError: function(errorCode, errorMessage)
// Callback when the broadcasters emits an error.

onLocalCopySaved: function(filePath)
// Callback when the local copy file is ready. At this point you should save the file at filePath to a more permanent storage location on your device.

onBroadcastIdReceived: function(broadcastId)
// Callback when the broadcaster recieves the broadcastId of the ongoing broadcast.

onUplinkTestComplete: function(speed, recommendation)
// Callback when the uplink speed test is finished. You can use our recommendation argument here if you want to disable broadcasting for users on bad networks here.

onStreamHealthUpdate: function(streamhealth)
// Callback when the streamhealth is updated.

onPictureSaved: function(filePath)
// Callback when the broadcaster have snapped an image of the ongoing broadcast. At this point you should save the file at filePath to a more permanent storage location on your device.

onIncomingTalkbackRequest: function(talkbackMessage, talkbackCaller, talkbackId)
// Callback when there's an incoming talkback request. The talkbackId is a required in order to accept/decline this talkback. 

onTalkbackIdle: function()
// Callback when the talkback session becomes idle.

onTalkbackPlaying: function()
// Callback when the talkback session is playing.

onTalkbackAccepted: function()
// Callback when the talkback reqeust is accepted

onTalkbackNeedsAccept: function()
// Callback when a talkback request is ready to be accepted.

onCameraReady: function(hasZoom, hasTorch, canSwitchCamera)
// Callback when the new camera is ready to be used. This is called when the broadcaster is first initiated and when the broadcaster switches between available cameras. Use the provided arguments to lock specific buttons which toggles torch, etc.

onStartBroadcastNotReady: function()
// Callback when startBroadcast function was called by the broadcast SDK is not ready to broadcast just yet. At this point it might be a good to let the user try again.
```


### Controlling the broadcaster
By storing a reference to the RNBambuserBroadcaster you can call its functions.

```javascript
<RNBambuserBroadcaster
ref={ref => {this.myBroadcasterRef = ref; }} applicationId={yourApplicationId} />
```

The available functions for RNBambuserBroadcaster can be called are:
```javascript
this.myBroadcasterRef.startBroadcast();
// Call this when you want to start broadcasting. This will trigger the callback onBroadcastStarted when the broadcast starts.

this.myBroadcasterRef.stopBroadcast();
// Call this when you want to stop broadcasting. This will trigger the callback onBroadcastStopped when the broadcast stopped.

this.myBroadcasterRef.switchCamera();
// Call this when you want switch which camera your device is broadcasting from.

this.myBroadcasterRef.takePicture();
// Call this when you want to take a picture of ongoing broadcast. This will trigger the callback onPictureSaved when the image is ready.

this.myBroadcasterRef.startUplinkTest();
// Call this if you want to start an uplink test. When this is finished the callback of onUplinkTestComplete is invoked.

this.myBroadcasterRef.acceptTalkback(talkbackId);
// If you want to accept an incoming talkback request, then you call this function with the talkbackId provided from onIncomingTalkbackRequest.

this.myBroadcasterRef.declineTalkback(talkbackId);
// If you want to decline an incoming talkback request, then you call this function with the talkbackId provided from onIncomingTalkbackRequest.

this.myBroadcasterRef.endTalkback();
// If you want to end the currently ongoing talkback session, then call this function.
```

## More information

* [Bambuser Docs](https://bambuser.com/docs)

* [Bambuser AB](https://bambuser.com)

