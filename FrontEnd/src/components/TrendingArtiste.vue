<script setup>
import { ref, computed, onMounted} from 'vue'
import { useRouter } from "vue-router";
import { authState } from "../store/auth";
import { getTrendingArtists } from "../store/song";


const router = useRouter();
const props = defineProps(['type']);
const highlightedArtists = ref([]);

const getHighlightedArtists = async () => {
    try {
        const data = await getTrendingArtists();
        highlightedArtists.value = Array.isArray(data) ? data : [];
    } catch (error) {
        console.error("Error fetching trending artists:", error);
    }
}

const getArtistByName = (name) => {
    if (!name || !highlightedArtists.value) return null;
    return highlightedArtists.value.find(a => {
        if (!a) return false;
        return a.nameArtist === name || a.name === name;
    }) || null;
};

const getArtistImageByName = (name) => {
    const artist = getArtistByName(name);
    return artist?.profileArtist || '';
};

const getArtistName = (artist) => {
    if (!artist) return '';
    return typeof artist === 'string' ? artist : (artist.nameArtist || artist.name || '');
};

const getShuffledArtists = () => {
    const source = Array.isArray(highlightedArtists.value) ? highlightedArtists.value : [];
    const artists = [...source];
    for (let i = artists.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [artists[i], artists[j]] = [artists[j], artists[i]];
    }

    const entries = artists.map(artist => {
        const name = typeof artist === 'string' ? artist : (artist.nameArtist || artist.name || '');
        const image = typeof artist === 'string' ? '' : (artist.profileArtist || '');
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
        image: getArtistImageByName(artist)
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
});
</script>

<template>
    <div v-if="props.type === 'default'" class="trending-artiste bg-black rounded-2xl sm:rounded-4xl p-3 sm:p-10 m-2 sm:m-4 text-white">
        <h2 class="text-center font-bold text-4xl sm:text-9xl m-4 sm:m-10 sm:mb-20 mb-8">Trending Artists</h2>
        <section class="grid grid-cols-1 sm:grid-cols-3 gap-2 sm:gap-6 mt-4 text-center text-lg">
            <div
                v-for="(artist, index) in highlightedArtists.slice(0, 3)"
                :key="getArtistName(artist) || index"
                @click="handleClick(getArtistName(artist))"
                class="bg-[#1a1a1a] rounded-2xl sm:rounded-4xl p-3 sm:p-4 bg-cover bg-center hover:scale-105 transition-transform duration-300 cursor-pointer"
                :class="index === 1 ? 'h-40 sm:h-[72rem]' : 'h-40 sm:h-[65rem] sm:self-end'"
                :style="{ backgroundImage: `url(${getArtistImageByName(getArtistName(artist))})` }"
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