<script setup>
import { computed, ref, watch } from 'vue';
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

const currentTrackKey = computed(() => {
    if (!props.currentTrack) return '';
    return `${props.currentTrack.name || ''}::${props.currentTrack.artist || ''}::${props.currentTrack.duration || ''}::${props.currentTrack.cover || ''}`;
});

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

const songKey = (song) => `${song.name || ''}::${song.artist || ''}::${song.duration || ''}::${song.cover || ''}`;
const songMemoKey = (song) => song.id || song.idSong || `${song.name}-${song.artist}-${song.duration}`;

const handleSongDeleted = (payload) => {
    localSongs.value = localSongs.value.filter((song) => {
        if (payload?.idSong) {
            return (song.id || song.idSong) !== payload.idSong;
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
            return (song.id || song.idSong) === payload.idSong;
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

    return currentTrackKey.value === songKey(song) && props.currentTrack.isPlaying;
};


</script>

<template>
    <div class="rounded-[28px] border border-white/10 bg-black/85 p-4 m-4 text-white shadow-xl backdrop-blur-xl sm:p-6">
        <div class="mb-4 flex items-end justify-between gap-3">
            <div>
                <p class="text-xs uppercase tracking-[0.3em] text-white/35">Library</p>
                <h2 class="text-left text-xl font-semibold sm:text-3xl">{{ name }}</h2>
            </div>
        </div>

        <section v-if="localSongs.length > 0" class="space-y-3">
            <Song 
                v-for="(song, index) in localSongs" 
                v-memo="[songMemoKey(song), currentTrackKey]"
                :key="songMemoKey(song)"
                :id-song="song.id || song.idSong"
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

        <p v-else class="text-center text-white/50">No songs available.</p>
    </div>
</template>