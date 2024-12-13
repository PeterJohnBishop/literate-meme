const mongoose = require("mongoose");

const commentSchema = new mongoose.Schema({
    text: {
      type: String,
      required: true,
    },
    sender: {
      type: String,
      required: true,
    },
    role: {
        type: String,
        enum: ['admin', 'user', 'guest'], 
        required: true,
        default: 'guest'
      }
  },
  {
      timestamps: true
  }
);

  module.exports = commentSchema;