<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from "vue-router";
import { authState } from "../store/auth";
import { getTrendingArtists, getArtists } from "../store/Song";


const router = useRouter();
const props = defineProps(['type']);
const highlightedArtists = ref([]);
const defaultArtists = ref([]);

const getHighlightedArtists = async () => {
    try {
        const data = await getTrendingArtists();
        highlightedArtists.value = Array.isArray(data) ? data : [];
    } catch (error) {
        console.error("Error fetching trending artists:", error);
    }
}

const shuffleArray = (items) => {
    const array = [...items];
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
};

const getArtistName = (artist) => {
    if (!artist) return '';
    return typeof artist === 'string' ? artist : (artist.nameArtist || artist.name || '');
};

const loadDefaultArtists = async () => {
    try {
        const data = await getArtists();
        const artists = Array.isArray(data) ? data : [];
        defaultArtists.value = shuffleArray(artists).filter((artist) => getArtistName(artist)).slice(0, 3);
    } catch (error) {
        console.error('Error fetching artists:', error);
        defaultArtists.value = [];
    }
};

const getArtistByName = (name) => {
    if (!name) return null;
    const source = [...defaultArtists.value, ...highlightedArtists.value];
    return source.find((artist) => getArtistName(artist) === name) || null;
};

const getArtistCardImageByName = (name) => {
    const artist = getArtistByName(name);
    return artist?.verticalBannerArtist || artist?.profileArtist || '';
};

const getArtistCoverImageByName = (name) => {
    const artist = getArtistByName(name);
    return artist?.horizontalBannerArtist || '';
};

const getShuffledArtists = () => {
    const artists = shuffleArray(highlightedArtists.value);
    const entries = artists.map((artist) => {
        const name = getArtistName(artist);
        const image = artist?.profileArtist || '';
        return [name, image];
    });
    return Object.fromEntries(entries);
};

const handleHorizontalWheel = (e) => {
  const el = e.currentTarget;
  if (!el || el.scrollWidth <= el.clientWidth) return;
  e.preventDefault();
  
  const delta = e.deltaY || e.deltaX;
  el.scrollBy({
    left: delta * 1.2,
    behavior: 'smooth'
  });
};

const handleClick = (artist) => {
    const payload = {
        view: 'artist',
        name: artist,
        image: getArtistCoverImageByName(artist)
    };

  if (props.type === 'default' && !authState?.isAuthenticated) {
    localStorage.setItem('pendingRedirect', JSON.stringify(payload));
    router.push('/login');
    return;
  }

  router.push({
    path: "/webplayer",
    query: payload
  });
};

onMounted(() => {
    getHighlightedArtists();
    loadDefaultArtists();
});
</script>

<template>
    <div v-if="props.type === 'default'" class="trending-artiste bg-black rounded-2xl sm:rounded-4xl p-3 sm:p-10 m-2 sm:m-4 text-white">
        <h2 class="text-center font-bold text-4xl sm:text-9xl m-4 sm:m-10 sm:mb-20 mb-8">Trending Artists</h2>
        <section class="grid grid-cols-1 sm:grid-cols-3 gap-2 sm:gap-6 mt-4 text-center text-lg">
            <div
                v-for="(artist, index) in defaultArtists"
                :key="getArtistName(artist) || index"
                @click="handleClick(getArtistName(artist))"
                class="bg-[#1a1a1a] rounded-2xl sm:rounded-4xl p-3 sm:p-4 bg-cover bg-center hover:scale-105 transition-transform duration-300 cursor-pointer"
                :class="index === 1 ? 'h-40 sm:h-[72rem]' : 'h-40 sm:h-[65rem] sm:self-end'"
                :style="{ backgroundImage: `url(${getArtistCardImageByName(getArtistName(artist))})` }"
            >
                <h3 class="font-bold text-lg sm:text-4xl m-2 sm:m-5">{{ getArtistName(artist) }}</h3>
            </div>
        </section>
    </div>

    <div v-else-if="props.type === 'webplayer'" class="trending-artiste bg-black rounded-2xl sm:rounded-4xl p-3 sm:p-10 m-2 sm:m-4 text-white">
    <h2 class="text-left font-bold text-xl sm:text-3xl">Trending Artists</h2>
        <section class="flex overflow-x-auto gap-2 sm:gap-6 mt-4 text-center text-lg p-2 sm:p-4" @wheel="handleHorizontalWheel">
            <div v-for="(image, artist) in getShuffledArtists()" :key="artist"
                @click="handleClick(artist)"
                class="h-40 sm:h-72 w-32 sm:w-56 flex-shrink-0 bg-[#1a1a1a] rounded-2xl sm:rounded-4xl p-2 sm:p-4 bg-cover bg-center bg-no-repeat hover:scale-105 transition-transform duration-300 cursor-pointer flex flex-col justify-end" :style="{ backgroundImage: `url(${image})`, backgroundPosition: 'center' }">
                <h3 class="font-bold text-sm sm:text-2xl m-1 sm:m-5">{{ artist }}</h3>
            </div>
        </section>
    </div>
</template>