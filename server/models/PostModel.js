const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const Comment = require('./CommentModel');

const postSchema = new Schema(
    {
        photos: {
            type: Array,
            required: false,
            unique: false
        },
        title: {
            type: String,
            required: true, 
            unique: true
        }, 
        content: {
            type: String,
            required: true, 
            unique: false
        }, 
        comments: {
            type: [Comment],
            required: false
        }
    },
    {
        timestamps: true
    }
);

const Post = mongoose.model("Post", postSchema);

module.exports = Post;

