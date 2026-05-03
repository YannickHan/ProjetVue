<script setup>
defineProps(['name', 'cover', 'artists', 'nbTracks'])
</script>

<template>
    <div class="grid grid-col gap-2 rounded-lg hover:bg-[#1a1a1a] transition-colors duration-300 cursor-pointer p-2 sm:p-4">
        <img :src="cover" alt="Cover Image" class="w-32 sm:w-64 md:w-80 lg:w-96 xl:w-[500px] aspect-square rounded-lg">
        <p class="font-bold text-base sm:text-3xl">{{ name }}</p>
        <p class="text-sm sm:text-xl line-clamp-2" break-words>{{ artists }} et bien plus</p>
        <p class="text-gray-400 text-xs sm:text-lg">{{ nbTracks }}</p>
    </div>
</template>