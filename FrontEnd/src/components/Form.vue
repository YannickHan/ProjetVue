<script setup>
import { ref } from 'vue'
import { login } from "../store/auth";
import { useRouter } from "vue-router";

defineProps(['type'])

const email = ref("");
const password = ref("");
const router = useRouter();

const handleLogin = async () => {
  try {
    await login(email.value, password.value);
    const pending = JSON.parse(localStorage.getItem('pendingRedirect'));
    if (pending) {
      localStorage.removeItem('pendingRedirect');
      router.push({
        path: "/webplayer",
        query: pending
      });
    } else {
      router.push("/webplayer");
    }
  } catch (e) {
    alert(e.message || "Login failed");
  }
};
</script>

<template>
    <div v-if="type === 'contact'">
        <form action="POST" class="bg-white rounded-4xl p-10 m-4 text-black h-[45rem] flex flex-col justify-start">
            <h1 class="text-2xl font-bold mb-4">Contact Us</h1>
            <label for="first-name" class="block text-sm font-medium text-gray-700">First Name:</label>
            <input type="text" id="first-name" name="first-name" required class="border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            <label for="last-name" class="block text-sm font-medium text-gray-700">Last Name:</label>
            <input type="text" id="last-name" name="last-name" required class="border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            <label for="email" class="block text-sm font-medium text-gray-700">Email:</label>
            <input type="email" id="email" name="email" required class="border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500">
            <label for="message" class="block text-sm font-medium text-gray-700">Message:</label>
            <textarea id="message" name="message" required class="border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-2 focus:ring-blue-500 h-full resize-none"></textarea>
            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-md mt-4">Send</button>
        </form>
    </div>

    <div v-else-if="type === 'login'" class="flex justify-center h-auto">
      <form action="POST" @submit.prevent="handleLogin" class="p-6 text-black w-[24rem] flex flex-col justify-start">
        <label for="email" class="block text-lg font-bold text-white">Email</label>
        <input v-model="email" type="email" id="email" name="email" required class="border border-white rounded-md py-2 px-3 focus:outline-none focus:ring-5 focus:ring-[#1e8e12] text-white">
        <label for="password" class="block text-lg font-bold text-white mt-4">Password</label>
        <input v-model="password" type="password" id="password" name="password" required class="border border-white rounded-md py-2 px-3 focus:outline-none focus:ring-5 focus:ring-[#1e8e12] text-white">
        <button type="submit" class="bg-[#23a517] hover:bg-[#1e8e12] text-black font-bold py-2 px-4 rounded-3xl mt-4 cursor-pointer">Login</button>
        <p class="text-white m-4 text-center">----- Or -----</p>
        <button type="button" class="bg-[#1877f2] hover:bg-[#0a66c2] text-white font-bold py-2 px-4 rounded-3xl mt-2 cursor-pointer">Sign in with Facebook</button>
        <button type="button" class="bg-[#ea4335] hover:bg-[#d33425] text-white font-bold py-2 px-4 rounded-3xl mt-2 cursor-pointer">Sign in with Google</button>
        <button type="button" class="bg-[#333333] hover:bg-[#1a1a1a] text-white font-bold py-2 px-4 rounded-3xl mt-2 cursor-pointer">Sign in with Apple</button>
        <button type="button" class="bg-[#5865f2] hover:bg-[#4752c4] text-white font-bold py-2 px-4 rounded-3xl mt-2 cursor-pointer">Sign in with Discord</button>
        <button type="submit" class="bg-[#1a1a1a] hover:bg-[#3a3a3a] text-white font-bold py-2 px-4 rounded-3xl mt-4 cursor-pointer">Sign Up</button>
      </form>
    </div>

    <div v-else>
        <p>none</p>
    </div>
</template>