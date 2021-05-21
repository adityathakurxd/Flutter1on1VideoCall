# Flutter Video Call: 1 on 1 Video Call in Flutter

## Presentation
Link:

## Steps

**Create a new Flutter Project:**
 

**Clear out code**

```dart
import 'package:flutter/material.dart';  
  
void main() {  
  runApp(const MyApp());  
}  
  
class MyApp extends StatelessWidget {  
  const MyApp({Key? key}) : super(key: key);  
  
  // This widget is the root of your application.  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      title: 'Flutter Demo',  
      theme: ThemeData(  
        primarySwatch: Colors.blue,  
      ),  
      home: const HomePage(),  
    );  
  }  
}
```
**Define a HomePage Widget** 
It is a stateful widget and renders a view on screen which for now returns empty containers.
```dart
  
class HomePage extends StatefulWidget {  
  const HomePage({Key? key}) : super(key: key);  
  
  @override  
  _HomePageState createState() => _HomePageState();  
}  
  
class _HomePageState extends State<HomePage> {  
  late int _remoteUid;  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text('Video Call in Flutter'),  
      ),  
      body: Stack(  
        children: [  
          Center(  
            child: _renderRemoteVideo(),  
          ),  
          Align(  
            alignment: Alignment.topLeft,  
            child: Container(  
              width: 100,  
              height: 100,  
              child: Center(  
                child: _renderLocalPreview(),  
              ),  
            ),  
          )  
        ],  
      ),  
    );  
  }  
  
  Widget _renderLocalPreview(){  
    return Container();  
  }  
  
  Widget _renderRemoteVideo(){  
    if(_remoteUid != null){  
      return Container();  
    }  
    else {  
      return Text(  
        'User will appear here!',  
        textAlign: TextAlign.center,  
      );  
    }  
  }   
}
```

## Agora
**Create a Agora.io Account**

**Head over to: https://console.agora.io/**

**Create a New project**

**Get an App id and Temporary Token** 
```dart
const appId = "";  
const token = "";
```

Add and **import packages** for integration in Flutter to pubspec.yaml
```dart
agora_rtc_engine: ^4.0.1
permission_handler: ^8.0.0
```
Import the packages to main.dart
```dart
import 'package:permission_handler/permission_handler.dart';  
import 'package:agora_rtc_engine/rtc_engine.dart';
```
**Define** the engine `RtcEngine _engine;`

**Initialise** Agora by creating a new function and calling it in `initState()`

```dart
@override  
void initState() {  
  initForAgora();  
  super.initState();  
}  
  
Future<void> initForAgora() async {  
  await [Permission.camera, Permission.microphone].request();  
    
  _engine = await RtcEngine.createWithConfig(RtcEngineConfig(appId));  
    
  await _engine.enableVideo();  
    
  _engine.setEventHandler(  
    RtcEngineEventHandler(  
      joinChannelSuccess: (String channel, int uid, int elapsed){  
        print("Local User $uid joined");  
      },  
      userJoined: (int uid, int elapsed){  
        print("Remote User $uid joined");  
        setState(() {  
          _remoteUid = uid;  
        });  
      },  
      userOffline: (int uid, UserOfflineReason reason){  
        print("Remote User $uid left channel");  
        setState(() {  
          _remoteUid = null;  
        });  
      }  
    )  
  );  
    
  await _engine.joinChannel(token, "channelname", null, 0);  
}
```

**Modify the views**

Add imports
```dart
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;  
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
```
Modify Functions
```dart
Widget _renderLocalPreview(){  
  return RtcLocalView.SurfaceView();  
}  
  
Widget _renderRemoteVideo(){  
  if(_remoteUid != null){  
    return RtcRemoteView.SurfaceView(uid: _remoteUid,);  
  }  
  else {  
    return Text(  
      'User will appear here!',  
      textAlign: TextAlign.center,  
    );  
  }  
}
```

<p align='center'> <img src="https://user-images.githubusercontent.com/53579386/119154662-0224c600-ba70-11eb-830c-5e2b98cb8427.jpeg" alt="Phone Screenshot"> </p>
