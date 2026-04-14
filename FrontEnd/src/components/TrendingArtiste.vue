<script setup>
import { useRouter } from "vue-router";

const router = useRouter();
defineProps(['one', 'two', 'three', 'type'])

const backgroundImages = {
    "Taylor Swift": "https://i.pinimg.com/736x/5e/dc/bd/5edcbdc406d790deefc554e5703879b7.jpg",
    "Justin Bieber": "https://wallpapercat.com/w/full/8/5/2/151041-1366x2048-mobile-hd-justin-bieber-background.jpg",
    "Doja Cat": "https://i.pinimg.com/736x/b2/d5/68/b2d5686acf5791074153982e68b0ce43.jpg",
    "DJ Snake": "https://wallpapercat.com/w/small-vertical-retina/8/4/9/2576255-1333x2000-mobile-hd-dj-snake-wallpaper-image.jpg?id=1662450997",
    "Dua Lipa": "https://wallpapercat.com/w/small-vertical-retina/a/f/7/106752-1440x2560-mobile-hd-dua-lipa-wallpaper-photo.jpg?id=1644914842",
    "Post Malone": "https://wallpapercat.com/w/small-vertical-retina/1/7/f/106654-1440x2560-samsung-hd-post-malone-background.jpg?id=1644914818",
    "Lorde": "https://wallpapercat.com/w/full/9/5/7/2327352-1920x1200-desktop-hd-lorde-wallpaper.jpg",
    "Billie Eilish": "https://wallpapercat.com/w/small-vertical-retina/f/4/3/11705-1920x2688-phone-hd-billie-eilish-background-photo.jpg?id=1644840023",
    "Sabrina Carpenter": "https://wallpapercave.com/wp/wp15388514.jpg",
};

const getShuffledArtists = () => {
    const artists = Object.entries(backgroundImages);
    for (let i = artists.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [artists[i], artists[j]] = [artists[j], artists[i]];
    }
    return Object.fromEntries(artists);
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
    window.scrollTo(0, 0);
    router.push("/webplayer");
    emit('select-artist', { activeView: 'artiste' });
};

const emit = defineEmits(['select-artist'])
function selectArtist(payload) {
  emit('select-artist', payload)
}
</script>

<template>
    <div v-if="type === 'default'" class="trending-artiste bg-black rounded-4xl p-10 m-4 text-white">
        <h2 class="text-center font-bold text-9xl m-10 mb-20">Trending Artists</h2>
        <section class="grid grid-cols-3 gap-6 mt-4 text-center text-lg">
            <div @click="handleClick(two)" class="h-[65rem] bg-[#1a1a1a] rounded-4xl p-4 bg-cover bg-center hover:scale-105 transition-transform duration-300 cursor-pointer self-end" :style="{ backgroundImage: `url(${backgroundImages[two]})` }">
                <h3 class="font-bold text-4xl m-5">{{ two }}</h3>
            </div>
            <div @click="handleClick(one)" class="h-[72rem] bg-[#1a1a1a] rounded-4xl p-4 bg-cover bg-center hover:scale-105 transition-transform duration-300 cursor-pointer" :style="{ backgroundImage: `url(${backgroundImages[one]})` }">
                <h3 class="font-bold text-4xl m-5">{{ one }}</h3>
            </div>
            <div @click="handleClick(three)" class="h-[65rem] bg-[#1a1a1a] rounded-4xl p-4 bg-cover bg-center hover:scale-105 transition-transform duration-300 cursor-pointer self-end" :style="{ backgroundImage: `url(${backgroundImages[three]})` }">
                <h3 class="font-bold text-4xl m-5">{{ three }}</h3>
            </div>
        </section>
    </div>

    <div v-else-if="type === 'webplayer'" class="trending-artiste bg-black rounded-4xl p-10 m-4 text-white">
    <h2 class="text-left font-bold text-3xl">Trending Artists</h2>
        <section class="flex overflow-x-auto gap-6 mt-4 text-center text-lg pb-4" @wheel="handleHorizontalWheel">
            <div v-for="(image, artist) in getShuffledArtists()" :key="artist"
                @click="selectArtist({ artist, image })"
                class="h-72 w-56 flex-shrink-0 bg-[#1a1a1a] rounded-4xl p-4 bg-cover bg-center bg-no-repeat hover:scale-105 transition-transform duration-300 cursor-pointer flex flex-col justify-end" :style="{ backgroundImage: `url(${image})`, backgroundPosition: 'center' }">
                <h3 class="font-bold text-2xl m-5">{{ artist }}</h3>
            </div>
        </section>
    </div>
</template>