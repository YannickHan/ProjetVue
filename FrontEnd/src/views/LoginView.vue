<script setup>
import { useRouter } from 'vue-router'
import Form from '../components/Form.vue'

const handleLoginSuccess = () => {
  const pending = JSON.parse(localStorage.getItem('pendingRedirect'))

  if (pending) {
    localStorage.removeItem('pendingRedirect')
    router.push({
      path: '/webplayer',
      query: pending
    })
  } else {
    router.push('/webplayer')
  }
}
</script>

<template>
    <div class="animated-gradient rounded-4xl m-4 p-10 text-white h-[9rem] flex flex-col justify-center items-center">
        <h1 class="text-7xl font-bold mb-4">UNLEASH YOUR POTENTIAL</h1>
    </div>
    <h1 class="text-5xl font-bold m-15 text-center">WELCOME BACK !</h1>
    <Form type="login" @success="handleLoginSuccess"/>
</template>