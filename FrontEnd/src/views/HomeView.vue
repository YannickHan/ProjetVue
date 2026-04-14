<script setup>
    import TrendingArtiste from '../components/TrendingArtiste.vue'
    import MusicList from '../components/MusicList.vue'
    import Playlist from '../components/Playlist.vue'
</script>

<template>
    <img src="/Logo.png" alt="Logo" class="logo pl-20 pr-20" />
    <TrendingArtiste one="Taylor Swift" two="Justin Bieber" three="Doja Cat" type="default"/>
    <MusicList name="Trending Songs" />
    <Playlist name="Sélection de l'équipe" />
</template>