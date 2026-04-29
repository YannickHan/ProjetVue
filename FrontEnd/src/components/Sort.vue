<script setup>
import { ref, watch, onMounted, onBeforeUnmount } from 'vue';

const props = defineProps({
  type: {
    type: String,
    required: true,
  },
})

const emit = defineEmits(['sort-change']);

const dropdownRef = ref(null);
const isOpen = ref(false);

const sortBy = ref('name');
const order = ref('asc');
// ------------------ This handle the sorting ------------------
const emitSort = () => {
  emit('sort-change', {
    sortBy: sortBy.value,
    order: order.value
  });
};

watch([sortBy, order], emitSort);

function toggleMenu() {
  isOpen.value = !isOpen.value;
}

// ------------------ This handle the click outside the object ------------------
function handleClickOutside(e) {
  if (!dropdownRef.value) return;
  if (!dropdownRef.value.contains(e.target)) {
    isOpen.value = false;
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
  emitSort();
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>

<template>
  <div ref="dropdownRef" class="relative w-fit">
    <button
      @click="toggleMenu"
      class="px-5 py-2 rounded-full border cursor-pointer transition hover:scale-[1.02]"
      :class="isOpen
        ? 'text-green-500 ring-2 ring-green-500'
        : 'text-white border-white'"
    >
      ⬍
    </button>

    <transition name="fade">
      <div v-if="isOpen" :class="[
        'absolute mt-3 w-56 text-white p-4 rounded-2xl border border-green-500 bg-black/80 z-50',
        props.type === 'songCatalog' ? 'left-0' : '',
        props.type === 'artistList' ? 'right-0' : ''
      ]"> 
        <div v-if="props.type === 'songCatalog'">
          <div class="mb-4">
            <label class="text-sm text-green-500">Sort by</label>
            <select v-model="sortBy" class="text-lg w-full mt-1 p-3 rounded-lg border border-white bg-black/60">
              <option value="name">Title</option>
              <option value="artist">Artist</option>
            </select>
          </div>
          <div>
            <label class="text-sm text-green-500">Order</label>
            <select v-model="order" class="text-lg w-full mt-1 p-3 rounded-lg border border-white bg-black/60">
              <option value="asc">A → Z</option>
              <option value="desc">Z → A</option>
            </select>
          </div>
        </div>
        <div v-else-if="props.type === 'artistList'">
          <label class="text-sm text-green-500">Order</label>
          <select v-model="order" class="text-lg w-full mt-1 p-3 rounded-lg border border-white bg-black/60">
            <option value="asc">A → Z</option>
            <option value="desc">Z → A</option>
          </select>
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
  transform: translateY(-5px);
}
</style>