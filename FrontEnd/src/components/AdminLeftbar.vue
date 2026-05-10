<script setup>
defineProps({
    activeView: {
        type: String,
        default: 'dashboard',
    },
});

const emit = defineEmits(['change-view']);

const selectView = (view) => {
    emit('change-view', view);
};
</script>

<template>
    <div class="flex h-full flex-col overflow-hidden rounded-[28px] border border-white/10 bg-black/95 p-4 text-white shadow-2xl shadow-black/30 backdrop-blur-xl sm:p-5">
        <div class="mb-5 flex items-start justify-between gap-4 border-b border-white/10 pb-4">
            <div>
                <p class="text-[11px] uppercase tracking-[0.35em] text-white/45">Phantom Waves</p>
                <h1 class="mt-1 text-xl font-semibold sm:text-2xl">Admin Panel</h1>
            </div>
            <button class="rounded-full border border-white/10 bg-white/5 px-3 py-2 text-xs font-semibold text-white/70 sm:hidden" @click="selectView('music')">Home</button>
        </div>

        <nav class="space-y-2">
            <button :class="['flex w-full items-center gap-3 rounded-2xl px-4 py-3 text-left transition cursor-pointer', activeView === 'dashboard' ? 'bg-gray-200 text-slate-950 shadow-lg shadow-black/20' : 'bg-white/5 text-white/85 hover:bg-white/10']" @click="selectView('dashboard')">
                <span class="text-lg">✦</span>
                <span class="font-medium">Dashboard</span>
            </button>
            <button :class="['flex w-full items-center gap-3 rounded-2xl px-4 py-3 text-left transition cursor-pointer', activeView === 'musicList' ? 'bg-gray-200 text-slate-950 shadow-lg shadow-black/20' : 'bg-white/5 text-white/85 hover:bg-white/10']" @click="selectView('musicList')">
                <span class="text-lg">✦</span>
                <span class="font-medium">Songs</span>
            </button>
            <button :class="['flex w-full items-center gap-3 rounded-2xl px-4 py-3 text-left transition cursor-pointer', activeView === 'artistList' ? 'bg-gray-200 text-slate-950 shadow-lg shadow-black/20' : 'bg-white/5 text-white/85 hover:bg-white/10']" @click="selectView('artistList')">
                <span class="text-lg">✦</span>
                <span class="font-medium">Artists</span>
            </button>
        </nav>
    </div>
</template>