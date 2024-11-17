const express = require('express');
const bodyParser = require('body-parser');
const dotenv = require("dotenv");
const cors = require('cors');
const app = express();

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

//routes

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});