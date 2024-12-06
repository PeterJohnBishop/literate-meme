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
    }
  },
  {
    timestamps: true
  }
);

const User = mongoose.model("User", userSchema);

module.exports = User;