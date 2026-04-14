const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

const TOKEN = 'WebProjectToken12345';

const users = [
  {
    id: 1,
    name: 'Admin',
    email: 'admin@phantomwaves.com',
    password: 'admin',
    role: 'admin',
  },
  {
    id: 2,
    name: 'User',
    email: 'user@user.com',
    password: 'user',
    role: 'user',
  },
];

const sanitizeUser = (user) => ({
  id: user.id,
  name: user.name,
  email: user.email,
  role: user.role,
});

// Middleware
app.use(cors());
app.use(express.json());


// Routes
app.get('/api/data', (req, res) => {
  res.json({ message: "Hello from the Express backend!" });
});

const profileHandler = (req, res) => {
  const authHeader = req.headers.authorization || '';
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;

  if (token !== TOKEN) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  const user = users[0];

  res.json({ user: sanitizeUser(user) });
};

const loginHandler = (req, res) => {
  const { email, password } = req.body;

  const user = users.find((entry) => entry.email === email && entry.password === password);

  console.log("Login attempt:", email, password, "Found user:", !!user);
  
  if (!user) {
    return res.status(401).json({ message: 'Invalid credentials' });
  }

  res.json({ token: TOKEN, user: sanitizeUser(user) });
};

const registerHandler = (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  const alreadyExists = users.some((entry) => entry.email === email);

  if (alreadyExists) {
    return res.status(409).json({ message: 'User already exists' });
  }

  const newUser = {
    id: users.length + 1,
    name,
    email,
    password,
    role: 'user',
  };

  users.push(newUser);

  res.status(201).json({ user: sanitizeUser(newUser) });
};

app.get(['/api/profile', '/profile'], profileHandler);
app.post(['/api/login', '/login'], loginHandler);
app.post(['/api/register', '/register'], registerHandler);

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});