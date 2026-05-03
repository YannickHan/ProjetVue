CREATE DATABASE IF NOT EXISTS `mydb`;
USE `mydb`;

-- ========================================
-- DROP ALL TABLES (Child tables first, then parent tables)
-- ========================================
DROP TABLE IF EXISTS `playlisthassong`;
DROP TABLE IF EXISTS `artisthassong`;
DROP TABLE IF EXISTS `playlist`;
DROP TABLE IF EXISTS `song`;
DROP TABLE IF EXISTS `artist`;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `sav`;

-- ========================================
-- CREATE ALL TABLES
-- ========================================

CREATE TABLE `artist` (
  `idArtist` int NOT NULL AUTO_INCREMENT,
  `nameArtist` varchar(45) NOT NULL,
  `highlightedArtist` tinyint(1) NOT NULL,
  `horizontalBannerArtist` varchar(255) DEFAULT NULL,
  `verticalBannerArtist` varchar(255) DEFAULT NULL,
  `profileArtist` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idArtist`)
) ENGINE=InnoDB;

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
  `pathSong` varchar(255) NOT NULL,
  PRIMARY KEY (`idSong`)
) ENGINE=InnoDB;

CREATE TABLE `playlist` (
  `idPlaylist` int NOT NULL AUTO_INCREMENT,
  `namePlaylist` varchar(45) NOT NULL,
  `highlightedPlaylist` tinyint(1) NOT NULL,
  `User_idUser` int DEFAULT NULL,
  PRIMARY KEY (`idPlaylist`),
  KEY `fk_Playlist_User_idx` (`User_idUser`),
  CONSTRAINT `fk_Playlist_User`
    FOREIGN KEY (`User_idUser`) REFERENCES `user` (`idUser`)
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

CREATE TABLE `artisthassong` (
  `Artist_idArtist` int NOT NULL,
  `Song_idSong` int NOT NULL,
  PRIMARY KEY (`Artist_idArtist`,`Song_idSong`),
  KEY `fk_ArtistHasSong_Song_idx` (`Song_idSong`),
  KEY `fk_ArtistHasSong_Artist_idx` (`Artist_idArtist`),
  CONSTRAINT `fk_ArtistHasSong_Artist`
    FOREIGN KEY (`Artist_idArtist`) REFERENCES `artist` (`idArtist`),
  CONSTRAINT `fk_ArtistHasSong_Song`
    FOREIGN KEY (`Song_idSong`) REFERENCES `song` (`idSong`)
) ENGINE=InnoDB;

CREATE TABLE `playlisthassong` (
  `Playlist_idPlaylist` int NOT NULL,
  `Song_idSong` int NOT NULL,
  `trackPosition` int NOT NULL,
  PRIMARY KEY (`Playlist_idPlaylist`,`Song_idSong`),
  KEY `fk_PlaylistHasSong_Song_idx` (`Song_idSong`),
  KEY `fk_PlaylistHasSong_Playlist_idx` (`Playlist_idPlaylist`),
  CONSTRAINT `fk_PlaylistHasSong_Playlist`
    FOREIGN KEY (`Playlist_idPlaylist`) REFERENCES `playlist` (`idPlaylist`),
  CONSTRAINT `fk_PlaylistHasSong_Song`
    FOREIGN KEY (`Song_idSong`) REFERENCES `song` (`idSong`)
) ENGINE=InnoDB;

-- ========================================
-- CREATE TRIGGERS
-- ========================================

-- Empêche un utilisateur d'avoir plusieurs playlists "Liked"
DELIMITER ;;
CREATE TRIGGER `trg_Playlist_BeforeInsert`
BEFORE INSERT ON `playlist`
FOR EACH ROW
BEGIN
    IF NEW.namePlaylist = 'Liked' AND (
        SELECT COUNT(*) FROM `playlist`
        WHERE User_idUser = NEW.User_idUser
          AND namePlaylist = 'Liked'
    ) > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cet utilisateur possède déjà une playlist Liked.';
    END IF;
END;;
DELIMITER ;

-- Crée automatiquement une playlist "Liked" à la création d'un utilisateur
DELIMITER ;;
CREATE TRIGGER `trg_User_AfterInsert`
AFTER INSERT ON `user`
FOR EACH ROW
BEGIN
    INSERT INTO `playlist` (`namePlaylist`, `highlightedPlaylist`, `User_idUser`)
    VALUES ('Liked', 0, NEW.idUser);
END;;
DELIMITER ;