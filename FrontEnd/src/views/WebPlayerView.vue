<script setup>
import { computed, ref, watch, onMounted, onUnmounted } from 'vue';
import { useRoute, useRouter } from 'vue-router'
import { getTrendingSongs, searchSongsByTitle, getSongs, getLikedSongs } from '../store/Song';
import { getUserPlaylists, getPlaylistById, updatePlaylist, deletePlaylist } from '../services/SongServices'
import { authState } from '../store/auth'
import LeftBar from '../components/LeftBar.vue';
import MusicList from '../components/MusicList.vue';
import banner from '../components/banner.vue';
import Footer from '../components/Footer.vue';
import Playlist from '../components/Playlist.vue';
import TrendingArtiste from '../components/TrendingArtiste.vue';
import SearchBar from '../components/SearchBar.vue';
import Sort from '../components/Sort.vue';
import ArtistProfile from '../components/ArtistProfile.vue';
import Learning from '../components/Learning.vue';
import PlaylistEdit from '../components/PlaylistEdit.vue';
import ConfirmDialog from '../components/ConfirmDialog.vue';

const route = useRoute()
const router = useRouter()
const sidebarOpen = ref(false)
const contentScrollRef = ref(null)
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

const viewTitle = computed(() => {
    if (activeView.value === 'music') return 'Home';
    if (activeView.value === 'search') return 'Search';
    if (activeView.value === 'likes') return 'Likes';
    if (activeView.value === 'surprise') return 'Quiz';
    if (activeView.value === 'artist') return 'Artist Profile';
    if (typeof activeView.value === 'string' && activeView.value.startsWith('playlist-')) return 'Playlist';
    return 'Lecture';
});

// ----------------------------This handle the view----------------------------
const title = computed(() => {
    if (activeView.value === 'search') return 'Search Results';
    if (activeView.value === 'likes') return 'Liked Songs';
    if (activeView.value === 'surprise') return 'Surprise Playlist';
        // playlist-<id>
        if (typeof activeView.value === 'string' && activeView.value.startsWith('playlist-')) return 'Playlist'
        return 'My Playlist';
});

const playlistSongs = ref([])
const playlistInfo = ref(null)

watch(activeView, async (view) => {
  if (typeof view === 'string' && view.startsWith('playlist-')) {
    const parts = view.split('-')
    const id = Number(parts[1])
    try {
      const res = await getPlaylistById(id)
      playlistInfo.value = res?.playlist ?? null
      playlistSongs.value = res?.playlist?.songs ?? []
    } catch (err) {
      console.error('Failed to load playlist', err)
      playlistInfo.value = null
      playlistSongs.value = []
    }
  }
}, { immediate: true })

const showEditModal = ref(false)
const showConfirmDelete = ref(false)

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

const handleChangeView = (view) => {
    sidebarOpen.value = false
  router.push({
    path: '/webplayer',
    query: { view }
  })
}

watch(activeView, () => {
    sidebarOpen.value = false
    if (contentScrollRef.value) {
        contentScrollRef.value.scrollTop = 0
    }
})

// ----------------------------This handle the song selection state----------------------------
const currentTrack = ref({
    isPlaying: false,
    name: '',
    artist: '',
    cover: '',
    duration: '',
    path: '',
});

const handleSongPlayStateChange = (payload) => {
    currentTrack.value = {
        isPlaying: payload?.isPlaying ?? true,
        name: payload?.name ?? '',
        artist: payload?.artist ?? '',
        cover: payload?.cover ?? '',
        duration: payload?.duration ?? '',
        path: payload?.path ?? '',
    };
};

const handleLikeChanged = async () => {
    if (activeView.value !== 'likes') return;
    await getLikesSongs();
};

const handleEditPlaylist = async ({ name, cover }) => {
  try {
    const id = playlistInfo.value?.idPlaylist
    if (!id) return
    await updatePlaylist(id, { name, cover })
    showEditModal.value = false
    // reload playlist
    const res = await getPlaylistById(id)
    playlistInfo.value = res?.playlist ?? null
  } catch (err) {
    console.error('Edit playlist failed', err)
    alert('Failed to update playlist')
  }
}

const handleDeletePlaylist = async () => {
  try {
    const id = playlistInfo.value?.idPlaylist
    if (!id) return
    await deletePlaylist(id)
    showConfirmDelete.value = false
    router.push({ path: '/webplayer', query: { view: 'music' } })
  } catch (err) {
    console.error('Delete playlist failed', err)
    alert('Failed to delete playlist')
  }
}

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
    <div class="relative min-h-screen w-full max-w-full overflow-x-hidden bg-black text-white pb-10">
        <div class="pointer-events-none absolute inset-0 opacity-20">
            <div class="absolute -left-24 top-12 h-72 w-72 rounded-full bg-white/5 blur-2xl"></div>
            <div class="absolute right-0 top-1/4 h-96 w-96 rounded-full bg-white/5 blur-2xl"></div>
            <div class="absolute bottom-0 left-1/3 h-80 w-80 rounded-full bg-white/5 blur-2xl"></div>
        </div>

        <div class="relative z-10 grid h-screen w-full max-w-full grid-cols-1 gap-3 p-2 pt-16 sm:p-4 lg:grid-cols-[280px_minmax(0,1fr)] lg:gap-4 lg:pt-4">
            <button @click="sidebarOpen = !sidebarOpen" aria-label="Toggle menu" class="fixed left-4 top-20 z-[60] rounded-full border border-white/10 bg-black/80 px-4 py-3 text-sm font-semibold lg:hidden">
                Menu
            </button>

            <div class="fixed inset-0 top-16 z-30 bg-black/70 transition-opacity lg:hidden" :class="sidebarOpen ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none'" @click="sidebarOpen = false"></div>

            <aside class="fixed left-0 top-16 z-40 h-[calc(100vh-4rem)] w-[86vw] max-w-[320px] transform transition-transform duration-300 lg:static lg:z-auto lg:h-full lg:w-auto lg:max-w-none lg:top-0" :class="sidebarOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'">
                <LeftBar :active-view="activeView" @change-view="handleChangeView" />
            </aside>

            <main class="relative flex h-full min-h-0 flex-col overflow-hidden rounded-[28px] border border-white/10 bg-black/90 shadow-xl shadow-black/40">
                <div class="flex items-center justify-between border-b border-white/10 px-4 py-4 sm:px-6">
                    <div>
                        <p class="text-xs uppercase tracking-[0.35em] text-white/35">Phantom Waves</p>
                        <h1 class="text-xl font-semibold sm:text-3xl">{{ viewTitle }}</h1>
                    </div>
                </div>

                <div ref="contentScrollRef" class="min-h-0 flex-1 overflow-y-auto px-3 py-4 sm:px-6 sm:py-6 pb-16 sm:pb-16">
                    <div v-if="activeView === 'music'" class="space-y-5">
                        <section class="overflow-hidden rounded-[28px] border border-white/10 bg-black/80 shadow-lg">
                            <banner />
                        </section>

                        <section class="space-y-4">
                            <div class="rounded-[28px] border border-white/10 bg-black/80 p-4 shadow-lg sm:p-5">
                                <div class="mb-4 flex items-center justify-between gap-3">
                                    <div>
                                        <p class="text-xs uppercase tracking-[0.3em] text-white/35">Trending</p>
                                        <h2 class="text-xl font-semibold sm:text-2xl">Best of Today</h2>
                                    </div>
                                </div>
                                <TrendingArtiste one="Taylor Swift" two="Justin Bieber" three="Doja Cat" type="webplayer" @select-artist="handleSelectArtist"/>
                                <MusicList
                                    class="relative z-50"
                                    name="Top tracks"
                                    :songs="highlightedSongs"
                                    :current-track="currentTrack"
                                    @song-play-state-change="handleSongPlayStateChange"
                                />
                            </div>

                            <div class="space-y-4 w-full">
                                <Playlist name="Your Playlists"/>
                            </div>
                        </section>
                        <Footer />
                    </div>

                    <div v-else-if="activeView === 'search'" class="space-y-5">
                        <section class="rounded-[28px] border border-white/10 bg-black/80 p-4 shadow-lg sm:p-6">
                            <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
                                <div>
                                    <p class="text-xs uppercase tracking-[0.3em] text-white/35">Browse</p>
                                    <h2 class="text-xl font-semibold sm:text-2xl">Looking for something ?</h2>
                                </div>
                                <div class="w-full lg:max-w-xl">
                                    <SearchBar @search="handleSearchSongs" />
                                </div>
                            </div>
                        </section>
                        <MusicList
                            name="Song Catalog"
                            :songs="displayedSearchSongs"
                            :current-track="currentTrack"
                            type="admin"
                            @song-play-state-change="handleSongPlayStateChange"
                        />
                        <Footer />
                    </div>

                    <div v-else-if="activeView === 'likes'" class="space-y-5">
                        <section class="rounded-[28px] border border-white/10 bg-black/80 p-4 shadow-lg sm:p-6">
                            <p class="text-xs uppercase tracking-[0.3em] text-white/35">Library</p>
                            <h2 class="text-xl font-semibold sm:text-2xl">Find your favorite songs</h2>
                        </section>
                        <MusicList
                            name="Songs you've liked"
                            :songs="likesSongs"
                            :current-track="currentTrack"
                            @song-play-state-change="handleSongPlayStateChange"
                            @like-changed="handleLikeChanged"
                        />
                        <Footer class="pb-32" />
                    </div>

                    <div v-else-if="activeView === 'artist' && selectedArtist" class="space-y-5">
                        <ArtistProfile
                            :name="selectedArtist.artist"
                            :bg-cover="selectedArtist.image"
                            :nb-followers="0"
                        />
                        <Footer />
                    </div>

                    <div v-else-if="activeView === 'surprise'" class="space-y-5">
                        <section class="rounded-[28px] border border-white/10 bg-black/80 p-4 shadow-lg sm:p-6">
                            <p class="text-xs uppercase tracking-[0.3em] text-white/35">Discover</p>
                            <h2 class="text-xl font-semibold sm:text-2xl">Challenge Yourself on you knowledge of Music</h2>
                        </section>
                        <Learning />
                        <Footer />
                    </div>

                    <div v-else-if="typeof activeView === 'string' && activeView.startsWith('playlist-')" class="space-y-5">
                        <section class="rounded-[28px] border border-white/10 bg-black/80 p-4 shadow-lg sm:p-6">
                            <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                                <div class="flex items-center gap-4">
                                    <img v-if="playlistInfo?.cover" :src="playlistInfo.cover" class="h-24 w-24 rounded-2xl object-cover shadow-lg shadow-black/30 sm:h-28 sm:w-28" />
                                    <img v-else src="/Logo3.png" class="h-24 w-24 rounded-2xl object-cover shadow-lg shadow-black/30 sm:h-28 sm:w-28" />
                                    <div>
                                        <p class="text-xs uppercase tracking-[0.3em] text-white/35">Playlist</p>
                                        <h2 class="text-2xl font-semibold sm:text-3xl">{{ playlistInfo?.name || 'Playlist' }}</h2>
                                        <p class="mt-1 text-sm text-white/55">{{ (playlistInfo?.songs || []).length }} tracks</p>
                                    </div>
                                </div>
                                <div v-if="playlistInfo?.userId === authState.user?.id" class="flex flex-wrap gap-2">
                                    <button @click="showEditModal = true" class="rounded-full border border-white/10 bg-white/5 px-4 py-2 text-sm font-medium text-white transition hover:bg-white/10">✎ Edit</button>
                                    <button @click="showConfirmDelete = true" class="rounded-full border border-red-500/20 bg-red-500/10 px-4 py-2 text-sm font-medium text-red-200 transition hover:bg-red-500/20">🗑 Delete</button>
                                </div>
                            </div>
                        </section>
        
                        <MusicList
                            name="Songs in this playlist"
                            :songs="playlistSongs"
                            :current-track="currentTrack"
                            @song-play-state-change="handleSongPlayStateChange"
                        />
                        <Footer />
                    </div>
                </div>
            </main>
        </div>
    </div>
    <PlaylistEdit :show="showEditModal" :initialName="playlistInfo?.name || ''" :initialCover="playlistInfo?.cover || ''" @save="handleEditPlaylist" @cancel="showEditModal = false" />
    <ConfirmDialog :show="showConfirmDelete" title="Delete playlist" message="Are you sure you want to delete this playlist? This action is irreversible." confirmText="Delete" cancelText="Cancel" @confirm="handleDeletePlaylist" @cancel="showConfirmDelete = false" />
</template>