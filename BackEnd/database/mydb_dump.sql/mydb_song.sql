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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-22  0:14:49
