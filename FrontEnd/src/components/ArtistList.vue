<script setup>
import { computed, ref, onMounted, onBeforeUnmount } from 'vue';
import Sort from '../components/Sort.vue';
import AddButton from '../components/AddButton.vue';
import { authState } from "../store/auth";
import { getArtists, updateArtist, deleteArtist } from '../services/SongServices';

const openSettings = ref(null);
const editArtist = ref(null);
const order = ref('asc');

const emit = defineEmits(['select-artist']);

// ------------------ This handle the sorting ------------------
const handleSortChange = ({ order: newOrder }) => {
  if (newOrder === 'asc' || newOrder === 'desc') {
    order.value = newOrder;
  }
};

const artistsList = ref([]);

const artists = computed(() => {
  const arr = artistsList.value.map(a => ({
    idArtist: a.idArtist,
    nameArtist: a.nameArtist,
    image: a.profileArtist || '',
  }));
  return arr.sort((a, b) => {
    return order.value === 'asc'
      ? a.nameArtist.localeCompare(b.nameArtist, undefined, { sensitivity: 'base' })
      : b.nameArtist.localeCompare(a.nameArtist, undefined, { sensitivity: 'base' });
  });
});

const loadArtists = async () => {
  try {
    const rows = await getArtists();
    // rows: [{idArtist, nameArtist}]
    console.log('Loaded artists:', rows);
    artistsList.value = rows;
  } catch (err) {
    console.error('Failed to load artists:', err);
    artistsList.value = [];
  }
};

const selectArtist = (artist, image) => {
  emit('select-artist', { artist, image });
};

// ------------------ This handle editing ------------------
const openEdit = (artistId, artistName, profileUrl) => {
  editArtist.value = {
    idArtist: artistId,
    name: artistName,
    coverUrl: profileUrl || '',
  };
  openSettings.value = null;
};

const closeEdit = () => {
  editArtist.value = null;
};

const handleSaveEdit = async (event) => {
  event.preventDefault();
  if (!editArtist.value?.idArtist) return;
  
  try {
    await updateArtist(editArtist.value.idArtist, {
      name: editArtist.value.name,
      profileAvatar: editArtist.value.coverUrl,
    });
    alert('✅ Artist updated successfully!');
    closeEdit();
    loadArtists();
  } catch (err) {
    console.error('Error updating artist:', err);
    alert(`❌ Error: ${err.message}`);
  }
};

const handleDeleteArtist = async (artistId, artistName) => {
  const id = artistId || editArtist.value?.idArtist;
  const name = artistName || editArtist.value?.name;
  
  if (!id) return;
  
  if (!confirm(`Are you sure you want to delete "${name}"?`)) return;
  
  try {
    await deleteArtist(id);
    alert('✅ Artist deleted successfully!');
    closeEdit();
    openSettings.value = null;
    loadArtists();
  } catch (err) {
    console.error('Error deleting artist:', err);
    alert(`❌ Error: ${err.message}`);
  }
};

// ------------------ This handle the click outside the object ------------------
function handleClickOutside(e) {
  const isSettingsButton = e.target.closest('.settings-btn');
  const isDropdown = e.target.closest('.dropdown-menu');
  if (!isSettingsButton && !isDropdown) {
    openSettings.value = null;
  }
}
onMounted(() => {
  document.addEventListener('click', handleClickOutside);
  loadArtists();
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>

<template>
  <div class="trending-artiste rounded-2xl sm:rounded-4xl p-3 sm:p-10 text-white">
    <div class="flex flex-col sm:flex-row items-start sm:items-center gap-2 sm:gap-0">
        <h2 class="font-bold text-xl sm:text-3xl">Artist List</h2>
        <div class="ml-auto flex items-center gap-2 sm:gap-3 w-full sm:w-auto">
            <Sort type="artistList" @sort-change="handleSortChange" />
            <AddButton type="artistList" />
        </div>
    </div>
    <section class="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-4 text-center text-lg pb-4">
        <div v-for="artist in artists" :key="artist.idArtist" @click="selectArtist(artist.nameArtist, artist.image)"
            class="relative h-72 bg-[#1a1a1a] rounded-4xl p-4 bg-cover bg-center bg-no-repeat hover:scale-105 transition-transform duration-300 cursor-pointer flex flex-col justify-end"
            :style="{ backgroundImage: `url(${artist.image})` }"
        >
          <h3 class="font-bold text-2xl m-5">{{ artist.nameArtist }}</h3>
          <button
            type="button"
            @click.stop="openSettings = openSettings === artist.nameArtist ? null : artist.nameArtist"
            aria-label="Settings"
            class="settings-btn absolute top-3 right-5 w-8 h-8 rounded-full bg-black/55 text-white text-xl leading-none flex items-center justify-center cursor-pointer hover:scale-110 hover:bg-black/75 transition-transform duration-300 z-10"
          >
            ⋮
          </button>
          <div v-if="openSettings === artist.nameArtist && authState.user?.role === 'admin'" class="dropdown-menu absolute top-7 right-5 mt-2 w-50 bg-black/60 border rounded text-white text-base z-50">
            <div class="px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black" @click.stop="openEdit(artist.idArtist, artist.nameArtist, artist.image)">Modify parameters</div>
            <div class="px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black" @click.stop="handleDeleteArtist(artist.idArtist, artist.nameArtist)">Delete artist</div>
          </div>
        </div>
    </section>
    <div v-if="editArtist" class="fixed inset-0 backdrop-blur-sm flex items-center justify-center z-50 p-4">
      <div class="w-full max-w-2xl rounded-2xl border border-white/5 bg-black/90 p-4 sm:p-6 relative">
        <h1 class="text-lg sm:text-xl font-bold mb-4 sm:mb-6">Modify parameters</h1>
        <form class="space-y-3 sm:space-y-4" @submit.prevent="handleSaveEdit">
          <div>
            <label class="block text-xs sm:text-sm text-white/70 mb-1">Stage name</label>
            <input v-model="editArtist.name" type="text" name="name" required class="text-base w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
          </div>
          <div>
            <label class="block text-xs sm:text-sm text-white/70 mb-1">Artist photo URL</label>
            <input v-model="editArtist.coverUrl" type="text" name="coverUrl" required class="text-base w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
          </div>
          <div class="flex flex-col sm:flex-row justify-end gap-2 sm:gap-3 pt-3 sm:pt-4">
            <button type="button" @click="handleDeleteArtist" class="px-3 sm:px-4 py-2 text-xs sm:text-sm rounded-xl bg-red-600 hover:bg-red-500 transition"> Delete </button>
            <button type="button" @click="closeEdit" class="px-3 sm:px-4 py-2 text-xs sm:text-sm rounded-xl bg-white/10 hover:bg-white/20 transition"> Cancel </button>
            <button type="submit" class="px-4 sm:px-5 py-2 text-xs sm:text-sm rounded-xl bg-green-600 hover:bg-green-500 transition"> Save </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>