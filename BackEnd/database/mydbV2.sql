CREATE DATABASE IF NOT EXISTS `mydb`;
USE `mydb`;

-- ========================================
-- DROP ALL TABLES (Child tables first, then parent tables)
-- ========================================

-- Drop junction/child tables first (no other tables depend on them)
DROP TABLE IF EXISTS `playlisthassong`;
DROP TABLE IF EXISTS `genrehassong`;
DROP TABLE IF EXISTS `genrehasplaylist`;
DROP TABLE IF EXISTS `artisthassong`;
DROP TABLE IF EXISTS `artisthasspeciality`;
DROP TABLE IF EXISTS `artisthasgenre`;
DROP TABLE IF EXISTS `artisthasalbum`;
DROP TABLE IF EXISTS `albumhasgenre`;
DROP TABLE IF EXISTS `socialmediaartist`;

-- Drop parent tables (after all child tables are gone)
DROP TABLE IF EXISTS `playlist`;
DROP TABLE IF EXISTS `song`;
DROP TABLE IF EXISTS `album`;
DROP TABLE IF EXISTS `artist`;
DROP TABLE IF EXISTS `genre`;
DROP TABLE IF EXISTS `speciality`;
DROP TABLE IF EXISTS `user`;

-- Drop independent tables
DROP TABLE IF EXISTS `sav`;

-- ========================================
-- CREATE ALL TABLES
-- ========================================

CREATE TABLE `album` (
  `idAlbum` int NOT NULL AUTO_INCREMENT,
  `titleAlbum` varchar(45) NOT NULL,
  `releaseAlbum` date DEFAULT NULL,
  `coverAlbum` blob,
  PRIMARY KEY (`idAlbum`)
) ENGINE=InnoDB;

CREATE TABLE `genre` (
  `idGenre` int NOT NULL AUTO_INCREMENT,
  `nameGenre` varchar(45) NOT NULL,
  PRIMARY KEY (`idGenre`)
) ENGINE=InnoDB;

CREATE TABLE `speciality` (
  `idSpeciality` int NOT NULL AUTO_INCREMENT,
  `nameSpeciality` varchar(45) NOT NULL,
  PRIMARY KEY (`idSpeciality`)
) ENGINE=InnoDB;

CREATE TABLE `artist` (
  `idArtist` int NOT NULL AUTO_INCREMENT,
  `nameArtist` varchar(45) NOT NULL,
  `highlightedArtist` tinyint(1) NOT NULL,
  `horizontalBannerArtist` varchar(255) DEFAULT NULL,
  `verticalBannerArtist` varchar(255) DEFAULT NULL,
  `profileArtist` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idArtist`)
) ENGINE=InnoDB AUTO_INCREMENT=16;

CREATE TABLE `user` (
  `idUser` int NOT NULL AUTO_INCREMENT,
  `nameUser` varchar(45) DEFAULT NULL,
  `mailUser` varchar(45) NOT NULL,
  `profilePictureUser` blob,
  `passwordUser` varchar(255) NOT NULL,
  `adminUser` tinyint(1) NOT NULL,
  PRIMARY KEY (`idUser`),
  UNIQUE KEY `unique_mail` (`mailUser`)
) ENGINE=InnoDB;

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
) ENGINE=InnoDB AUTO_INCREMENT=17;

CREATE TABLE `playlist` (
  `idPlaylist` int NOT NULL AUTO_INCREMENT,
  `namePlaylist` varchar(45) NOT NULL,
  `datePlaylist` date NOT NULL,
  `highlightedPlaylist` tinyint(1) NOT NULL,
  `User_idUser` int DEFAULT NULL,
  PRIMARY KEY (`idPlaylist`),
  KEY `fk_Playlist_User_idx` (`User_idUser`),
  CONSTRAINT `fk_Playlist_User` FOREIGN KEY (`User_idUser`) REFERENCES `user` (`idUser`)
) ENGINE=InnoDB;

CREATE TABLE `sav` (
  `idSAV` int NOT NULL AUTO_INCREMENT,
  `messageSAV` varchar(1000) DEFAULT NULL,
  `firstNameSAV` varchar(45) DEFAULT NULL,
  `lastNameSAV` varchar(45) DEFAULT NULL,
  `mailSAV` varchar(45) DEFAULT NULL,
  `adminNoteSAV` varchar(1000) DEFAULT NULL,
  `stateSAV` tinyint(1) NOT NULL DEFAULT 0,
  `dateSAV` date NOT NULL,
  PRIMARY KEY (`idSAV`)
) ENGINE=InnoDB;

CREATE TABLE `albumhasgenre` (
  `Album_idAlbum` int NOT NULL,
  `Genre_idGenre` int NOT NULL,
  PRIMARY KEY (`Album_idAlbum`,`Genre_idGenre`),
  KEY `fk_AlbumHasGenre_Genre_idx` (`Genre_idGenre`),
  KEY `fk_AlbumHasGenre_Album_idx` (`Album_idAlbum`),
  CONSTRAINT `fk_AlbumHasGenre_Album` FOREIGN KEY (`Album_idAlbum`) REFERENCES `album` (`idAlbum`),
  CONSTRAINT `fk_AlbumHasGenre_Genre` FOREIGN KEY (`Genre_idGenre`) REFERENCES `genre` (`idGenre`)
) ENGINE=InnoDB;

CREATE TABLE `artisthasalbum` (
  `Artist_idArtist` int NOT NULL,
  `Album_idAlbum` int NOT NULL,
  PRIMARY KEY (`Artist_idArtist`,`Album_idAlbum`),
  KEY `fk_ArtistHasAlbum_Album_idx` (`Album_idAlbum`),
  KEY `fk_ArtistHasAlbum_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_ArtistHasAlbum_Album` FOREIGN KEY (`Album_idAlbum`) REFERENCES `album` (`idAlbum`),
  CONSTRAINT `fk_ArtistHasAlbum_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`)
) ENGINE=InnoDB;

CREATE TABLE `artisthasgenre` (
  `Artist_idArtist` int NOT NULL,
  `Genre_idGenre` int NOT NULL,
  PRIMARY KEY (`Artist_idArtist`,`Genre_idGenre`),
  KEY `fk_ArtistHasGenre_Genre_idx` (`Genre_idGenre`),
  KEY `fk_ArtistHasGenre_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_ArtistHasGenre_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`),
  CONSTRAINT `fk_ArtistHasGenre_Genre` FOREIGN KEY (`Genre_idGenre`) REFERENCES `genre` (`idGenre`)
) ENGINE=InnoDB;

CREATE TABLE `artisthassong` (
  `Artist_idArtist` int NOT NULL,
  `Song_idSong` int NOT NULL,
  PRIMARY KEY (`Artist_idArtist`,`Song_idSong`),
  KEY `fk_ArtistHasSong_Song_idx` (`Song_idSong`),
  KEY `fk_ArtistHasSong_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_ArtistHasSong_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`),
  CONSTRAINT `fk_ArtistHasSong_Song` FOREIGN KEY (`Song_idSong`) REFERENCES `song` (`idSong`)
) ENGINE=InnoDB;

CREATE TABLE `artisthasspeciality` (
  `Artist_idArtist` int NOT NULL,
  `Speciality_idSpeciality` int NOT NULL,
  PRIMARY KEY (`Artist_idArtist`,`Speciality_idSpeciality`),
  KEY `fk_ArtistHasSpeciality_Speciality_idx` (`Speciality_idSpeciality`),
  KEY `fk_ArtistHasSpeciality_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_ArtistHasSpeciality_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`),
  CONSTRAINT `fk_ArtistHasSpeciality_Speciality` FOREIGN KEY (`Speciality_idSpeciality`) REFERENCES `speciality` (`idSpeciality`)
) ENGINE=InnoDB;

CREATE TABLE `genrehasplaylist` (
  `Genre_idGenre` int NOT NULL,
  `Playlist_idPlaylist` int NOT NULL,
  PRIMARY KEY (`Genre_idGenre`,`Playlist_idPlaylist`),
  KEY `fk_GenreHasPlaylist_Playlist_idx` (`Playlist_idPlaylist`),
  KEY `fk_GenreHasPlaylist_Genre_idx` (`Genre_idGenre`),
  CONSTRAINT `fk_GenreHasPlaylist_Genre` FOREIGN KEY (`Genre_idGenre`) REFERENCES `genre` (`idGenre`),
  CONSTRAINT `fk_GenreHasPlaylist_Playlist` FOREIGN KEY (`Playlist_idPlaylist`) REFERENCES `playlist` (`idPlaylist`)
) ENGINE=InnoDB;

CREATE TABLE `genrehassong` (
  `Genre_idGenre` int NOT NULL,
  `Song_idSong` int NOT NULL,
  PRIMARY KEY (`Genre_idGenre`,`Song_idSong`),
  KEY `fk_GenreHasSong_Song_idx` (`Song_idSong`),
  KEY `fk_GenreHasSong_Genre_idx` (`Genre_idGenre`),
  CONSTRAINT `fk_GenreHasSong_Genre` FOREIGN KEY (`Genre_idGenre`) REFERENCES `genre` (`idGenre`),
  CONSTRAINT `fk_GenreHasSong_Song` FOREIGN KEY (`Song_idSong`) REFERENCES `song` (`idSong`)
) ENGINE=InnoDB;

CREATE TABLE `playlisthassong` (
  `Playlist_idPlaylist` int NOT NULL,
  `Song_idSong` int NOT NULL,
  `trackPosition` int NOT NULL,
  PRIMARY KEY (`Playlist_idPlaylist`,`Song_idSong`),
  KEY `fk_PlaylistHasSong_Song_idx` (`Song_idSong`),
  KEY `fk_PlaylistHasSong_Playlist_idx` (`Playlist_idPlaylist`),
  CONSTRAINT `fk_PlaylistHasSong_Playlist` FOREIGN KEY (`Playlist_idPlaylist`) REFERENCES `playlist` (`idPlaylist`),
  CONSTRAINT `fk_PlaylistHasSong_Song` FOREIGN KEY (`Song_idSong`) REFERENCES `song` (`idSong`)
) ENGINE=InnoDB;

CREATE TABLE `socialmediaartist` (
  `idSocialMediaArtist` int NOT NULL AUTO_INCREMENT,
  `linkSocialMedia` varchar(255) NOT NULL,
  `Artist_idArtist` int NOT NULL,
  PRIMARY KEY (`idSocialMediaArtist`),
  KEY `fk_SocialMediaArtist_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_SocialMediaArtist_Artist` FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`)
) ENGINE=InnoDB;

-- ========================================
-- CREATE TRIGGERS
-- ========================================

DELIMITER ;;
CREATE TRIGGER `trg_Playlist_BeforeInsert` BEFORE INSERT ON `playlist` FOR EACH ROW BEGIN
    IF NEW.namePlaylist = 'Liked' AND (
        SELECT COUNT(*) FROM `Playlist`
        WHERE User_idUser = NEW.User_idUser
        AND namePlaylist = 'Liked'
    ) > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cet utilisateur possède déjà une playlist Liked.';
    END IF;
END;;
DELIMITER ;

DELIMITER ;;
CREATE TRIGGER `trg_User_AfterInsert` AFTER INSERT ON `user` FOR EACH ROW BEGIN
    INSERT INTO `Playlist` (`namePlaylist`, `datePlaylist`, `highlightedPlaylist`, `User_idUser`)
    VALUES ('Liked', CURDATE(), 0, NEW.idUser);
END;;
DELIMITER ;