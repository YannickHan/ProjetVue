<script setup>
import { computed, ref, onMounted, onBeforeUnmount } from 'vue';
import Sort from '../components/Sort.vue';
import AddButton from '../components/AddButton.vue';
import { authState } from "../store/auth";

const openSettings = ref(null);
const editArtist = ref(null);
const order = ref('asc');

const emit = defineEmits(['select-artist']);

const backgroundImages = {
  "Taylor Swift": "https://i.pinimg.com/736x/5e/dc/bd/5edcbdc406d790deefc554e5703879b7.jpg",
  "Justin Bieber": "https://wallpapercat.com/w/full/8/5/2/151041-1366x2048-mobile-hd-justin-bieber-background.jpg",
  "Doja Cat": "https://i.pinimg.com/736x/b2/d5/68/b2d5686acf5791074153982e68b0ce43.jpg",
  "DJ Snake": "https://wallpapercat.com/w/small-vertical-retina/8/4/9/2576255-1333x2000-mobile-hd-dj-snake-wallpaper-image.jpg?id=1662450997",
  "Dua Lipa": "https://wallpapercat.com/w/small-vertical-retina/a/f/7/106752-1440x2560-mobile-hd-dua-lipa-wallpaper-photo.jpg?id=1644914842",
  "Post Malone": "https://wallpapercat.com/w/small-vertical-retina/1/7/f/106654-1440x2560-samsung-hd-post-malone-background.jpg?id=1644914818",
  "Lorde": "https://wallpapercat.com/w/full/9/5/7/2327352-1920x1200-desktop-hd-lorde-wallpaper.jpg",
  "Billie Eilish": "https://wallpapercat.com/w/small-vertical-retina/f/4/3/11705-1920x2688-phone-hd-billie-eilish-background-photo.jpg?id=1644840023",
  "Sabrina Carpenter": "https://wallpapercave.com/wp/wp15388514.jpg",
}

// ------------------ This handle the sorting ------------------
const handleSortChange = ({ order: newOrder }) => {
  if (newOrder === 'asc' || newOrder === 'desc') {
    order.value = newOrder;
  }
};

const artists = computed(() => {
  return [...Object.entries(backgroundImages)].sort(([a], [b]) => {
    return order.value === 'asc'
      ? a.localeCompare(b, undefined, { sensitivity: 'base' })
      : b.localeCompare(a, undefined, { sensitivity: 'base' });
  });
});

const selectArtist = (artist, image) => {
  emit('select-artist', { artist, image });
};

// ------------------ This handle editing ------------------
const openEdit = (artist) => {
  editArtist.value = {
    name: artist,
    coverUrl: backgroundImages[artist],
  };
  openSettings.value = null;
};

const closeEdit = () => {
  editArtist.value = null;
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
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>

<template>
  <div class="trending-artiste rounded-4xl p-10 text-white">
    <div class="flex items-center">
        <h2 class="font-bold text-3xl">Artist List</h2>
        <div class="ml-auto flex items-center gap-3">
            <Sort type="artistList" @sort-change="handleSortChange" />
            <AddButton type="artistList" />
        </div>
    </div>
    <section class="grid grid-cols-3 gap-6 mt-4 text-center text-lg pb-4">
        <div v-for="[artist, image] in artists" :key="artist" @click="selectArtist(artist, image)"
            class="relative h-72 bg-[#1a1a1a] rounded-4xl p-4 bg-cover bg-center bg-no-repeat hover:scale-105 transition-transform duration-300 cursor-pointer flex flex-col justify-end"
            :style="{ backgroundImage: `url(${image})` }"
        >
          <h3 class="font-bold text-2xl m-5">{{ artist }}</h3>
          <img src="https://cdn-icons-png.flaticon.com/512/1828/1828687.png" 
            @click.stop="openSettings = openSettings === artist ? null : artist"
            alt="Settings" 
            class="settings-btn absolute top-3 right-5 w-5 h-5 cursor-pointer hover:scale-110 transition-transform duration-300">
          <div v-if="openSettings === artist && authState.user?.role === 'admin'" class="dropdown-menu absolute top-7 right-5 mt-2 w-50 bg-black/60 border rounded text-white text-base z-50">
            <div class="px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black" @click.stop="openEdit(artist)">Modify parameters</div>
            <div class="px-4 py-2 cursor-pointer hover:bg-white/90 hover:text-black">Delete artist</div>
          </div>
        </div>
    </section>
    <div v-if="editArtist" class="fixed inset-0 backdrop-blur-sm flex items-center justify-center z-50">
      <div class="w-full max-w-2xl rounded-2xl border border-white/5 bg-black/90 p-6 relative">
        <h1 class="text-xl font-bold mb-6">Modify parameters</h1>
        <form class="space-y-4">
          <div>
            <label class="block text-sm text-white/70 mb-1">Stage name</label>
            <input v-model="editArtist.name" type="text" name="name" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
          </div>
          <div>
            <label class="block text-sm text-white/70 mb-1">Artist photo URL</label>
            <input v-model="editArtist.coverUrl" type="text" name="coverUrl" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
          </div>
          <div class="flex justify-end gap-3 pt-4">
            <button type="button" @click="closeEdit" class="px-4 py-2 text-sm rounded-xl bg-white/10 hover:bg-white/20 transition"> Cancel </button>
            <button type="submit" class="px-5 py-2 text-sm rounded-xl bg-green-600 hover:bg-green-500 transition"> Save </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>