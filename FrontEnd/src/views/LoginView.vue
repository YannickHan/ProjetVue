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
 <div class="animated-gradient rounded-4xl m-4 p-6 sm:p-10 text-white min-h-[9rem] flex flex-col justify-center items-center overflow-hidden">
        <h1 class="text-[clamp(1.5rem,8vw,4.5rem)] font-bold mb-4 text-center break-words leading-tight">UNLEASH YOUR POTENTIAL</h1>
    </div>
    <h1 class="text-[clamp(1.5rem,6vw,3rem)] font-bold m-6 sm:m-10 md:m-15 text-center">WELCOME BACK !</h1>
    <Form type="login" @success="handleLoginSuccess"/>
</template>