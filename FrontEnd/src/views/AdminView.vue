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
import { searchSongsByTitle } from '../store/Song';

const songs = ref(SongsData);
const searchResults = ref([]);
const searchQuery = ref('');

const handleLogout = () => {
  logout();
  router.push("/");
};

const activeView = ref('dashboard');
const handleChangeView = (view) => {
  activeView.value = view;
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

const displayedSongs = computed(() => {
  if (searchQuery.value) return searchResults.value;
  return processedSongs.value;
});
</script>

<template>
  <div>
    <div class="grid grid-cols-1 lg:grid-cols-[0.2fr_0.8fr] grid-rows-[auto_1fr] lg:grid-rows-1 h-screen w-screen p-2 sm:p-4 gap-2 sm:gap-4">
        <AdminLeftbar :active-view="activeView" @change-view="handleChangeView" />
        <div class="bg-black text-white h-full w-full flex flex-col overflow-y-auto rounded-2xl sm:rounded-4xl">
            <div v-if="activeView === 'dashboard'" class="text-lg sm:text-2xl font-bold">
              <AdminDashboard/>
              <Footer class="pb-10" />
            </div>
            <div v-else-if="activeView === 'musicList'" class="text-lg sm:text-2xl font-bold">
              <div class="flex flex-col sm:flex-row items-center gap-2 sm:gap-4 m-2 sm:m-5">
                  <div class="flex-1 w-full">
                    <SearchBar @search="handleSearchSongs" />
                  </div>
              </div>
              <div class="flex flex-col sm:flex-row gap-2 sm:gap-0 m-2 sm:m-5">
                <div :class="hasFilters ? 'w-34' : 'w-25'" class="relative w-full sm:w-auto">
                  <Filter @update:filters="handleFilters" />
                </div>
                <Sort @sort-change="handleSortChange" type="songCatalog" />
                <div class="ml-auto w-full sm:w-auto">
                  <AddButton type="songCatalog"/>
                </div>
              </div>
              <MusicList 
                    name="Song Catalog"
                    :songs="displayedSongs"
                    :current-track="currentTrack"
                    @song-play-state-change="handleSongPlayStateChange"
                    class="transition-all duration-300 ease-in-out"
                />
              <Footer class="pb-10" />
            </div>
            <div v-else="activeView === 'artistList'" class="text-lg sm:text-2xl font-bold">
                <ArtistList />
              <Footer class="pb-10"/>
            </div>
        </div>
    </div>
  </div>
</template>
