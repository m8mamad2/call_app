
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