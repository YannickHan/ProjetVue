<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import PlaylistCard from './PlaylistCard.vue'
import { authState } from '../store/auth'
import { getUserPlaylists, createPlaylist } from '../services/SongServices'

defineProps(['name'])

const router = useRouter()
const playlists = ref([])
const isLoading = ref(false)
const errorMessage = ref('')

const newName = ref('')
const newCover = ref('')

const handleHorizontalWheel = (e) => {
  const el = e.currentTarget;
  if (!el || el.scrollWidth <= el.clientWidth) return;
  e.preventDefault();
  
  const delta = e.deltaY || e.deltaX;
  el.scrollBy({
    left: delta * 1.2,
    behavior: 'smooth'
  });
};

const handlePlaylistClick = (playlistId) => {
  router.push({
    path: '/webplayer',
    query: { view: `playlist-${playlistId}` }
  })
}

const loadPlaylists = async () => {
  const userId = authState.user?.id
  if (!userId) return;
  isLoading.value = true
  try {
    const res = await getUserPlaylists(userId)
    playlists.value = res?.playlists ?? []
  } catch (err) {
    console.error('Failed to load playlists', err)
    errorMessage.value = 'Failed to load playlists'
  } finally {
    isLoading.value = false
  }
}

const handleCreate = async () => {
  if (!newName.value) return alert('Name required')
  try {
    const userId = authState.user?.id
    await createPlaylist({ name: newName.value, userId, cover: newCover.value || null })
    newName.value = ''
    newCover.value = ''
    await loadPlaylists()
    alert('Playlist created')
  } catch (err) {
    console.error('Create playlist failed', err)
    alert('Failed to create playlist')
  }
}

onMounted(() => {
  loadPlaylists()
})
</script>

<template>
    <div class="mix-playlist mx-auto w-full max-w-full rounded-[24px] border border-white/10 bg-black/90 p-3 text-white shadow-xl backdrop-blur-xl sm:p-4">
        <div class="mb-3 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <div>
            <p class="text-xs uppercase tracking-[0.3em] text-white/35">Collections</p>
            <h2 class="text-left text-lg font-semibold sm:text-xl">{{ name }}</h2>
          </div>
          <div class="grid w-full gap-2 sm:grid-cols-2 lg:max-w-xl lg:grid-cols-[1fr_1fr_auto]">
            <input v-model="newName" placeholder="New playlist name" class="rounded-xl border border-white/10 bg-black/80 p-2 text-xs text-white placeholder:text-white/35 outline-none transition focus:border-white/25 sm:text-sm" />
            <input v-model="newCover" placeholder="Cover URL (optional)" class="rounded-xl border border-white/10 bg-black/80 p-2 text-xs text-white placeholder:text-white/35 outline-none transition focus:border-white/25 sm:text-sm" />
            <button @click="handleCreate" class="rounded-xl border border-white/10 bg-white/5 px-3 py-2 text-xs font-semibold text-white transition hover:bg-white/10 sm:text-sm">Create</button>
          </div>
        </div>

        <section class="w-full overflow-x-auto pb-1" @wheel="handleHorizontalWheel">
            <div v-if="isLoading" class="rounded-2xl border border-white/10 bg-black/75 p-4 text-gray-300">Loading...</div>
            <div v-else class="flex flex-nowrap justify-start gap-2 pb-1 sm:gap-3 m-2">
              <PlaylistCard v-for="pl in playlists" :key="pl.idPlaylist" :id="pl.idPlaylist" :name="pl.name" :artists="(pl.songs || []).slice(0,4).map(s=>s.artist).join(', ')" :nb-tracks="(pl.songs || []).length + ' tracks'" :cover="pl.cover || '/Logo3.png'" @click="handlePlaylistClick(pl.idPlaylist)"/>
            </div>
        </section>
    </div>
</template>