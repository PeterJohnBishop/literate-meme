const express = require('express');
const bodyParser = require('body-parser');
const dotenv = require("dotenv");
const cors = require('cors');
const app = express();
const mongoose = require('mongoose');
const http = require('http'); // Import HTTP module to work with Socket.IO
const { Server } = require('socket.io');
const s3Routes = require('./routes/S3Routes.js');
const userRoutes = require('./routes/UserRoutes.js');
const validateFirebaseToken = require('./utils/validate.js');

dotenv.config();

const PORT = process.env.PORT;

const allowedOrigins = [
    /^http:\/\/localhost(:\d+)?$/, //localhost:allports
];

const corsOptions = {
    origin: (origin, callback) => {
        if (!origin) {
        // Allow requests with no origin (like mobile apps or curl requests)
        callback(null, true);
        } else if (allowedOrigins.some(o => typeof o === 'string' ? o === origin : o.test(origin))) {
        callback(null, true);
        } else {
        callback(new Error('Not allowed by CORS'));
        }
    },
};

app.use(bodyParser.json());
app.use(cors());
app.use(cors(corsOptions));

app.use(validateFirebaseToken);

app.post("/secured-endpoint", validateFirebaseToken, (req, res) => {
  res.status(200).json({ message: "Authorized request", user: req.user });
});

app.get('/', (req, res) => {
  res.send('Welcome to Literate-Meme Server!');
});
app.use('/s3', s3Routes);
app.use('/users', userRoutes);

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: allowedOrigins,
    methods: ["GET", "PUT", "POST", "DELETE"],
    credentials: true,
  },
});

const configureSocketIO = (io) => {
    io.on('connection', (socket) => {
      console.log('A user connected on port:', PORT);
  
      socket.on('fromSwiftUI', (data) => {
        console.log(`Message received on port ${PORT}:`, data);
      });

      socket.on('fromReact', (data) => {
        console.log(`Message received on port ${PORT}:`, data);
      });
  
      socket.on('FireAuth', (data) => {
        console.log(`Message received on port ${PORT}:`, data);
      });
  
      socket.on('disconnect', () => {
        console.log(`User disconnected from port ${PORT}`);
      });
    });
  };

configureSocketIO(io); 
  
mongoose.connect(process.env.MONGODB_URI);
const connection = mongoose.connection;
connection.once("open", () => {
  console.log(`MongoDB database connection to established successfully`);
});

server.listen(PORT, () => {
  console.log(`HTTP server and Socket.IO listening on http://localhost:${PORT}`);
});

