// Music handlers
const { pool } = require('../config');

// List all songs with their main artist
const getSongsHandler = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT 
        s.idSong AS idSong,
        s.titleSong AS name,
        a.nameArtist AS artist,
        s.durationSong AS duration,
        s.coverSong AS cover,
        s.pathSong AS path
      FROM Song s
      JOIN ArtistHasSong ahs ON s.idSong = ahs.Song_idSong
      JOIN Artist a ON a.idArtist = ahs.Artist_idArtist
    `);

    res.json(rows);
  } catch (error) {
    console.error('GetSongs error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getTrendingArtistsHandler = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT * FROM Artist WHERE highlightedArtist = 1
    `);

    res.json(rows);
  } catch (error) {
    console.error('GetTrendingArtists error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getArtistsHandler = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT * FROM Artist
    `);
    res.json(rows);
  } catch (error) {
    console.error('GetArtists error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getTrendingSongsHandler = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT s.idSong AS idSong, s.titleSong, s.durationSong, s.coverSong, pathSong, a.nameArtist FROM song s
      INNER JOIN artisthassong ahs ON ahs.song_idSong = s.idSong
      LEFT JOIN artist a ON ahs.artist_idArtist = a.idArtist
      WHERE highlightedSong = 1;
    `);
    res.json(rows);
  } catch (error) {
    console.error('GetTrendingSongs error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const updateSongHandler = async (req, res) => {
  const { idSong } = req.params;
  const { title, release, duration, cover, mp3Url } = req.body;

  if (!title) {
    return res.status(400).json({ success: false, message: 'Title is required' });
  }

  try {
    const [result] = await pool.query(
      'UPDATE Song SET titleSong = ?, releaseSong = ?, durationSong = ?, coverSong = ?, pathSong = ? WHERE idSong = ?',
      [title, release || null, duration || null, cover || null, mp3Url || null, idSong]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Song not found' });
    }

    res.json({ success: true, message: 'Song updated successfully' });
  } catch (error) {
    console.error('UpdateSong error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const deleteSongHandler = async (req, res) => {
  const { idSong } = req.params;
  try {
    // Remove relations first
    await pool.query('DELETE FROM ArtistHasSong WHERE Song_idSong = ?', [idSong]);
    const [result] = await pool.query('DELETE FROM Song WHERE idSong = ?', [idSong]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Song not found' });
    }
    res.json({ success: true, message: 'Song deleted successfully' });
  } catch (error) {
    console.error('DeleteSong error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const addSongHandler = async (req, res) => {
  console.log('Received song data:', req.body);
  
  // Extract field names from frontend form
  const raw = req.body || {};
  const title = raw.title || raw.name || raw.titleSong;
  const release = raw.releaseDate || raw.release || raw.releaseSong || null;
  const duration = raw.duration || raw.durationSong || null;
  const cover = raw.coverUrl || raw.cover || raw.coverSong || null;
  const path = raw.mp3Url || raw.path || raw.pathSong || null;
  const highlighted = raw.highlighted || raw.highlightedSong || 0;
  const artistName = raw.artist || raw.nameArtist || null;

  // Validate required fields
    if (!title) {
      return res.status(400).json({ success: false, message: 'Title is required' });
    }
    if (!duration) {
      return res.status(400).json({ success: false, message: 'Duration is required' });
    }
    if (!cover) {
      return res.status(400).json({ success: false, message: 'Cover URL is required' });
    }
    if (!path) {
      return res.status(400).json({ success: false, message: 'MP3 URL is required' });
    }
    if (!artistName) {
      return res.status(400).json({ success: false, message: 'Artist is required' });
    }

  try {
    // Step 1: Find artist - must exist
    console.log(`Looking for artist: ${artistName}`);
    const [artistRows] = await pool.query(
      'SELECT idArtist FROM Artist WHERE nameArtist = ? LIMIT 1',
      [artistName]
    );

    if (!artistRows || artistRows.length === 0) {
      console.log(`Artist not found: ${artistName}`);
        return res.status(404).json({ 
          success: false, 
          message: `Artist "${artistName}" does not exist. Please create the artist first.` 
        });
    }

    const artistId = artistRows[0].idArtist;
    console.log(`Found artist ID: ${artistId}`);

    // Step 2: Insert song
    console.log(`Inserting song: ${title}`);
    const [result] = await pool.query(
      'INSERT INTO Song (titleSong, releaseSong, durationSong, coverSong, highlightedSong, pathSong) VALUES (?, ?, ?, ?, ?, ?)',
      [title, release, duration, cover, highlighted ? 1 : 0, path]
    );
    const songId = result.insertId;
    console.log(`Song inserted with ID: ${songId}`);

    // Step 3: Create relationship between artist and song
    console.log(`Linking artist ${artistId} to song ${songId}`);
    await pool.query(
      'INSERT INTO ArtistHasSong (Artist_idArtist, Song_idSong) VALUES (?, ?)',
      [artistId, songId]
    );
    console.log('Song successfully linked to artist');

      res.status(201).json({ 
        success: true, 
        message: 'Song added successfully', 
        id: songId, 
        artistId 
      });
  } catch (error) {
    console.error('AddSong error:', error);
      res.status(500).json({ 
        success: false, 
        message: 'Server error', 
        error: error.message 
      });
  }
};

const addArtistHandler = async (req, res) => {
    const { name, horizontalBanner, verticalBanner, profileAvatar } = req.body;
    if (!name) {
        return res.status(400).json({ success: false, message: 'Artist name is required' });
    }
    try {
        const [result] = await pool.query(
            'INSERT INTO Artist (nameArtist, horizontalBannerArtist, verticalBannerArtist, profileArtist) VALUES (?, ?, ?, ?)',
            [name, horizontalBanner, verticalBanner, profileAvatar]
        );
        res.status(201).json({ success: true, message: 'Artist added successfully', id: result.insertId });
    } catch (error) {   
        console.error('AddArtist error:', error);
        res.status(500).json({ success: false, message: 'Server error', error: error.message });
    }
};

const updateArtistHandler = async (req, res) => {
    const { idArtist } = req.params;
    const { name, horizontalBanner, verticalBanner, profileAvatar } = req.body;
    
    if (!name) {
        return res.status(400).json({ success: false, message: 'Artist name is required' });
    }
    
    try {
        console.log(`Updating artist ${idArtist}: ${name}`);
        const [result] = await pool.query(
            'UPDATE Artist SET nameArtist = ?, horizontalBannerArtist = ?, verticalBannerArtist = ?, profileArtist = ? WHERE idArtist = ?',
            [name, horizontalBanner, verticalBanner, profileAvatar, idArtist]
        );
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: 'Artist not found' });
        }
        
        res.json({ success: true, message: 'Artist updated successfully' });
    } catch (error) {
        console.error('UpdateArtist error:', error);
        res.status(500).json({ success: false, message: 'Server error', error: error.message });
    }
};

const deleteArtistHandler = async (req, res) => {
    const { idArtist } = req.params;
    
    try {
        console.log(`Deleting artist ${idArtist}`);
        
        // First delete artist from ArtistHasSong
        await pool.query('DELETE FROM ArtistHasSong WHERE Artist_idArtist = ?', [idArtist]);
        
        // Then delete the artist
        const [result] = await pool.query('DELETE FROM Artist WHERE idArtist = ?', [idArtist]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: 'Artist not found' });
        }
        
        res.json({ success: true, message: 'Artist deleted successfully' });
    } catch (error) {
        console.error('DeleteArtist error:', error);
        res.status(500).json({ success: false, message: 'Server error', error: error.message });
    }
};

module.exports = {
  getSongsHandler,
  getTrendingArtistsHandler,
  getTrendingSongsHandler,
  addSongHandler,
  updateSongHandler,
  deleteSongHandler,
  getArtistsHandler,
  addArtistHandler,
  updateArtistHandler,
  deleteArtistHandler
};

