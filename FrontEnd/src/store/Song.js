import { reactive } from "vue";
import * as songServices from "../services/SongServices";

export const getTrendingArtists = async () => {
    const data = await songServices
.getTrendingArtists();
    return data;
}

export const getTrendingSongs = async () => {
    const data = await songServices
.getTrendingSongs();
    const returnData = data.map(song => ({
        id: song?.idSong ?? song?.id ?? null,
        name: song?.name ?? song?.titleSong ?? '',
        artist: song?.nameArtist ?? 'Unknown artist',
        duration: song?.durationSong ?? '',
        cover: song?.coverSong ?? '',
        path: song?.path ?? song?.pathSong ?? '',
    }));
    // console.log('Fetched trending songs:', returnData);
    return returnData;
}

export const getSongs = async () => {
    const data = await songServices
.getSongs();
    return data;
}

export const getArtists = async () => {
    const data = await songServices
.getArtists();
    return data;
}

export const addSong = async (songData) => {
    try {
        const response = await songServices.addSong(songData);
        return response;
    } catch (error) {
        return error?.response?.data?.message ?? error?.message ?? 'An error occurred';
    }
}

export const addArtist = async (artistData) => {
    try {
        const response = await songServices.addArtist(artistData);
        return response;
    } catch (error) {
        return error?.response?.data?.message ?? error?.message ?? 'An error occurred';
    }
}
