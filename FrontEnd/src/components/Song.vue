<script setup>
import { ref, watch, onMounted, onBeforeUnmount, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { authState } from "../store/auth"
import { updateSong, deleteSong, likeSong, unlikeSong, getUserLikes } from '../services/SongServices'

const router = useRouter()

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

const STORAGE_KEY = 'phantomwaves_liked_songs'

const computeSongKey = () => {
  // Prefer stable DB id when available, otherwise fallback to a composite key
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

const toggleLike = async () => {
  // Require login to like a song
  if (!authState.isAuthenticated) {
    router.push('/login')
    return
  }

  const previous = isLiked.value
  isLiked.value = !previous
  const key = computeSongKey()

  const userId = authState.user?.id ?? null

  // Logged in + DB song → server is the source of truth.
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
      alert('❌ Failed to update like on server.')
      return
    }
  } else {
    // Local/static song without a DB id → use localStorage as fallback.
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

const togglePlay = () => {
  isPlaying.value = !isPlaying.value
  emit('play-state-change', {
    isPlaying: isPlaying.value,
    name: props.name,
    artist: props.artist,
    duration: props.duration,
    cover: props.cover,
    path: props.path,
  })
}
// ----------------------------This handle the mediaplayer---------------------------- 
watch( 
  () => props.isPlayingExternal, 
  (value) => { 
    isPlaying.value = value 
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

  // Fallback for local/static songs that do not come from DB.
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

  // Fallback for local/static songs that do not come from DB.
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

onMounted(async () => {
  document.addEventListener('click', handleClickOutside)
  try {
    const userId = authState.user?.id ?? null

    // Logged in + DB song → server is the source of truth.
    if (userId && props.idSong) {
      try {
        const res = await getUserLikes(userId)
        const likesArr = res?.likes ?? []
        const songId = Number(props.idSong)
        isLiked.value = likesArr.some(song => Number(song.idSong) === songId)
      } catch (e) {
        console.warn('Failed to fetch user likes', e)
        isLiked.value = false
      }
    } else if (userId && !props.idSong) {
      // Logged-in user on a local/static song without DB id → localStorage fallback.
      const key = computeSongKey()
      const liked = getLikedSongsFromStorage()
      isLiked.value = liked.includes(key)
    } else {
      // Anonymous: cannot like, never show as liked.
      isLiked.value = false
    }
  } catch (e) {
    console.warn('Error initializing liked state', e)
  }
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
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
              @click="open = !open"
              alt="Settings" 
              class="w-4 sm:w-5 h-4 sm:h-5 mx-auto cursor-pointer hover:scale-110 transition-transform duration-300">
          <div v-if="open && authState.user?.role === 'admin'" class="absolute right-0 mt-2 w-40 sm:w-50 bg-black/60 border rounded text-white text-xs sm:text-base z-50">
            <div class="px-2 sm:px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black" @click="openEdit()">Modify parameters</div>
            <div class="px-2 sm:px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black" @click.stop="handleDeleteSong(props.idSong, props.name)">Delete song</div>
          </div>
          <div v-else-if="open" class="absolute right-0 mt-2 w-40 sm:w-50 bg-black/60 border rounded text-white text-xs sm:text-base z-50">
            <div class="px-2 sm:px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black">Option 1</div>
            <div class="px-2 sm:px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black">Option 2</div>
          </div>
        </div>
    </div>
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

