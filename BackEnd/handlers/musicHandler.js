// Music handlers
const { pool } = require('../config');

// List all songs with their main artist
const getSongsHandler = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT 
        s.idSong AS idSong,
        s.titleSong AS name,
        s.idGenre AS idGenre,
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

const searchSongsByTitleHandler = async (req, res) => {
  const title = (req.query.title || '').trim();

  if (!title) {
    return res.json([]);
  }

  console.log(`Searching songs with title like: ${title}`);
  
  try {
    const [rows] = await pool.query(
      `
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
      WHERE s.titleSong LIKE ?
      ORDER BY s.titleSong ASC
      `,
      [`%${title}%`]
    );

    res.json(rows);
  } catch (error) {
    console.error('SearchSongsByTitle error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getSongsByArtistHandler = async (req, res) => {
  const name = (req.params.nameArtist || '').trim();
  if (!name) {
    return res.json([]);
  }

  try {
    const [rows] = await pool.query(
      `
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
      WHERE a.nameArtist = ?
      ORDER BY s.titleSong ASC
      `,
      [name]
    );
    res.json(rows);
  } catch (error) {
    console.error('GetSongsByArtist error:', error);
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

const getGenresHandler = async (req, res) => {
  try {
    const [genreRows] = await pool.query(`
      SELECT
        idGenre,
        idGenre AS id,
        nameGenre AS name,
        descriptionGenre AS description
      FROM Genre
      ORDER BY nameGenre ASC
    `);

    const [songRows] = await pool.query(`
      SELECT
        s.idSong,
        s.titleSong AS title,
        s.idGenre,
        a.nameArtist AS artist
      FROM Song s
      LEFT JOIN ArtistHasSong ahs ON ahs.Song_idSong = s.idSong
      LEFT JOIN Artist a ON a.idArtist = ahs.Artist_idArtist
      WHERE s.idGenre IS NOT NULL
      ORDER BY s.titleSong ASC
    `);

    const songsByGenre = songRows.reduce((acc, song) => {
      if (!acc[song.idGenre]) acc[song.idGenre] = [];
      if (acc[song.idGenre].length < 4) {
        acc[song.idGenre].push({
          idSong: song.idSong,
          title: song.title,
          artist: song.artist || 'Unknown artist',
        });
      }
      return acc;
    }, {});

    const payload = genreRows.map((genre) => ({
      ...genre,
      examples: songsByGenre[genre.idGenre] || [],
    }));

    res.json(payload);
  } catch (error) {
    console.error('GetGenres error:', error);
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

// Likes handlers (using Playlist/PlaylistHasSong)
const getOrCreateLikedPlaylistId = async (userId) => {
  const normalizedUserId = Number(userId);
  if (!Number.isInteger(normalizedUserId) || normalizedUserId <= 0) {
    return null;
  }

  const [userRows] = await pool.query(
    'SELECT idUser FROM User WHERE idUser = ? LIMIT 1',
    [normalizedUserId]
  );

  if (!userRows || userRows.length === 0) {
    return null;
  }

  const [playlistRows] = await pool.query(
    'SELECT idPlaylist FROM Playlist WHERE User_idUser = ? AND namePlaylist = ? LIMIT 1',
    [normalizedUserId, 'Liked']
  );

  if (playlistRows && playlistRows.length > 0) {
    return playlistRows[0].idPlaylist;
  }

  const [insertResult] = await pool.query(
    'INSERT INTO Playlist (namePlaylist, highlightedPlaylist, User_idUser) VALUES (?, ?, ?)',
    ['Liked', 0, normalizedUserId]
  );

  return insertResult.insertId;
};

const addLikeHandler = async (req, res) => {
  const { idSong } = req.params;
  const { userId } = req.body;

  if (!userId) return res.status(400).json({ success: false, message: 'userId is required' });

  try {
    // Ensure song exists
    const [songRows] = await pool.query('SELECT idSong FROM Song WHERE idSong = ?', [idSong]);
    if (!songRows || songRows.length === 0) return res.status(404).json({ success: false, message: 'Song not found' });

    // Ensure user's "Liked" playlist exists
    const playlistId = await getOrCreateLikedPlaylistId(userId);
    if (!playlistId) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    // Check if song already liked
    const [exists] = await pool.query(
      'SELECT Playlist_idPlaylist FROM PlaylistHasSong WHERE Playlist_idPlaylist = ? AND Song_idSong = ?',
      [playlistId, idSong]
    );
    if (exists && exists.length > 0) {
      return res.json({ success: true, message: 'Already liked' });
    }

    // Get next trackPosition
    const [maxPos] = await pool.query(
      'SELECT MAX(trackPosition) as maxPos FROM PlaylistHasSong WHERE Playlist_idPlaylist = ?',
      [playlistId]
    );
    const nextPos = (maxPos[0]?.maxPos || 0) + 1;

    // Add song to Liked playlist
    await pool.query(
      'INSERT INTO PlaylistHasSong (Playlist_idPlaylist, Song_idSong, trackPosition) VALUES (?, ?, ?)',
      [playlistId, idSong, nextPos]
    );
    res.json({ success: true, message: 'Liked' });
  } catch (error) {
    console.error('AddLike error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const removeLikeHandler = async (req, res) => {
  const { idSong } = req.params;
  const { userId } = req.body;

  if (!userId) return res.status(400).json({ success: false, message: 'userId is required' });

  try {
    // Ensure user's "Liked" playlist exists
    const playlistId = await getOrCreateLikedPlaylistId(userId);
    if (!playlistId) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    // Remove song from Liked playlist
    const [result] = await pool.query(
      'DELETE FROM PlaylistHasSong WHERE Playlist_idPlaylist = ? AND Song_idSong = ?',
      [playlistId, idSong]
    );
    if (result.affectedRows === 0) {
      return res.json({ success: true, message: 'Already unliked' });
    }
    res.json({ success: true, message: 'Unliked' });
  } catch (error) {
    console.error('RemoveLike error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const getUserLikesHandler = async (req, res) => {
  const { idUser } = req.params;
  try {
    // Ensure user's "Liked" playlist exists
    const playlistId = await getOrCreateLikedPlaylistId(idUser);
    if (!playlistId) {
      // Stale frontend session or deleted user: return empty likes without server error.
      return res.json({ success: true, likes: [] });
    }

    // Get all songs in user's Liked playlist with full song attributes
    const [rows] = await pool.query(
      `
      SELECT
        s.idSong AS idSong,
        s.titleSong AS name,
        a.nameArtist AS artist,
        s.durationSong AS duration,
        s.coverSong AS cover,
        s.pathSong AS path,
        phs.trackPosition AS trackPosition
      FROM PlaylistHasSong phs
      JOIN Song s ON s.idSong = phs.Song_idSong
      LEFT JOIN ArtistHasSong ahs ON ahs.Song_idSong = s.idSong
      LEFT JOIN Artist a ON a.idArtist = ahs.Artist_idArtist
      WHERE phs.Playlist_idPlaylist = ?
      ORDER BY phs.trackPosition ASC, s.titleSong ASC
      `,
      [playlistId]
    );
    res.json({ success: true, likes: rows });
  } catch (error) {
    console.error('GetUserLikes error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Playlists handlers
const createPlaylistHandler = async (req, res) => {
  const { name, userId, cover } = req.body;
  if (!name || !userId) return res.status(400).json({ success: false, message: 'name and userId required' });

  try {
    const normalizedUserId = Number(userId);
    const [userRows] = await pool.query('SELECT idUser FROM User WHERE idUser = ? LIMIT 1', [normalizedUserId]);
    if (!userRows || userRows.length === 0) return res.status(404).json({ success: false, message: 'User not found' });

    const [result] = await pool.query(
      'INSERT INTO Playlist (namePlaylist, highlightedPlaylist, User_idUser, coverPlaylist) VALUES (?, ?, ?, ?)',
      [name, 0, normalizedUserId, cover || null]
    );

    res.status(201).json({ success: true, id: result.insertId });
  } catch (error) {
    console.error('CreatePlaylist error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const getUserPlaylistsHandler = async (req, res) => {
  const { idUser } = req.params;
  try {
    const normalizedUserId = Number(idUser);
    const [userRows] = await pool.query('SELECT idUser FROM User WHERE idUser = ? LIMIT 1', [normalizedUserId]);
    if (!userRows || userRows.length === 0) return res.status(404).json({ success: false, message: 'User not found' });

    const [playlists] = await pool.query('SELECT idPlaylist, namePlaylist, highlightedPlaylist, coverPlaylist FROM Playlist WHERE User_idUser = ? ORDER BY idPlaylist DESC', [normalizedUserId]);

    // fetch songs for these playlists
    const playlistIds = playlists.map(p => p.idPlaylist);
    let songsByPlaylist = {};
    if (playlistIds.length > 0) {
      const [rows] = await pool.query(
        `SELECT phs.Playlist_idPlaylist AS idPlaylist, phs.Song_idSong AS idSong, s.titleSong AS title, a.nameArtist AS artist, phs.trackPosition
         FROM PlaylistHasSong phs
         JOIN Song s ON s.idSong = phs.Song_idSong
         LEFT JOIN ArtistHasSong ahs ON ahs.Song_idSong = s.idSong
         LEFT JOIN Artist a ON a.idArtist = ahs.Artist_idArtist
         WHERE phs.Playlist_idPlaylist IN (${playlistIds.map(() => '?').join(',')})
         ORDER BY phs.Playlist_idPlaylist, phs.trackPosition ASC`,
        playlistIds
      );

      songsByPlaylist = rows.reduce((acc, r) => {
        if (!acc[r.idPlaylist]) acc[r.idPlaylist] = [];
        acc[r.idPlaylist].push({ idSong: r.idSong, title: r.title, artist: r.artist, trackPosition: r.trackPosition });
        return acc;
      }, {});
    }

    const payload = playlists.map(p => ({ idPlaylist: p.idPlaylist, name: p.namePlaylist, cover: p.coverPlaylist, highlighted: p.highlightedPlaylist, songs: songsByPlaylist[p.idPlaylist] || [] }));
    res.json({ success: true, playlists: payload });
  } catch (error) {
    console.error('GetUserPlaylists error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const addSongToPlaylistHandler = async (req, res) => {
  const { idPlaylist } = req.params;
  const { idSong } = req.body;
  if (!idSong) return res.status(400).json({ success: false, message: 'idSong required' });

  try {
    // ensure playlist exists
    const [plRows] = await pool.query('SELECT idPlaylist FROM Playlist WHERE idPlaylist = ? LIMIT 1', [idPlaylist]);
    if (!plRows || plRows.length === 0) return res.status(404).json({ success: false, message: 'Playlist not found' });

    // ensure song exists
    const [songRows] = await pool.query('SELECT idSong FROM Song WHERE idSong = ? LIMIT 1', [idSong]);
    if (!songRows || songRows.length === 0) return res.status(404).json({ success: false, message: 'Song not found' });

    // check if already in playlist
    const [exists] = await pool.query('SELECT * FROM PlaylistHasSong WHERE Playlist_idPlaylist = ? AND Song_idSong = ?', [idPlaylist, idSong]);
    if (exists && exists.length > 0) return res.json({ success: true, message: 'Already in playlist' });

    const [maxPos] = await pool.query('SELECT MAX(trackPosition) as maxPos FROM PlaylistHasSong WHERE Playlist_idPlaylist = ?', [idPlaylist]);
    const nextPos = (maxPos[0]?.maxPos || 0) + 1;

    await pool.query('INSERT INTO PlaylistHasSong (Playlist_idPlaylist, Song_idSong, trackPosition) VALUES (?, ?, ?)', [idPlaylist, idSong, nextPos]);
    res.json({ success: true, message: 'Added to playlist' });
  } catch (error) {
    console.error('AddSongToPlaylist error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const removeSongFromPlaylistHandler = async (req, res) => {
  const { idPlaylist, idSong } = req.params;
  try {
    const [result] = await pool.query('DELETE FROM PlaylistHasSong WHERE Playlist_idPlaylist = ? AND Song_idSong = ?', [idPlaylist, idSong]);
    if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Song not found in playlist' });
    res.json({ success: true, message: 'Removed from playlist' });
  } catch (error) {
    console.error('RemoveSongFromPlaylist error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const updatePlaylistHandler = async (req, res) => {
  const { idPlaylist } = req.params;
  const { name, cover } = req.body;
  if (!name && !cover) return res.status(400).json({ success: false, message: 'Nothing to update' });

  try {
    const fields = [];
    const values = [];
    if (name) { fields.push('namePlaylist = ?'); values.push(name); }
    if (cover !== undefined) { fields.push('coverPlaylist = ?'); values.push(cover); }
    values.push(idPlaylist);

    const [result] = await pool.query(`UPDATE Playlist SET ${fields.join(', ')} WHERE idPlaylist = ?`, values);
    if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Playlist not found' });
    res.json({ success: true, message: 'Playlist updated' });
  } catch (error) {
    console.error('UpdatePlaylist error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const deletePlaylistHandler = async (req, res) => {
  const { idPlaylist } = req.params;
  try {
    await pool.query('DELETE FROM PlaylistHasSong WHERE Playlist_idPlaylist = ?', [idPlaylist]);
    const [result] = await pool.query('DELETE FROM Playlist WHERE idPlaylist = ?', [idPlaylist]);
    if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Playlist not found' });
    res.json({ success: true, message: 'Playlist deleted' });
  } catch (error) {
    console.error('DeletePlaylist error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

const getPlaylistByIdHandler = async (req, res) => {
  const { idPlaylist } = req.params;
  try {
    const [playlists] = await pool.query('SELECT idPlaylist, namePlaylist, highlightedPlaylist, coverPlaylist, User_idUser FROM Playlist WHERE idPlaylist = ? LIMIT 1', [idPlaylist]);
    if (!playlists || playlists.length === 0) return res.status(404).json({ success: false, message: 'Playlist not found' });

    const p = playlists[0];
    const [songs] = await pool.query(
      `SELECT s.idSong, s.titleSong AS name, a.nameArtist AS artist, s.coverSong AS cover, s.durationSong AS duration, phs.trackPosition
       FROM PlaylistHasSong phs
       JOIN Song s ON s.idSong = phs.Song_idSong
       LEFT JOIN ArtistHasSong ahs ON ahs.Song_idSong = s.idSong
       LEFT JOIN Artist a ON a.idArtist = ahs.Artist_idArtist
       WHERE phs.Playlist_idPlaylist = ?
       ORDER BY phs.trackPosition ASC`,
      [idPlaylist]
    );

    res.json({ 
      success: true, 
      playlist: { 
        idPlaylist: p.idPlaylist, 
        name: p.namePlaylist, 
        cover: p.coverPlaylist, 
        highlighted: p.highlightedPlaylist, 
        userId: p.User_idUser,
        songs: songs || [] 
      } 
    });
  } catch (error) {
    console.error('GetPlaylistById error:', error);
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
  const idGenre = raw.idGenre || null;
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
      'INSERT INTO Song (titleSong, releaseSong, durationSong, coverSong, highlightedSong, idGenre, pathSong) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [title, release, duration, cover, highlighted ? 1 : 0, idGenre, path]
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
  getSongsByArtistHandler,
  searchSongsByTitleHandler,
  getTrendingArtistsHandler,
  getTrendingSongsHandler,
  getGenresHandler,
  addSongHandler,
  updateSongHandler,
  deleteSongHandler,
  getArtistsHandler,
  addArtistHandler,
  updateArtistHandler,
  deleteArtistHandler
  , addLikeHandler, removeLikeHandler, getUserLikesHandler,
  createPlaylistHandler, getUserPlaylistsHandler, getPlaylistByIdHandler, addSongToPlaylistHandler, removeSongFromPlaylistHandler, updatePlaylistHandler, deletePlaylistHandler
};

