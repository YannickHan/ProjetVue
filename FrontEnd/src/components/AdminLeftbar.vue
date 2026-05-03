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
    <div class="bg-black rounded-4xl p-10 text-white flex flex-col justify-start overflow-y-auto">
        <h1 class="text-3xl font-bold mb-4">Welcome back, Admin !</h1>
            <button
                :class="['p-2 pl-10 rounded-lg cursor-pointer font-bold text-left text-lg', activeView === 'dashboard' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                @click="selectView('dashboard')"
            >
                Dashboard
            </button>
            <button
                :class="['p-2 pl-10 rounded-lg cursor-pointer font-bold text-left text-lg', activeView === 'musicList' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                @click="selectView('musicList')"
            >
                Song Catalog
            </button>
            <button
                :class="['p-2 pl-10 rounded-lg cursor-pointer font-bold text-left text-lg', activeView === 'artistList' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                @click="selectView('artistList')"
            >
                Artist List
            </button>
                
    </div>
</template>