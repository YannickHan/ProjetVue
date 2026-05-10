<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { authState } from '../store/auth'
import { getUserPlaylists, createPlaylist, deletePlaylist } from '../services/SongServices'
import PlaylistCreate from './PlaylistCreate.vue'
import ConfirmDialog from './ConfirmDialog.vue'

defineProps({
        activeView: {
                type: String,
                default: 'music',
        },
});

const emit = defineEmits(['change-view']);

const selectView = (view) => {
        emit('change-view', view);
};

const playlists = ref([])
const loadingPlaylists = ref(false)
const openedMenuId = ref(null)
const showCreateModal = ref(false)
const showConfirmDelete = ref(false)
const playlistToDelete = ref(null)

const loadPlaylists = async () => {
    const userId = authState.user?.id
    if (!userId) { playlists.value = []; return }
    loadingPlaylists.value = true
    try {
        const res = await getUserPlaylists(userId)
        playlists.value = res?.playlists ?? []
    } catch (err) {
        console.error('Failed to load playlists', err)
        playlists.value = []
    } finally {
        loadingPlaylists.value = false
    }
}

const handleAddPlaylist = () => { showCreateModal.value = true }
const onCreatePlaylist = async ({ name, cover }) => {
    try {
        const userId = authState.user?.id
        await createPlaylist({ name, userId, cover: cover || null })
        showCreateModal.value = false
        await loadPlaylists()
    } catch (err) {
        console.error('Create playlist failed', err)
        alert('Failed to create playlist')
    }
}

const handleDeletePlaylist = async (id) => {
  playlistToDelete.value = id
  showConfirmDelete.value = true
}

const confirmDeletePlaylist = async () => {
  if (!playlistToDelete.value) return
  try {
    await deletePlaylist(playlistToDelete.value)
    if (openedMenuId.value === playlistToDelete.value) openedMenuId.value = null
    await loadPlaylists()
    } catch (err) {
        console.error('Delete playlist failed', err)
        alert('Failed to delete playlist')
    } finally {
    showConfirmDelete.value = false
    playlistToDelete.value = null
  }
}

const handleClickOutside = (e) => {
   if (!e.target.closest('.playlist-menu')) {
    openedMenuId.value = null
  }
}

onMounted(() => {
    loadPlaylists()
    document.addEventListener('click', handleClickOutside)
})


onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<template>
    <div class="flex flex-col rounded-[28px] border border-white/10 bg-black/95 p-4 text-white shadow-2xl shadow-black/30 backdrop-blur-xl sm:p-5">
        <div class="mb-5 flex items-start justify-between gap-4 border-b border-white/10 pb-4">
            <div>
                <p class="text-[11px] uppercase tracking-[0.35em] text-white/45">Phantom Waves</p>
                <h1 class="mt-1 text-xl font-semibold sm:text-2xl">WebPlayer</h1>
                <p class="mt-1 text-sm text-white/55">Simple navigation, quick playback.</p>
            </div>
            <button class="rounded-full border border-white/10 bg-white/5 px-3 py-2 text-xs font-semibold text-white/70 sm:hidden" @click="selectView('music')">Home</button>
        </div>

        <nav class="space-y-2">
            <button :class="['flex w-full items-center gap-3 rounded-2xl px-4 py-3 text-left transition cursor-pointer', activeView === 'music' ? 'bg-gray-200 text-slate-950 shadow-lg shadow-black/20' : 'bg-white/5 text-white/85 hover:bg-white/10']" @click="selectView('music')">
                <span class="text-lg">⌂</span>
                <span class="font-medium">Music</span>
            </button>
            <button :class="['flex w-full items-center gap-3 rounded-2xl px-4 py-3 text-left transition cursor-pointer', activeView === 'search' ? 'bg-gray-200 text-slate-950 shadow-lg shadow-black/20' : 'bg-white/5 text-white/85 hover:bg-white/10']" @click="selectView('search')">
                <span class="text-lg">⌕</span>
                <span class="font-medium">Search</span>
            </button>
            <button :class="['flex w-full items-center gap-3 rounded-2xl px-4 py-3 text-left transition cursor-pointer', activeView === 'likes' ? 'bg-gray-200 text-slate-950 shadow-lg shadow-black/20' : 'bg-white/5 text-white/85 hover:bg-white/10']" @click="selectView('likes')">
                <span class="text-lg">♥</span>
                <span class="font-medium">Likes</span>
            </button>
            <button :class="['flex w-full items-center gap-3 rounded-2xl px-4 py-3 text-left transition cursor-pointer', activeView === 'surprise' ? 'bg-gray-200 text-slate-950 shadow-lg shadow-black/20' : 'bg-white/5 text-white/85 hover:bg-white/10']" @click="selectView('surprise')">
                <span class="text-lg">✦</span>
                <span class="font-medium">Quiz</span>
            </button>
        </nav>
    </div>
    <div class="flex flex-col rounded-[28px] border border-white/10 bg-black/95 p-4 mt-4 text-white shadow-2xl shadow-black/30 backdrop-blur-xl sm:p-5">
        <div>
            <p class="text-[11px] uppercase tracking-[0.35em] text-white/45">Phantom Waves</p>
            <h1 class="mt-1 text-xl font-semibold sm:text-2xl">Playlists</h1>
            <p class="mt-1 text-sm text-white/55">Your collections</p>
        </div>
        <button @click="handleAddPlaylist" class="rounded-full border border-white/10 bg-white/5 px-3 py-2 text-xs font-semibold text-white transition hover:bg-white/10">+ Add</button>

        <div class="mt-4 min-h-0 flex-1 pr-1">
            <div v-if="loadingPlaylists" class="rounded-2xl bg-white/5 p-4 text-sm text-white/55">Loading...</div>
            <div v-else-if="playlists.length === 0" class="rounded-2xl border border-dashed border-white/10 bg-white/5 p-4 text-sm text-white/45">No playlists</div>
            <div v-else class="overflow-y-auto max-h-[280px] pr-2 space-y-2">
                <div v-for="pl in playlists" :key="pl.idPlaylist" class="group flex w-full items-center justify-between gap-3 rounded-2xl border border-white/10 bg-white/5 p-2 transition hover:bg-white/10">
                    <button class="flex flex-1 items-center gap-3 text-left transition cursor-pointer" @click="selectView('playlist-'+pl.idPlaylist)">
                        <img v-if="pl.cover" :src="pl.cover" class="h-12 w-12 rounded-xl object-cover ring-1 ring-white/10" />
                        <img v-else src="/Logo3.png" class="h-12 w-12 rounded-xl object-cover ring-1 ring-white/10" />
                        <div class="min-w-0">
                            <div class="truncate font-medium">{{ pl.name }}</div>
                            <div class="text-xs text-white/45">{{ pl.songs.length }} tracks</div>
                        </div>
                    </button>
                    <div class="relative playlist-menu">
                        <button @click.stop="openedMenuId = openedMenuId === pl.idPlaylist ? null : pl.idPlaylist" class="rounded-full px-2 py-1 text-lg leading-none text-white/70 transition hover:bg-white/10">⋯</button>
                        <div v-if="openedMenuId === pl.idPlaylist" class="absolute right-0 z-50 mt-2 w-40 overflow-hidden rounded-2xl border border-white/10 bg-red-500 shadow-2xl shadow-black/40">
                            <button @click.stop="handleDeletePlaylist(pl.idPlaylist)" class="block w-full px-3 py-2 text-left text-sm text-white transition hover:text-black">Delete playlist</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <PlaylistCreate :show="showCreateModal" @create="onCreatePlaylist" @cancel="showCreateModal = false" />
    <ConfirmDialog :show="showConfirmDelete" title="Delete playlist" message="Are you sure you want to delete this playlist?" confirmText="Delete" cancelText="Cancel" @confirm="confirmDeletePlaylist" @cancel="showConfirmDelete = false" />
</template>