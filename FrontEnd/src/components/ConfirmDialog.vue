<template>
  <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60">
    <div class="bg-zinc-900 rounded-lg p-4 w-80">
      <h3 class="text-lg font-semibold mb-2">{{ title }}</h3>
      <p class="text-gray-400 mb-4">{{ message }}</p>
      <div class="flex justify-end gap-2">
        <button @click="$emit('cancel')" class="px-3 py-1 rounded bg-zinc-700 hover:bg-zinc-600">{{ cancelText }}</button>
        <button @click="$emit('confirm')" class="px-3 py-1 rounded bg-red-700 hover:bg-red-600 text-white">{{ confirmText }}</button>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  show: { type: Boolean, default: false },
  title: { type: String, default: 'Confirmation' },
  message: { type: String, default: 'Are you sure?' },
  confirmText: { type: String, default: 'Delete' },
  cancelText: { type: String, default: 'Cancel' }
})
defineEmits(['confirm', 'cancel'])
</script>
