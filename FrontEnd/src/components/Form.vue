<script setup>
import { ref } from 'vue'
import { login, register } from "../store/auth";
import { useRouter } from "vue-router";
import { sendSAVRequest } from '../store/SAV';


defineProps(['type'])

const email = ref("");
const password = ref("");
const signupEmail = ref("");
const signupUsername = ref("");
const signupPassword = ref("");
const showSignupModal = ref(false);
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

const openSignupModal = () => {
  showSignupModal.value = true;
};

const closeSignupModal = () => {
  showSignupModal.value = false;
};

const handleSignup = async () => {
  try {
    await register(signupUsername.value, signupEmail.value, signupPassword.value);
    alert("Inscription réussie");
    closeSignupModal();
  } catch (e) {
    alert(e.message || "Registration failed");
  }
};

const handleContactSubmit = async (e) => {
  e.preventDefault();
  const formData = new FormData(e.target);
  const message = formData.get('message');
  const firstName = formData.get('first-name');
  const lastName = formData.get('last-name');
  const email = formData.get('email');

  try {
    await sendSAVRequest(message, firstName, lastName, email);
    alert("SAV request submitted successfully");
    e.target.reset();
  } catch (e) {
    alert(e.message || "Failed to submit SAV request");
  }
};
</script>

<template>
    <div v-if="type === 'contact'">
        <form @submit="handleContactSubmit" class="bg-white rounded-4xl p-10 m-4 text-black h-[45rem] flex flex-col justify-start">
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
        <button type="button" @click="openSignupModal" class="bg-[#1a1a1a] hover:bg-[#3a3a3a] text-white font-bold py-2 px-4 rounded-3xl mt-4 cursor-pointer">Sign Up</button>
      </form>

      <div
        v-if="showSignupModal"
        @click.self="closeSignupModal"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm px-4"
      >
        <div class="w-full max-w-md rounded-3xl bg-white p-6 text-black shadow-2xl">
          <div class="mb-4 flex items-center justify-between">
            <h2 class="text-2xl font-bold">Create your account</h2>
            <button
              type="button"
              @click="closeSignupModal"
              class="rounded-lg px-3 py-1 text-sm font-bold text-gray-600 hover:bg-gray-100"
            >
              X
            </button>
          </div>

          <form @submit.prevent="handleSignup" class="flex flex-col gap-3">
            <label for="signup-email" class="text-sm font-semibold text-gray-700">Adresse mail</label>
            <input
              id="signup-email"
              v-model="signupEmail"
              type="email"
              required
              class="rounded-xl border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#23a517]"
            >

            <label for="signup-username" class="text-sm font-semibold text-gray-700">Nom d'utilisateur</label>
            <input
              id="signup-username"
              v-model="signupUsername"
              type="text"
              required
              class="rounded-xl border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#23a517]"
            >

            <label for="signup-password" class="text-sm font-semibold text-gray-700">Mot de passe</label>
            <input
              id="signup-password"
              v-model="signupPassword"
              type="password"
              required
              class="rounded-xl border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#23a517]"
            >

            <button
              type="submit"
              class="mt-2 rounded-2xl bg-[#23a517] px-4 py-2 font-bold text-black hover:bg-[#1e8e12]"
            >
              Creer un compte
            </button>
          </form>
        </div>
      </div>
    </div>

    <div v-else>
        <p>none</p>
    </div>
</template>