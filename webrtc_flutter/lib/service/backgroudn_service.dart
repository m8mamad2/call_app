// service.on('start-call').listen((to) {
//         socket!.emit('start-call', {"to": to!['data'] });
//       },);

//       service.on("accept-call").listen((event) {
//         NotificationService().cancleAllNotif();
//         socket!.emit("accept-call", { "to": event!['data'] });
//       },);
        
//       service.on('deny-call').listen((event) {
//         NotificationService().cancleAllNotif();
//         service.invoke('connectionData', { "data": StateDataToUI.exitCall.name }, );
//       },);
      
//       service.on("ice-candidate").listen((event) {
//         socket!.emit("ice-candidate",event);
//       },);

//       service.on('offer').listen((event) {
//         socket!.emit('offer', event);
//       },);
    
//       service.on('offer-answer').listen((event) {
//         socket!.emit('offer-answer',event);
//       },);

//       service.on('leave-call').listen((event) {
//         socket!.emit('leave-call', event!['data']);
//         service.invoke('connectionData', { "data": StateDataToUI.exitCall.name }, );
//       },);

//       service.on("deny-call").listen((event){
//         service.invoke('connectionData', { "data": StateDataToUI.exitCall.name }, );
//         socket!.emit('deny-call', event!['data']);
//       });

      