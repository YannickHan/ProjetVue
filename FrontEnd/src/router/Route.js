import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/HomeView.vue'
import About from '../views/AboutView.vue'
import Support from '../views/SupportView.vue'
import Login from '../views/LoginView.vue'
import Admin from '../views/AdminView.vue'
import WebPlayer from '../views/WebPlayerView.vue'
import { authState } from "../store/auth";

const routes = [
  { path: '/', name: 'home', component: Home },
  { path: '/about', name: 'about', component: About },
  { path: '/support', name: 'support', component: Support },
  { path: '/login', name: 'login', component: Login },
  { path: '/admin', name: 'admin', component: Admin, meta: { requiresAuth: true, requiresAdmin: true } },
  { path: '/webplayer', name: 'music', component: WebPlayer, meta: { requiresAuth: true } },
  // { path: '/webplayer', name: 'music', component: WebPlayer },
  // { path: '/admin', name: 'admin', component: Admin},
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !authState.isAuthenticated) {
    next('/login');
    return;
  }

  if (to.meta.requiresAdmin && authState.user?.role !== 'admin') {
    next('/');
    return;
  }

  next();
});

export default router