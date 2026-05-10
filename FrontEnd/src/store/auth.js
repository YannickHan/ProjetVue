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

// The user is restored synchronously from localStorage at creation
// of authState, so initAuth no longer needs to fetch the profile at startup.
export const initAuth = async () => {
  if (!authState.token) {
    logout();
    return;
  }
  // If the token exists but we don't have the user (e.g., old storage), clear it.
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