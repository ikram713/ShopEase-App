const express = require('express');
const Item = require('../models/Item');
const router = express.Router();

// 👇 Cloudinary config
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const cloudinary = require('../utils/cloudinary'); // create this file (shown below)
const multer = require('multer');

// 👇 Setup Multer to use Cloudinary
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'ecommerce_items',
    allowed_formats: ['jpg', 'jpeg', 'png'],
  },
});

const upload = multer({ storage });


// Route to add a new item
router.post('/add-item', upload.single('image'), async (req, res) => {
  try {
    const { name, description, price } = req.body;
    const image = req.file ? req.file.path : null; //  Cloudinary URL

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


//  Route to get all items
router.get('/items', async (req, res) => {
  try {
    const items = await Item.find();
    res.json(items); // No need to prepend with host now (image is already a URL)
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error fetching items' });
  }
});

module.exports = router;
