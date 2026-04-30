<script setup>
import { ref, onMounted } from 'vue';
import Song from './Song.vue';

const props = defineProps({
    name: String,
    songs: {
        type: Array,
        default: () => [],
    },
    currentTrack: {
        type: Object,
        required: false,
        default: null,
    }
});

const emit = defineEmits(['song-play-state-change']);

const handleSongPlayStateChange = (payload) => {
    emit('song-play-state-change', payload);
};

const isSongPlaying = (song) => {
    if (!props.currentTrack) return false;

    return props.currentTrack.name === song.name
        && props.currentTrack.artist === song.artist
        && props.currentTrack.duration === song.duration
        && props.currentTrack.cover === song.cover
        && props.currentTrack.isPlaying;
};

//cover from https://covers.musichoarders.xyz/

</script>

<template>
    <div class="trending-artiste bg-black rounded-4xl p-10 m-4 text-white">
        <h2 class="text-left font-bold text-3xl">{{ name }}</h2>

        <section class="m-5">
            <Song 
                v-for="(song, index) in songs" 
                :key="index"
                :name="song.name"
                :artist="song.artist"
                :duration="song.duration"
                :cover="song.cover"
                :path="song.path"
                :is-playing-external="isSongPlaying(song)"
                @play-state-change="handleSongPlayStateChange"
            />
        </section>
    </div>
</template>