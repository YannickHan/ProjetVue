<script setup>
import MusicList from './MusicList.vue';
import Playlist from './Playlist.vue';
import SongsData from '../assets/songsData.json';
import { ref } from 'vue';

const props = defineProps({
    name: String,
    bgCover: String,
    nbFollowers: Number
});   

const isFollowing = ref(false)
const songs = ref(SongsData);
</script>

<template>
    <div class="artist-page-view">
        <div class="
            h-124 
            rounded-4xl 
            bg-[position:center_40%]
            mt-5 
            ml-5 ss
            mr-5
            flex flex-col justify-end
            pb-6"
            :style="{ backgroundImage: `url(${props.bgCover})` }"
            >
            <h1 class="text-7xl font-bold text-white text-left pl-7">{{ name }}</h1>
            <p class="text-white font-medium text-left pl-7">
                {{ nbFollowers.toLocaleString()}} followers
                <button
                    @click="isFollowing = !isFollowing"
                    class="font-bold rounded-full px-6 py-2 w-32 mt-4 ml-3 border-2 transition-all duration-200 hover:cursor-pointer hover:bg-gray-500/20"
                    :class="isFollowing 
                    ? 'bg-green-500 text-white border-green-500 w-42' 
                    : 'bg-transparent text-green-500 border-green-500'"
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