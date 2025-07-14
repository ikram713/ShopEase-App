const express = require("express");
const router = express.Router();
const profileController = require("../controllers/profileController");

router.post("/get", profileController.getProfile);
router.put("/edit", profileController.editProfile);
router.put('/avatar', profileController.updateAvatar);

module.exports = router;
