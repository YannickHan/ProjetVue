<script setup>
import { ref, computed , onMounted} from 'vue'
import { getSAVRequests, updateSAVAdminNote, updateSAVStatus } from '../store/SAV';

const requests = ref([]);

const fetchRequests = async () => {
  try {
    const data = await getSAVRequests();
    requests.value = data;
  } catch (error) {
    console.error("Error fetching SAV requests:", error);
  }
};

onMounted(async () => {
  await fetchRequests();
});

const selectedPanel = ref(null)
const editing = ref(false)

const editForm = ref({
  adminNote: ''
})

const statuses = ['pending', 'in progress', 'done']

const statusClass = (status) => ({
  'bg-yellow-500/10 text-yellow-300 border-yellow-500/20': status === 'pending',
  'bg-blue-500/10 text-blue-300 border-blue-500/20': status === 'in progress',
  'bg-green-500/10 text-green-300 border-green-500/20': status === 'done'
})

const previewMessage = (message, maxLength = 20) => {
  if (!message) return ''
  return message.length > maxLength ? `${message.slice(0, maxLength)}...` : message
}

// ----------------------------This handle the categories ----------------------------
const unresolvedRequests = computed(() =>
  requests.value.filter(r => r.status !== 'done')
)

const resolvedRequests = computed(() =>
  requests.value.filter(r => r.status === 'done')
)

// ----------------------------This handle the panel ----------------------------
const openPanel = (req) => {
  selectedPanel.value = req
  editing.value = false
  editForm.value.adminNote = req.adminNoteSAV || ''
  originalStatus.value = req.status
  statusChanged.value = false
}

const closePanel = () => {
  selectedPanel.value = null
  editing.value = false
}

// ----------------------------This handle the modifications ----------------------------
const statusChanged = ref(false)
const originalStatus = ref(null)

const updateStatus = (status) => {
  if (!selectedPanel.value) return
  const index = requests.value.findIndex(r => r.id === selectedPanel.value.id)
  if (index === -1) return

  // Update local state optimistically
  requests.value[index].status = status
  selectedPanel.value.status = status
  statusChanged.value = status !== originalStatus.value

  // Persist to database
  updateSAVStatus(selectedPanel.value.id, status)
    .catch(e => {
      alert('❌ Failed to update status: ' + (e.message || 'Unknown error'))
      // Revert optimistic update on error
      requests.value[index].status = originalStatus.value
      selectedPanel.value.status = originalStatus.value
      statusChanged.value = false
      console.error(e)
    })
}

const saveEdit = async () => {
  if (!selectedPanel.value) return
  try {
    await updateSAVAdminNote(selectedPanel.value.id, editForm.value.adminNote)
  } catch (e) {
    alert(e.message || 'Failed to save admin note')
    console.error(e)
    return
  }

  const index = requests.value.findIndex(r => r.id === selectedPanel.value.id)
  if (index === -1) return
  requests.value[index].adminNoteSAV = editForm.value.adminNote
  selectedPanel.value.adminNoteSAV = editForm.value.adminNote
  editing.value = false
  statusChanged.value = false
  originalStatus.value = selectedPanel.value.status
}
</script>

<template>
  <div class="text-white p-6 space-y-10">
    <header>
      <h1 class="text-3xl font-bold">Requests Dashboard</h1>
      <p class="mt-1 text-base text-white/50">Support & ticket management</p>
    </header>
    <section>
      <h2 class="text-lg font-semibold mb-4">Unresolved</h2>
      <div class="grid md:grid-cols-2 gap-4">
        <div v-for="req in unresolvedRequests" :key="req.id"
          @click="openPanel(req)"
          class="p-4 rounded-xl border border-white/10 bg-white/5 hover:bg-white/10 hover:scale-[1.01] transition cursor-pointer"
        >
          <div class="flex justify-between items-start gap-2">
            <h3 class="font-semibold text-sm flex-1 truncate"> {{ previewMessage(req.messageSAV, 20) }} </h3>
            <span class="text-[10px] px-2 py-1 rounded-full border uppercase" :class="statusClass(req.status)"> {{ req.status }} </span>
          </div>
          <div class="mt-2 flex items-center justify-between text-xs">
            <span class="text-white/70"> {{ req.user.firstNameSAV }} {{ req.user.lastNameSAV }} </span>
            <span class="text-white/30"> {{ req.user.emailSAV }} </span>
          </div>
        </div>
      </div>
    </section>

    <section>
      <h2 class="text-lg font-semibold mb-4">History</h2>
      <div class="grid md:grid-cols-2 gap-4">
        <div v-for="req in resolvedRequests" :key="req.id"
          @click="openPanel(req)"
          class="p-4 rounded-xl border border-white/10 bg-white/5 hover:bg-white/10 hover:scale-[1.01] transition cursor-pointer"
        >
          <div class="flex justify-between items-start gap-2">
            <h3 class="font-semibold text-sm flex-1 truncate"> {{ previewMessage(req.messageSAV, 20) }} </h3>
            <span class="text-[10px] px-2 py-1 rounded-full border uppercase" :class="statusClass(req.status)"> {{ req.status }} </span>
          </div>
          <div class="mt-2 flex items-center justify-between text-xs">
            <span class="text-white/70"> {{ req.user.firstNameSAV }} {{ req.user.lastNameSAV }} </span>
            <span class="text-white/30"> {{ req.user.emailSAV }} </span>
          </div>
        </div>
      </div>
    </section>
  </div>

  <div v-if="selectedPanel" class="fixed inset-0 backdrop-blur-sm flex items-center justify-center z-50" @click="closePanel">
    <div class="w-full max-w-4xl rounded-2xl border border-white/5 bg-black/80 p-6 relative" @click.stop>
      <button class="absolute top-5 right-5 text-white/50 hover:text-white text-xl" @click="closePanel"> ✕ </button>
      <div class="flex justify-between items-start pr-6">
        <h2 class="text-xl font-bold">{{ previewMessage(selectedPanel.messageSAV, 40) }}</h2>
        <div class="flex gap-2 flex-wrap">
          <button v-for="s in statuses" :key="s" @click="updateStatus(s)"
            class="text-[10px] px-2 py-1 rounded-full border uppercase cursor-pointer"
            :class="[
              selectedPanel.status === s
                ? 'bg-white text-black border-white'
                : 'bg-white/5 text-white/70 border-white/5 hover:bg-white/20'
            ]"
          > 
          {{ s }}
          </button>
        </div>
      </div>
      <div class="mt-4 p-4 rounded-xl bg-white/5 border border-white/5 text-sm text-white"> {{ selectedPanel.messageSAV }} </div>
      <div class="mt-4">
        <textarea v-if="editing" v-model="editForm.adminNote" class="w-full h-40 p-3 bg-white/10 rounded-lg border border-white/5 text-sm"></textarea>
        <p v-else class="text-sm text-green-500"> {{ selectedPanel.adminNoteSAV || 'No admin note' }} </p>
      </div>
      <div class="flex justify-end gap-2 mt-4">
        <button class="px-3 py-1 text-xs bg-white/10 border border-white/10 rounded-xl hover:bg-white/20 cursor-pointer" @click="editing = !editing">
          {{ editing ? 'Cancel' : 'Edit note' }}
        </button>
        <button v-if="editing" class="px-3 py-1 text-xs bg-green-500/80 hover:bg-green-500 rounded-xl" @click="saveEdit"> Save </button>
      </div>
    </div>
  </div>
</template>