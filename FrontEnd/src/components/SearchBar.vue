<script setup>
import { ref } from "vue"

const isFocused = ref(false)
const input = ref("")

</script>

<template>
    <div class="relative w-full">
        <img :src="isFocused ? 'https://imgur.com/F2bPXV7.png' : 'https://imgur.com/zqlJ7IV.png'" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 transition-all duration-200"/>
        <input v-model="input" type="text" placeholder="Search for songs, artists, albums or genres..." class="w-full pl-12 pr-6 py-3 text-white bg-transparent rounded-full border border-white focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent focus:text-green-500 focus:placeholder-green-500" @focus="isFocused = true" @blur="isFocused = false"/>
    </div>
</template>

<style scoped>
</style>