<script setup>
import NavBar from './components/NavBar.vue'
import Footer from './components/Footer.vue'

import { ref, onMounted } from 'vue'

const message = ref('Loading...')

onMounted(async () => {
  const response = await fetch('/api/data')
  const data = await response.json()
  message.value = data.message
})
</script>

<template>
  <NavBar />
  <main class="pt-15">
    <RouterView />
  </main>
  <Footer />
</template> 