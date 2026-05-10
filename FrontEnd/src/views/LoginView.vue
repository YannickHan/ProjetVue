<script setup>
import Form from '../components/Form.vue'
</script>

<template>
  <div class="relative min-h-screen overflow-hidden bg-black text-white">
    <div class="pointer-events-none absolute inset-0">
      <div class="absolute left-[-6rem] top-[-6rem] h-72 w-72 rounded-full bg-emerald-500/15 blur-3xl"></div>
      <div class="absolute right-[-5rem] top-[18%] h-80 w-80 rounded-full bg-white/8 blur-3xl"></div>
      <div class="absolute bottom-[-7rem] left-[25%] h-96 w-96 rounded-full bg-emerald-400/10 blur-3xl"></div>
    </div>

    <div class="relative z-10 mx-auto grid min-h-screen w-full max-w-7xl grid-cols-1 gap-4 p-3 sm:p-5 lg:grid-cols-[1.05fr_0.95fr] lg:p-6">
      <section class="overflow-hidden rounded-[32px] border border-white/10 bg-gradient-to-br from-white/10 via-black to-black p-6 shadow-2xl shadow-black/50 sm:p-8 lg:p-10">
        <div class="flex h-full flex-col justify-between gap-8">
          <div class="space-y-6">
            <div class="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-4 py-2 text-xs uppercase tracking-[0.35em] text-white/50">
              Phantom Waves
            </div>

            <div class="space-y-4">
              <p class="text-xs uppercase tracking-[0.4em] text-white/40">Stream. Discover. Play.</p>
              <h1 class="max-w-xl text-[clamp(2.4rem,8vw,5.5rem)] font-black leading-[0.92] tracking-tight">
                Sign in and jump back into the music.
              </h1>
              <p class="max-w-xl text-sm leading-7 text-white/65 sm:text-base">
                Go back to your playlists, keep your likes in sync and go straight to your favorite songs.
              </p>
            </div>
          </div>

          <div class="grid gap-3 sm:grid-cols-3">
            <div class="rounded-3xl border border-white/10 bg-white/5 p-4 backdrop-blur-sm">
              <p class="text-xs uppercase tracking-[0.3em] text-white/40">Fast access</p>
              <p class="mt-2 text-sm text-white/75">Return to your queue in one click.</p>
            </div>
            <div class="rounded-3xl border border-white/10 bg-white/5 p-4 backdrop-blur-sm">
              <p class="text-xs uppercase tracking-[0.3em] text-white/40">Your library</p>
              <p class="mt-2 text-sm text-white/75">Save songs in playlists and likes.</p>
            </div>
            <div class="rounded-3xl border border-white/10 bg-white/5 p-4 backdrop-blur-sm">
              <p class="text-xs uppercase tracking-[0.3em] text-white/40">Responsive</p>
              <p class="mt-2 text-sm text-white/75">Built to feel right on every screen.</p>
            </div>
          </div>
        </div>
      </section>

      <section class="flex items-center justify-center rounded-[32px] border border-white/10 bg-black/90 p-4 shadow-2xl shadow-black/50 sm:p-6 lg:p-8">
        <div class="w-full max-w-md">
          <div class="mb-6 rounded-[28px] border border-white/10 bg-white/5 p-5 text-center shadow-lg shadow-black/20">
            <p class="text-xs uppercase tracking-[0.35em] text-white/40">Welcome back</p>
            <h2 class="mt-3 text-3xl font-semibold sm:text-4xl">Login</h2>
            <p class="mt-2 text-sm text-white/60">Use your account to continue where you left off.</p>
          </div>

          <Form type="login" />
        </div>
      </section>
    </div>
  </div>
</template>