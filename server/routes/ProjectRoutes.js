const router = require("express").Router();
const Project = require("../models/ProjectModel");
const validateFirebaseToken = require('../utils/validate.js')

// create project document in mongodb
router.post("/project", validateFirebaseToken, (req, res) => {

    const uid = req.body.uid;
    const images = req.body.images;
    const title = req.body.title;
    const description = req.body.description;
    const tags = req.body.tags;
  
    const newProject = new Project({
      uid,
      images,
      title,
      description,
      tags
    });
  
    newProject
      .save()
      .then(() => res.status(200).json("New Project document created!"))
      .catch((err) => res.status(400).json("Error: " + err));
});

// read one by uid
router.get("/project/:uid", validateFirebaseToken, (req, res) => {
    const { uid } = req.params;

    Project.findOne({ uid })
        .then((project) => {
            if (!project) {
                return res.status(404).json({ error: "Project not found" });
            }
            res.status(200).json(project);
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

// read all documents
router.get("/", validateFirebaseToken, (req, res) => {
    Project.find()
      .then((project) => {
        res.status(200).json(project)
        console.log(JSON.stringify(project))
    })
      .catch((err) => res.status(400).json("Error: " + err));
});

// update project document
router.put("/project/:uid", validateFirebaseToken, (req, res) => {
    const { uid } = req.params;
    const updatedData = req.body; // Data to update

    Project.findOneAndUpdate({ uid }, updatedData, { new: true })
        .then((updatedProject) => {
            if (!updatedProject) {
                return res.status(404).json({ error: "Project not found" });
            }
            res.status(200).json({ message: "Project updated successfully", project: updatedProject });
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

// delete project document
router.delete("/project/:uid", validateFirebaseToken, (req, res) => {
    const { uid } = req.params;

    Project.findOneAndDelete({ uid })
        .then((deletedProject) => {
            if (!deletedProject) {
                return res.status(404).json({ error: "Project not found" });
            }
            res.status(200).json({ message: "Project deleted successfully" });
        })
        .catch((err) => res.status(500).json({ error: "Error: " + err }));
});

module.exports = router;