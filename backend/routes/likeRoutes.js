const express = require('express');
const router = express.Router();
const { likeProduct, getUserLikes } = require('../controllers/likeController');

/**
 * @swagger
 * tags:
 *   name: Likes
 *   description: Like system for products
 */

/**
 * @swagger
 * /like:
 *   post:
 *     summary: Like or unlike a product
 *     tags: [Likes]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *               - productId
 *             properties:
 *               userId:
 *                 type: string
 *                 example: "64aebc12f3f2897d5c2b739e"
 *               productId:
 *                 type: string
 *                 example: "64aebf6b69e22d9a83a8a6c2"
 *     responses:
 *       200:
 *         description: Product liked or unliked successfully
 *       500:
 *         description: Server error
 */
router.post('/like', likeProduct);

/**
 * @swagger
 * /get-likes:
 *   post:
 *     summary: Get all liked product IDs for a user
 *     tags: [Likes]
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
 *                 example: "64aebc12f3f2897d5c2b739e"
 *     responses:
 *       200:
 *         description: List of liked products
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 likedProducts:
 *                   type: array
 *                   items:
 *                     type: string
 *       500:
 *         description: Server error
 */
router.post('/get-likes', getUserLikes);

module.exports = router;
