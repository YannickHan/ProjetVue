<script setup>
import { computed, ref, onMounted, onUnmounted } from 'vue';
import LeftBar from '../components/LeftBar.vue';
import MusicList from '../components/MusicList.vue';
import banner from '../components/banner.vue';
import Footer from '../components/Footer.vue';
import Playlist from '../components/Playlist.vue';
import TrendingArtiste from '../components/TrendingArtiste.vue';
import MediaPlayer from '../components/MediaPlayer.vue';
import SearchBar from '../components/SearchBar.vue';
import ArtistProfile from '../components/ArtistProfile.vue';

const activeView = ref('music');

// ----------------------------This handle the view----------------------------
const title = computed(() => {
    if (activeView.value === 'search') return 'Search Results';
    if (activeView.value === 'likes') return 'Liked Songs';
    if (activeView.value === 'surprise') return 'Surprise Playlist';
    return 'My Playlist';
});

const handleChangeView = (view) => {
    activeView.value = view;
};


// ----------------------------This handle artist pages ---------------------------
const selectedArtist = ref(null)

const handleSelectArtist = ({ artist, image }) => {
  selectedArtist.value = { artist, image }
  activeView.value = 'artist'
}

// ----------------------------This handle the mediaplayer state----------------------------
const currentTrack = ref({
    isPlaying: false,
    name: '',
    artist: '',
    cover: '',
    duration: '',
});

const handleSongPlayStateChange = (payload) => {
    currentTrack.value = payload;
};

const handleMediaPlayerTogglePlay = () => {
    currentTrack.value = {
        ...currentTrack.value,
        isPlaying: !currentTrack.value.isPlaying,
    };
};

// ----------------------------This handle the non-scrollable behavior----------------------------
onMounted(() => {
  document.body.style.overflow = 'hidden';
});

onUnmounted(() => {
  document.body.style.overflow = 'auto';
});
</script>

<template>
    <div class="grid grid-cols-[0.3fr_1fr]">
        <LeftBar :active-view="activeView" @change-view="handleChangeView" />
        <div class="bg-black rounded-4xl m-4 text-white h-[53rem] flex flex-col overflow-y-auto">
            <div v-if="activeView === 'music'" class="text-2xl font-bold">
                <banner />
                <TrendingArtiste one="Taylor Swift" two="Justin Bieber" three="Doja Cat" type="webplayer" @select-artist="handleSelectArtist"/>
                <MusicList
                    name="Best of Today"
                    :current-track="currentTrack"
                    @song-play-state-change="handleSongPlayStateChange"
                />
                <Playlist name="Best Playlist of Today"/>
                <Footer class="pb-10" />
                <MediaPlayer
                    :is-playing="currentTrack.isPlaying"
                    :track-name="currentTrack.name"
                    :track-artist="currentTrack.artist"
                    :track-duration="currentTrack.duration"
                    :track-cover="currentTrack.cover"
                    @toggle-play="handleMediaPlayerTogglePlay"
                />
            </div>
            <div v-else-if="activeView === 'search'" class="text-2xl font-bold">
                <SearchBar/>
                <MusicList
                    name="Recommandations"
                    :current-track="currentTrack"
                    @song-play-state-change="handleSongPlayStateChange"
                />
                <Footer class="pb-10" />
                <MediaPlayer
                    :is-playing="currentTrack.isPlaying"
                    :track-name="currentTrack.name"
                    :track-artist="currentTrack.artist"
                    :track-duration="currentTrack.duration"
                    :track-cover="currentTrack.cover"
                    @toggle-play="handleMediaPlayerTogglePlay"
                />
            </div>
            <div v-else-if="activeView === 'likes'" class="text-2xl font-bold">
                <!-- <MusicList
                    name="Liked"
                    :current-track="currentTrack"
                    @song-play-state-change="handleSongPlayStateChange"
                /> -->
                <Footer class="pb-10" />
                <MediaPlayer
                    :is-playing="currentTrack.isPlaying"
                    :track-name="currentTrack.name"
                    :track-artist="currentTrack.artist"
                    :track-duration="currentTrack.duration"
                    :track-cover="currentTrack.cover"
                    @toggle-play="handleMediaPlayerTogglePlay"
                />
            </div>
            <div v-else-if="activeView === 'artist'" class="text-2xl font-bold">
                <ArtistProfile
                    :name="selectedArtist.artist"
                    :bg-cover="selectedArtist.image"
                    :nb-followers="0"
                />
                <MusicList
                    name="Discography"
                    :current-track="currentTrack"
                    @song-play-state-change="handleSongPlayStateChange"
                />
                <Footer class="pb-10" />
                <MediaPlayer
                    :is-playing="currentTrack.isPlaying"
                    :track-name="currentTrack.name"
                    :track-artist="currentTrack.artist"
                    :track-duration="currentTrack.duration"
                    :track-cover="currentTrack.cover"
                    @toggle-play="handleMediaPlayerTogglePlay"
                />
            </div>
            <div v-else class="text-2xl font-bold">
                <Footer class="pb-10" />
                <MediaPlayer
                    :is-playing="currentTrack.isPlaying"
                    :track-name="currentTrack.name"
                    :track-artist="currentTrack.artist"
                    :track-duration="currentTrack.duration"
                    :track-cover="currentTrack.cover"
                    @toggle-play="handleMediaPlayerTogglePlay"
                />
            </div>
        </div>
    </div>
</template>