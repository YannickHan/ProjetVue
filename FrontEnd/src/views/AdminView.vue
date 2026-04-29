<script setup>
import { ref, computed } from 'vue';
import AdminLeftbar from '../components/AdminLeftbar.vue';
import Sort from '../components/Sort.vue';
import Filter from "../components/Filter.vue";
import AddButton from '../components/AddButton.vue';
import SearchBar from '../components/SearchBar.vue';
import MusicList from '../components/MusicList.vue';
import AdminDashboard from '../components/AdminDashboard.vue';
import ArtistList from '../components/ArtistList.vue';
import SongsData from '../assets/songsData.json';
import Footer from '../components/Footer.vue';
import { logout } from "../store/auth";

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

// ----------------------------This handle the filtering ----------------------------
const filters = ref({
  artists: []
});

const hasFilters = computed(() =>
  filters.value.artists.length > 0
);

function handleFilters(data) {
  filters.value = data;
}

function normalizeArtists(str) {
  return str
    .replace(/\s*ft\.\s*/gi, ',')
    .split(',')
    .map(a => a.trim())
    .filter(Boolean);
}

// ----------------------------This handle the sorting ----------------------------
const sortOptions = ref({
  sortBy: 'name',
  order: 'asc'
});

const handleSortChange = (options) => {
  sortOptions.value = options;
};

const processedSongs = computed(() => {
  let result = [...songs.value];
  if (filters.value.artists.length) {
    result = result.filter(song => {
      const songArtists = normalizeArtists(song.artist);
      return filters.value.artists.some(a => songArtists.includes(a));
    });
  }
  const key = sortOptions.value.sortBy;
  result.sort((a, b) => {
    const aVal = (a[key] ?? '').toString().toLowerCase();
    const bVal = (b[key] ?? '').toString().toLowerCase();

    return sortOptions.value.order === 'asc'
      ? aVal.localeCompare(bVal)
      : bVal.localeCompare(aVal);
  });

  return result;
});
</script>

<template>
  <div>
    <div class="grid grid-cols-[0.3fr_1fr]">
        <AdminLeftbar :active-view="activeView" @change-view="handleChangeView" />
        <div class="bg-black rounded-4xl m-4 text-white h-[53rem] flex flex-col overflow-y-auto">
            <div v-if="activeView === 'dashboard'" class="text-2xl font-bold">
              <AdminDashboard/>
              <Footer class="pb-10" />
            </div>
            <div v-else-if="activeView === 'musicList'" class="text-2xl font-bold">
              <div class="flex items-center gap-4 m-5">
                  <div class="flex-1">
                    <SearchBar />
                  </div>
              </div>
              <div class="flex m-5">
                <div :class="hasFilters ? 'w-34' : 'w-25'" class="relative">
                  <Filter @update:filters="handleFilters" />
                </div>
                <Sort @sort-change="handleSortChange" type="songCatalog" />
                <div class="ml-auto">
                  <AddButton type="songCatalog"/>
                </div>
              </div>
              <MusicList 
                    name="Song Catalog"
                    :songs="processedSongs"
                    :current-track="currentTrack"
                    @song-play-state-change="handleSongPlayStateChange"
                    class="transition-all duration-300 ease-in-out"
                />
              <Footer class="pb-10" />
            </div>
            <div v-else="activeView === 'artistList'" class="text-2xl font-bold">
                <ArtistList />
              <Footer class="pb-10"/>
            </div>
        </div>
    </div>
  </div>
</template>
