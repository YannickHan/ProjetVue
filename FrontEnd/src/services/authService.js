const API_URL = "http://localhost:3000";

export const login = async (email, password) => {
  const res = await fetch(`${API_URL}/api/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ email, password }),
  });

  if (!res.ok) {
    let errorMessage = "Login failed";

    try {
      const errorData = await res.json();
      if (errorData?.message) {
        errorMessage = errorData.message;
      }
    } catch {
    }

    throw new Error(errorMessage);
  }

  const data = await res.json();

  localStorage.setItem("token", data.token);

  return data;
};

export const logout = () => {
  localStorage.removeItem("token");
};

export const getToken = () => {
  return localStorage.getItem("token");
};

// Exemple requête protégée
export const getProfile = async () => {
  const token = getToken();

  const res = await fetch(`${API_URL}/api/profile`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  if (!res.ok) {
    throw new Error("Unauthorized");
  }

  return await res.json();
};