<script setup>
import PlaylistCard from './PlaylistCard.vue'
defineProps(['name'])

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
</script>

<template>
    <div class="mix-playlist bg-black rounded-2xl sm:rounded-4xl p-3 sm:p-10 m-2 sm:m-4 text-white">
        <h2 class="text-left font-bold text-xl sm:text-3xl">{{ name }}</h2>
        <section class="m-1 sm:m-5 flex overflow-x-auto scroll-smooth" @wheel="handleHorizontalWheel">
            <PlaylistCard name="J-pop Hits 2025" artists="YOASOBI, Natori, Eve, Aimer, Kenshi Yonezu" nb-tracks="50 TITRES" cover="https://resources.tidal.com/images/e4716750/e68e/47d4/99b3/7fe1c02904ca/1080x1080.jpg"/>
            <PlaylistCard name="Anime Openings" artists="LiSA, Kenshi Yonezu, RADWIMPS" nb-tracks="42 TITRES" cover="https://resources.tidal.com/images/e4716750/e68e/47d4/99b3/7fe1c02904ca/1080x1080.jpg" />
            <PlaylistCard name="Lofi Night Study" artists="Jinsang, Idealism, Tomppabeats" nb-tracks="65 TITRES" cover="https://image-cdn-ak.spotifycdn.com/image/ab67706c0000da848bc80c95b9d248cf462c0bd1" />
            <PlaylistCard name="Global Top Hits" artists="The Weeknd, Billie Eilish, Dua Lipa" nb-tracks="55 TITRES" cover="https://resources.tidal.com/images/e4716750/e68e/47d4/99b3/7fe1c02904ca/1080x1080.jpg" />
            <PlaylistCard name="Gym Motivation" artists="Eminem, Kanye West, Travis Scott" nb-tracks="45 TITRES" cover="https://resources.tidal.com/images/e4716750/e68e/47d4/99b3/7fe1c02904ca/1080x1080.jpg" />
        </section>
    </div>
</template>