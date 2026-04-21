const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;
const pool = require('./db');

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

const USER_SELECT = `
    SELECT idUser AS id,
      nameUser AS name,
      mailUser AS email,
      passwordUser AS password,
      IF(adminUser = 1, 'admin', 'user') AS role
    FROM User
    `;
    
// Middleware
app.use(cors());
app.use(express.json());
app.use('/static', express.static('public'));


// Routes
app.get('/api/data', (req, res) => {
  res.json({ message: "Hello from the Express backend!" });
});

const profileHandler =  async (req, res) => {
  const authHeader = req.headers.authorization || '';
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;

  if (token !== TOKEN) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  try {
    const [rows] = await pool.query(`${USER_SELECT} WHERE adminUser = 1 LIMIT 1`);
    const user = rows[0];

    if(!user){
      return res.status(404).json({message: 'User not found'});
    }
  

  res.json({ user: sanitizeUser(user) });
  }catch(error){
    console.error('Profile error:', error);
    res.status(500).json({message: 'Server error'})
  }
};

const loginHandler = async (req, res) => {
  const { email, password } = req.body;
try{
  const [rows]=await pool.query(
    `${USER_SELECT} where mailUser=? AND passwordUser = ?`, [email, password]
  ); 
  const user = rows[0];
  console.log("Login attempt:",email, "Found user:", !!user);

  if(!user){
    return res.status(401).json({ message: 'Invalid credentials'})
  }
  res.json({token: TOKEN, user: sanitizeUser(user)});
}catch(error){
  console.error(`Login error: `, error)
  res.status(500).json({message:'Server error'});
}
}

const registerHandler = async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ message: 'Missing required fields' });
  }
try{
  const [existing] = await pool.query(
    'SELECT idUser FROM User WHERE mailUser = ?',
    [email]
  );
  if(existing.length > 0){
    return res.status(409).json({message: 'User already exists'});
  }

  const[result]= await pool.query(
    'INSERT INTO user(nameUser, mailUser, passwordUser, adminUser) values (?,?,?,0)',
    [name, email,password] 
  );

  const [rows] = await pool.query(`${USER_SELECT} WHERE idUser = ?`, [result.insertId]);
  const newUser = rows[0];

  res.status(201).json({user: sanitizeUser(newUser)});
} catch(error) {
  console.error('Register error:', error);
  res.status(500).json({message: 'Server error'});
};

}
// Liste toutes les chansons avec leur artiste principal
const getSongsHandler = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT 
        s.titleSong AS name,
        a.nameArtist AS artist,
        s.durationSong AS duration,
        s.coverSong AS cover,
        s.pathSong AS path
      FROM Song s
      JOIN ArtistHasSong ahs ON s.idSong = ahs.Song_idSong
      JOIN Artist a ON a.idArtist = ahs.Artist_idArtist
      ORDER BY s.idSong
    `);
    
    res.json(rows);
  } catch (error) {
    console.error('GetSongs error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

app.get('/api/songs', getSongsHandler);
app.get(['/api/profile', '/profile'], profileHandler);
app.post(['/api/login', '/login'], loginHandler);
app.post(['/api/register', '/register'], registerHandler);

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});