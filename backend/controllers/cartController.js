const Cart = require("../models/Cart");
const Item = require("../models/Item");

exports.addToCart = async (req, res) => {
  const { userId, itemId } = req.body;

  try {
    let cart = await Cart.findOne({ userId });

    if (!cart) {
      cart = new Cart({ userId, items: [{ itemId, quantity: 1 }] });
    } else {
      const existingItem = cart.items.find(i => i.itemId.toString() === itemId);

      if (existingItem) {
        existingItem.quantity += 1;
      } else {
        cart.items.push({ itemId, quantity: 1 });
      }
    }

    await cart.save();
    res.status(200).json({ success: true, message: "Item added to cart", cart });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
  }
};


exports.getUserCart = async (req, res) => {
  const { userId } = req.body;

  try {
    const cart = await Cart.findOne({ userId }).populate("items.itemId");

    if (!cart || cart.items.length === 0) {
      return res.status(200).json({ success: true, cart: [], message: "Cart is empty" });
    }

    res.status(200).json({ success: true, cart: cart.items });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
  }
};
