const API_URL = "http://localhost:3000";

export const sendSAVRequest = async (message, firstName, lastName, email) => {
    const res = await fetch(`${API_URL}/api/sav`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({ message, firstName, lastName, email }),
    });
    if (!res.ok) {
        throw new Error("Failed to submit SAV request");
    }
    return await res.json();
};

export const getSAVRequests = async () => {
    const res = await fetch(`${API_URL}/api/sav`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
    });
    if (!res.ok) {
        throw new Error("Failed to fetch SAV requests");
    }
    return await res.json();
};

export const updateSAVStatus = async (idSAV, status) => {
    console.log("Updating SAV status:", idSAV, status);
    const res = await fetch(`${API_URL}/api/sav/${idSAV}/status`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({ status }),
    });
    if (!res.ok) {
        throw new Error("Failed to update SAV status 1");
    }
    return await res.json();
};

export const updateSAVAdminNote = async (idSAV, adminNote) => {
    const res = await fetch(`${API_URL}/api/sav/${idSAV}/adminNote`, {
        method: "PUT",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({ adminNote }),
    });
    if (!res.ok) {
        throw new Error("Failed to update SAV admin note");
    }
    return await res.json();
};
