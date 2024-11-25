const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const userSchema = new Schema(
  {
    uid: {
        type: String,
        required: true,
        unique: true,
    },
    userPhotoURL: {
        type: String,
        required: true,
        unique: true,
      },
    username: {
        type: String,
        required: true,
        unique: true,
    },
    connections: {
        type: Array,
        required: false,
    },
    media: {
      type: Array,
      required: false,
    },
    locationLat: {
      type: Number,
      required: false,
    },
    locationLong: {
      type: Number,
      required: false,
    },
  },
  {
    timestamps: true
  }
);

const User = mongoose.model("User", userSchema);

module.exports = User;