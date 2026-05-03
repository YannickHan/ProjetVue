<script setup>
    import TrendingArtiste from '../components/TrendingArtiste.vue'
    import MusicList from '../components/MusicList.vue'
    import Playlist from '../components/Playlist.vue'
    import { getTrendingSongs } from '../store/Song';
    import { ref, onMounted } from 'vue';
    import { useRouter } from "vue-router";

    const songs = ref([]);

    const getHighlightedSongs = async () => {
        try {
            const data = await getTrendingSongs();
            songs.value = data;
            console.log("Fetched trending songs:", songs.value);
        } catch (error) {
            console.error("Error fetching trending songs:", error);
        }
    };

    onMounted(async () => {
        await getHighlightedSongs();
    });

    // ----------------------------This handle the routing to artist page ----------------------------
    const router = useRouter();
    
    const handleSelectArtist = (payload) => {
        router.push({
        path: '/webplayer',
        query: {
            view: 'artist',
            name: payload.artist,
            image: payload.image
        }
    });
};
</script>

<template>
    <img src="/Logo.png" alt="Logo" class="logo pl-20 pr-20" />
    <TrendingArtiste @select-artist="handleSelectArtist" one="Taylor Swift" two="Justin Bieber" three="Doja Cat" type="default"/>
    <MusicList name="Trending Songs" :songs="songs" />
    <Playlist name="Team selections" />
</template>