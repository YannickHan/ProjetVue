<script setup>
import { ref, computed } from 'vue'
import song from '../assets/songsData.json'

const emit = defineEmits(['play-song'])

const props = defineProps({
    currentTrack: {
        type: Object,
        default: () => ({}),
    },
})

const randomizer = (song) => {
    const randomIndex = Math.floor(Math.random() * song.length)
    return song[randomIndex]
}

const cardBackImage = '/Card.png'
const Song1 = randomizer(song)
const Song2 = randomizer(song)
const Song3 = randomizer(song)

const cards = ref([
    {
        id: 1,
        title: 'Card 1',
        name: Song1.name,
        artist: Song1.artist,
        image: Song1.cover,
        duration: Song1.duration,
        flipped: false,
    },
    {
        id: 2,
        title: 'Card 2',
        name: Song2.name,
        artist: Song2.artist,
        image: Song2.cover,
        duration: Song2.duration,
        flipped: false,
    },
    {
        id: 3,
        title: 'Card 3',
        name: Song3.name,
        artist: Song3.artist,
        image: Song3.cover,
        duration: Song3.duration,
        flipped: false,
    },
])

const toggleCard = (id) => {
    const card = cards.value.find((item) => item.id === id)

    if (card) {
        card.flipped = !card.flipped
    }
}

const playSong = (card) => {
    emit('play-song', {
        name: card.name,
        artist: card.artist,
        cover: card.image,
        duration: card.duration,
        isPlaying: true,
    })
}

const isCardPlaying = (card) => {
    return props.currentTrack.name === card.name && 
           props.currentTrack.artist === card.artist &&
           props.currentTrack.isPlaying
}
</script>

<template>
    <div class="quiz-view">
        <h1 class="quiz-title">Lottery</h1>

        <div class="quiz-grid">
            <button
                v-for="card in cards"
                :key="card.id"
                type="button"
                class="flip-card"
                :class="{ flipped: card.flipped }"
                @click="toggleCard(card.id)"
            >
                <span class="flip-card__inner">
                    <span class="flip-card__face flip-card__front">
                        <img :src="cardBackImage" :alt="card.title" class="flip-card__image" />
                    </span>

                    <span class="flip-card__face flip-card__back flex flex-col gap-4">
                        <img :src="card.image" :alt="card.title" class="h-48 w-48 rounded-lg" />
                        <div class="text-center">
                            <p class="flip-card__text">{{ card.name }}</p>
                            <p class="text-sm text-gray-300">{{ card.artist }}</p>
                        </div>
                        <div class="grid grid-cols-3 gap-4">
                            <button
                                type="button"
                                aria-label="Like"
                                @click.stop
                                class="p-5 bg-red-500 rounded-lg text-white font-bold hover:bg-red-600 transition-colors duration-300 hover:scale-105 transition-transform duration-300 cursor-pointer "
                            >
                                ♥
                            </button>
                            <button
                                type="button"
                                :aria-label="isCardPlaying(card) ? 'Pause' : 'Play'"
                                @click.stop="playSong(card)"
                                class="p-5 bg-green-500 rounded-lg text-white font-bold hover:bg-green-600 transition-colors duration-300 hover:scale-105 transition-transform duration-300 cursor-pointer"
                            >
                                {{ isCardPlaying(card) ? '⏸' : '▶' }}
                            </button>
                            <button
                                type="button"
                                aria-label="Add to playlist"
                                @click.stop
                                class="p-5 bg-blue-500 rounded-lg text-white font-bold hover:bg-blue-600 transition-colors duration-300 hover:scale-105 transition-transform duration-300 cursor-pointer"
                            >
                                +
                            </button>
                        </div>
                    </span>
                </span>
            </button>
        </div>
    </div>
</template>

<style scoped>
.quiz-view {
    width: 100%;
    padding: 2rem 1rem;
}

.quiz-title {
    margin-bottom: 2rem;
    text-align: center;
    font-size: 1.875rem;
    font-weight: 700;
}

.quiz-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1rem;
    max-width: 72rem;
    margin: 0 auto;
}

.flip-card {
    width: 100%;
    aspect-ratio: 3 / 4;
    border: 0;
    padding: 0;
    background: transparent;
    cursor: pointer;
    perspective: 1200px;
    transition: filter 0.3s ease, text-shadow 0.3s ease;
}

.flip-card:hover {
    filter: drop-shadow(0 0 20px rgba(35, 166, 213, 0.6)) drop-shadow(0 0 40px rgba(35, 166, 213, 0.3));
}

.flip-card__inner {
    position: relative;
    display: block;
    width: 100%;
    height: 100%;
    transform-style: preserve-3d;
    transition: transform 0.7s ease;
}

.flip-card.flipped .flip-card__inner {
    transform: rotateY(180deg);
}

.flip-card__face {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    backface-visibility: hidden;
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 1.25rem;
    overflow: hidden;
    background: #1a1a1a;
    box-shadow: 0 18px 35px rgba(0, 0, 0, 0.25);
}

.flip-card__front {
    transform: rotateY(0deg);
}

.flip-card__back {
    transform: rotateY(180deg);
    padding: 1.5rem;
    text-align: center;
}

.flip-card__image {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.flip-card__text {
    font-size: 1.5rem;
    font-weight: 600;
}

.flip-card:focus-visible {
    outline: 3px solid #23a6d5;
    outline-offset: 4px;
    border-radius: 1.25rem;
}
</style>

