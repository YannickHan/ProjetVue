// Authentication handlers
const bcrypt = require('bcrypt');
const { TOKEN, USER_SELECT, pool } = require('../config');
const { sanitizeUser } = require('../utils');

const profileHandler = async (req, res) => {
  const authHeader = req.headers.authorization || '';
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;

  if (token !== TOKEN) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  try {
    const [rows] = await pool.query(`${USER_SELECT} WHERE adminUser = 1 LIMIT 1`);
    const user = rows[0];

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ user: sanitizeUser(user) });
  } catch (error) {
    console.error('Profile error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const loginHandler = async (req, res) => {
  const { email, password } = req.body;
  try {
    const [rows] = await pool.query(
      `${USER_SELECT} where mailUser=?`,
      [email]
    );

    const user = rows[0];
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const passwordMatch = await bcrypt.compare(password, user.password);

    if (!passwordMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    res.json({ token: TOKEN, user: sanitizeUser(user) });
  } catch (error) {
    console.error(`Login error: `, error);
    res.status(500).json({ message: 'Server error' });
  }
};

const registerHandler = async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ message: 'Missing required fields' });
  }
  try {
    const [existing] = await pool.query(
      'SELECT idUser FROM User WHERE mailUser = ?',
      [email]
    );
    if (existing.length > 0) {
      return res.status(409).json({ message: 'User already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const [result] = await pool.query(
      'INSERT INTO User(nameUser, mailUser, passwordUser, adminUser) values (?,?,?,0)',
      [name, email, hashedPassword]
    );

    const [rows] = await pool.query(`${USER_SELECT} WHERE idUser = ?`, [result.insertId]);
    const newUser = rows[0];

    res.status(201).json({ user: sanitizeUser(newUser) });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = {
  profileHandler,
  loginHandler,
  registerHandler,
};
