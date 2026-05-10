<template>
  <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60">
    <div class="bg-zinc-900 rounded-lg p-4 w-80">
      <h3 class="text-lg font-semibold mb-2">Create a playlist</h3>
      <input v-model="name" placeholder="Name" class="w-full mb-2 p-2 rounded bg-zinc-800 text-white" />
      <input v-model="cover" placeholder="Image URL (optional)" class="w-full mb-3 p-2 rounded bg-zinc-800 text-white" />
      <div class="flex justify-end gap-2">
        <button @click="$emit('cancel')" class="px-3 py-1 rounded bg-zinc-700">Cancel</button>
        <button @click="handleCreate" class="px-3 py-1 rounded bg-emerald-700 text-white">Create</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  show: { type: Boolean, default: false }
})
const emit = defineEmits(['create', 'cancel'])

const name = ref('')
const cover = ref('')

watch(() => props.show, (v) => {
  if (!v) {
    name.value = ''
    cover.value = ''
  }
})

const handleCreate = () => {
  if (!name.value) return alert('Name is required')
  emit('create', { name: name.value, cover: cover.value || null })
}
</script>
