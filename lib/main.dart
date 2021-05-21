import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

const appId = "95d395dcac5745128d8c7bd135a00daa";
const token = "00695d395dcac5745128d8c7bd135a00daaIAA95oKp2v6wWlaL/UqDBap1mBYg0IqUPOinQFG15xjlFjiw7U4AAAAAEABZxLUYLAmpYAEAAQAsCalg";

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _remoteUid;
  late RtcEngine _engine;

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
}

