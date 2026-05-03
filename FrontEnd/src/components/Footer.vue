<script setup>
  import { RouterLink } from 'vue-router'

  const scrollToTop = () => {
    window.scrollTo({ top: 0 })
  }
</script>
<template>
  <footer class="mt-4 sm:mt-10 border-t border-[#282828] bg-black px-2 sm:px-5 pb-3 sm:pb-5 pt-4 sm:pt-10 text-[#b3b3b3]">
    <div class="mx-auto mb-4 sm:mb-10 grid gap-4 sm:gap-10 grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 max-w-[1200px]">
      <div>
        <h4 class="mb-2 sm:mb-4 text-xs sm:text-sm font-semibold uppercase tracking-[0.5px] text-white">Company</h4>
        <ul class="list-none p-0">
          <li class="mb-1 sm:mb-2.5"><router-link to="/about" class="text-xs sm:text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" @click="scrollToTop">About</router-link></li>
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">Jobs</p></li>
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">For the Record</p></li>
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">Communities</p></li>
        </ul>
      </div>

      <div>
        <h4 class="mb-2 sm:mb-4 text-xs sm:text-sm font-semibold uppercase tracking-[0.5px] text-white">Artists</h4>
        <ul class="list-none p-0">
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">Develop</p></li>
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">Advertising</p></li>
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">Investors</p></li>
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">Vendors</p></li>
        </ul>
      </div>

      <div>
        <h4 class="mb-2 sm:mb-4 text-xs sm:text-sm font-semibold uppercase tracking-[0.5px] text-white">Links</h4>
        <ul class="list-none p-0">
          <li class="mb-1 sm:mb-2.5"><router-link to="/Support" class="text-xs sm:text-sm text-[#b3b3b3] no-underline transition-colors duration-300 hover:text-white" @click="scrollToTop">Support</router-link></li>
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">Twitter</p></li>
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">Instagram</p></li>
          <li class="mb-1 sm:mb-2.5"><p class="text-xs sm:text-sm text-[#b3b3b3]">Facebook</p></li>
        </ul>
      </div>
    </div>

    <div class="mx-auto max-w-[1200px] border-t border-[#282828] pt-3 sm:pt-5">
      <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-5">
        <p class="m-0 text-xs text-[#b3b3b3]">&copy; 2025 Phantom Waves. All rights reserved.</p>
        <ul class="flex list-none flex-wrap gap-2 sm:gap-5 p-0">
          <li class="m-0"><p class="text-xs text-[#b3b3b3]">Privacy Policy</p></li>
          <li class="m-0"><p class="text-xs text-[#b3b3b3]">Terms of Service</p></li>
          <li class="m-0"><p class="text-xs text-[#b3b3b3]">Cookie Settings</p></li>
        </ul>
      </div>
    </div>
  </footer>
</template>
