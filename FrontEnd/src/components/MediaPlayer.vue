<script setup>
import { computed, nextTick, onBeforeUnmount, ref, watch } from 'vue';

const emit = defineEmits(['toggle-play', 'next-song', 'prev-song']);

const props = defineProps({
    isPlaying: {
        type: Boolean,
        default: false,
    },
    trackName: {
        type: String,
        default: '',
    },
    trackArtist: {
        type: String,
        default: '',
    },
    trackDuration: {
        type: String,
        default: '',
    },
    trackCover: {
        type: String,
        default: '',
    },
    trackPath: {
        type: String,
        default: '',
    },
});

const handleTogglePlay = () => {
    emit('toggle-play');
};

const handleNextSong = () => {
    emit('next-song');
};

const handlePrevSong = () => {
    emit('prev-song');
};

// ----------------------------This handle the audio element and progress bar----------------------------
const BACKEND_STATIC_URL = 'http://localhost:3000/static/';

const audioRef = ref(null);
const elapsedSeconds = ref(0);
const audioDurationSeconds = ref(0);

// Résout un chemin de piste relatif (ex: "music/foo.mp3") en URL servie par le backend.
const resolvedAudioUrl = computed(() => {
    const path = props.trackPath;
    if (!path) return '';
    if (/^https?:\/\//i.test(path)) return path;
    return `${BACKEND_STATIC_URL}${path.replace(/^\/+/, '')}`;
});

// Convertit une durée au format "hh:mm:ss" ou "mm:ss" en secondes (fallback si l'audio n'a pas chargé).
const toSeconds = (value) => {
    const parts = String(value || '').split(':').map(Number);
    if (parts.some(Number.isNaN)) return 0;
    if (parts.length === 3) return parts[0] * 3600 + parts[1] * 60 + parts[2];
    if (parts.length === 2) return parts[0] * 60 + parts[1];
    return parts[0] || 0;
};

// Formate une durée en secondes au format "mm:ss"
const formatTime = (total) => {
    const safeTotal = Math.max(0, Math.floor(Number(total) || 0));
    const minutes = Math.floor(safeTotal / 60);
    const seconds = safeTotal % 60;

    return `${minutes}:${String(seconds).padStart(2, '0')}`;
};

const totalSeconds = computed(() => audioDurationSeconds.value || toSeconds(props.trackDuration));
const displayedElapsed = computed(() => formatTime(elapsedSeconds.value));
const progressPercent = computed(() => {
    if (!totalSeconds.value) return 0;

    return Math.min((elapsedSeconds.value / totalSeconds.value) * 100, 100);
});

const onTimeUpdate = () => {
    if (!audioRef.value) return;
    elapsedSeconds.value = audioRef.value.currentTime || 0;
};

const onLoadedMetadata = () => {
    if (!audioRef.value) return;
    audioDurationSeconds.value = Number.isFinite(audioRef.value.duration) ? audioRef.value.duration : 0;
};

const onEnded = () => {
    elapsedSeconds.value = 0;
    emit('next-song');
};

const playAudio = () => {
    if (!audioRef.value || !resolvedAudioUrl.value) return;
    const result = audioRef.value.play();
    if (result && typeof result.catch === 'function') {
        result.catch((err) => {
            console.warn('Audio playback failed:', err);
        });
    }
};

// Lorsque la piste change, on remet le compteur à zéro et on relance la lecture si nécessaire.
watch(
    () => resolvedAudioUrl.value,
    () => {
        elapsedSeconds.value = 0;
        audioDurationSeconds.value = 0;
        nextTick(() => {
            if (props.isPlaying) playAudio();
        });
    }
);

// Lecture / pause selon l'état parent.
watch(
    () => props.isPlaying,
    (playing) => {
        if (!audioRef.value) return;
        if (playing) {
            playAudio();
        } else {
            audioRef.value.pause();
        }
    },
    { immediate: true }
);

onBeforeUnmount(() => {
    if (audioRef.value) {
        audioRef.value.pause();
    }
});
</script>

<template>
    <div class="fixed bottom-0 z-10 w-full h-16 sm:h-24 pl-2 sm:pl-10 pr-2 sm:pr-10 bg-[#23a517]">
        <div class="grid grid-cols-4 sm:grid-cols-7 gap-1 sm:gap-4 h-full">
            <img
                :src="trackCover || '/Logo3.png'"
                alt="Track cover"
                class="w-10 sm:w-16 h-10 sm:h-16 object-cover rounded-md border mx-auto my-auto hover:scale-115 transition-transform duration-300"
            />
            <div class="hidden sm:flex flex-col justify-center">
                <p class="text-xl font-bold">{{ trackName || 'No track selected' }}</p>
                <p class="text-sm opacity-80">{{ trackArtist || 'Choose a song from the list' }}</p>
            </div>
            <button
                type="button"
                class="text-xl sm:text-2xl cursor-pointer self-center rounded-lg hover:scale-115 transition-transform duration-300"
                :aria-label="'Previous track'"
                @click="handlePrevSong"
            >
                ⏮
            </button>
            <button
                type="button"
                class="text-2xl sm:text-3xl cursor-pointer self-center rounded-4xl hover:scale-115 transition-transform duration-300"
                :aria-label="isPlaying ? 'Pause track' : 'Play track'"
                @click="handleTogglePlay"
            >
                {{ isPlaying ? '⏸' : '▶' }}
            </button>
            <button
                type="button"
                class="text-xl sm:text-2xl cursor-pointer self-center rounded-lg hover:scale-115 transition-transform duration-300"
                :aria-label="'Next track'"
                @click="handleNextSong"
            >
                ⏭
            </button>
            <div class="hidden sm:block"></div>
            <p class="hidden sm:block text-sm font-semibold opacity-90 self-center">{{ displayedElapsed }} / {{ trackDuration || '0:00' }}</p>
        </div>
        <div class="absolute bottom-0 left-0 w-full h-1 bg-gray-300 rounded-b-4xl">
            <div class="h-full bg-yellow-500 rounded-b-4xl" :style="{ width: `${progressPercent}%` }"></div>
        </div>
        <audio
            ref="audioRef"
            :src="resolvedAudioUrl"
            preload="metadata"
            class="hidden"
            @timeupdate="onTimeUpdate"
            @loadedmetadata="onLoadedMetadata"
            @ended="onEnded"
        ></audio>
    </div>
</template>

<style scoped>

</style>