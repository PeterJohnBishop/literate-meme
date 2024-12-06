const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const tagSchema = new Schema(
    {
      uid: {
          type: String,
          required: true,
          unique: true,
      },
      icon: {
          type: String,
          required: true,
          unique: true,
        },
      tag: {
          type: String,
          required: true,
          unique: true,
        }
    },
    {
      timestamps: true
    }
  );
  
  const Tag = mongoose.model("Tag", tagSchema);
  
  module.exports = Tag;