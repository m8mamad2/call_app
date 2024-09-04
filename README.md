
# Flutter Application with WebRTC & Socket.IO & Background Service 
![socketdotio](https://github.com/user-attachments/assets/f35af491-e8dd-4da5-94eb-d194fcf20397)<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/200/svg"><title>Socket.io</title><path d="M11.9362.0137a12.1694 12.1694 0 00-2.9748.378C4.2816 1.5547.5678 5.7944.0918 10.6012c-.59 4.5488 1.7079 9.2856 5.6437 11.6345 3.8608 2.4179 9.0926 2.3199 12.8734-.223 3.3969-2.206 5.5118-6.2277 5.3858-10.2845-.058-4.0159-2.31-7.9167-5.7588-9.9796C16.354.5876 14.1431.0047 11.9362.0137zm-.063 1.696c4.9448-.007 9.7886 3.8137 10.2815 8.9245.945 5.6597-3.7528 11.4125-9.4875 11.5795-5.4538.544-10.7245-4.0798-10.8795-9.5566-.407-4.4338 2.5159-8.8346 6.6977-10.2995a9.1126 9.1126 0 013.3878-.647zm5.0908 3.2248c-2.6869 2.0849-5.2598 4.3078-7.8886 6.4567 1.2029.017 2.4118.016 3.6208.01 1.41-2.165 2.8589-4.3008 4.2678-6.4667zm-5.6647 7.6536c-1.41 2.166-2.86 4.3088-4.2699 6.4737 2.693-2.0799 5.2548-4.3198 7.9017-6.4557a255.4132 255.4132 0 00-3.6318-.018z"/></svg>![webrtc](https://github.com/user-attachments/assets/a08bde31-1ad2-4960-9447-0fae3d2e0249)<svg role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><title>WebRTC</title><path d="M11.9998.3598c-2.8272 0-5.1456 2.1733-5.3793 4.94a5.4117 5.4117 0 00-1.2207-.1401C2.418 5.1597 0 7.5779 0 10.5603c0 2.2203 1.341 4.1274 3.2568 4.957a5.3734 5.3734 0 00-.7372 2.7227c0 2.9823 2.4175 5.4002 5.4002 5.4002 1.6627 0 3.1492-.7522 4.1397-1.934.9906 1.1818 2.4773 1.934 4.1398 1.934 2.983 0 5.4004-2.418 5.4004-5.4002 0-.9719-.258-1.883-.7073-2.6708C22.7283 14.7068 24 12.8418 24 10.6795c0-2.9823-2.4175-5.4006-5.3998-5.4006-.417 0-.8223.049-1.2121.1384C17.2112 2.5949 14.867.3598 11.9998.3598zm-5.717 6.8683h10.5924c.7458 0 1.352.605 1.352 1.3487v7.6463c0 .7438-.6062 1.3482-1.352 1.3482h-3.6085l-7.24 3.5491 1.1008-3.5491h-.8447c-.7458 0-1.3522-.6044-1.3522-1.3482V8.5768c0-.7438.6064-1.3487 1.3522-1.3487Z"/></svg>

## Overview
This Flutter application is runs in the background. It utilizes Socket.IO for real-time communication and WebRTC for handling voice and video calls. The app displays a notification when an incoming call is detected From Socket.io , allowing users to answer or decline the call. The backend of this project is developed using TypeScript, Socket.IO, and Node.js, ensuring a reliable and scalable real-time communication system.



## Features

- **Background Service Operation:** The app runs in the background, continuously listening for incoming calls.
- **Real-time Communication with Socket.IO:** Efficiently manages signaling for call setup, status updates, and more using Socket.IO.
- **WebRTC for Call Handling:** Uses WebRTC to establish peer-to-peer connections for high-quality audio and video communication.



## Installation

1 - Clone the repository:
```bash
  https://github.com/M8mamad2/call_app.git
```


#### Mobile Application


Navigate to the project directory:
```bash
  cd webrtc_flutter
```
Install dependencies::
```bash
  flutter pub get
```
Run the app:
```bash
  flutter run
``` 

#### Node js Application

Navigate to the project directory:
```bash
  cd webrtc_server
```
3 - Install dependencies::
```bash
  npm install
```
4 - Run the app:
```bash
  npm run dev
``` 
## How It Works

- **Background Service:** The Flutter app runs a background service that maintains a connection with the server using Socket.IO. This connection is crucial for receiving incoming call notifications in real-time.

- **Incoming Call Notification:** When the server detects an incoming call for the user, it sends a notification through Socket.IO. The app receives this notification and displays it to the user, allowing them to accept or decline the call.

- **WebRTC Connection:** If the user accepts the call, the app initiates a WebRTC connection, facilitating a direct peer-to-peer communication channel for high-quality audio and video transmission.
