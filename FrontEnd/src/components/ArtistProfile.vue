<script setup>
import MusicList from './MusicList.vue';
import Playlist from './Playlist.vue';
import { ref, watch } from 'vue';
import { getSongsByArtist } from '../services/SongServices';

const props = defineProps({
    name: String,
    bgCover: String,
    nbFollowers: Number
});

const isFollowing = ref(false)
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
        <div class="h-40 sm:h-124 rounded-2xl sm:rounded-4xl bg-[position:center_40%] mt-2 sm:mt-5 ml-2 sm:ml-5 mr-2 sm:mr-5 flex flex-col justify-end pb-2 sm:pb-6"
            :style="{ backgroundImage: `url(${props.bgCover})` }"
            >
            <h1 class="text-2xl sm:text-7xl font-bold text-white text-left pl-2 sm:pl-7">{{ name }}</h1>
            <p class="text-xs sm:text-base text-white font-medium text-left pl-2 sm:pl-7">
                {{ nbFollowers.toLocaleString()}} followers
                <button
                    @click="isFollowing = !isFollowing"
                    class="font-bold rounded-full px-2 sm:px-6 py-1 sm:py-2 text-xs sm:text-base w-20 sm:w-32 mt-1 sm:mt-4 ml-1 sm:ml-3 border-2 transition-all duration-200 hover:cursor-pointer"
                    :class="isFollowing 
                    ? 'bg-green-500 text-white border-green-500 sm:w-42 hover:bg-green-600 hover:border-green-600' 
                    : 'bg-black/10 text-green-500 border-green-500 hover:bg-white/10'"
                    >
                    {{ isFollowing ? 'Following' : 'Follow' }}
                </button>
            </p>
        </div>
        <MusicList
            name="Top Tracks"
            :songs="songs"
            :current-track="currentTrack"
            @song-play-state-change="handleSongPlayStateChange"
        />
        <Playlist
            name="Discography"
            :current-track="currentTrack"
            @song-play-state-change="handleSongPlayStateChange"
        />
    </div>
</template>