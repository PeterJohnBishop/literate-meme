const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const projectSchema = new Schema(
    {
      uid: {
          type: String,
          required: true,
          unique: true,
      },
      images: {
          type: Array,
          required: true,
          unique: false,
        },
      title: {
          type: String,
          required: true,
          unique: true,
        },
      description: {
        type: String,
        required: true,
        unique: false,
        },
      tags: {
        type: Array,
          required: true,
          unique: false,
      }
    },
    {
      timestamps: true
    }
  );
  
  const Project = mongoose.model("Project", projectSchema);
  
  module.exports = Project;