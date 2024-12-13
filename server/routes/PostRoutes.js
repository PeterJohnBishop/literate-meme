const router = require("express").Router();
const Post = require("../models/PostModel");
const validateFirebaseToken = require('../utils/validate.js');

router.post("/post", validateFirebaseToken, (req, res) => {

    const photos = req.body.photos;
    const title = req.body.title;
    const content = req.body.content;
    const comments = req.body.comments;
  
    const newPost = new Post({
      photos,
      title,
      content,
      comments
    });
  
    newPost
      .save()
      .then((post) => res.status(200).json(post))
      .catch((err) => res.status(400).json("Error: " + err));
});

// read one by uid
router.get("/post/:documentId", validateFirebaseToken, (req, res) => {
    const { documentId } = req.params;

    Post.findOne({ documentId })
        .then((post) => {
            if (!post) {
                return res.status(404).json({ error: "Post not found" });
            }
            res.status(200).json(post);
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

// read all documents
router.get("/", validateFirebaseToken, (req, res) => {
    Post.find()
      .then((post) => {
        res.status(200).json(post)
        console.log(JSON.stringify(post))
    })
      .catch((err) => res.status(400).json("Error: " + err));
});

// update post document
router.put("/post/:documentId", validateFirebaseToken, (req, res) => {
    const { documentId } = req.params;
    const updatedData = req.body; // Data to update

    Post.findOneAndUpdate({ documentId }, updatedData, { new: true })
        .then((updatedPost) => {
            if (!updatedPost) {
                return res.status(404).json({ error: "Post not found" });
            }
            res.status(200).json({ message: "Post updated successfully", user: updatedPost });
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

// delete user document
router.delete("/post/:documentId", validateFirebaseToken, (req, res) => {
    const { documentId } = req.params;

    Post.findOneAndDelete({ documentId })
        .then((deletePost) => {
            if (!deletePost) {
                return res.status(404).json({ error: "Post not found" });
            }
            res.status(200).json({ message: "Post deleted successfully" });
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

module.exports = router;