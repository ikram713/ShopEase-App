const express = require("express");
const router = express.Router();
const profileController = require("../controllers/profileController");

/**
 * @swagger
 * tags:
 *   name: Profile
 *   description: Endpoints for user profile management
 */

/**
 * @swagger
 * /profile/get:
 *   post:
 *     summary: Get user profile
 *     tags: [Profile]
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
 *                 description: ID of the user
 *                 example: "64aebc12f3f2897d5c2b739e"
 *     responses:
 *       200:
 *         description: Successfully retrieved user profile
 *       404:
 *         description: User not found
 *       500:
 *         description: Server error
 */
router.post("/get", profileController.getProfile);

/**
 * @swagger
 * /profile/edit:
 *   put:
 *     summary: Edit user profile
 *     tags: [Profile]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *               - username
 *               - email
 *             properties:
 *               userId:
 *                 type: string
 *                 example: "64aebc12f3f2897d5c2b739e"
 *               username:
 *                 type: string
 *                 example: "ikramUser"
 *               email:
 *                 type: string
 *                 example: "ikram@example.com"
 *     responses:
 *       200:
 *         description: Profile updated successfully
 *       404:
 *         description: User not found
 *       500:
 *         description: Failed to update profile
 */
router.put("/edit", profileController.editProfile);

/**
 * @swagger
 * /profile/avatar:
 *   put:
 *     summary: Update user avatar
 *     tags: [Profile]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userId
 *               - avatar
 *             properties:
 *               userId:
 *                 type: string
 *                 example: "64aebc12f3f2897d5c2b739e"
 *               avatar:
 *                 type: string
 *                 description: Public URL of the new avatar image
 *                 example: "https://res.cloudinary.com/demo/image/upload/v1620000000/avatar.jpg"
 *     responses:
 *       200:
 *         description: Avatar updated successfully
 *       400:
 *         description: Missing userId or avatar URL
 *       404:
 *         description: User not found
 *       500:
 *         description: Failed to update avatar
 */
router.put("/avatar", profileController.updateAvatar);

module.exports = router;
