const User = require("../models/User");

// GET /api/profile
exports.getProfile = async (req, res) => {
    const { userId } = req.body;

    try {
    const user = await User.findById(userId).select("-password");
    if (!user) return res.status(404).json({ success: false, message: "User not found" });

    res.status(200).json({ success: true, user });
    } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Server error" });
    }
};

// PUT /api/profile/edit
exports.editProfile = async (req, res) => {
    const { userId, username, email } = req.body;

    try {
    const updatedUser = await User.findByIdAndUpdate(
        userId,
        { username, email },
        { new: true, runValidators: true }
    ).select("-password");

    if (!updatedUser)
        return res.status(404).json({ success: false, message: "User not found" });

    res.status(200).json({ success: true, user: updatedUser });
    } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Failed to update profile" });
    }
};


exports.updateAvatar = async (req, res) => {
    const { userId, avatar } = req.body;

    if (!userId || !avatar) {
    return res.status(400).json({ success: false, message: "Missing userId or avatar URL" });
    }

    try {
    const updatedUser = await User.findByIdAndUpdate(
        userId,
      { avatar }, // 👈 set the avatar field
        { new: true, runValidators: true }
    ).select("-password");

    if (!updatedUser) {
        return res.status(404).json({ success: false, message: "User not found" });
    }

    res.status(200).json({ success: true, user: updatedUser });
    } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Failed to update avatar" });
    }
};