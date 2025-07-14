const express = require('express');
const router = express.Router();
const Item = require('../models/Item');

// GET /search?query=shoes
router.get('/', async (req, res) => {
    const searchQuery = req.query.query || '';
    try {
    const results = await Item.find({
      name: { $regex: searchQuery, $options: 'i' }, // case-insensitive
    });
    res.json(results);
    } catch (err) {
    res.status(500).json({ error: 'Search failed', details: err.message });
    }
});

module.exports = router;
