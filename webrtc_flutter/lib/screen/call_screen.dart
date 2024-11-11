import 'dart:developer';

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


  final _localRTCRenderer = RTCVideoRenderer();
  final _remoteRTCRenderer = RTCVideoRenderer();

  final socket = SignalService.socket;
  
  MediaStream? _localStream;

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
    _finishCall();

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

    _rtcPeerConnection = await createPeerConnection( kIceConfiguration, config);

    _rtcPeerConnection!.onTrack = (track) {
      _remoteRTCRenderer.srcObject = track.streams[0];
      setState(() {});
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstranis);

    _localStream!.getTracks().forEach((track) async{
      await _rtcPeerConnection!.addTrack(track, _localStream!);
    });

    _localRTCRenderer.srcObject = _localStream;

    setState(() {});

    if(widget.isCaller){
      
      _rtcPeerConnection!.onIceCandidate = (candidte)async=> 
        await Future.delayed( const Duration(milliseconds: 1), ()=> _iceCandidates.add(candidte));

      socket!.on('call-accepted', (data)async {

        
        SignalService.stateController.sink.add( { "state":StateDataToUI.exitCall.name, "from": "" } );

        RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();
        await _rtcPeerConnection!.setLocalDescription(fixSdp(offer));
        final dataToSend = { 'to': widget.remoteId, 'offer': offer.toMap(), };
        socket?.emit('offer', dataToSend);

        
      },);

      socket!.on('offer-answer',(data) async{
        RTCSessionDescription remoteOffer = RTCSessionDescription(data!['answer']['sdp'], data['answer']['type']);
          await _rtcPeerConnection?.setRemoteDescription(fixSdp(remoteOffer));
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
        String candidate = data!["candidate"]["candidate"];
        String sdpMid = data["candidate"]["sdpMid"];
        int sdpMLineIndex = data["candidate"]["sdpMLineIndex"];
        await _rtcPeerConnection?.addCandidate( RTCIceCandidate(candidate, sdpMid, sdpMLineIndex) );
      },);
    }
    
    if(!widget.isCaller){

      _rtcPeerConnection!.onIceCandidate = (iceCandidate)async{
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
            await _rtcPeerConnection!.setRemoteDescription(
              RTCSessionDescription(data!['offer']['sdp'], data['offer']['type'])
            );
            RTCSessionDescription? answer = await _rtcPeerConnection?.createAnswer();
            _rtcPeerConnection!.setLocalDescription(fixSdp(answer!));
            final dataForSend = { "answer": answer.toMap(), "to": widget.remoteId, };
            socket?.emit("offer-answer", dataForSend);
            
        },);

      socket!.on("ice-candidate", (data)async {
        String candidate = data!["candidate"]["candidate"];
        String sdpMid = data["candidate"]["sdpMid"];
        int sdpMLineIndex = data["candidate"]["sdpMLineIndex"];
        await _rtcPeerConnection?.addCandidate( RTCIceCandidate(candidate, sdpMid, sdpMLineIndex) );

      },);
    }

  }

   listenSocket()async{
      
      socket!.on('left-call', (data) {
        socket?.emit('left-call');
        SignalService.stateController.sink.add({ "state":StateDataToUI.exitCall.name, "from": "" });
      },);

      socket!.on('call-denied',(data) {
        socket?.emit('call-denied');
      },);      

  }

  _finishCall(){
    socket?.on('left-call', (event)=> _navigateBack());
    socket?.on('call-denied', (event)=> _navigateBack());
  }

  _toggleAudio() {
    isAudioOn = !isAudioOn;

    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
  }

  _toggleVideo() {
    isVideoOn = !isVideoOn;

    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});
  }

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

            if( _localRTCRenderer.srcObject != null )
              Positioned(
                right: 16,
                bottom: 100,
                height:  300,
                // width: 120,
                child: Container(
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

            
            // stream controls
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

