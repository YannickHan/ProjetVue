import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router/Route' // adapte le chemin selon où tu mets le fichier

createApp(App).use(router).mount('#app')
