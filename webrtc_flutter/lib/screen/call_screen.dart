import 'package:callapp/service/signaling_service.dart';
import 'package:callapp/utils/constans/sizes.dart';
import 'package:callapp/utils/constans/webrtc_constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';


class CallScreen extends StatefulWidget {
  final bool isCaller;
  final String? remoteId;
  const CallScreen({super.key, required this.isCaller, this.remoteId,});

  @override
  State<CallScreen> createState() => _CallScreenState();
}
class _CallScreenState extends State<CallScreen> {


  // Video Rendering
  final _localRTCRenderer = RTCVideoRenderer();
  final _remoteRTCRenderer = RTCVideoRenderer();

  // Socket Instane 
  final socket = SignalService.socket;
  
  // manage stream of media such as audio and video,
  MediaStream? _localStream;

  // manage connection between peer 
  RTCPeerConnection? _rtcPeerConnection;

  final List<RTCIceCandidate> _iceCandidates = [];

  bool isAudioOn = true;
  bool isVideoOn = true;
  bool isFrontCameraOn = true;

  
  @override
  void initState() {

    _localRTCRenderer.initialize();
    _remoteRTCRenderer.initialize();

    _setupConnection();

    super.initState();
  }

  @override
  void dispose()async {
    super.dispose();

    if(_rtcPeerConnection != null){
      await _rtcPeerConnection!.close();
      _rtcPeerConnection = null;
    }

    if(_localStream != null){
      _localStream!.getTracks().forEach((track) async{
        await track.stop();
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRTCRenderer.dispose();
    _remoteRTCRenderer.dispose();
    _rtcPeerConnection?.dispose();
  }


  _setupConnection() async {

    
    // stablish a WebRTC P2P connection between two devices
    _rtcPeerConnection = await createPeerConnection( kIceConfiguration, config);

    // listem for remote mediatrack and added to RTCVideoRenderer object
    _rtcPeerConnection!.onTrack = (RTCTrackEvent track) {
      _remoteRTCRenderer.srcObject = track.streams[0];
      setState(() {});
    };

    // get local Media
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstranis);

    // add localTrack to peerConnetion
    _localStream!.getTracks().forEach((track) async{
      await _rtcPeerConnection!.addTrack(track, _localStream!);
    });

    // set source for local video renderer
    _localRTCRenderer.srcObject = _localStream;

    setState(() {});

    if(widget.isCaller){
      
      // listen for when get IceCandidate & add iceCandidate to List _iceCandidates
      _rtcPeerConnection!.onIceCandidate = (candidte)async=> 
        await Future.delayed( const Duration(milliseconds: 1), ()=> _iceCandidates.add(candidte));


      socket!.on('call-accepted', (data)async {

        
        SignalService.stateController.sink.add( { "state":StateDataToUI.exitCall.name, "from": "" } );

        // create SDP offer
        RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();
        
        // set Local SDP (Offer) for peerConnection
        await _rtcPeerConnection!.setLocalDescription(fixSdp(offer));
        
        // send offer to Signaling Server
        final dataToSend = { 'to': widget.remoteId, 'offer': offer.toMap(), };
        socket?.emit('offer', dataToSend);

        
      },);

      socket!.on('offer-answer',(data) async{

          // get Answer From Another User
          RTCSessionDescription remoteOffer = RTCSessionDescription(data!['answer']['sdp'], data['answer']['type']);

          // set SDP Answer to peerConnection
          await _rtcPeerConnection?.setRemoteDescription(fixSdp(remoteOffer));

          // send IceCandidate to Signaling Server
          for ( var iceCandidate in _iceCandidates ) {
            final data = {
              "to": widget.remoteId,
              "candidate": {
                "sdpMid": iceCandidate.sdpMid,
                "candidate": iceCandidate.candidate,
                "sdpMLineIndex": iceCandidate.sdpMLineIndex,
              }
            };
            socket?.emit("ice-candidate",data);
          }
      },);

      socket!.on("ice-candidate", (data)async {
        // listen for IceCandidate 
        String candidate = data!["candidate"]["candidate"];
        String sdpMid = data["candidate"]["sdpMid"];
        int sdpMLineIndex = data["candidate"]["sdpMLineIndex"];
        
        // set IceCandidate of another user 
        await _rtcPeerConnection?.addCandidate( RTCIceCandidate(candidate, sdpMid, sdpMLineIndex) );
      },);
    }
    
    if(!widget.isCaller){

      _rtcPeerConnection!.onIceCandidate = (iceCandidate)async{
        // listen for when get IceCandidate and send to signaling server
        await Future.delayed(const Duration(milliseconds: 1));
        final data  = {
              "to": widget.remoteId,
              "candidate": {
                "sdpMid": iceCandidate.sdpMid,
                "candidate": iceCandidate.candidate,
                "sdpMLineIndex": iceCandidate.sdpMLineIndex,
              }
            };
        socket?.emit("ice-candidate",data);
    };

      socket!.on('offer', (data)async {
          // when comes offer from another user, set it for peerConnection
          await _rtcPeerConnection!.setRemoteDescription(RTCSessionDescription(data!['offer']['sdp'], data['offer']['type']));
          
          // create SDP Answer 
          RTCSessionDescription? answer = await _rtcPeerConnection?.createAnswer();
          
          // set SDP Answer 
          _rtcPeerConnection!.setLocalDescription(fixSdp(answer!));


          // send SDP Answer to Signaling Server
          final dataForSend = { "answer": answer.toMap(), "to": widget.remoteId, };
          socket?.emit("offer-answer", dataForSend);
        },);

      socket!.on("ice-candidate", (data)async {

        // listen for IceCandidate
        String candidate = data!["candidate"]["candidate"];
        String sdpMid = data["candidate"]["sdpMid"];
        int sdpMLineIndex = data["candidate"]["sdpMLineIndex"];

        // set IceCandidate of another user
        await _rtcPeerConnection?.addCandidate( RTCIceCandidate(candidate, sdpMid, sdpMLineIndex) );
      },);
    }

    socket?.on('left-call', (event){
      // if User exit from Call
      SignalService.stateController.sink.add({ "state":StateDataToUI.exitCall.name, "from": "" });
      _navigateBack();
      });

    socket?.on('call-denied', (event){
      // if User Not Excepted call
      SignalService.stateController.sink.add({ "state":StateDataToUI.exitCall.name, "from": "" });
      _navigateBack();
      });

  }

  // To enable or disable Audio
  _toggleAudio() {
    isAudioOn = !isAudioOn;

    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
  }

  // To enable or disable Video
  _toggleVideo() {
    isVideoOn = !isVideoOn;

    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});
  }

  // For Leave Call
  _leaveCall()async {
    socket?.emit('leave-call',{'data':widget.remoteId});
    _navigateBack();
  }

  _navigateBack(){
    SignalService.stateController.sink.add( { "state":StateDataToUI.exitCall.name } );
    if(mounted)
        if (Navigator.canPop(context)) Navigator.of(context).pop();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
          children: [
            
            // For Render Local Medi
            Positioned.fill(
              child: RTCVideoView(
                _remoteRTCRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                placeholderBuilder: (_) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Text("Waiting for to Join"),
                    ),
                  );
                }
              ),
            ),

            // For Render Remote Medi
            if( _localRTCRenderer.srcObject != null )
              Positioned(
                right: 16,
                bottom: 100,
                height:  300,
                // width: 120,
                child: SizedBox(
                  width: kWidth(context)*0.4,
                  height: kHeight(context)*0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: RTCVideoView(
                      _localRTCRenderer,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror: true,
                    ),
                  ),
                ),
              ),

            
            // Action
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
              
                    InkWell(
                      onTap: _toggleAudio,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                        ),
                        child: Icon( isAudioOn ? Icons.mic_off : Icons.mic_none_outlined ),
                      ),
                    ),

                    InkWell(
                      onTap: _leaveCall,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red
                        ),
                        child: const Icon(Icons.call_end,color: Colors.white,),
                      ),
                    ),

                    InkWell(
                      onTap: _toggleVideo,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color:  Colors.white 
                        ),
                        child: Icon( isVideoOn ? Icons.videocam_off : Icons.videocam_rounded ),
                      ),
                    ),
                    
                  ],
                ),
              )
            ),
            
          ],
        ),
    );
  }

}

