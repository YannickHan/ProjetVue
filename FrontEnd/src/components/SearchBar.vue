<script setup>
import { ref } from "vue"
const isFocused = ref(false)
const input = ref("")
</script>

<template>
    <div class="flex flex-col items-center gap-6 mt-10">
        <h2 class="text-left font-bold text-3xl">Search</h2>
        <div class="relative w-full max-w-3xl">
            <img :src="isFocused ? 'https://cdn.discordapp.com/attachments/1426268143881289890/1492196803200811224/Merch.png?ex=69dc6e51&is=69db1cd1&hm=8e7ce01a5275ffc6e6ebbf129da696627cfd135309b3763d9f483856a35b4a56&' : 'https://cdn.discordapp.com/attachments/1426268143881289890/1492196802735378442/Merch1.png?ex=69dc6e51&is=69db1cd1&hm=27697b6efa37e397a15180f4311b1d86a8c4ef7ce0f8681454413d547eeea898&'" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 transition-all duration-200"/>
            <input v-model="input" type="text" placeholder="Search for songs, artists, albums or genres..." class="w-full pl-12 pr-6 py-3 text-white bg-transparent rounded-full border border-white focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent focus:text-green-500 focus:placeholder-green-500" @focus="isFocused = true" @blur="isFocused = false"/>
        </div>
    </div>
</template>

<style scoped>
</style>