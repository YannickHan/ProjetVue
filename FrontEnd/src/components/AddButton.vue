<script setup>
import { ref } from 'vue'
import { addSong, addArtist } from '../store/Song';
import { getArtists } from '../services/SongServices';

const props = defineProps({
  type: {
    type: String,
    required: true,
  },
})

const openPanel = ref(false)

// ----------------------------This handle the panel ----------------------------
const open = () => {
  openPanel.value = true
}

const artists = ref([]);

const loadArtists = async () => {
  try {
    artists.value = await getArtists();
  } catch (err) {
    console.error('Failed to load artists:', err);
    artists.value = [];
  }
}

const close = () => {
  openPanel.value = false
}

const handleSubmitSong = async (event) => {
  event.preventDefault();
  const formData = new FormData(event.target);
  const songData = {
    title: formData.get('title'),
    releaseDate: formData.get('releaseDate'),
    duration: formData.get('duration'),
    artist: formData.get('artist'),
      mp3Url: formData.get('mp3Url'),
    coverUrl: formData.get('coverUrl'),
  };
  try {
      console.log('Submitting song:', songData);
      await addSong(songData);
      alert('✅ Song added successfully!');
    close();
  } catch (error) {
    console.error('Error adding song:', error);
      const errorMessage = error.message || 'Failed to add song. Please try again.';
      alert(`❌ Error: ${errorMessage}`);
  }
};

const handleSubmitArtist = async (event) => {
  event.preventDefault();
  const formData = new FormData(event.target);
  const artistData = {
    name: formData.get('name'),
    horizontalBanner: formData.get('horizontalBanner'),
    verticalBanner: formData.get('verticalBanner'),
    profileAvatar: formData.get('profileAvatar'),
  };
  try {
      console.log('Submitting artist:', artistData);
      await addArtist(artistData);
      alert('✅ Artist added successfully!');
    close();
  } catch (error) {
    console.error('Error adding artist:', error);
      const errorMessage = error.message || 'Failed to add artist. Please try again.';
      alert(`❌ Error: ${errorMessage}`);
  }
};
</script>

<template>
  <button class="px-4 py-3 text-lg text-white rounded-full bg-green-500/80 hover:bg-green-500 hover:scale-[1.02]" @click="open"> 
    {{ props.type === 'artistList' ? 'Add an artist' : 'Add a song' }}
  </button>
  <div v-if="openPanel" class="fixed inset-0 backdrop-blur-sm flex items-center justify-center z-50">
    <div v-if="props.type === 'songCatalog'" class="w-full max-w-2xl rounded-2xl border border-white/5 bg-black/90 p-6 relative">
      <h1 class="text-xl font-bold mb-6">Add a new song</h1>
        <form @submit.prevent="handleSubmitSong" class="space-y-4">
        <div>
          <label class="block text-sm text-white/70 mb-1">Title</label>
          <input type="text" name="title" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
        </div>
        <div>
          <label class="block text-sm text-white/70 mb-1">Release Date</label>
          <input type="text" name="releaseDate" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
        </div>
        <div>
          <label class="block text-sm text-white/70 mb-1">Duration</label>
          <input type="text" name="duration" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
        </div>
        <div>
          <label class="block text-sm text-white/70 mb-1">Artist</label>
          <select name="artist" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500" @focus="loadArtists">
            <option value="" disabled selected>Select an artist</option>
            <option v-for="a in artists" :key="a.idArtist" :value="a.nameArtist">{{ a.nameArtist }}</option>
          </select>
        </div>
        <div>
          <label class="block text-sm text-white/70 mb-1">MP3 URL</label>
          <input type="text" name="mp3Url" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
        </div>
        <div>
          <label class="block text-sm text-white/70 mb-1">Cover image URL</label>
          <input type="text" name="coverUrl" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
        </div>
        <div class="flex justify-end gap-3 pt-4">
          <button type="button" @click="close"class="px-4 py-2 text-sm rounded-xl bg-white/10 hover:bg-white/20 transition"> Cancel </button>
          <button type="submit" class="px-5 py-2 text-sm rounded-xl bg-green-600 hover:bg-green-500 transition cursor-pointer"> Save </button>
        </div>
      </form>
    </div>
    <div v-else-if="props.type === 'artistList'" class="w-full max-w-2xl rounded-2xl border border-white/5 bg-black/90 p-6 relative">
      <h1 class="text-xl font-bold mb-6">Add a new artist</h1>
        <form @submit.prevent="handleSubmitArtist" class="space-y-4">
        <div>
          <label class="block text-sm text-white/70 mb-1">Stage name</label>
          <input type="text" name="name" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
        </div>
        <div>
          <label class="block text-sm text-white/70 mb-1">Horizontal banner URL</label>
          <input type="text" name="horizontalBanner" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
        </div>
        <div>
          <label class="block text-sm text-white/70 mb-1">Vertical banner URL</label>
          <input type="text" name="verticalBanner" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
        </div>
        <div>
          <label class="block text-sm text-white/70 mb-1">Profile avatar URL</label>
          <input type="text" name="profileAvatar" required class="text-lg w-full bg-white/5 border border-white/20 rounded-xl px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-green-500"/>
        </div>
        <div class="flex justify-end gap-3 pt-4">
          <button type="button" @click="close" class="px-4 py-2 text-sm rounded-xl bg-white/10 hover:bg-white/20 transition"> Cancel </button>
          <button type="submit" class="px-5 py-2 text-sm rounded-xl bg-green-600 hover:bg-green-500 transition cursor-pointer"> Save </button>
        </div>
      </form>
    </div>
  </div>
</template>
              