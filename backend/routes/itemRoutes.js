const express = require('express');
const Item = require('../models/Item');
const router = express.Router();

const { CloudinaryStorage } = require('multer-storage-cloudinary');
const cloudinary = require('../utils/cloudinary');
const multer = require('multer');

const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'ecommerce_items',
    allowed_formats: ['jpg', 'jpeg', 'png'],
  },
});

const upload = multer({ storage });

/**
 * @swagger
 * tags:
 *   name: Items
 *   description: Item management (CRUD)
 */

/**
 * @swagger
 * /items:
 *   get:
 *     summary: Get all items
 *     tags: [Items]
 *     responses:
 *       200:
 *         description: A list of items
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   _id:
 *                     type: string
 *                   name:
 *                     type: string
 *                   description:
 *                     type: string
 *                   price:
 *                     type: number
 *                   image:
 *                     type: string
 *       500:
 *         description: Error fetching items
 */
router.get('/items', async (req, res) => {
  try {
    const items = await Item.find();
    res.json(items);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error fetching items' });
  }
});

/**
 * @swagger
 * /add-item:
 *   post:
 *     summary: Add a new item with an image
 *     tags: [Items]
 *     consumes:
 *       - multipart/form-data
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - description
 *               - price
 *               - image
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Laptop"
 *               description:
 *                 type: string
 *                 example: "High performance gaming laptop"
 *               price:
 *                 type: number
 *                 example: 1200.99
 *               image:
 *                 type: string
 *                 format: binary
 *     responses:
 *       201:
 *         description: Item added successfully
 *       500:
 *         description: Error saving item
 */
router.post('/add-item', upload.single('image'), async (req, res) => {
  try {
    const { name, description, price } = req.body;
    const image = req.file ? req.file.path : null;

    const newItem = new Item({
      name,
      description,
      price,
      image,
    });

    await newItem.save();
    res.status(201).json({ message: 'Item added successfully', item: newItem });
  } catch (error) {
    console.error('Error saving item:', error);
    res.status(500).json({ error: 'Error saving item' });
  }
});

module.exports = router;
