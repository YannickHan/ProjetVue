<script setup>
import { ref, onMounted } from 'vue';
import Song from './Song.vue';

const props = defineProps({
    name: String,
    currentTrack: {
        type: Object,
        required: false,
        default: null,
    },
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

const songs = ref([]);
const loading = ref(true);
const error = ref(null);

onMounted(async () => {
    try {
        const response = await fetch('/api/songs');
        if (!response.ok) {
            throw new Error('Impossible de charger les chansons');
        }
        songs.value = await response.json();
    } catch (err) {
        console.error('Erreur fetch songs:', err);
        error.value = err.message;
    } finally {
        loading.value = false;
    }
});

</script>

<template>
    <div class="trending-artiste bg-black rounded-4xl p-10 m-4 text-white">
        <h2 class="text-left font-bold text-3xl">{{ name }}</h2>

        <p v-if="loading" class="text-center text-gray-400 my-5">Chargement...</p>
        <p v-else-if="error" class="text-center text-red-400 my-5">{{ error }}</p>
        

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