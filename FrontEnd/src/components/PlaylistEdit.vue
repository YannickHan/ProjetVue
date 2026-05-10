<template>
  <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center bg-black/60">
    <div class="bg-zinc-900 rounded-lg p-4 w-80">
      <h3 class="text-lg font-semibold mb-3">Edit playlist</h3>
      <input v-model="editName" placeholder="Name" class="w-full mb-2 p-2 rounded bg-zinc-800 text-white" />
      <input v-model="editCover" placeholder="Image URL" class="w-full mb-3 p-2 rounded bg-zinc-800 text-white" />
      <div v-if="editCover" class="mb-2">
        <img :src="editCover" class="w-full h-40 object-cover rounded" />
      </div>
      <div class="flex justify-end gap-2">
        <button @click="$emit('cancel')" class="px-3 py-1 rounded bg-zinc-700">Cancel</button>
        <button @click="handleSave" class="px-3 py-1 rounded bg-blue-700 text-white">Save</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  show: { type: Boolean, default: false },
  initialName: { type: String, default: '' },
  initialCover: { type: String, default: '' }
})
const emit = defineEmits(['save', 'cancel'])

const editName = ref('')
const editCover = ref('')

watch(() => props.show, (v) => {
  if (v) {
    editName.value = props.initialName || ''
    editCover.value = props.initialCover || ''
  }
})

const handleSave = () => {
  if (!editName.value) return alert('Name is required')
  emit('save', { name: editName.value, cover: editCover.value || null })
}
</script>
