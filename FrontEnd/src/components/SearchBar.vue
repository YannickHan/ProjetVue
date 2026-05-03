<script setup>
import { ref } from "vue";

const isFocused = ref(false)
const input = ref("")
const emit = defineEmits(['search'])

const submitSearch = () => {
    emit('search', input.value.trim())
}

const handleInput = () => {
    emit('search', input.value.trim())
}
</script>

<template>
    <div class="relative w-full">
        <img :src="isFocused ? 'https://imgur.com/F2bPXV7.png' : 'https://imgur.com/zqlJ7IV.png'" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5"/>
        <input v-model="input" type="text" placeholder="Search for songs, artists, albums or genres..." 
        class="w-full pl-12 pr-4 py-3 placeholder-white/50 rounded-full border border-white outline-none appearance-none
        focus:border-none focus:ring-2 focus:placeholder-green-500 focus:ring-green-500" 
        @focus="isFocused = true" @blur="isFocused = false" @input="handleInput" @keyup.enter="submitSearch"/>
    </div>
</template>