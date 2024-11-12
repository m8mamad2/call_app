
import 'package:flutter_webrtc/flutter_webrtc.dart';

const kIceConfiguration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
};

const Map<String, dynamic> config = {
      'mandatory': {},
      'optional': [ {'DtlsSrtpKeyAgreement': true} ]
  };

const mediaConstranis = {
'audio': true,
'video': {
  'mandatory': {
    'minWidth': '640', 
    'minHeight': '480',
    'minFrameRate': '30',
  },
  'facingMode': 'user',
  'optional': [],
}
};

RTCSessionDescription fixSdp(RTCSessionDescription s) {
  var sdp = s.sdp;
  s.sdp = sdp!.replaceAll('profile-level-id=640c1f', 'profile-level-id=42e032');
  s.sdp = sdp.replaceAll("useinbandfec=1", 'useinbandfec=1;stereo=1;maxaveragebitrate=510000');
  return s;
}