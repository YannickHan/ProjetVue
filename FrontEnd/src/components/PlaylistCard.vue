<script setup>
defineProps(['name', 'cover', 'artists', 'nbTracks', 'id'])
const emit = defineEmits(['click'])
</script>

<template>
    <article @click="emit('click')" class="group w-[170px] shrink-0 [direction:ltr] cursor-pointer overflow-hidden rounded-[18px] border border-white/10 bg-slate-950/75 p-3 shadow-lg shadow-black/20 transition duration-300 hover:-translate-y-1 hover:border-emerald-400/30 hover:bg-slate-900/90">
        <div class="relative overflow-hidden rounded-2xl bg-white/5">
            <img :src="cover" alt="Cover Image" class="h-24 w-full object-cover transition duration-500 group-hover:scale-105 sm:h-28">
            <div class="absolute inset-0 bg-gradient-to-t from-black/40 via-transparent to-transparent"></div>
        </div>
        <div class="mt-2 space-y-1">
            <p class="truncate text-sm font-semibold">{{ name }}</p>
            <p class="line-clamp-2 text-xs text-white/60" break-words>{{ artists }} et bien plus</p>
            <p class="text-xs uppercase tracking-[0.22em] text-white/40">{{ nbTracks }}</p>
        </div>
    </article>
</template>