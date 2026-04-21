<script setup>
import { ref, computed } from 'vue';
import AdminLeftbar from '../components/AdminLeftbar.vue';
import SortFilter from '../components/SortFilter.vue';
import SearchBar from '../components/SearchBar.vue';
import MusicList from '../components/MusicList.vue';
import SongsData from '../assets/songsData.json';
import { logout } from "../store/auth";
import { useRouter } from "vue-router";

const router = useRouter();
const songs = ref(SongsData);

const handleLogout = () => {
  logout();
  router.push("/");
};

const activeView = ref('dashboard');
const handleChangeView = (view) => {
  activeView.value = view;
};

const currentTrack = ref({
    isPlaying: false,
    name: '',
    artist: '',
    cover: '',
    duration: '',
});

const sortOptions = ref({
  sortBy: 'artist',
  order: 'asc'
});

const handleSortChange = (options) => {
  sortOptions.value = options;
};

const sortedSongs = computed(() => {
  return [...songs.value].sort((a, b) => {
    let aVal = a[sortOptions.value.sortBy];
    let bVal = b[sortOptions.value.sortBy];
    if (typeof aVal === 'string') {
      aVal = aVal.toLowerCase();
      bVal = bVal.toLowerCase();
    }
    if (aVal < bVal) return sortOptions.value.order === 'asc' ? -1 : 1;
    if (aVal > bVal) return sortOptions.value.order === 'asc' ? 1 : -1;
    return 0;
  });
});
</script>

<template>
  <div>
    <div class="grid grid-cols-[0.3fr_1fr]">
        <AdminLeftbar :active-view="activeView" @change-view="handleChangeView" />
        <div class="bg-black rounded-4xl m-4 text-white h-[53rem] flex flex-col overflow-y-auto">
            <div v-if="activeView === 'dashboard'" class="text-2xl font-bold">
              
              <Footer class="pb-10" />
            </div>
            <div v-else-if="activeView === 'musicList'" class="text-2xl font-bold">
              <div class="flex items-center gap-4 m-10">
                <div class="flex-1">
                  <SearchBar />
                </div>
                <SortFilter @sort-change="handleSortChange" />
              </div>
              <MusicList 
                    name="Song Catalog"
                    :songs="sortedSongs"
                    :current-track="currentTrack"
                    @song-play-state-change="handleSongPlayStateChange"
                />
              <Footer class="pb-10" />
            </div>
            <div v-else="activeView === 'artistList'" class="text-2xl font-bold">
              <div class="flex items-center gap-4 m-10">
                <div class="flex-1">
                  <SearchBar />
                </div>
                <SortFilter @sort-change="handleSortChange" />
              </div>
              <Footer class="pb-10" />
            </div>
        </div>
    </div>
  </div>
</template>
