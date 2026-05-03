const express = require('express');
const cors = require('cors');
const { PORT } = require('./config');

// Import handlers
const { profileHandler, loginHandler, registerHandler } = require('./handlers/authHandler');
const { getSongsHandler, getTrendingArtistsHandler, getTrendingSongsHandler, addSongHandler, getArtistsHandler, addArtistHandler, updateArtistHandler, deleteArtistHandler, updateSongHandler, deleteSongHandler } = require('./handlers/musicHandler');
const { addSAVHandler, getSAVHandler, updateStatusSAVHandler, updateAdminNoteSAVHandler } = require('./handlers/savHandler');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use('/static', express.static('public'));

// Routes
app.get('/api/data', (req, res) => {
  res.json({ message: "Hello from the Express backend!" });
});

// Authentication routes
app.get(['/api/profile', '/profile'], profileHandler);
app.post(['/api/login', '/login'], loginHandler);
app.post(['/api/register', '/register'], registerHandler);

// Music routes
app.get('/api/songs', getSongsHandler);
app.get('/api/trendingArtists', getTrendingArtistsHandler);
app.get('/api/trendingSongs', getTrendingSongsHandler);
app.post('/api/addSongs', addSongHandler);
app.put('/api/songs/:idSong', updateSongHandler);
app.delete('/api/songs/:idSong', deleteSongHandler);
app.get('/api/artists', getArtistsHandler);
app.post('/api/artists', addArtistHandler);
app.put('/api/artists/:idArtist', updateArtistHandler);
app.delete('/api/artists/:idArtist', deleteArtistHandler);

// SAV routes
app.post('/api/sav', addSAVHandler);
app.get('/api/sav', getSAVHandler);
app.put('/api/sav/:idSAV/status', updateStatusSAVHandler);
app.put('/api/sav/:idSAV/adminNote', updateAdminNoteSAVHandler);

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});