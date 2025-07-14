const User = require('../models/User');
const Item = require('../models/Item');

// Like or Unlike Product
exports.likeProduct = async (req, res) => {
  try {
    const { userId, productId } = req.body;

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ msg: 'User not found' });

    const item = await Item.findById(productId);
    if (!item) return res.status(404).json({ msg: 'Item not found' });

    const alreadyLiked = user.likedProducts.includes(productId);

    if (alreadyLiked) {
      user.likedProducts.pull(productId); // unlike
    } else {
      user.likedProducts.push(productId); // like
    }

    await user.save();
    res.json({ likedProducts: user.likedProducts, liked: !alreadyLiked });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get User's Liked Products
exports.getUserLikes = async (req, res) => {
  try {
    const { userId } = req.body;

    const user = await User.findById(userId).populate('likedProducts');
    if (!user) return res.status(404).json({ message: 'User not found' });

    res.json({ favorites: user.likedProducts });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
