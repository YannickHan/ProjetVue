import { reactive } from "vue";
import * as authService from "../services/authService";

export const authState = reactive({
  user: null,
  token: authService.getToken(),
  isAuthenticated: !!authService.getToken(),
});

export const login = async (email, password) => {
  const data = await authService.login(email, password);

  authState.user = data.user;
  authState.token = data.token;
  authState.isAuthenticated = true;
};

export const logout = () => {
  authService.logout();

  authState.user = null;
  authState.token = null;
  authState.isAuthenticated = false;
};