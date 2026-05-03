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
    <div class="bg-black rounded-2xl sm:rounded-4xl p-3 sm:p-10 text-white flex flex-col justify-start overflow-y-auto lg:h-screen h-auto">
        <h1 class="hidden sm:block text-3xl font-bold mb-4">Welcome back, Admin !</h1>
        <h1 class="sm:hidden text-sm font-bold mb-2">Admin</h1>
            <button
                :class="['p-2 pl-3 sm:pl-10 rounded-lg cursor-pointer font-bold text-left text-sm sm:text-lg', activeView === 'dashboard' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                @click="selectView('dashboard')"
            >
                Dashboard
            </button>
            <button
                :class="['p-2 pl-3 sm:pl-10 rounded-lg cursor-pointer font-bold text-left text-sm sm:text-lg', activeView === 'musicList' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                @click="selectView('musicList')"
            >
                Catalog
            </button>
            <button
                :class="['p-2 pl-3 sm:pl-10 rounded-lg cursor-pointer font-bold text-left text-sm sm:text-lg', activeView === 'artistList' ? 'bg-gray-600' : 'hover:bg-gray-600']"
                @click="selectView('artistList')"
            >
                Artists
            </button>
                
    </div>
</template>