<script setup>
import { computed } from 'vue'
import { RouterLink } from 'vue-router'
import { useRouter } from 'vue-router'
import { authState, logout } from '../store/auth';

const isAuthenticated = computed(() => authState.isAuthenticated);
const userRole = computed(() => authState.user?.role || '');
const router = useRouter();

const handleLogout = () => {
  logout();
  router.push('/');
};

const scrollToTop = () => {
    window.scrollTo({ top: 0 })
  }
</script>

<template>
  <nav class="fixed top-0 left-0 w-full z-50 bg-black grid grid-cols-[0.5fr_1fr_1fr_0.3fr] text-center font-bold">
        <router-link to="/" class="text-white duration-300 hover:bg-white hover:text-black flex justify-center items-center" @click="scrollToTop"><img src="/Logo2.png" alt="Logo" class="h-14"></router-link>
        <router-link v-if="userRole === 'admin'" to="/admin" class="text-white duration-300 hover:bg-white hover:text-black p-4" @click="scrollToTop">Admin</router-link>
        <p v-else></p>
        <router-link v-if="isAuthenticated" to="/webplayer" class="text-white duration-300 hover:bg-white hover:text-black p-4" @click="scrollToTop">WebPlayer</router-link>
        <p v-else></p>
        <router-link v-if="!isAuthenticated" to="/login" class="text-white duration-300 hover:bg-white hover:text-black p-4" @click="scrollToTop">Login</router-link>
        <button v-else @click="handleLogout" class="text-white duration-300 hover:bg-white hover:text-black p-4 cursor-pointer">Logout</button>
    </nav>
</template>