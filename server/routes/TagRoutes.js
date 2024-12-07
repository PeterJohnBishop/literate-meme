const router = require("express").Router();
const Tag = require("../models/TagModel.js");
const validateFirebaseToken = require('../utils/validate.js')

router.post("/tag", validateFirebaseToken, (req, res) => {

    console.log("Create tag request incomming.");

    const uid = req.body.uid;
    const tag = req.body.tag;
  
    const newTag = new Tag({
      uid,
      tag
    });

    console.log(`Saving ${newTag}`);
  
    newTag
      .save()
      .then(() => res.status(200).json("New Tag document created!"))
      .catch((err) => res.status(400).json("Error: " + err));
});

// read one by uid
router.get("/tag/:uid", validateFirebaseToken, (req, res) => {
    const { uid } = req.params;

    Tag.findOne({ uid })
        .then((tag) => {
            if (!tag) {
                return res.status(404).json({ error: "Tag not found" });
            }
            res.status(200).json(tag);
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

// read all documents
router.get("/", validateFirebaseToken, (req, res) => {
    Tag.find()
      .then((tag) => {
        res.status(200).json(tag)
        console.log(JSON.stringify(tag))
    })
      .catch((err) => res.status(400).json("Error: " + err));
});

// update tag document
router.put("/tag/:uid", validateFirebaseToken, (req, res) => {
    const { uid } = req.params;
    const updatedData = req.body; // Data to update

    Tag.findOneAndUpdate({ uid }, updatedData, { new: true })
        .then((updatedTag) => {
            if (!updatedTag) {
                return res.status(404).json({ error: "Tag not found" });
            }
            res.status(200).json({ message: "Tag updated successfully", tag: updatedTag });
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

// delete project document
router.delete("/tag/:uid", validateFirebaseToken, (req, res) => {
    const { uid } = req.params;

    Tag.findOneAndDelete({ uid })
        .then((deletedTag) => {
            if (!deletedTag) {
                return res.status(404).json({ error: "Tag not found" });
            }
            res.status(200).json({ message: "Tag deleted successfully" });
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

module.exports = router;