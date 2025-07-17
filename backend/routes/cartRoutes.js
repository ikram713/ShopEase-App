const express = require("express");
const router = express.Router();
const cartController = require("../controllers/cartController");

router.post("/add", cartController.addToCart);
/**
 * @swagger
 * tags:
 *   name: Cart
 *   description: Shopping cart operations
 */

/**
 * @swagger
 * /cart/add:
 *   post:
 *     summary: Add an item to the user's cart
 *     tags: [Cart]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *               - itemId
 *               - quantity
 *             properties:
 *               userId:
 *                 type: string
 *                 example: "64adf8e7a45cbe8a60e9a221"
 *               itemId:
 *                 type: string
 *                 example: "64a6d2bdf7f445ed79c76f20"
 *               quantity:
 *                 type: integer
 *                 example: 2
 *     responses:
 *       201:
 *         description: Item added to cart
 *       400:
 *         description: Invalid input or item not found
 */

router.post("/get", cartController.getUserCart);

/**
 * @swagger
 * /cart/get:
 *   post:
 *     summary: Get the user's cart items
 *     tags: [Cart]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *             properties:
 *               userId:
 *                 type: string
 *                 example: "64adf8e7a45cbe8a60e9a221"
 *     responses:
 *       200:
 *         description: Returns the user's cart items
 *       404:
 *         description: User not found or cart is empty
 */

module.exports = router;
