<script setup>
import NavBar from './components/NavBar.vue'
import Footer from './components/Footer.vue'
import { useRoute } from 'vue-router'

import { onMounted } from 'vue'
import { initAuth } from './store/auth'

const route = useRoute()

const showFooter = () => {
  const hiddenRoutes = ['music', 'admin']
  return !hiddenRoutes.includes(route.name)
}

onMounted(async () => {
  await initAuth()
})
</script>

<template>
  <NavBar />
  <main class="pt-15">
    <RouterView />
  </main>
  <Footer v-if="showFooter()" />
</template> 