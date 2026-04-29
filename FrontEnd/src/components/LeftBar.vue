<script setup>
import MediaPlayer from '../components/MediaPlayer.vue';

defineProps({
    activeView: {
        type: String,
        default: 'music',
    },
});

const emit = defineEmits(['change-view']);

const selectView = (view) => {
    emit('change-view', view);
};
</script>

<template>
    <div class="bg-black rounded-4xl p-10 text-white flex flex-col justify-start overflow-y-auto">
        <h1 class="text-3xl font-bold mb-4">Welcome to Phantom Waves</h1>
                <button
                    :class="['p-2 pl-10 rounded-lg cursor-pointer font-bold text-left text-lg', activeView === 'music' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                    @click="selectView('music')"
                >
                    Music
                </button>
                <button
                    :class="['p-2 pl-10 rounded-lg cursor-pointer font-bold text-left text-lg', activeView === 'search' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                    @click="selectView('search')"
                >
                    Search
                </button>
                <button
                    :class="['p-2 pl-10 rounded-lg cursor-pointer font-bold text-left text-lg', activeView === 'likes' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                    @click="selectView('likes')"
                >
                    Likes
                </button>
                <button
                    :class="['p-2 pl-10 rounded-lg cursor-pointer font-bold text-left text-lg', activeView === 'surprise' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                    @click="selectView('surprise')"
                >
                    Surprise me !
                </button>
        <h2 class="mt-7 text-xl font-bold">Playlists</h2>
        <!-- <MediaPlayer /> -->
    </div>
</template>