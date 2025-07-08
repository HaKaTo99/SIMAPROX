const jwt = require('jsonwebtoken');

exports.login = (req, res) => {
    const { username, password } = req.body;
    if (username === 'admin' && password === 'simapro@123') {
        const token = jwt.sign({ username }, process.env.JWT_SECRET, { expiresIn: '1h' });
        return res.json({ token });
    }
    return res.status(401).json({ message: 'Invalid credentials' });
};
