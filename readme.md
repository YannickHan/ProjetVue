# PhantomWaves

> A full-stack music streaming web application using featuring an audio player, playlist management, customer support and an admin panel.

---

## Overview

**PhantomWaves** is a music streaming web application built as part of a school project. It offers a modern interface inspired by major streaming platforms (Spotify-like), including:

- An integrated audio player
- Personalized playlist management
- User authentication (user / admin roles)
- A full admin dashboard
- Customer support (ticketing system)
- A music quiz activity

---

## Tech Stack

### Frontend
| Technology | Version |
|---|---|
| Vue.js | 3.x |
| Vue Router | 4.x |
| Tailwind CSS | 4.x |
| Vite | 7.x |

### Backend
| Technology | Version |
|---|---|
| Node.js | — |
| Express | 5.x |
| MySQL2 | 3.x |
| bcrypt | 6.x |
| dotenv | 17.x |
| CORS | 2.x |

---

## Prerequisites

Make sure you have the following installed:

- [Node.js](https://nodejs.org/) (v18 or higher recommended)
- [MySQL](https://www.mysql.com/) (v8 recommended)
- npm

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/YannickHan/ProjetVue.git
cd ProjetVue
```

### 2. Install dependencies

```bash
npm run install
```

> This command automatically installs both Frontend and Backend dependencies using `concurrently`.

### 3. Set up the database

Import the SQL schema into your MySQL server:

```bash
mysql -u root -p < BackEnd/database/mydbV2.sql
mysql -u root -p mydb < BackEnd/database/mydbInsert.sql
```

### 4. Configure environment variables

Create a `.env` file inside the `BackEnd/` folder:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=mydb
PORT=3000
```

---

## Running the Project

### Start both servers simultaneously

```bash
npm run dev
```

This starts:
- the **Express server** at `http://localhost:3000`
- the **Vite dev server (Vue.js)** at `http://localhost:5173` (accessible on local network)

### Individual commands

```bash
# Backend only
npm run server

# Frontend only
cd FrontEnd && npm run dev

# Production build (Frontend)
cd FrontEnd && npm run build
```

---

## Project Structure

```
ProjetVue/
├── BackEnd/
│   ├── database/
│   │   ├── mydbV2.sql          # Database schema
│   │   └── mydbInsert.sql      # Seed data
│   ├── handlers/
│   │   ├── authHandler.js      # Authentication (login, register, profile)
│   │   ├── musicHandler.js     # Songs, artists, playlists, likes
│   │   └── savHandler.js       # Customer support (SAV)
│   ├── public/                 # Static audio and image files
│   ├── config.js               # Global config (port, token, SQL queries)
│   ├── db.js                   # MySQL connection pool
│   ├── index.js                # Express entry point & routes
│   └── utils.js                # Utility functions
│
├── FrontEnd/
│   ├── src/
│   │   ├── views/
│   │   │   ├── HomeView.vue        # Home page
│   │   │   ├── WebPlayerView.vue   # Web player
│   │   │   ├── LoginView.vue       # Login / Register
│   │   │   ├── AdminView.vue       # Admin dashboard
│   │   │   ├── SupportView.vue     # Customer support
│   │   │   └── AboutView.vue       # About / Quiz
│   │   ├── components/             # Reusable Vue components
│   │   ├── router/                 # Vue Router configuration
│   │   ├── services/               # API call services
│   │   ├── store/                  # Global state management
│   │   └── main.js                 # Vue entry point
│   ├── index.html
│   └── vite.config.js
│
└── package.json                # Root scripts (dev, install)
```

---

## API Routes

### Authentication

| Method | Route | Description |
|---|---|---|
| `POST` | `/api/login` | User login |
| `POST` | `/api/register` | User registration |
| `GET` | `/api/profile` | Get logged-in user profile |

### Songs

| Method | Route | Description |
|---|---|---|
| `GET` | `/api/songs` | Get all songs |
| `GET` | `/api/songs/search` | Search songs by title |
| `GET` | `/api/artists/:name/songs` | Get songs by artist |
| `GET` | `/api/trendingSongs` | Get trending songs |
| `GET` | `/api/genres` | Get all genres |
| `POST` | `/api/addSongs` | Add a song (admin) |
| `PUT` | `/api/songs/:id` | Update a song (admin) |
| `DELETE` | `/api/songs/:id` | Delete a song (admin) |

### Artists

| Method | Route | Description |
|---|---|---|
| `GET` | `/api/artists` | Get all artists |
| `GET` | `/api/trendingArtists` | Get trending artists |
| `POST` | `/api/artists` | Add an artist (admin) |
| `PUT` | `/api/artists/:id` | Update an artist (admin) |
| `DELETE` | `/api/artists/:id` | Delete an artist (admin) |

### Likes

| Method | Route | Description |
|---|---|---|
| `POST` | `/api/songs/:id/like` | Like a song |
| `DELETE` | `/api/songs/:id/like` | Remove a like |
| `GET` | `/api/users/:id/likes` | Get a user's liked songs |

### Playlists

| Method | Route | Description |
|---|---|---|
| `POST` | `/api/playlists` | Create a playlist |
| `GET` | `/api/users/:id/playlists` | Get a user's playlists |
| `GET` | `/api/playlists/:id` | Get playlist details |
| `POST` | `/api/playlists/:id/songs` | Add a song to a playlist |
| `DELETE` | `/api/playlists/:id/songs/:songId` | Remove a song from a playlist |
| `PUT` | `/api/playlists/:id` | Update a playlist |
| `DELETE` | `/api/playlists/:id` | Delete a playlist |

### Customer Support (SAV)

| Method | Route | Description |
|---|---|---|
| `POST` | `/api/sav` | Submit a support ticket |
| `GET` | `/api/sav` | List all tickets (admin) |
| `PUT` | `/api/sav/:id/status` | Update ticket status |
| `PUT` | `/api/sav/:id/adminNote` | Add an admin note to a ticket |

---

## Database

The `mydb` schema includes the following tables:

- **`user`** — Users (name, email, hashed password, admin role)
- **`artist`** — Artists (name, banners, profile picture)
- **`song`** — Songs (title, duration, release date, genre, audio file path)
- **`genre`** — Music genres
- **`playlist`** — User playlists
- **`playlisthassong`** — Playlist ↔ song association
- **`artisthassong`** — Artist ↔ song association
- **`sav`** — Customer support tickets

---

## Features

- **Authentication** — Registration, login and session management with token
- **Audio Player** — Play tracks with full controls (play, pause, next, previous)
- **Playlists** — Create, edit, delete and manage personal playlists
- **Admin Panel** — Full management of songs and artists
- **Quiz** — Music quiz activity
- **Support** — Customer ticketing system with admin follow-up

---

## Authors

| Name | ID |
|---|---|
| Yannick SHANG QIANG HAN | TP145875 |
| Inès Souad BENALIA | TP145275 |
| Kim Lan TRAN | TP146161 |
