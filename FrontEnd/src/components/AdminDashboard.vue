<script setup>
import { ref, computed } from 'vue'

const requests = ref([
  {
    id: 1,
    title: "Add song to playlist",
    description: "User wants to add tracks directly from the player to a playlist.",
    user: { firstName: "John", lastName: "Doe", email: "john.doe@user.com" },
    status: "pending",
    type: "playlist",
    priority: "low",
    adminNote: "",
    createdAt: "2026-04-20"
  },
  {
    id: 2,
    title: "Playback stops on lock screen",
    description: "Music stops when the phone locks or app goes background.",
    user: { firstName: "Emma", lastName: "Smith", email: "emma.smith@user.com" },
    status: "in progress",
    type: "player",
    priority: "high",
    adminNote: "Investigating background audio service",
    createdAt: "2026-04-22"
  },
  {
    id: 3,
    title: "Improve player UI responsiveness",
    description: "Lag when skipping tracks or seeking in the timeline.",
    user: { firstName: "Kim Lan", lastName: "TRAN", email: "kimlan.tran@phantomwaves.com" },
    status: "done",
    type: "ui",
    priority: "medium",
    adminNote: "Optimized player state updates",
    createdAt: "2026-04-18"
  },
  {
    id: 4,
    title: "Offline download not working",
    description: "Users cannot download songs for offline listening.",
    user: { firstName: "Alex", lastName: "Martin", email: "alex.martin@user.com" },
    status: "pending",
    type: "offline",
    priority: "high",
    adminNote: "",
    createdAt: "2026-04-23"
  },
  {
    id: 5,
    title: "Search results irrelevant",
    description: "Search returns unrelated tracks for simple queries.",
    user: { firstName: "Sophie", lastName: "Lee", email: "sophie.lee@user.com" },
    status: "in progress",
    type: "search",
    priority: "medium",
    adminNote: "Reworking ranking algorithm",
    createdAt: "2026-04-24"
  },
  {
    id: 6,
    title: "Add equalizer settings",
    description: "Users want bass/treble control in the player.",
    user: { firstName: "David", lastName: "Nguyen", email: "david.nguyen@user.com" },
    status: "pending",
    type: "feature",
    priority: "low",
    adminNote: "",
    createdAt: "2026-04-21"
  },
  {
    id: 7,
    title: "Playlist sync across devices",
    description: "Playlists not updating between mobile and desktop.",
    user: { firstName: "Lina", lastName: "Chen", email: "lina.chen@user.com" },
    status: "pending",
    type: "sync",
    priority: "high",
    adminNote: "",
    createdAt: "2026-04-19"
  },
  {
    id: 8,
    title: "Audio quality drops randomly",
    description: "Stream quality decreases even on stable connection.",
    user: { firstName: "Marco", lastName: "Rossi", email: "marco.rossi@user.com" },
    status: "done",
    type: "streaming",
    priority: "high",
    adminNote: "Fixed adaptive bitrate bug",
    createdAt: "2026-04-17"
  },
  {
    id: 9,
    title: "Lyrics not syncing properly",
    description: "Lyrics are out of sync with playback timeline.",
    user: { firstName: "Nina", lastName: "Kovac", email: "nina.kovac@user.com" },
    status: "in progress",
    type: "lyrics",
    priority: "medium",
    adminNote: "Fixing timestamp mapping",
    createdAt: "2026-04-25"
  },
  {
    id: 10,
    title: "Add mood-based recommendations",
    description: "Suggest songs based on user mood or activity.",
    user: { firstName: "Lucas", lastName: "Moreau", email: "lucas.moreau@user.com" },
    status: "pending",
    type: "recommendation",
    priority: "medium",
    adminNote: "",
    createdAt: "2026-04-26"
  }
])

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
  editForm.value.adminNote = req.adminNote || ''
}

const closePanel = () => {
  selectedPanel.value = null
  editing.value = false
}

// ----------------------------This handle the modifications ----------------------------
const updateStatus = (status) => {
  if (!selectedPanel.value) return
  const index = requests.value.findIndex(r => r.id === selectedPanel.value.id)
  if (index === -1) return
  requests.value[index].status = status
  selectedPanel.value.status = status
}

const saveEdit = () => {
  if (!selectedPanel.value) return
  const index = requests.value.findIndex(r => r.id === selectedPanel.value.id)
  if (index === -1) return
  requests.value[index].adminNote = editForm.value.adminNote
  selectedPanel.value.adminNote = editForm.value.adminNote
  editing.value = false
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
          <div class="flex justify-between">
            <h3 class="font-semibold text-sm"> {{ req.title }} </h3>
            <span class="text-[10px] px-2 py-1 rounded-full border uppercase" :class="statusClass(req.status)"> {{ req.status }} </span>
          </div>
          <div class="mt-2 flex items-center justify-between text-xs">
            <span class="text-white/70"> {{ req.user.firstName }} {{ req.user.lastName }} </span>
            <span class="text-white/30"> {{ req.user.email }} </span>
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
          <div class="flex justify-between">
            <h3 class="font-semibold text-sm"> {{ req.title }} </h3>
            <span class="text-[10px] px-2 py-1 rounded-full border uppercase" :class="statusClass(req.status)"> {{ req.status }} </span>
          </div>
          <div class="mt-2 flex items-center justify-between text-xs">
            <span class="text-white/70"> {{ req.user.firstName }} {{ req.user.lastName }} </span>
            <span class="text-white/30"> {{ req.user.email }} </span>
          </div>
        </div>
      </div>
    </section>
  </div>

  <div v-if="selectedPanel" class="fixed inset-0 backdrop-blur-sm flex items-center justify-center z-50" @click="closePanel">
    <div class="w-full max-w-4xl rounded-2xl border border-white/5 bg-black/80 p-6 relative" @click.stop>
      <button class="absolute top-5 right-5 text-white/50 hover:text-white text-xl" @click="closePanel"> ✕ </button>
      <div class="flex justify-between items-start pr-6">
        <h2 class="text-xl font-bold">{{ selectedPanel.title }}</h2>
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
      <div class="mt-4 p-4 rounded-xl bg-white/5 border border-white/5 text-sm text-white"> {{ selectedPanel.description }} </div>
      <div class="mt-4">
        <textarea v-if="editing" v-model="editForm.adminNote" class="w-full h-40 p-3 bg-white/10 rounded-lg border border-white/5 text-sm"/>
        <p v-else class="text-sm text-green-500"> {{ selectedPanel.adminNote || 'No admin note' }} </p>
      </div>
      <div class="flex justify-end gap-2 mt-4">
        <button class="px-3 py-1 text-xs bg-white/10 border border-white/10 rounded-xl hover:bg-white/20 cursor-pointer" @click="editing = !editing">
          {{ editing ? 'Cancel' : 'Edit note' }}
        </button>
        <button v-if="editing" class="px-3 py-1 text-xs bg-green-500/80 hover:bg-green-500 rounded-xl" @click="saveEdit"> Save </button>
        <button class="px-3 py-1 text-xs bg-green-500/80 hover:bg-green-500 rounded-xl" @click="saveEdit"> Save </button>
      </div>
    </div>
  </div>
</template>