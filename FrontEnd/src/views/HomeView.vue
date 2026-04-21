<script setup>
    import TrendingArtiste from '../components/TrendingArtiste.vue'
    import MusicList from '../components/MusicList.vue'
    import Playlist from '../components/Playlist.vue'
    
    import SongsData from '../assets/songsData.json';
    import { ref } from 'vue';

    const songs = ref(SongsData);

</script>

<template>
    <img src="/Logo.png" alt="Logo" class="logo pl-20 pr-20" />
    <TrendingArtiste one="Taylor Swift" two="Justin Bieber" three="Doja Cat" type="default"/>
    <MusicList name="Trending Songs" :songs="songs" />
    <Playlist name="Sélection de l'équipe" />
</template>