const router = require("express").Router();
const User = require("../models/UserModel");
const validateFirebaseToken = require('../utils/validate.js')

// create user document in mongodb
router.post("/user", validateFirebaseToken, (req, res) => {

    const uid = req.body.uid;
    const userPhotoURL = req.body.userPhotoURL;
    const username = req.body.username;
  
    const newUser = new User({
      uid,
      userPhotoURL,
      username
    });
  
    newUser
      .save()
      .then(() => res.status(200).json("New User document created!"))
      .catch((err) => res.status(400).json("Error: " + err));
});

// read one by uid
router.get("/user/:uid", validateFirebaseToken, (req, res) => {
    const { uid } = req.params;

    User.findOne({ uid })
        .then((user) => {
            if (!user) {
                return res.status(404).json({ error: "User not found" });
            }
            res.status(200).json(user);
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

// read all documents
router.get("/", validateFirebaseToken, (req, res) => {
    User.find()
      .then((user) => {
        res.status(200).json(user)
        console.log(JSON.stringify(user))
    })
      .catch((err) => res.status(400).json("Error: " + err));
});

// update user document
router.put("/user/:uid", validateFirebaseToken, (req, res) => {
    const { uid } = req.params;
    const updatedData = req.body; // Data to update

    User.findOneAndUpdate({ uid }, updatedData, { new: true })
        .then((updatedUser) => {
            if (!updatedUser) {
                return res.status(404).json({ error: "User not found" });
            }
            res.status(200).json({ message: "User updated successfully", user: updatedUser });
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

// delete user document
router.delete("/user/:uid", validateFirebaseToken, (req, res) => {
    const { uid } = req.params;

    User.findOneAndDelete({ uid })
        .then((deletedUser) => {
            if (!deletedUser) {
                return res.status(404).json({ error: "User not found" });
            }
            res.status(200).json({ message: "User deleted successfully" });
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

module.exports = router;