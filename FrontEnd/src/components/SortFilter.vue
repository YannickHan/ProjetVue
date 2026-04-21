<script setup>
import { ref, watch } from 'vue';

const emit = defineEmits(['sort-change']);

const showMenu = ref(false);
const sortBy = ref('name');
const order = ref('asc');

const toggleMenu = () => {
  showMenu.value = !showMenu.value;
};

watch([sortBy, order], () => {
  emit('sort-change', {
    sortBy: sortBy.value,
    order: order.value
  });
});
</script>

<template>
  <div class="relative">
    <button
      @click="toggleMenu"
      :class="['w-full px-6 py-3 bg-transparent rounded-full border cursor-pointer',
      showMenu
        ? 'text-green-500 ring-2 ring-green-500'
        : 'text-white border-white'
      ]"
      >
      Filters
    </button>

    <transition name="fade">
      <div
        v-if="showMenu"
        class="absolute right-0 mt-3 w-56 text-white p-4 rounded-2xl border border-green-500 bg-black/75"
        >
        <div class="mb-4">
          <label class="text-xs text-green-500">Sort by</label>
          <select
            v-model="sortBy"
            class="w-full mt-1 p-3 rounded-lg border border-white text-white text-xl cursor-pointer 
                  focus:ring-2 focus:ring-green-500 focus:border-none"
          >
            <option value="name">Title</option>
            <option value="artist">Artist</option>
          </select>
        </div>
        <div>
          <label class="text-xs text-green-500">Order</label>
          <select
            v-model="order"
            class="w-full mt-1 p-3 rounded-lg border border-white text-white text-xl cursor-pointer 
                    focus:ring-2 focus:ring-green-500 focus:border-none"
          >
            <option value="asc">A → Z</option>
            <option value="desc">Z → A</option>
          </select>
        </div>

      </div>
    </transition>

  </div>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: all 0.15s ease;
}

.fade-enter-from, .fade-leave-to {
  opacity: 0;
  transform: translateY(-5px);
}
</style>