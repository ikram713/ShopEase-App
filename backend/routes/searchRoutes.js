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



/**
 * @swagger
 * /search:
 *   get:
 *     summary: Search for items by name
 *     tags: [Search]
 *     parameters:
 *       - in: query
 *         name: query
 *         schema:
 *           type: string
 *         required: false
 *         description: The search keyword (e.g., shoes)
 *     responses:
 *       200:
 *         description: List of items that match the search
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Item'
 *       500:
 *         description: Search failed due to server error
 */


module.exports = router;
