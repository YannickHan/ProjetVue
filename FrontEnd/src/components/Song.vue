<script setup>
import { ref, watch, onMounted, onBeforeUnmount, reactive } from 'vue'
import { authState } from "../store/auth"

// ----------------------------This handle the parent----------------------------
const props = defineProps({
  name: String,
  artist: String,
  duration: String,
  cover: String,
  isPlayingExternal: {
    type: Boolean,
    default: false,
  },
})

// ----------------------------This handle the parent----------------------------
const emit = defineEmits(['play-state-change'])

// ----------------------------This handle the like---------------------------- 
const isLiked = ref(false) 
const isPlaying = ref(false) 

const toggleLike = () => { 
  isLiked.value = !isLiked.value 
} 

const togglePlay = () => { 
  isPlaying.value = !isPlaying.value 
  emit('play-state-change', { 
    isPlaying: isPlaying.value, 
    name: props.name, 
    artist: props.artist, 
    duration: props.duration, 
    cover: props.cover, 
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

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<template>
    <div class="grid grid-cols-[0.2fr_0.2fr_1fr_1fr_1fr_0.2fr_0.2fr] text-center items-center bg-black rounded-lg hover:bg-[#1a1a1a] transition-colors duration-300">
        <button @click="togglePlay" type="button" class="w-full h-full mx-auto rounded-lg hover:bg-[#3a3a3a] flex items-center justify-center text-white cursor-pointer" :aria-label="isPlaying ? 'Pause song' : 'Play song'">
            <span class="ml-0.5">{{ isPlaying ? '⏸' : '▶' }}</span>
        </button>
        <img :src="cover" alt="Cover Image" class="w-16 h-16 rounded-lg mx-auto">
        <p class="text-left">{{ name }}</p>
        <p>{{ artist }}</p>
        <p>{{ duration }}</p>
        <img :src="isLiked ? 'https://cdn-icons-png.flaticon.com/512/2107/2107845.png' : 'https://cdn-icons-png.flaticon.com/512/1000/1000621.png'" alt="like" class="w-5 h-5 mx-auto cursor-pointer hover:scale-110 transition-transform duration-300" @click="toggleLike">
        <div ref="dropdownRef" class="relative inline-block"> 
          <img src="https://cdn-icons-png.flaticon.com/512/1828/1828687.png" 
              @click="open = !open"
              alt="Settings" 
              class="w-5 h-5 mx-auto cursor-pointer hover:scale-110 transition-transform duration-300">
          <div v-if="open && authState.user?.role === 'admin'" class="absolute right-0 mt-2 w-50 bg-black/60 border rounded text-white text-base z-50">
            <div class="px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black" @click="openEdit()">Modify parameters</div>
            <div class="px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black">Delete song</div>
          </div>
          <div v-else-if="open" class="absolute right-0 mt-2 w-50 bg-black/60 border rounded text-white text-base z-50">
            <div class="px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black">Option 1</div>
            <div class="px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black">Option 2</div>
          </div>
        </div>
    </div>
    <div v-if="editSong && authState.user?.role === 'admin'" class="fixed inset-0 backdrop-blur-sm flex items-center justify-center z-50">
      <div class="w-full max-w-2xl rounded-2xl border border-white/5 bg-black/90 p-6 relative">
        <h1 class="text-xl font-bold mb-6">Modify parameters</h1>
        <form class="space-y-4">
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