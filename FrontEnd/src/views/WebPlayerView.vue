<script setup>
import { computed, ref, watch, onMounted, onUnmounted } from 'vue';
import { useRoute, useRouter } from 'vue-router'
import { getTrendingSongs, searchSongsByTitle, getSongs, getLikedSongs } from '../store/Song';
import LeftBar from '../components/LeftBar.vue';
import MusicList from '../components/MusicList.vue';
import banner from '../components/banner.vue';
import Footer from '../components/Footer.vue';
import Playlist from '../components/Playlist.vue';
import TrendingArtiste from '../components/TrendingArtiste.vue';
import MediaPlayer from '../components/MediaPlayer.vue';
import SearchBar from '../components/SearchBar.vue';
import Sort from '../components/Sort.vue';
import ArtistProfile from '../components/ArtistProfile.vue';
import Quiz from '../components/Quiz.vue';

const route = useRoute()
const router = useRouter()
const activeView = computed(() => route.query.view || 'music')
const allSongs = ref([]);
const highlightedSongs = ref([]);
const likesSongs = ref([]);
const searchResults = ref([]);
const searchQuery = ref('');

const getHighlightedSongs = async () => {
        try {
            const data = await getTrendingSongs();
            highlightedSongs.value = data;
            console.log("Fetched trending songs:", highlightedSongs.value);
        } catch (error) {
            console.error("Error fetching trending songs:", error);
        }
    };

const getLikesSongs = async () => {
    try {
        const data = await getLikedSongs();
        likesSongs.value = data;
        console.log("Fetched liked songs:", likesSongs.value);
    } catch (error) {
        console.error("Error fetching liked songs:", error);
    }
};

watch(activeView, (view) => {
    if (view === 'likes') {
        getLikesSongs();
    }
}, { immediate: true });

const getAllSongs = async () => {
    try {
        const data = await getSongs();
        allSongs.value = data;
        console.log("Fetched all songs:", allSongs.value);
    } catch (error) {
        console.error("Error fetching songs:", error);
    }
};

const handleSearchSongs = async (query) => {
    searchQuery.value = query;
    try {
        if (!query) {
            searchResults.value = [];
            return;
        }

        const data = await searchSongsByTitle(query);
        searchResults.value = data;
    } catch (error) {
        console.error('Error searching songs:', error);
        searchResults.value = [];
    }
};

const displayedSearchSongs = computed(() => {
    if (searchQuery.value) return searchResults.value;
    return allSongs.value;
});

// ----------------------------This handle the view----------------------------
const title = computed(() => {
    if (activeView.value === 'search') return 'Search Results';
    if (activeView.value === 'likes') return 'Liked Songs';
    if (activeView.value === 'surprise') return 'Surprise Playlist';
    return 'My Playlist';
});

const handleChangeView = (view) => {
  router.push({
    path: '/webplayer',
    query: {
      view
    }
  })
}
const scrollToTop = () => {
    window.scrollTo({ top: 0 })
};

// ----------------------------This handle artist pages ---------------------------
const selectedArtist = computed(() => {
  if (!route.query.name) return null;
  return {
    artist: route.query.name,
    image: route.query.image || ''
  };
});

const handleSelectArtist = ({ artist, image }) => {
  router.push({
    path: '/webplayer',
    query: {
      view: 'artist',
      name: artist,
      image: image
    }
  })
}

// ----------------------------This handle the mediaplayer state----------------------------
const currentTrack = ref({
    isPlaying: false,
    name: '',
    artist: '',
    cover: '',
    duration: '',
    path: '',
});

const currentSongIndex = ref(-1);

const handleSongPlayStateChange = (payload) => {
    currentTrack.value = payload;
    // Update current song index when a song is selected
    const index = allSongs.value.findIndex(song => 
        song.name === payload.name && 
        song.artist === payload.artist &&
        song.duration === payload.duration
    );
    if (index !== -1) {
        currentSongIndex.value = index;
    }
};

const handleMediaPlayerTogglePlay = () => {
    currentTrack.value = {
        ...currentTrack.value,
        isPlaying: !currentTrack.value.isPlaying,
    };
};

const handleMediaPlayerNext = () => {
    if (allSongs.value.length === 0) return;
    
    let nextIndex = currentSongIndex.value + 1;
    if (nextIndex >= allSongs.value.length) {
        nextIndex = 0; // Loop back to first song
    }
    
    currentSongIndex.value = nextIndex;
    const nextSong = allSongs.value[nextIndex];
    currentTrack.value = {
        isPlaying: true,
        name: nextSong.name,
        artist: nextSong.artist,
        cover: nextSong.cover,
        duration: nextSong.duration,
    };
};

const handleMediaPlayerPrevious = () => {
    if (allSongs.value.length === 0) return;
    
    let prevIndex = currentSongIndex.value - 1;
    if (prevIndex < 0) {
        prevIndex = allSongs.value.length - 1; // Loop back to last song
    }
    
    currentSongIndex.value = prevIndex;
    const prevSong = allSongs.value[prevIndex];
    currentTrack.value = {
        isPlaying: true,
        name: prevSong.name,
        artist: prevSong.artist,
        cover: prevSong.cover,
        duration: prevSong.duration,
    };
};

const handleLikeChanged = async () => {
    if (activeView.value !== 'likes') return;
    await getLikesSongs();
};

// ----------------------------This handle the non-scrollable behavior----------------------------
onMounted(() => {
    document.body.style.overflow = 'hidden';
    getAllSongs();
    getHighlightedSongs();
});

onUnmounted(() => {
  document.body.style.overflow = 'auto';
});
</script>

<template>
    <div class="grid grid-cols-1 lg:grid-cols-[0.2fr_0.8fr] grid-rows-[auto_1fr] lg:grid-rows-1 h-screen w-screen p-2 sm:p-4 gap-2 sm:gap-4">
        <LeftBar :active-view="activeView" @change-view="handleChangeView" />
        <div class="bg-black text-white h-full w-full flex flex-col overflow-y-auto rounded-2xl sm:rounded-4xl">
            <div v-if="activeView === 'music'" class="text-lg sm:text-2xl font-bold">
                <banner />
                <TrendingArtiste one="Taylor Swift" two="Justin Bieber" three="Doja Cat" type="webplayer" @select-artist="handleSelectArtist"/>
                <MusicList
                    name="Best of Today"
                    :songs="highlightedSongs"
                    :current-track="currentTrack"
                    @song-play-state-change="handleSongPlayStateChange"
                />
                <Playlist name="Best Playlist of Today"/>
                <Footer class="pb-50" />
            </div>
            <div v-else-if="activeView === 'search'" class="text-lg sm:text-2xl font-bold">
                <div class="flex flex-col sm:flex-row items-center gap-2 sm:gap-4 m-4 sm:m-10">
                    <div class="flex-1 w-full">
                        <SearchBar @search="handleSearchSongs" />
                    </div>
                </div>
                <MusicList
                    name="Recommandations"
                    :songs="displayedSearchSongs"
                    :current-track="currentTrack"
                    type="admin"
                    @song-play-state-change="handleSongPlayStateChange"
                />
                <Footer class="pb-50" />
            </div>
            <div v-else-if="activeView === 'likes'" class="text-lg sm:text-2xl font-bold">
                <MusicList
                    name="Liked Songs"
                    :songs="likesSongs"
                    :current-track="currentTrack"
                    @song-play-state-change="handleSongPlayStateChange"
                    @like-changed="handleLikeChanged"
                />
                <Footer class="pb-50" />
            </div>
            <div v-else-if="activeView === 'artist' && selectedArtist" class="text-lg sm:text-2xl font-bold">
                <ArtistProfile
                    :name="selectedArtist.artist"
                    :bg-cover="selectedArtist.image"
                    :nb-followers="0"
                />
                <Footer class="pb-10" />
            </div>
            <div v-else class="text-lg sm:text-2xl font-bold">
                <Quiz :current-track="currentTrack" @play-song="handleSongPlayStateChange" />
                <Footer class="pb-50" />
            </div>
        </div>
    </div>
    <MediaPlayer
        :is-playing="currentTrack.isPlaying"
        :track-name="currentTrack.name"
        :track-artist="currentTrack.artist"
        :track-duration="currentTrack.duration"
        :track-cover="currentTrack.cover"
        @toggle-play="handleMediaPlayerTogglePlay"
        @next-song="handleMediaPlayerNext"
        @prev-song="handleMediaPlayerPrevious"
    />
</template>