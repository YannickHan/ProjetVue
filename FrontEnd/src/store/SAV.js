import { reactive } from "vue";
import * as SAVServices from "../services/SAVServices";

export const getSAVRequests = async () => {
    const data = await SAVServices.getSAVRequests();
    const returnData = data.map(req => ({
        id: req.idSAV,
        messageSAV: req.messageSAV,
        adminNoteSAV: req.adminNoteSAV,
        status: req.stateSAV === 0 ? "pending" : req.stateSAV === 1 ? "in progress" : "done",
        user: {
            firstNameSAV: req.firstNameSAV,
            lastNameSAV: req.lastNameSAV,
            emailSAV: req.emailSAV,
        }
    }));
    return returnData;
}

export const sendSAVRequest = async (message, firstName, lastName, email) => {
    const data = await SAVServices.sendSAVRequest(message, firstName, lastName, email);
    return data;
}

export const updateSAVStatus = async (idSAV, status) => {
    const data = await SAVServices.updateSAVStatus(idSAV, status);
    return data;
}

export const updateSAVAdminNote = async (idSAV, adminNote) => {
    const data = await SAVServices.updateSAVAdminNote(idSAV, adminNote);
    return data;
}