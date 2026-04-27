<script setup>
import { authState } from "../store/auth";
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'

// ----------------------------This handle the reception of the values----------------------------
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

// ----------------------------This handle the clicks outside the object ----------------------------
const handleClickOutside = (e) => {
  if (dropdownRef.value && !dropdownRef.value.contains(e.target)) {
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
          <div v-if="open && authState.user?.role === 'admin'" class="absolute right-0 mt-2 w-50 bg-black/75 border rounded text-white text-base z-50">
            <div class="px-4 py-2 cursor-pointer hover:bg-gray-100 hover:text-black">Modify parameters</div>
            <div class="px-4 py-2 cursor-pointer hover:bg-gray-100 hover:text-black">Delete song</div>
          </div>
          <div v-else-if="open" class="absolute right-0 mt-2 w-50 bg-black/75 border rounded text-white text-base z-50">
            <div class="px-4 py-2 cursor-pointer hover:bg-gray-100 hover:text-black">Option 1</div>
            <div class="px-4 py-2 cursor-pointer hover:bg-gray-100 hover:text-black">Option 2</div>
          </div>
        </div>
    </div>
</template>

