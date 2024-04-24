import 'package:admin/services/cloud_service.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';

class CallService {
  static late RtcEngine _engine;
  static late ValueNotifier<String> channel = ValueNotifier<String>("");

  static Future<void> init() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: '6497311dba644fad9601217560e65e7b',
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.disableVideo();

    _engine.registerEventHandler(
        RtcEngineEventHandler(onUserJoined: ((connection, remoteUid, elapsed) {
      print(remoteUid);
    })));
  }

  static Future<void> join(String channelID) async {
    CloudService.token(channelID).then((token) async {
      await _engine.joinChannel(
          token: token,
          channelId: channelID,
          uid: 0,
          options: ChannelMediaOptions());
    });

    channel.value = channelID;
  }

  static Future<void> leave() async {
    await _engine.leaveChannel();

    channel.value = "";
  }
}
