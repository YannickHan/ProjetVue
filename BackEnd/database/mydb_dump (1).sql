CREATE DATABASE  IF NOT EXISTS `mydb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `mydb`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: mydb
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `album`
--

DROP TABLE IF EXISTS `album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `album` (
  `idAlbum` int NOT NULL AUTO_INCREMENT,
  `titleAlbum` varchar(45) NOT NULL,
  `releaseAlbum` date DEFAULT NULL,
  `coverAlbum` blob,
  PRIMARY KEY (`idAlbum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album`
--

LOCK TABLES `album` WRITE;
/*!40000 ALTER TABLE `album` DISABLE KEYS */;
/*!40000 ALTER TABLE `album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `albumhasgenre`
--

DROP TABLE IF EXISTS `albumhasgenre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `albumhasgenre` (
  `Album_idAlbum` int NOT NULL,
  `Genre_idGenre` int NOT NULL,
  PRIMARY KEY (`Album_idAlbum`,`Genre_idGenre`),
  KEY `fk_AlbumHasGenre_Genre_idx` (`Genre_idGenre`),
  KEY `fk_AlbumHasGenre_Album_idx` (`Album_idAlbum`),
  CONSTRAINT `fk_AlbumHasGenre_Album` FOREIGN KEY (`Album_idAlbum`) REFERENCES `album` (`idAlbum`),
  CONSTRAINT `fk_AlbumHasGenre_Genre` FOREIGN KEY (`Genre_idGenre`) REFERENCES `genre` (`idGenre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `albumhasgenre`
--

LOCK TABLES `albumhasgenre` WRITE;
/*!40000 ALTER TABLE `albumhasgenre` DISABLE KEYS */;
/*!40000 ALTER TABLE `albumhasgenre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artist`
--

DROP TABLE IF EXISTS `artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist` (
  `idArtist` int NOT NULL AUTO_INCREMENT,
  `nameArtist` varchar(45) NOT NULL,
  `highlightedArtist` tinyint(1) NOT NULL,
  `horizontalBannerArtist` blob,
  `verticalBannerArtist` blob,
  `profileArtist` blob,
  PRIMARY KEY (`idArtist`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist`
--

LOCK TABLES `artist` WRITE;
/*!40000 ALTER TABLE `artist` DISABLE KEYS */;
INSERT INTO `artist` VALUES (1,'Ado',0,NULL,NULL,NULL),(2,'Joji',0,NULL,NULL,NULL),(3,'Harry Styles',0,NULL,NULL,NULL),(4,'Steve Lacy',0,NULL,NULL,NULL),(5,'Sam Smith',0,NULL,NULL,NULL),(6,'The Weeknd',0,NULL,NULL,NULL),(7,'Glass Animals',0,NULL,NULL,NULL),(8,'Mark Ronson',0,NULL,NULL,NULL),(9,'Dua Lipa',0,NULL,NULL,NULL),(10,'Justin Bieber',1,NULL,NULL,NULL),(11,'Olivia Rodrigo',0,NULL,NULL,NULL),(12,'Nicky Youre',0,NULL,NULL,NULL),(13,'Taylor Swift',1,NULL,NULL,NULL),(14,'Ed Sheeran',0,NULL,NULL,NULL),(15,'Doja Cat',1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artisthasalbum`
--

DROP TABLE IF EXISTS `artisthasalbum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artisthasalbum` (
  `Artist_idArtist` int NOT NULL,
  `Album_idAlbum` int NOT NULL,
  PRIMARY KEY (`Artist_idArtist`,`Album_idAlbum`),
  KEY `fk_ArtistHasAlbum_Album_idx` (`Album_idAlbum`),
  KEY `fk_ArtistHasAlbum_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_ArtistHasAlbum_Album` FOREIGN KEY (`Album_idAlbum`) REFERENCES `album` (`idAlbum`),
  CONSTRAINT `fk_ArtistHasAlbum_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artisthasalbum`
--

LOCK TABLES `artisthasalbum` WRITE;
/*!40000 ALTER TABLE `artisthasalbum` DISABLE KEYS */;
/*!40000 ALTER TABLE `artisthasalbum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artisthasgenre`
--

DROP TABLE IF EXISTS `artisthasgenre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artisthasgenre` (
  `Artist_idArtist` int NOT NULL,
  `Genre_idGenre` int NOT NULL,
  PRIMARY KEY (`Artist_idArtist`,`Genre_idGenre`),
  KEY `fk_ArtistHasGenre_Genre_idx` (`Genre_idGenre`),
  KEY `fk_ArtistHasGenre_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_ArtistHasGenre_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`),
  CONSTRAINT `fk_ArtistHasGenre_Genre` FOREIGN KEY (`Genre_idGenre`) REFERENCES `genre` (`idGenre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artisthasgenre`
--

LOCK TABLES `artisthasgenre` WRITE;
/*!40000 ALTER TABLE `artisthasgenre` DISABLE KEYS */;
/*!40000 ALTER TABLE `artisthasgenre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artisthassong`
--

DROP TABLE IF EXISTS `artisthassong`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artisthassong` (
  `Artist_idArtist` int NOT NULL,
  `Song_idSong` int NOT NULL,
  PRIMARY KEY (`Artist_idArtist`,`Song_idSong`),
  KEY `fk_ArtistHasSong_Song_idx` (`Song_idSong`),
  KEY `fk_ArtistHasSong_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_ArtistHasSong_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`),
  CONSTRAINT `fk_ArtistHasSong_Song` FOREIGN KEY (`Song_idSong`) REFERENCES `song` (`idSong`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artisthassong`
--

LOCK TABLES `artisthassong` WRITE;
/*!40000 ALTER TABLE `artisthassong` DISABLE KEYS */;
INSERT INTO `artisthassong` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11),(12,12),(13,13),(14,14),(6,15),(15,16);
/*!40000 ALTER TABLE `artisthassong` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artisthasspeciality`
--

DROP TABLE IF EXISTS `artisthasspeciality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artisthasspeciality` (
  `Artist_idArtist` int NOT NULL,
  `Speciality_idSpeciality` int NOT NULL,
  PRIMARY KEY (`Artist_idArtist`,`Speciality_idSpeciality`),
  KEY `fk_ArtistHasSpeciality_Speciality_idx` (`Speciality_idSpeciality`),
  KEY `fk_ArtistHasSpeciality_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_ArtistHasSpeciality_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`),
  CONSTRAINT `fk_ArtistHasSpeciality_Speciality` FOREIGN KEY (`Speciality_idSpeciality`) REFERENCES `speciality` (`idSpeciality`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artisthasspeciality`
--

LOCK TABLES `artisthasspeciality` WRITE;
/*!40000 ALTER TABLE `artisthasspeciality` DISABLE KEYS */;
/*!40000 ALTER TABLE `artisthasspeciality` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `idGenre` int NOT NULL AUTO_INCREMENT,
  `nameGenre` varchar(45) NOT NULL,
  PRIMARY KEY (`idGenre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genrehasplaylist`
--

DROP TABLE IF EXISTS `genrehasplaylist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genrehasplaylist` (
  `Genre_idGenre` int NOT NULL,
  `Playlist_idPlaylist` int NOT NULL,
  PRIMARY KEY (`Genre_idGenre`,`Playlist_idPlaylist`),
  KEY `fk_GenreHasPlaylist_Playlist_idx` (`Playlist_idPlaylist`),
  KEY `fk_GenreHasPlaylist_Genre_idx` (`Genre_idGenre`),
  CONSTRAINT `fk_GenreHasPlaylist_Genre` FOREIGN KEY (`Genre_idGenre`) REFERENCES `genre` (`idGenre`),
  CONSTRAINT `fk_GenreHasPlaylist_Playlist` FOREIGN KEY (`Playlist_idPlaylist`) REFERENCES `playlist` (`idPlaylist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genrehasplaylist`
--

LOCK TABLES `genrehasplaylist` WRITE;
/*!40000 ALTER TABLE `genrehasplaylist` DISABLE KEYS */;
/*!40000 ALTER TABLE `genrehasplaylist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genrehassong`
--

DROP TABLE IF EXISTS `genrehassong`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genrehassong` (
  `Genre_idGenre` int NOT NULL,
  `Song_idSong` int NOT NULL,
  PRIMARY KEY (`Genre_idGenre`,`Song_idSong`),
  KEY `fk_GenreHasSong_Song_idx` (`Song_idSong`),
  KEY `fk_GenreHasSong_Genre_idx` (`Genre_idGenre`),
  CONSTRAINT `fk_GenreHasSong_Genre` FOREIGN KEY (`Genre_idGenre`) REFERENCES `genre` (`idGenre`),
  CONSTRAINT `fk_GenreHasSong_Song` FOREIGN KEY (`Song_idSong`) REFERENCES `song` (`idSong`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genrehassong`
--

LOCK TABLES `genrehassong` WRITE;
/*!40000 ALTER TABLE `genrehassong` DISABLE KEYS */;
/*!40000 ALTER TABLE `genrehassong` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist`
--

DROP TABLE IF EXISTS `playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist` (
  `idPlaylist` int NOT NULL AUTO_INCREMENT,
  `namePlaylist` varchar(45) NOT NULL,
  `datePlaylist` date NOT NULL,
  `highlightedPlaylist` tinyint(1) NOT NULL,
  `User_idUser` int DEFAULT NULL,
  PRIMARY KEY (`idPlaylist`),
  KEY `fk_Playlist_User_idx` (`User_idUser`),
  CONSTRAINT `fk_Playlist_User` FOREIGN KEY (`User_idUser`) REFERENCES `user` (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist`
--

LOCK TABLES `playlist` WRITE;
/*!40000 ALTER TABLE `playlist` DISABLE KEYS */;
INSERT INTO `playlist` VALUES (1,'Liked','2026-04-20',0,1),(2,'Liked','2026-04-20',0,2);
/*!40000 ALTER TABLE `playlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_Playlist_BeforeInsert` BEFORE INSERT ON `playlist` FOR EACH ROW BEGIN
    IF NEW.namePlaylist = 'Liked' AND (
        SELECT COUNT(*) FROM `Playlist`
        WHERE User_idUser = NEW.User_idUser
        AND namePlaylist = 'Liked'
    ) > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cet utilisateur possède déjà une playlist Liked.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `playlisthassong`
--

DROP TABLE IF EXISTS `playlisthassong`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlisthassong` (
  `Playlist_idPlaylist` int NOT NULL,
  `Song_idSong` int NOT NULL,
  `trackPosition` int NOT NULL,
  PRIMARY KEY (`Playlist_idPlaylist`,`Song_idSong`),
  KEY `fk_PlaylistHasSong_Song_idx` (`Song_idSong`),
  KEY `fk_PlaylistHasSong_Playlist_idx` (`Playlist_idPlaylist`),
  CONSTRAINT `fk_PlaylistHasSong_Playlist` FOREIGN KEY (`Playlist_idPlaylist`) REFERENCES `playlist` (`idPlaylist`),
  CONSTRAINT `fk_PlaylistHasSong_Song` FOREIGN KEY (`Song_idSong`) REFERENCES `song` (`idSong`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlisthassong`
--

LOCK TABLES `playlisthassong` WRITE;
/*!40000 ALTER TABLE `playlisthassong` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlisthassong` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sav`
--

DROP TABLE IF EXISTS `sav`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sav` (
  `idSAV` int NOT NULL AUTO_INCREMENT,
  `messageSAV` varchar(1000) DEFAULT NULL,
  `firstNameSAV` varchar(45) DEFAULT NULL,
  `lastNameSAV` varchar(45) DEFAULT NULL,
  `mailSAV` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idSAV`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sav`
--

LOCK TABLES `sav` WRITE;
/*!40000 ALTER TABLE `sav` DISABLE KEYS */;
/*!40000 ALTER TABLE `sav` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialmediaartist`
--

DROP TABLE IF EXISTS `socialmediaartist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `socialmediaartist` (
  `idSocialMediaArtist` int NOT NULL AUTO_INCREMENT,
  `linkSocialMedia` varchar(255) NOT NULL,
  `Artist_idArtist` int NOT NULL,
  PRIMARY KEY (`idSocialMediaArtist`),
  KEY `fk_SocialMediaArtist_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_SocialMediaArtist_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialmediaartist`
--

LOCK TABLES `socialmediaartist` WRITE;
/*!40000 ALTER TABLE `socialmediaartist` DISABLE KEYS */;
/*!40000 ALTER TABLE `socialmediaartist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song` (
  `idSong` int NOT NULL AUTO_INCREMENT,
  `titleSong` varchar(45) NOT NULL,
  `releaseSong` date NOT NULL,
  `durationSong` time NOT NULL,
  `coverSong` varchar(500) DEFAULT NULL,
  `highlightedSong` tinyint(1) NOT NULL,
  `Album_idAlbum` int DEFAULT NULL,
  `pathSong` varchar(255) NOT NULL,
  PRIMARY KEY (`idSong`),
  KEY `fk_Song_Album_idx` (`Album_idAlbum`),
  CONSTRAINT `fk_Song_Album` FOREIGN KEY (`Album_idAlbum`) REFERENCES `album` (`idAlbum`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'Mirror','2022-01-01','03:45:00','https://m.media-amazon.com/images/I/81yRZl5LtRL.jpg',1,NULL,'music/mirror.mp3'),(2,'Glimpse of Us','2022-06-10','03:53:00','https://m.media-amazon.com/images/I/81lqJcDPfZL.jpg',1,NULL,'music/glimpse-of-us.mp3'),(3,'As It Was','2022-04-01','02:47:00','https://m.media-amazon.com/images/I/61RyXmXm5fL.jpg',1,NULL,'music/as-it-was.mp3'),(4,'Bad Habit','2022-07-29','03:52:00','https://m.media-amazon.com/images/I/81gt2TIexbL.jpg',0,NULL,'music/bad-habit.mp3'),(5,'Unholy','2022-09-22','02:36:00','https://m.media-amazon.com/images/I/61aZhNW9Q0L.jpg',1,NULL,'music/unholy.mp3'),(6,'Blinding Lights','2020-11-29','03:20:00','https://m.media-amazon.com/images/I/717Ypd1t7IL.jpg',1,NULL,'music/blinding-lights.mp3'),(7,'Heat Waves','2020-06-29','03:58:00','https://m.media-amazon.com/images/I/81vMxIyDZ9L.jpg',0,NULL,'music/heat-waves.mp3'),(8,'Uptown Funk','2014-11-10','04:30:00','https://m.media-amazon.com/images/I/71AZUM4CY1L.jpg',0,NULL,'music/uptown-funk.mp3'),(9,'Levitating','2020-10-01','03:23:00','https://m.media-amazon.com/images/I/81dhBdiI4+L.jpg',1,NULL,'music/levitating.mp3'),(10,'Peaches','2021-03-19','03:18:00','https://m.media-amazon.com/images/I/81lleqz5QXL.jpg',0,NULL,'music/peaches.mp3'),(11,'Good 4 U','2021-05-14','02:58:00','https://m.media-amazon.com/images/I/61fin73zyhL.jpg',0,NULL,'music/good-4-u.mp3'),(12,'Sunroof','2022-01-21','02:52:00','https://m.media-amazon.com/images/I/71DdC823BZL.jpg',0,NULL,'music/sunroof.mp3'),(13,'Anti-Hero','2022-10-21','03:21:00','https://m.media-amazon.com/images/I/81sD+kAZAFL.jpg',1,NULL,'music/anti-hero.mp3'),(14,'Shape of You','2017-01-06','03:53:00','https://m.media-amazon.com/images/I/B1TlPSY5bKS.jpg',0,NULL,'music/shape-of-you.mp3'),(15,'Starboy','2016-09-22','03:50:00','https://m.media-amazon.com/images/I/71fIuxvP+FL.jpg',0,NULL,'music/starboy.mp3'),(16,'Kiss Me More','2021-04-09','03:28:00','https://m.media-amazon.com/images/I/71xVNFRJBsL.jpg',1,NULL,'music/kiss-me-more.mp3');
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `speciality`
--

DROP TABLE IF EXISTS `speciality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `speciality` (
  `idSpeciality` int NOT NULL AUTO_INCREMENT,
  `nameSpeciality` varchar(45) NOT NULL,
  PRIMARY KEY (`idSpeciality`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `speciality`
--

LOCK TABLES `speciality` WRITE;
/*!40000 ALTER TABLE `speciality` DISABLE KEYS */;
/*!40000 ALTER TABLE `speciality` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `idUser` int NOT NULL AUTO_INCREMENT,
  `nameUser` varchar(45) DEFAULT NULL,
  `mailUser` varchar(45) NOT NULL,
  `profilePictureUser` blob,
  `passwordUser` varchar(255) NOT NULL,
  `adminUser` tinyint(1) NOT NULL,
  PRIMARY KEY (`idUser`),
  UNIQUE KEY `unique_mail` (`mailUser`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Admin','admin@phantomwaves.com',NULL,'$12$8POvDZ9DcFgArdiGHEuXweg4nWpJP0369eJeZ00MqyIsjxHnT1hBe',1),(2,'User','user@user.com',NULL,'$2b$10$5wPzQ7XJYNfvI3bRYHjALOSv6c9F2GhTFi4sSgAQKWqXg3rG/8.PG',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_User_AfterInsert` AFTER INSERT ON `user` FOR EACH ROW BEGIN
    INSERT INTO `Playlist` (`namePlaylist`, `datePlaylist`, `highlightedPlaylist`, `User_idUser`)
    VALUES ('Liked', CURDATE(), 0, NEW.idUser);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'mydb'
--

--
-- Dumping routines for database 'mydb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-22  0:13:42
