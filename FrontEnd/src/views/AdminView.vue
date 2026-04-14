<template>
  <div>
    <h2>Dashboard</h2>
    <button @click="handleLogout">Logout</button>
  </div>
</template>

<script setup>
import { logout } from "../store/auth";
import { useRouter } from "vue-router";

const router = useRouter();

const handleLogout = () => {
  logout();
  router.push("/");
};
</script>