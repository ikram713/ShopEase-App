const express = require('express');
const router = express.Router();
const { likeProduct, getUserLikes } = require('../controllers/likeController');

// No auth middleware needed
router.post('/like', likeProduct);
router.post('/get-likes', getUserLikes); // changed to POST since we're using req.body

module.exports = router;

