import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router/Route' // adjust the path depending on where you put the file

createApp(App).use(router).mount('#app')
