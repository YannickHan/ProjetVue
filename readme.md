# PhantomWaves

## Description

**PhantomWaves** is a web development project built using **HTML, CSS and JavaScript**, featuring a modular architecture with a Node.js backend and a dynamic frontend.

---

## Getting Started

### Clone the repository

```bash
git clone <repository-url>
cd phantomwaves
```

---

## Installation & Launch

```bash
npm run install
npm run dev
```

---

## Available Commands

### Development

```bash
npm run install      # Install dependencies
npm run start        # Start development server
npm run dev          # Run development mode
```

### Build

```bash
npm run build    # Build for production
npm run minify   # Minify assets
```

### Cleanup

```bash
npm run clean    # Remove build artifacts
```

### Testing

```bash
npm test         # Run tests
npm run lint     # Lint code
```

---

## Project Structure

```
phantomwaves/
├── Backend/
├── Frontend/
```

---

## Usage

Open `index.html` in your browser or run the development server for a better experience.

---

## Features

* Login system
* Web player
* Admin Pannel
* SAV Support
* Quiz Activity
  
---

## MySQL Integration

### 1. Install dependencies

```bash
cd server
npm install mysql2
```

---

### 2. Setup database connection

Update your `server/index.js`:

```js
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// MySQL connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '', // ← replace with your password
  database: 'phantomwaves_db'
});

db.connect(err => {
  if (err) {
    console.error('MySQL connection error:', err);
    return;
  }
  console.log('Connected to MySQL');
});

// Get all items
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

// Add new item
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


app.listen(3000, () => console.log('Server running on port 3000'));
```

---

### 3. Example Database

Create your database and table:

```sql
CREATE DATABASE IF NOT EXISTS `mydb`;
USE `mydb`;

CREATE TABLE `artist` (
  `idArtist` int NOT NULL AUTO_INCREMENT,
  `nameArtist` varchar(45) NOT NULL,
  `highlightedArtist` tinyint(1) NOT NULL,
  `horizontalBannerArtist` varchar(255) DEFAULT NULL,
  `verticalBannerArtist` varchar(255) DEFAULT NULL,
  `profileArtist` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idArtist`)
) ENGINE=InnoDB;
```

---

## Example Usage in Vue.js

```js
const addItem = async (name) => {
  await fetch('/api/items', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name })
  });
};
```

---

## Author

* Yannick SHANG QIANG HAN | TP145875
* Inès Souad BENALIA | TP145275
* Kim Lan TRAN | TP146161
