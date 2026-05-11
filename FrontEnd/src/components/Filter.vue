<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue';

const emit = defineEmits(['update:filters']);
const props = defineProps({
  songs: {
    type: Array,
    default: () => [],
  },
});

const isOpen = ref(false);
const dropdownRef = ref(null);

const filters = ref({
  artists: []
});

const artists = computed(() => {
  const all = props.songs
    .flatMap(song =>
      (song?.artist ?? song?.nameArtist ?? '')
        .replace(/ft\./gi, ',')
        .split(',')
        .map(a => a.trim())
        .filter(Boolean)
    );

  return [...new Set(all)].sort((a, b) =>
    a.localeCompare(b)
  );
});

// ------------------  This handle the filtering ------------------
const hasActiveFilters = computed(() =>
  filters.value.artists.length > 0
);

function toggleArtist(artist) {
  const arr = filters.value.artists;
  filters.value.artists = arr.includes(artist)
    ? arr.filter(a => a !== artist)
    : [...arr, artist];
  emit('update:filters', {
    artists: filters.value.artists
  });
}

function clearFilters() {
  filters.value.artists = [];
  emit('update:filters', {
    artists: []
  });
}

// ------------------ This handle the click outside the object ------------------
const handleClickOutside = (e) => {
  if (!dropdownRef.value) return;
  if (!dropdownRef.value.contains(e.target)) {
    isOpen.value = false;
  }
};

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>

<template>
  <div ref="dropdownRef" class="relative w-fit">
    <button @click="isOpen = !isOpen"
      class="text-lg text-white px-4 py-2 rounded-full border transition flex items-center gap-2 hover:scale-[1.02] cursor-pointer"
      :class="hasActiveFilters
        ? 'bg-green-500 border-green-500'
        : 'bg-transparent border-white'"
    >
      Filters
      <span v-if="hasActiveFilters" class="ml-1 text-xs bg-black/10 px-2 py-0.5 rounded-full">
        {{ filters.artists.length }}
      </span>
    </button>

    <div v-if="hasActiveFilters" class="mt-6 w-[66em] flex flex-wrap gap-2 p-2 rounded-xl border border-gray-700">
      <span v-for="a in filters.artists":key="a"
        class="px-3 py-1 text-xs rounded-full bg-white text-black flex items-center gap-2 cursor-pointer">
        {{ a }}
        <button @click="toggleArtist(a)" class="hover:text-green-500 cursor-pointer"> ✕ </button>
      </span>
      <button @click="clearFilters" class="text-xs text-gray-400 underline hover:text-white cursor-pointer"> Clear </button>
    </div>

    <transition name="fade">
      <div v-if="isOpen" class="absolute left-0 mt-3 w-[66em] bg-black/80 border border-green-500 rounded-2xl p-4 z-50">
        <p class="font-bold text-green-500 text-sm mb-3">Artists</p>
        <div class="flex flex-wrap gap-2">
          <label v-for="a in artists":key="a"
            class="cursor-pointer px-3 py-1 border rounded-full text-sm hover:bg-white hover:text-black hover:border-none"
            :class="filters.artists.includes(a)
              ? 'bg-green-500 text-white border-none'
              : 'border-gray-600 text-white'"
            >
            <input type="checkbox" class="hidden" :checked="filters.artists.includes(a)" @change="toggleArtist(a)"/> 
            {{ a }}
          </label>
        </div>
      </div>
    </transition>
  </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: all 0.15s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-6px);
}
</style>