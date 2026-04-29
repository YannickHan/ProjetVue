<script setup>
import { computed, onBeforeUnmount, ref, watch } from 'vue';

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

// ----------------------------This handle the timer for the progress bar----------------------------
const elapsedSeconds = ref(0);
const intervalId = ref(null);

// Convertit une durée au format "mm:ss" en secondes
const toSeconds = (value) => {
    const [minutes, seconds] = String(value || '').split(':').map(Number);

    if (Number.isNaN(minutes) || Number.isNaN(seconds)) {
        return 0;
    }

    return (minutes * 60) + seconds;
};

// Formate une durée en secondes au format "mm:ss"
const formatTime = (total) => {
    const safeTotal = Math.max(0, Number(total) || 0);
    const minutes = Math.floor(safeTotal / 60);
    const seconds = safeTotal % 60;

    return `${minutes}:${String(seconds).padStart(2, '0')}`;
};

// Calcule les valeurs pour l'affichage du temps écoulé et du pourcentage de progression
const totalSeconds = computed(() => toSeconds(props.trackDuration));
const displayedElapsed = computed(() => formatTime(elapsedSeconds.value));
const progressPercent = computed(() => {
    if (!totalSeconds.value) return 0;

    return Math.min((elapsedSeconds.value / totalSeconds.value) * 100, 100);
});

//arrêter le timer quand la chanson est terminée ou quand une nouvelle chanson est sélectionnée
const stopTimer = () => {
    if (!intervalId.value) return;

    clearInterval(intervalId.value);
    intervalId.value = null;
};

// Démarrer le timer pour suivre la progression de la chanson
const startTimer = () => {
    if (intervalId.value || !props.isPlaying || !totalSeconds.value) return;

    intervalId.value = setInterval(() => {
        if (elapsedSeconds.value >= totalSeconds.value) {
            stopTimer();
            return;
        }

        elapsedSeconds.value += 1;
    }, 1000);
};

// Surveiller les changements de lecture et de piste pour démarrer/arrêter le timer en conséquence
watch(
    () => props.isPlaying,
    (playing) => {
        if (!playing) {
            stopTimer();
            return;
        }

        startTimer();
    },
    { immediate: true }
);

// Réinitialiser le timer lorsque la piste change
watch(
    () => [props.trackName, props.trackArtist, props.trackDuration],
    () => {
        stopTimer();
        elapsedSeconds.value = 0;

        if (props.isPlaying) {
            startTimer();
        }
    }
);

// Nettoyer le timer lorsque le composant est détruit pour éviter les fuites de mémoire
onBeforeUnmount(() => {
    stopTimer();
});
</script>

<template>
    <div class="sticky bottom-0 z-10 w-full h-24 pl-10 pr-10 bg-[#23a517]">
        <div class="grid grid-cols-7 gap-4 h-full">
            <img
                :src="trackCover || '/Logo3.png'"
                alt="Track cover"
                class="w-16 h-16 object-cover rounded-md border mx-auto my-auto hover:scale-115 transition-transform duration-300"
            />
            <div class="flex flex-col justify-center">
                <p class="text-xl font-bold">{{ trackName || 'No track selected' }}</p>
                <p class="text-sm opacity-80">{{ trackArtist || 'Choose a song from the list' }}</p>
            </div>
            <button
                type="button"
                class="text-2xl cursor-pointer self-center rounded-lg hover:scale-115 transition-transform duration-300"
                :aria-label="'Previous track'"
                @click="handlePrevSong"
            >
                ⏮
            </button>
            <button
                type="button"
                class="text-3xl cursor-pointer self-center rounded-4xl hover:scale-115 transition-transform duration-300"
                :aria-label="isPlaying ? 'Pause track' : 'Play track'"
                @click="handleTogglePlay"
            >
                {{ isPlaying ? '⏸' : '▶' }}
            </button>
            <button
                type="button"
                class="text-2xl cursor-pointer self-center rounded-lg hover:scale-115 transition-transform duration-300"
                :aria-label="'Next track'"
                @click="handleNextSong"
            >
                ⏭
            </button>
            <P></P>
            <p class="text-sm font-semibold opacity-90 self-center">{{ displayedElapsed }} / {{ trackDuration || '0:00' }}</p>
        </div>
        <div class="absolute bottom-0 left-0 w-full h-1 bg-gray-300 rounded-b-4xl">
            <div class="h-full bg-yellow-500 rounded-b-4xl" :style="{ width: `${progressPercent}%` }"></div>
        </div>
    </div>
</template>

<style scoped>

</style>