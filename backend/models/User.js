const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  likedProducts: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Item' }],
  
  // 👇 Add these optional fields
  avatar: {
    type: String, // URL to the image
    default: null,
  },
  phone: {
    type: String,
    default: null,
  }
},
{ timestamps: true });

module.exports = mongoose.model('User', userSchema);
