
# Flutter Application with WebRTC & Socket.IO & Background Service 

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
