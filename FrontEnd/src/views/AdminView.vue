<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import AdminLeftbar from '../components/AdminLeftbar.vue'
import Sort from '../components/Sort.vue'
import Filter from '../components/Filter.vue'
import AddButton from '../components/AddButton.vue'
import SearchBar from '../components/SearchBar.vue'
import MusicList from '../components/MusicList.vue'
import AdminDashboard from '../components/AdminDashboard.vue'
import ArtistList from '../components/ArtistList.vue'
import Footer from '../components/Footer.vue'
import { logout } from '../store/auth'
import { getSongs, searchSongsByTitle } from '../store/Song'

const songs = ref([]);
const searchResults = ref([]);
const searchQuery = ref('');

const loadSongs = async () => {
  try {
    const data = await getSongs();
    songs.value = data.map(song => ({
      id: song?.idSong ?? song?.id ?? null,
      name: song?.name ?? song?.titleSong ?? '',
      artist: song?.artist ?? song?.nameArtist ?? 'Unknown artist',
      duration: song?.duration ?? song?.durationSong ?? '',
      cover: song?.cover ?? song?.coverSong ?? '',
      path: song?.path ?? song?.pathSong ?? '',
    }));
  } catch (error) {
    console.error('Error fetching songs:', error);
    songs.value = [];
  }
};

onMounted(() => {
  loadSongs();
});

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

// ----------------------------This handle the router ----------------------------

const router = useRouter()

const handleSelectArtist = (payload) => {
    router.push({
        path: '/webplayer',
        query: {
            view: 'artist',
            name: payload.artist,
            image: payload.image,
        },
    })
}

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

const sectionTitle = computed(() => {
  if (activeView.value === 'dashboard') return 'Dashboard'
  if (activeView.value === 'musicList') return 'Music catalog'
  return 'Artists'
})

const sectionSubtitle = computed(() => {
  if (activeView.value === 'dashboard') return 'Overview of platform activity and user requests.'
  if (activeView.value === 'musicList') return 'Browse the song catalog and keep it up to date.'
  return 'Browse the artist list and keep the catalog up to date.'
})

const totalSongs = computed(() => songs.value.length)
const visibleSongs = computed(() => displayedSongs.value.length)
const totalArtists = computed(() => {
  const artists = new Set()
  songs.value.forEach((song) => {
    normalizeArtists(song.artist).forEach((artist) => artists.add(artist))
  })
  return artists.size
})
</script>

<template>
  <div class="relative min-h-screen w-screen overflow-hidden bg-black text-white">
    <div class="pointer-events-none absolute inset-0 opacity-20">
      <div class="absolute -left-24 top-10 h-72 w-72 rounded-full bg-white/5 blur-2xl"></div>
      <div class="absolute right-0 top-1/4 h-96 w-96 rounded-full bg-white/5 blur-2xl"></div>
      <div class="absolute bottom-0 left-1/3 h-80 w-80 rounded-full bg-white/5 blur-2xl"></div>
    </div>

    <div class="relative z-10 grid h-screen w-screen grid-cols-1 gap-3 p-2 sm:p-4 lg:grid-cols-[260px_minmax(0,1fr)] lg:gap-4">
      <aside class="h-full">
        <AdminLeftbar :active-view="activeView" @change-view="handleChangeView" />
      </aside>

      <main class="relative flex h-full min-h-0 flex-col overflow-hidden rounded-[28px] border border-white/10 bg-black/90 shadow-xl shadow-black/40">
        <div class="flex items-center justify-between border-b border-white/10 px-4 py-4 sm:px-6">
          <div>
            <p class="text-xs uppercase tracking-[0.35em] text-white/35">Phantom Waves</p>
            <h1 class="text-xl font-semibold sm:text-3xl">Admin panel</h1>
          </div>
          <button @click="handleLogout" class="rounded-full border border-white/10 bg-white/5 px-4 py-2 text-sm font-semibold text-white/70 transition hover:bg-white/10">
            Logout
          </button>
        </div>

        <div class="min-h-0 flex-1 overflow-y-auto px-3 py-4 sm:px-6 sm:py-6">
          <div class="space-y-5">
            <section class="rounded-[28px] border border-white/10 bg-black/80 p-4 shadow-lg sm:p-6">
              <div class="grid gap-4 xl:grid-cols-[1.3fr_0.7fr]">
                <div class="space-y-4">
                  <p class="text-xs uppercase tracking-[0.3em] text-white/35">Administration</p>
                  <h2 class="text-2xl font-semibold sm:text-4xl">{{ sectionTitle }}</h2>
                  <p class="max-w-2xl text-sm leading-7 text-white/60 sm:text-base">
                    {{ sectionSubtitle }}
                  </p>
                </div>

                <div class="grid gap-3 sm:grid-cols-3 xl:grid-cols-1">
                  <div class="rounded-[24px] border border-white/10 bg-white/5 p-4">
                    <p class="text-xs uppercase tracking-[0.3em] text-white/35">Songs</p>
                    <p class="mt-2 text-2xl font-semibold">{{ totalSongs }}</p>
                    <p class="mt-1 text-sm text-white/55">Total songs loaded</p>
                  </div>
                  <div class="rounded-[24px] border border-white/10 bg-white/5 p-4">
                    <p class="text-xs uppercase tracking-[0.3em] text-white/35">Artists</p>
                    <p class="mt-2 text-2xl font-semibold">{{ totalArtists }}</p>
                    <p class="mt-1 text-sm text-white/55">Total artists loaded</p>
                  </div>
                </div>
              </div>
            </section>

            <section v-if="activeView === 'dashboard'" class="rounded-[28px] border border-white/10 bg-black/80 p-4 shadow-lg sm:p-6">
              <AdminDashboard />
            </section>

            <section v-else-if="activeView === 'musicList'" class="rounded-[28px] border border-white/10 bg-black/80 p-4 shadow-lg sm:p-6">
              <div class="mb-4 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
                <div>
                  <p class="text-xs uppercase tracking-[0.3em] text-white/35">Catalog tools</p>
                  <h2 class="text-xl font-semibold sm:text-2xl">Search and manage songs</h2>
                </div>
                <div class="flex gap-2">
                  <AddButton type="songCatalog" />
                </div>
              </div>
              <SearchBar @search="handleSearchSongs" />
              <div class="flex flex-row gap-3 sm:mt-5">
                <Sort @sort-change="handleSortChange" type="songCatalog" />
                <Filter :songs="songs" @update:filters="handleFilters" />
              </div>
              <div class="mt-5">
                <MusicList
                  name="Song Catalog"
                  :songs="displayedSongs"
                  :current-track="currentTrack"
                  @song-play-state-change="handleSongPlayStateChange"
                  class="transition-all duration-300 ease-in-out"
                />
              </div>
            </section>

            <section v-else class="rounded-[28px] border border-white/10 bg-black/80 p-4 shadow-lg sm:p-6">
              <div class="mb-4">
                <p class="text-xs uppercase tracking-[0.3em] text-white/35">Artists</p>
                <h2 class="text-xl font-semibold sm:text-2xl">Artist list</h2>
              </div>
              <ArtistList @select-artist="handleSelectArtist"/>
            </section>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>
