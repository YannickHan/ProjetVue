const API_URL = "http://localhost:3000";

export const getTrendingArtists = async () => {
    const res = await fetch(`${API_URL}/api/trendingArtists`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
    });
    if (!res.ok) {
        throw new Error("Failed to fetch trending artists");
    }
    return await res.json();
};

export const getTrendingSongs = async () => {
    const res = await fetch(`${API_URL}/api/trendingSongs`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
    });
    if (!res.ok) {
        throw new Error("Failed to fetch trending songs");
    }
    return await res.json();
};

export const getSongs = async () => {
    const res = await fetch(`${API_URL}/api/songs`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
    });
    if (!res.ok) {
        throw new Error("Failed to fetch songs");
    }
    return await res.json();
};

export const searchSongsByTitle = async (title) => {
    const params = new URLSearchParams({ title: title || "" });
    const res = await fetch(`${API_URL}/api/songs/search?${params.toString()}`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
    });

    if (!res.ok) {
        throw new Error("Failed to search songs");
    }

    return await res.json();
};

export const updateSong = async (songId, songData) => {
    const res = await fetch(`${API_URL}/api/songs/${songId}`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(songData),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data?.message || data?.error || "Failed to update song");
    }
    return data;
};

export const deleteSong = async (songId) => {
    console.log(`Attempting to delete song with ID: ${songId}`);
    const res = await fetch(`${API_URL}/api/songs/${songId}`, {
        method: "DELETE",
        headers: {
            "Content-Type": "application/json",
        },
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data?.message || data?.error || "Failed to delete song");
    }
    return data;
};

export const getArtists = async () => {
    const res = await fetch(`${API_URL}/api/artists`, {
        method: "GET",
        headers: { "Content-Type": "application/json" },
    });
    if (!res.ok) throw new Error('Failed to fetch artists');
    return await res.json();
};

export const getLikedSongs = async (userId) => {
    const res = await fetch(`${API_URL}/api/users/${userId}/likes`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data?.message || 'Failed to fetch liked songs');
    }
    return data;
};

export const addSong = async (songData) => {
    const res = await fetch(`${API_URL}/api/addSongs`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(songData),
    });

    const data = await res.json().catch(() => ({}));

    if (!res.ok) {
        throw new Error(data?.message || data?.error || "Failed to add song");
    }

    return data;
};

export const addArtist = async (artistData) => {
    const res = await fetch(`${API_URL}/api/artists`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(artistData),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data?.message || data?.error || "Failed to add artist");
    }
    return data;
};

export const updateArtist = async (artistId, artistData) => {
    const res = await fetch(`${API_URL}/api/artists/${artistId}`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(artistData),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data?.message || data?.error || "Failed to update artist");
    }
    return data;
};

export const deleteArtist = async (artistId) => {
    const res = await fetch(`${API_URL}/api/artists/${artistId}`, {
        method: "DELETE",
        headers: {
            "Content-Type": "application/json",
        },
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) {
        throw new Error(data?.message || data?.error || "Failed to delete artist");
    }
    return data;
};

export const likeSong = async (songId, userId) => {
    const res = await fetch(`${API_URL}/api/songs/${songId}/like`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userId }),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(data?.message || 'Failed to like song');
    return data;
};

export const unlikeSong = async (songId, userId) => {
    const res = await fetch(`${API_URL}/api/songs/${songId}/like`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userId }),
    });
    const data = await res.json().catch(() => ({}));
    if (!res.ok) throw new Error(data?.message || 'Failed to unlike song');
    return data;
};

export const getUserLikes = async (userId) => {
    const res = await fetch(`${API_URL}/api/users/${userId}/likes`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
    });
    const data = await res.json().catch(() => ({}));
    console.log(`Fetched liked songs for user ${userId}:`, data);
    if (!res.ok) throw new Error(data?.message || 'Failed to get user likes');
    return data;
};
