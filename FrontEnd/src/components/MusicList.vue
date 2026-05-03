<script setup>
import { ref, watch } from 'vue';
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

const emit = defineEmits(['song-play-state-change', 'like-changed']);

const localSongs = ref([]);

watch(
    () => props.songs,
    (newSongs) => {
        localSongs.value = Array.isArray(newSongs) ? [...newSongs] : [];
    },
    { immediate: true }
);

const handleSongPlayStateChange = (payload) => {
    emit('song-play-state-change', payload);
};

const handleLikeChanged = (payload) => {
    emit('like-changed', payload);
};

const handleSongDeleted = (payload) => {
    localSongs.value = localSongs.value.filter((song) => {
        if (payload?.idSong) {
            return (song.id ?? song.idSong) !== payload.idSong;
        }
        // For static songs with no DB id, remove by visible identity.
        return !(
            song.name === payload?.name &&
            song.artist === payload?.artist &&
            song.duration === payload?.duration
        );
    });
};

const handleSongUpdated = (payload) => {
    const matchSong = (song) => {
        if (payload?.idSong) {
            return (song.id ?? song.idSong) === payload.idSong;
        }
        return (
            song.name === payload?.oldName &&
            song.artist === payload?.oldArtist &&
            song.duration === payload?.oldDuration
        );
    };

    localSongs.value = localSongs.value.map((song) => {
        if (!matchSong(song)) return song;
        return {
            ...song,
            name: payload?.name ?? song.name,
            artist: payload?.artist ?? song.artist,
            duration: payload?.duration ?? song.duration,
            cover: payload?.cover || song.cover,
            path: payload?.path || song.path,
        };
    });
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
    <div class="trending-artiste bg-black rounded-2xl sm:rounded-4xl p-3 sm:p-10 m-1 sm:m-4 text-white">
        <h2 class="text-left font-bold text-xl sm:text-3xl">{{ name }}</h2>

        <section class="m-1 sm:m-5">
            <Song 
                v-for="(song, index) in localSongs" 
                :key="song.id ?? song.idSong ?? `${song.name}-${song.artist}-${song.duration}`"
                :id-song="song.id ?? song.idSong"
                :name="song.name"
                :artist="song.artist"
                :duration="song.duration"
                :cover="song.cover"
                :path="song.path"
                :is-playing-external="isSongPlaying(song)"
                @play-state-change="handleSongPlayStateChange"
                @song-deleted="handleSongDeleted"
                @song-updated="handleSongUpdated"
                @like-changed="handleLikeChanged"
            />
        </section>
    </div>
</template>