const express = require('express');
const mongoose = require('mongoose');
const path = require('path');
const itemRoutes = require('./routes/itemRoutes');
const searchRoutes = require('./routes/searchRoutes');
const authRoutes = require('./routes/authRoutes');
const likeRoutes = require('./routes/likeRoutes');
const cartRoutes = require("./routes/cartRoutes");
const profileRoutes = require("./routes/profileRoutes");
const cors = require('cors');
require('dotenv').config();
const { swaggerUi, swaggerSpec } = require('./utils/swagger');


const app = express();
const PORT = 5000;
app.use(cors());


// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, {
})
.then(() => console.log("MongoDB connected"))
.catch(err => console.error(err));


// Middleware
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads'))); // Serve image files
app.use('/api/items', itemRoutes); // All item routes
app.use('/search', searchRoutes);
app.use('/api/auth', authRoutes);
app.use('/api', likeRoutes);
app.use("/api/cart", cartRoutes);
app.use("/api/profile", profileRoutes);

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.listen(5000, '0.0.0.0', () => {
  console.log('Server running on http://0.0.0.0:5000');
  console.log("Swagger docs available at http://localhost:5000/api-docs");
});
