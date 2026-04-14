<script setup>
  import { RouterLink } from 'vue-router'

  const scrollToTop = () => {
    window.scrollTo({ top: 0 })
  }
</script>
<template>
  <footer class="mt-10 border-t border-[#282828] bg-black px-5 pb-5 pt-10 text-[#b3b3b3]">
    <div class="mx-auto mb-10 grid max-w-[1200px] gap-10 md:grid-cols-2 lg:grid-cols-3">
      <div>
        <h4 class="mb-4 text-sm font-semibold uppercase tracking-[0.5px] text-white">Company</h4>
        <ul class="list-none p-0">
          <li class="mb-2.5"><router-link to="/about" class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" @click="scrollToTop">About</router-link></li>
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#" @click.prevent="scrollToTop">Jobs</a></li>
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">For the Record</a></li>
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Communities</a></li>
        </ul>
      </div>

      <div>
        <h4 class="mb-4 text-sm font-semibold uppercase tracking-[0.5px] text-white">Artists</h4>
        <ul class="list-none p-0">
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Develop</a></li>
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Advertising</a></li>
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Investors</a></li>
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Vendors</a></li>
        </ul>
      </div>

      <div>
        <h4 class="mb-4 text-sm font-semibold uppercase tracking-[0.5px] text-white">Links</h4>
        <ul class="list-none p-0">
          <li class="mb-2.5"><router-link to="/Support" class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" @click="scrollToTop">Support</router-link></li>
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Twitter</a></li>
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Instagram</a></li>
          <li class="mb-2.5"><a class="text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Facebook</a></li>
        </ul>
      </div>
    </div>

    <div class="mx-auto max-w-[1200px] border-t border-[#282828] pt-5">
      <div class="flex flex-wrap items-center justify-between gap-5 max-md:flex-col max-md:items-start">
        <p class="m-0 text-xs text-[#b3b3b3]">&copy; 2025 Phantom Waves. All rights reserved.</p>
        <ul class="flex list-none flex-wrap gap-5 p-0 max-sm:flex-col max-sm:gap-2.5">
          <li class="m-0"><a class="text-xs text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Privacy Policy</a></li>
          <li class="m-0"><a class="text-xs text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Terms of Service</a></li>
          <li class="m-0"><a class="text-xs text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" href="#">Cookie Settings</a></li>
        </ul>
      </div>
    </div>
  </footer>
</template>
