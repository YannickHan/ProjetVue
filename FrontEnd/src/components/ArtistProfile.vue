<script setup>
import MusicList from './MusicList.vue';
import Playlist from './Playlist.vue';
import { ref, watch } from 'vue';
import { getSongsByArtist } from '../services/SongServices';

const props = defineProps({
    name: String,
    bgCover: String
});

const songs = ref([]);

const loadSongs = async (artistName) => {
    if (!artistName) {
        songs.value = [];
        return;
    }
    try {
        songs.value = await getSongsByArtist(artistName);
    } catch (error) {
        console.error('Failed to load artist songs:', error);
        songs.value = [];
    }
};

watch(() => props.name, loadSongs, { immediate: true });
</script>

<template>
    <div class="artist-page-view">
        <div class="h-40 sm:h-124 rounded-2xl sm:rounded-4xl bg-cover mt-2 sm:mt-5 ml-2 sm:ml-5 mr-2 sm:mr-5 flex flex-col justify-end pb-2 sm:pb-6"
            :style="{ backgroundImage: `url(${props.bgCover})` }"
            >
            <h1 class="text-2xl sm:text-7xl font-bold text-green-500 text-left pl-2 sm:pl-7">{{ name }}</h1>
        </div>
        <MusicList
            name="Top Tracks"
            :songs="songs"
            :current-track="currentTrack"
            @song-play-state-change="handleSongPlayStateChange"
            class="relative z-50"
        />
    </div>
</template>