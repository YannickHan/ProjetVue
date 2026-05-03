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
  if (data.user) {
    localStorage.setItem("user", JSON.stringify(data.user));
  }

  return data;
};

export const register = async (name, email, password) => {
  const res = await fetch(`${API_URL}/api/register`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ name, email, password }),
  });

  if (!res.ok) {
    let errorMessage = "Registration failed";

    try {
      const errorData = await res.json();
      if (errorData?.message) {
        errorMessage = errorData.message;
      }
    } catch {
    }

    throw new Error(errorMessage);
  }

  return await res.json();
};

export const logout = () => {
  localStorage.removeItem("token");
  localStorage.removeItem("user");
};

export const getToken = () => {
  return localStorage.getItem("token");
};

export const getStoredUser = () => {
  try {
    const raw = localStorage.getItem("user");
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
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