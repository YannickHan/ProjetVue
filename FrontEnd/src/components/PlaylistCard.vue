<script setup>
defineProps(['name', 'cover', 'artists', 'nbTracks'])
</script>

<template>
    <div class="m-10 grid grid-col gap-2 rounded-lg hover:bg-[#1a1a1a] transition-colors duration-300 cursor-pointer p-4">
        <img :src="cover" alt="Cover Image" class="w-64 sm:w-80 md:w-96 lg:w-[500px] aspect-square rounded-lg">
        <p class="font-bold text-3xl">{{ name }}</p>
        <p class="text-xl line-clamp-2" break-words>{{ artists }} et bien plus</p>
        <p class="text-gray-400 text-lg">{{ nbTracks }}</p>
    </div>
</template>