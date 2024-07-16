import cors from "cors"
import express from "express"
import { createServer } from "http"
import morgan from "morgan"
import { Server } from "socket.io"

const app = express()
const httpServer = createServer(app)

const io = new Server(httpServer, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
})

app.use(cors())
app.use(morgan('combined'))
app.use(express.json())

io.use((socket, next)=> {
    socket['user'] = socket.handshake.query?.callerId
    next()
})

io.on('connection', (socket)=> {

    console.log("new connection on socker server user is ", socket['user'])

    
    socket.join(socket['user'])
    
    const id = socket['user'];
    io.to(socket['user']).emit("you-are",{ id } )

    
    socket.on('start-call', ({ to })=> {
        console.log("initiating call request to ", to)
        socket.broadcast.emit("incoming-call", { from: socket['user'] })
    })

    // when an incoming call is accepted
    socket.on("accept-call", ({ to })=> {
        console.log("call accepted by ", socket['user'], " from ", to)
        socket.broadcast.emit("call-accepted", { to })
    })
    
    // when an incoming call is denied
    socket.on("deny-call", ({ to })=> {
        console.log("call denied by ", socket['user'], " from ", to)
        socket.broadcast.emit("call-denied", { to })
    })
    
    // when a party leaves the call
    socket.on("leave-call", ({ to })=> {
        console.log("left call mesg by ", socket['user'], " from ", to)
        socket.broadcast.emit("left-call", { to })
    })

    // when an incoming call is accepted,..
    // caller sends their webrtc offer
    socket.on("offer", ({ to, offer })=> {
        console.log("offer from ", socket['user'], " to ", to)
        socket.broadcast.emit("offer", { to, offer })
    })

    // when an offer is received,..
    // receiver sends a webrtc offer-answer
    socket.on("offer-answer", ({ to, answer })=> {
        console.log("offer answer from ", socket['user'], " to ", to)
        socket.broadcast.emit("offer-answer", { to, answer })
    })
    
    // when an ice candidate is sent
    socket.on("ice-candidate", ({ to, candidate })=> {
        console.log("ice candidate from ", socket['user'], " to ", to)

        socket.broadcast.emit("ice-candidate", { to, candidate })
    })

    // when a socker disconnects
    socket.on("disconnect", (reason)=> {
        console.log("a socker disconnected ", socket['user'])
    })

})


const PORT = process.env.PORT || 8080

httpServer.listen(PORT, ()=> {
    console.log(`listening on port ${PORT}`)
})
