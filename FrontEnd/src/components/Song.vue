<script setup>
import { ref, watch, onMounted, onBeforeUnmount, reactive, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { authState, logout } from "../store/auth"
import { updateSong, deleteSong, likeSong, unlikeSong, getUserLikes } from '../services/SongServices'
import { getUserPlaylists, addSongToPlaylist, removeSongFromPlaylist, createPlaylist } from '../services/SongServices'

const router = useRouter()
const route = useRoute()
const userLikesCache = new Map()
const userPlaylistsCache = new Map()

// ----------------------------This handle the parent----------------------------
const props = defineProps({
  idSong: [Number, String],
  name: String,
  artist: String,
  duration: String,
  cover: String,
  path: String,
  isPlayingExternal: {
    type: Boolean,
    default: false,
  },
})

// ----------------------------This handle the parent----------------------------
const emit = defineEmits(['play-state-change', 'song-deleted', 'song-updated', 'like-changed'])

// ----------------------------This handle the like---------------------------- 
const isLiked = ref(false)
const isPlaying = ref(false)
const audioRef = ref(null)
const activeAudioSrc = ref('')
const songInstanceId = `${props.idSong ?? `${props.name || ''}-${props.artist || ''}-${props.duration || ''}`}-${Math.random().toString(36).slice(2, 8)}`
const PLAY_EVENT = 'phantomwaves:play-song'
const BACKEND_ORIGIN = 'http://localhost:3000'
const BACKEND_STATIC_BASE = `${BACKEND_ORIGIN}/static/`

const audioCandidates = computed(() => {
  const rawPath = String(props.path || '').trim()
  if (!rawPath) return []
  if (/^https?:\/\//i.test(rawPath)) return [rawPath]

  const normalized = rawPath.replace(/^\/+/, '')
  const parts = normalized.split('/')
  const filename = parts[parts.length - 1]
  const fromMusicRoot = normalized.startsWith('music/') ? normalized : `music/${normalized}`

  const candidates = [
    `${BACKEND_STATIC_BASE}music/${filename}`,
    `${BACKEND_STATIC_BASE}${fromMusicRoot}`,
    `${BACKEND_STATIC_BASE}${normalized}`,
    `/static/${fromMusicRoot}`,
    `/${fromMusicRoot}`,
  ]

  return [...new Set(candidates)].filter(Boolean)
})

const STORAGE_KEY = 'phantomwaves_liked_songs'

const computeSongKey = () => {
  if (props.idSong) return `song:${props.idSong}`
  return `local:${(props.name || '')}::${(props.artist || '')}`
}

const getLikedSongsFromStorage = () => {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) : []
  } catch (e) {
    console.warn('Failed to parse liked songs from storage', e)
    return []
  }
}

const saveLikedSongsToStorage = (arr) => {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(arr))
  } catch (e) {
    console.warn('Failed to save liked songs to storage', e)
  }
}

const getUserLikesCached = async (userId) => {
  if (userLikesCache.has(userId)) return userLikesCache.get(userId)
  const promise = getUserLikes(userId)
  userLikesCache.set(userId, promise)
  return promise
}

const getUserPlaylistsCached = async (userId) => {
  if (userPlaylistsCache.has(userId)) return userPlaylistsCache.get(userId)
  const promise = getUserPlaylists(userId)
  userPlaylistsCache.set(userId, promise)
  return promise
}

const toggleLike = async () => {
  if (!authState.isAuthenticated) {
    router.push('/login')
    return
  }

  const previous = isLiked.value
  isLiked.value = !previous
  const key = computeSongKey()

  const userId = authState.user?.id ?? null
  if (userId && props.idSong) {
    try {
      if (!previous) {
        await likeSong(props.idSong, userId)
      } else {
        await unlikeSong(props.idSong, userId)
      }
    } catch (e) {
      console.error('Like API error:', e)
      isLiked.value = previous
      if ((e?.message || '').toLowerCase().includes('user not found')) {
        logout()
        alert('Your session is no longer valid. Please login again.')
        router.push('/login')
        return
      }
      alert(`❌ Failed to update like on server: ${e?.message || 'unknown error'}`)
      return
    }
  } else {
    const liked = getLikedSongsFromStorage()
    if (isLiked.value) {
      if (!liked.includes(key)) liked.push(key)
    } else {
      const idx = liked.indexOf(key)
      if (idx >= 0) liked.splice(idx, 1)
    }
    saveLikedSongsToStorage(liked)
  }

  emit('like-changed', { key, liked: isLiked.value, idSong: props.idSong || null })
}

const pauseSong = () => {
  if (audioRef.value) audioRef.value.pause()
  isPlaying.value = false
  emit('play-state-change', {
    isPlaying: false,
    name: props.name,
    artist: props.artist,
    duration: props.duration,
    cover: props.cover,
    path: props.path || '',
  })
}

const playSong = async () => {
  if (!audioRef.value || audioCandidates.value.length === 0) {
    alert('No audio file found for this song.')
    return
  }

  const audioEl = audioRef.value
  let lastError = null
  console.debug('[Song] audioCandidates:', audioCandidates.value)
  for (const candidate of audioCandidates.value) {
    console.debug('[Song] trying candidate:', candidate)
    try {
      // reset audio element between attempts
      try { audioEl.pause() } catch (e) {}
      try { audioEl.removeAttribute('src') } catch (e) {}
      try { audioEl.load() } catch (e) {}

      console.debug('[Song] setting audio.src =', candidate)
      try { audioEl.src = candidate } catch (e) { console.warn('[Song] set src error', e); lastError = e; continue }
      try { audioEl.crossOrigin = 'anonymous' } catch (e) {}

      try {
        // attempt play immediately (keeps user gesture)
        const playPromise = audioEl.play()
        if (playPromise && typeof playPromise.then === 'function') await playPromise

        activeAudioSrc.value = candidate
        window.dispatchEvent(new CustomEvent(PLAY_EVENT, { detail: { id: songInstanceId } }))
        isPlaying.value = true
        emit('play-state-change', {
          isPlaying: true,
          name: props.name,
          artist: props.artist,
          duration: props.duration,
          cover: props.cover,
          path: props.path || '',
        })
        return
      } catch (playErr) {
        lastError = playErr
        console.warn('[Song] Candidate failed to play, trying next', candidate, playErr)
      }
    } catch (err) {
      lastError = err
      console.warn('Unexpected candidate error', candidate, err)
    }
  }

  console.error('Audio playback failed for all candidates:', audioCandidates.value, lastError)
  isPlaying.value = false
  alert('Unable to play this song. Check that the file exists on the server and the URL is correct.')
}

const togglePlay = async () => {
  if (!authState.isAuthenticated) {
    localStorage.setItem('pendingRedirect', JSON.stringify({
      path: route.path,
      query: route.query,
    }))
    router.push('/login')
    return
  }

  if (isPlaying.value) {
    pauseSong()
  } else {
    await playSong()
  }
}

const handleAudioEnded = () => {
  isPlaying.value = false
  emit('play-state-change', {
    isPlaying: false,
    name: props.name,
    artist: props.artist,
    duration: props.duration,
    cover: props.cover,
    path: props.path || '',
  })
}
// ----------------------------This handle the playback state---------------------------- 
watch( 
  () => props.isPlayingExternal, 
  (value) => { 
    isPlaying.value = value 
    if (!value && audioRef.value) audioRef.value.pause()
  }, 
  { immediate: true } 
)

// ----------------------------This handle the settings----------------------------
const open = ref(false)
const dropdownRef = ref(null)

const editSong = ref(false)

const form = reactive({
  title: '',
  artist: '',
  mp3Url: '',
  coverUrl: ''
})

const handleOpenMenu = () => {
  if (!authState.isAuthenticated) {
    router.push('/login')
    return
  }
  open.value = !open.value
}

const openEdit = () => {
  form.title = props.name
  form.artist = props.artist
  form.coverUrl = props.cover
  form.mp3Url = ''
  editSong.value = true
  open.value = false
}

const handleSaveSong = async (event) => {
  event.preventDefault();
  const id = props.idSong;
  if (!id) {
    emit('song-updated', {
      idSong: null,
      oldName: props.name,
      oldArtist: props.artist,
      oldDuration: props.duration,
      oldCover: props.cover,
      name: form.title,
      artist: form.artist,
      duration: props.duration,
      cover: form.coverUrl,
      path: form.mp3Url,
    });
    alert('✅ Song updated in the list.');
    closeEdit();
    return;
  }

  try {
    await updateSong(id, {
      title: form.title,
      artist: form.artist,
      mp3Url: form.mp3Url,
      coverUrl: form.coverUrl,
    });
    emit('song-updated', {
      idSong: id,
      oldName: props.name,
      oldArtist: props.artist,
      oldDuration: props.duration,
      oldCover: props.cover,
      name: form.title,
      artist: form.artist,
      duration: props.duration,
      cover: form.coverUrl,
      path: form.mp3Url,
    });
    alert('✅ Song updated successfully!');
    closeEdit();
  } catch (err) {
    console.error('Error updating song:', err);
    alert(`❌ Error: ${err.message}`);
  }
}

const handleDeleteSong = async (songId, songTitle) => {
  const id = songId || props.idSong;
  const name = songTitle || props.name;
  if (!confirm(`Are you sure you want to delete "${name}"?`)) return;
  if (!id) {
    emit('song-deleted', {
      idSong: null,
      name: props.name,
      artist: props.artist,
      duration: props.duration,
      cover: props.cover,
    });
    alert('✅ Song removed from the list.');
    open.value = false;
    closeEdit();
    return;
  }

  try {
    console.log('Deleting song with id:', id);
    await deleteSong(id);
    emit('song-deleted', {
      idSong: id,
      name: props.name,
      artist: props.artist,
      duration: props.duration,
      cover: props.cover,
    });
    alert('✅ Song deleted successfully!');
    open.value = false;
    closeEdit();
  } catch (err) {
    console.error('Error deleting song:', err);
    alert(`❌ Error: ${err.message}`);
  }
}

const closeEdit = () => {
  editSong.value = false
}

// ----------------------------This handle the clicks outside the object ----------------------------
const handleClickOutside = (e) => {
  if (!dropdownRef.value) return
  if (!dropdownRef.value.contains(e.target)) {
    open.value = false
  }
}

const loadPlaylistsForMenu = async () => {
  const userId = authState.user?.id ?? null
  if (!userId) return

  try {
    const p = await getUserPlaylistsCached(userId)
    const playlists = p?.playlists ?? []
    userPlaylists.value = playlists

    const songId = Number(props.idSong)
    const membership = {}
    playlists.forEach(pl => {
      const has = Array.isArray(pl.songs) && pl.songs.some(s => Number(s.idSong) === songId)
      membership[pl.idPlaylist] = has
    })
    playlistMembership.value = membership
  } catch (err) {
    console.warn('Failed to load playlists', err)
  }
}

watch(open, (value) => {
  if (value && authState.isAuthenticated && authState.user?.id) {
    loadPlaylistsForMenu()
  }
})

onMounted(async () => {
  window.addEventListener(PLAY_EVENT, (e) => {
    const activeId = e?.detail?.id
    if (activeId !== songInstanceId && isPlaying.value) {
      pauseSong()
    }
  })
  document.addEventListener('click', handleClickOutside)
  try {
    const userId = authState.user?.id ?? null
    if (userId && props.idSong) {
      try {
        const res = await getUserLikesCached(userId)
        const likesArr = res?.likes ?? []
        const songId = Number(props.idSong)
        isLiked.value = likesArr.some(song => Number(song.idSong) === songId)
      } catch (e) {
        console.warn('Failed to fetch user likes', e)
        isLiked.value = false
      }
    } else if (userId && !props.idSong) {
      const key = computeSongKey()
      const liked = getLikedSongsFromStorage()
      isLiked.value = liked.includes(key)
    } else {
      isLiked.value = false
    }
  } catch (e) {
    console.warn('Error initializing liked state', e)
  }
})

// Playlists local state
const userPlaylists = ref([])
const playlistMembership = ref({})
const newPlaylistName = ref('')
const newPlaylistCover = ref('')

const toggleSongInPlaylist = async (playlist) => {
  if (!authState.isAuthenticated) { router.push('/login'); return }
  const userId = authState.user?.id ?? null
  const plId = playlist.idPlaylist
  const wasIn = !!playlistMembership.value[plId]
  try {
    if (wasIn) {
      await removeSongFromPlaylist(plId, props.idSong)
      playlistMembership.value[plId] = false
      const p = userPlaylists.value.find(x => x.idPlaylist === plId)
      if (p) p.songs = p.songs.filter(s => Number(s.idSong) !== Number(props.idSong))
    } else {
      await addSongToPlaylist(plId, props.idSong)
      playlistMembership.value[plId] = true
      const p = userPlaylists.value.find(x => x.idPlaylist === plId)
      if (p) p.songs = p.songs.concat([{ idSong: props.idSong, title: props.name, artist: props.artist }])
    }
    if (userId) userPlaylistsCache.delete(userId)
  } catch (err) {
    console.error('Playlist toggle error', err)
    alert(`❌ ${err?.message || 'Playlist operation failed'}`)
  }
}

const handleCreatePlaylist = async () => {
  if (!newPlaylistName.value) return alert('Playlist name required')
  try {
    const userId = authState.user?.id
    const res = await createPlaylist({ name: newPlaylistName.value, userId, cover: newPlaylistCover.value || null })
    if (res?.id) {
      const p = await getUserPlaylists(userId)
      userPlaylists.value = p?.playlists ?? []
      if (userId) userPlaylistsCache.delete(userId)
      newPlaylistName.value = ''
      newPlaylistCover.value = ''
      alert('✅ Playlist created')
    }
  } catch (err) {
    console.error('Create playlist error', err)
    alert(`❌ ${err?.message || 'Failed to create playlist'}`)
  }
}

onBeforeUnmount(() => {
  try { window.removeEventListener(PLAY_EVENT, () => {}) } catch (e) {}
  document.removeEventListener('click', handleClickOutside)
  if (audioRef.value) {
    try { audioRef.value.pause() } catch (e) {}
    try { audioRef.value.src = '' } catch (e) {}
  }
})
</script>

<template>
    <div class="grid grid-cols-[0.15fr_0.2fr_1fr_0.15fr_0.15fr] sm:grid-cols-[0.2fr_0.2fr_1fr_1fr_1fr_0.2fr_0.2fr] text-center items-center bg-black rounded-lg hover:bg-[#1a1a1a] transition-colors duration-300 p-2 sm:p-0">
        <!-- Play Button -->
        <button @click="togglePlay" type="button" class="w-full h-full mx-auto rounded-lg hover:bg-[#3a3a3a] flex items-center justify-center text-white cursor-pointer" :aria-label="isPlaying ? 'Pause song' : 'Play song'">
            <span class="ml-0.5 text-sm sm:text-base">{{ isPlaying ? '⏸' : '▶' }}</span>
        </button>
        
        <!-- Cover Image -->
        <img :src="cover" alt="Cover Image" class="w-12 sm:w-14 md:w-16 aspect-square object-cover rounded-lg mx-auto">
        
        <!-- Name and Artist (mobile: combined, desktop: separate) -->
        <div class="sm:hidden text-left px-2">
            <p class="text-sm font-semibold">{{ name }}</p>
            <p class="text-xs text-gray-400">{{ artist }}</p>
        </div>
        <p class="hidden sm:block text-left">{{ name }}</p>
        
        <!-- Artist (desktop only) -->
        <p class="hidden sm:block">{{ artist }}</p>
        
        <!-- Duration (desktop only) -->
        <p class="hidden sm:block">{{ duration }}</p>
        
        <!-- Like Button -->
        <img :src="isLiked ? 'https://cdn-icons-png.flaticon.com/512/2107/2107845.png' : 'https://cdn-icons-png.flaticon.com/512/1000/1000621.png'" alt="like" class="w-4 sm:w-5 h-4 sm:h-5 mx-auto cursor-pointer hover:scale-110 transition-transform duration-300" @click="toggleLike">
        
        <!-- Settings Button -->
        <div ref="dropdownRef" class="relative inline-block"> 
          <img src="https://cdn-icons-png.flaticon.com/512/1828/1828687.png" 
              @click="handleOpenMenu"
              alt="Settings" 
              class="w-4 sm:w-5 h-4 sm:h-5 mx-auto cursor-pointer hover:scale-110 transition-transform duration-300">
          <div v-if="open && authState.user?.role === 'admin' && route.path === '/'" class="absolute right-0 mt-2 w-40 sm:w-50 bg-black/60 border rounded text-white text-xs sm:text-base z-50">
            <div class="px-2 sm:px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black" @click="openEdit()">Modify parameters</div>
            <div class="px-2 sm:px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black" @click.stop="handleDeleteSong(props.idSong, props.name)">Delete song</div>
          </div>
          <div v-else-if="open" class="absolute right-0 mt-2 w-72 sm:w-80 bg-black/80 border rounded text-white text-xs sm:text-base z-50 p-3">
            <div class="mb-2 font-semibold">Your Playlists</div>
            <div class="max-h-40 overflow-y-auto mb-2">
              <div v-if="userPlaylists.length === 0" class="text-gray-400 text-sm">No playlists yet.</div>
              <div v-for="pl in userPlaylists" :key="pl.idPlaylist" class="flex items-center justify-between gap-2 py-1">
                <div class="flex items-center gap-2">
                  <img v-if="pl.cover" :src="pl.cover" class="w-8 h-8 object-cover rounded" />
                  <div>
                    <div class="text-sm font-medium">{{ pl.name }}</div>
                    <div class="text-xs text-gray-400">{{ (pl.songs || []).length }} tracks</div>
                  </div>
                </div>
                <div>
                  <button @click.stop="toggleSongInPlaylist(pl)" class="px-2 py-1 rounded bg-emerald-700 hover:bg-emerald-600 text-white text-xs">
                    {{ playlistMembership[pl.idPlaylist] ? 'Remove' : 'Add' }}
                  </button>
                </div>
              </div>
            </div>

            <div class="border-t border-zinc-700 pt-2">
              <div class="text-sm font-semibold mb-1">Create playlist</div>
              <input v-model="newPlaylistName" placeholder="Name" class="w-full mb-1 p-1 text-sm rounded bg-zinc-900" />
              <input v-model="newPlaylistCover" placeholder="Cover image URL (optional)" class="w-full mb-2 p-1 text-sm rounded bg-zinc-900" />
              <div class="flex gap-2">
                <button @click.stop="handleCreatePlaylist" class="px-3 py-1 rounded bg-blue-600 hover:bg-blue-500 text-white text-sm">Create</button>
                <button @click.stop="open = false" class="px-3 py-1 rounded bg-zinc-700 hover:bg-zinc-600 text-white text-sm">Close</button>
              </div>
            </div>
          </div>
        </div>
        </div>
        <audio
      ref="audioRef"
      :src="activeAudioSrc"
      preload="metadata"
      class="hidden"
      @ended="handleAudioEnded"
        ></audio>
          <div v-if="editSong && authState.user?.role === 'admin'" class="fixed inset-0 backdrop-blur-sm flex items-center justify-center z-50">
      <div class="w-full max-w-2xl rounded-2xl border border-white/5 bg-black/90 p-6 relative">
        <h1 class="text-xl font-bold mb-6">Modify parameters</h1>
        <form class="space-y-4" @submit.prevent="handleSaveSong">
  <div>
    <label class="block text-sm text-white/70 mb-1">Title</label>
    <input v-model="form.title" type="text"
      class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white"/>
  </div>

  <div>
    <label class="block text-sm text-white/70 mb-1">Artist</label>
    <input v-model="form.artist" type="text"
      class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white"/>
  </div>

  <div>
    <label class="block text-sm text-white/70 mb-1">MP3 URL</label>
    <input v-model="form.mp3Url" type="text"
      class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white"/>
  </div>

  <div>
    <label class="block text-sm text-white/70 mb-1">Cover image URL</label>
    <input v-model="form.coverUrl" type="text"
      class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white"/>
  </div>

  <div class="flex justify-end gap-3 pt-4">
    <button type="button" @click="handleDeleteSong" class="px-4 py-2 text-sm rounded-xl bg-red-600 hover:bg-red-500 transition"> Delete </button>
    <button type="button" @click="closeEdit"
      class="px-4 py-2 text-sm rounded-xl bg-white/10 hover:bg-white/20 transition">
      Cancel
    </button>

    <button type="submit"
      class="px-5 py-2 text-sm rounded-xl bg-green-600 hover:bg-green-500 transition">
      Save
    </button>
  </div>
</form>
      </div>
    </div>
</template>

