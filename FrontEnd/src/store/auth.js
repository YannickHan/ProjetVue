import { reactive } from "vue";
import * as authService from "../services/authService";

export const authState = reactive({
  user: authService.getStoredUser(),
  token: authService.getToken(),
  isAuthenticated: !!authService.getToken(),
});

export const login = async (email, password) => {
  const data = await authService.login(email, password);

  authState.user = data.user || null;
  authState.token = data.token;
  authState.isAuthenticated = true;
};

export const register = async (name, email, password) => {
  await authService.register(name, email, password);
}

// L'utilisateur est restauré de manière synchrone depuis localStorage à la création
// de authState, donc initAuth n'a plus besoin de récupérer le profil au démarrage.
export const initAuth = async () => {
  if (!authState.token) {
    logout();
    return;
  }
  // Si le token existe mais qu'on n'a pas le user (ex: ancien storage), purger.
  if (!authState.user) {
    logout();
  }
};

export const fetchProfile = async () => {
  const data = await authService.getProfile();
  authState.user = data.user ?? data;
  authState.isAuthenticated = true;
  return authState.user;
};

export const logout = () => {
  authService.logout();

  authState.user = null;
  authState.token = null;
  authState.isAuthenticated = false;
};