<script setup>
import { ref } from 'vue'

const openPanel = ref(false)

// ----------------------------This handle the panel ----------------------------
const open = () => {
  openPanel.value = true
}

const close = () => {
  openPanel.value = false
}
</script>

<template>
<button class="ml-auto px-4 py-2 text-lg text-white rounded-full bg-green-500/80 hover:bg-green-500 hover:scale-[1.02]" @click="open"> Add a song </button>
<div v-if="openPanel" class="fixed inset-0 backdrop-blur-sm flex items-center justify-center z-50">
    <div class="w-full max-w-4xl rounded-2xl border border-white/5 bg-black/80 p-6 relative">
        <button class="absolute top-5 right-5 text-white/50 hover:text-white text-xl" @click="close"> ✕ </button>
        <p>Panel content here</p>
    </div>
  </div>
</template>
              