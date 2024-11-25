const router = require("express").Router();
const User = require("../models/UserModel");
const validateFirebaseToken = require('../utils/validate.js')

router.post("/user", validateFirebaseToken, (req, res) => {

    const uid = req.body.uid;
    const userPhotoURL = req.body.userPhotoURL;
    const username = req.body.username;
    const connections = req.body.connections;
    const media = req.body.media;
    const locationLat = req.body.locationLat;
    const locationLong = req.body.locationLong;
  
    const newUser = new User({
      uid,
      userPhotoURL,
      connections,
      username,
      media,
      locationLat,
      locationLong
    });
  
    newUser
      .save()
      .then(() => res.status(200).json("New User document created!"))
      .catch((err) => res.status(400).json("Error: " + err));
});

//read all
router.get("/", validateFirebaseToken, (req, res) => {
    User.find()
      .then((user) => {
        res.status(200).json(user)
        console.log(JSON.stringify(user))
    })
      .catch((err) => res.status(400).json("Error: " + err));
});

  module.exports = router;