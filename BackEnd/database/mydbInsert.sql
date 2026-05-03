INSERT INTO `artist` VALUES 
(1,'Ado',0,NULL,NULL,NULL),
(2,'Joji',0,NULL,NULL,NULL),
(3,'Harry Styles',0,NULL,NULL,NULL),
(4,'Steve Lacy',0,NULL,NULL,NULL),
(5,'Sam Smith',0,NULL,NULL,NULL),
(6,'The Weeknd',0,NULL,NULL,NULL),
(7,'Glass Animals',0,NULL,NULL,NULL),
(8,'Mark Ronson',0,NULL,NULL,NULL),
(9,'Dua Lipa',0,NULL,NULL,'https://wallpapercat.com/w/small-vertical-retina/a/f/7/106752-1440x2560-mobile-hd-dua-lipa-wallpaper-photo.jpg?id=1644914842'),
(10,'Justin Bieber',1,NULL,NULL,'https://wallpapercat.com/w/full/8/5/2/151041-1366x2048-mobile-hd-justin-bieber-background.jpg'),
(11,'Olivia Rodrigo',0,NULL,NULL,NULL),
(12,'Nicky Youre',0,NULL,NULL,NULL),
(13,'Taylor Swift',1,NULL,NULL,'https://i.pinimg.com/736x/5e/dc/bd/5edcbdc406d790deefc554e5703879b7.jpg'),
(14,'Ed Sheeran',0,NULL,NULL,NULL),
(15,'Doja Cat',1,NULL,NULL,'https://i.pinimg.com/736x/b2/d5/68/b2d5686acf5791074153982e68b0ce43.jpg'),
(16,'DJ Snake',0,NULL,NULL,'https://wallpapercat.com/w/small-vertical-retina/8/4/9/2576255-1333x2000-mobile-hd-dj-snake-wallpaper-image.jpg?id=1662450997'),
(17,'Post Malone',0,NULL,NULL,'https://wallpapercat.com/w/small-vertical-retina/1/7/f/106654-1440x2560-samsung-hd-post-malone-background.jpg?id=1644914818'),
(18,'Lorde',0,NULL,NULL,'https://wallpapercat.com/w/full/9/5/7/2327352-1920x1200-desktop-hd-lorde-wallpaper.jpg'),
(19,'Billie Eilish',0,NULL,NULL,'https://wallpapercat.com/w/small-vertical-retina/f/4/3/11705-1920x2688-phone-hd-billie-eilish-background-photo.jpg?id=1644840023'),
(20,'Sabrina Carpenter',1,NULL,NULL,'https://wallpapercave.com/wp/wp15388514.jpg');

INSERT INTO `song` VALUES
(1,'Mirror','2022-01-01','03:45:00','https://m.media-amazon.com/images/I/81yRZl5LtRL.jpg',1,NULL,'music/mirror.mp3'),
(2,'Glimpse of Us','2022-06-10','03:53:00','https://m.media-amazon.com/images/I/81lqJcDPfZL.jpg',1,NULL,'music/glimpse-of-us.mp3'),
(3,'As It Was','2022-04-01','02:47:00','https://m.media-amazon.com/images/I/61RyXmXm5fL.jpg',1,NULL,'music/as-it-was.mp3'),
(4,'Bad Habit','2022-07-29','03:52:00','https://m.media-amazon.com/images/I/81gt2TIexbL.jpg',0,NULL,'music/bad-habit.mp3'),
(5,'Unholy','2022-09-22','02:36:00','https://m.media-amazon.com/images/I/61aZhNW9Q0L.jpg',1,NULL,'music/unholy.mp3'),
(6,'Blinding Lights','2020-11-29','03:20:00','https://m.media-amazon.com/images/I/717Ypd1t7IL.jpg',1,NULL,'music/blinding-lights.mp3'),
(7,'Heat Waves','2020-06-29','03:58:00','https://m.media-amazon.com/images/I/81vMxIyDZ9L.jpg',0,NULL,'music/heat-waves.mp3'),
(8,'Uptown Funk','2014-11-10','04:30:00','https://m.media-amazon.com/images/I/71AZUM4CY1L.jpg',0,NULL,'music/uptown-funk.mp3'),
(9,'Levitating','2020-10-01','03:23:00','https://m.media-amazon.com/images/I/81dhBdiI4+L.jpg',1,NULL,'music/levitating.mp3'),
(10,'Peaches','2021-03-19','03:18:00','https://m.media-amazon.com/images/I/81lleqz5QXL.jpg',0,NULL,'music/peaches.mp3'),
(11,'Good 4 U','2021-05-14','02:58:00','https://m.media-amazon.com/images/I/61fin73zyhL.jpg',0,NULL,'music/good-4-u.mp3'),
(12,'Sunroof','2022-01-21','02:52:00','https://m.media-amazon.com/images/I/71DdC823BZL.jpg',0,NULL,'music/sunroof.mp3'),
(13,'Anti-Hero','2022-10-21','03:21:00','https://m.media-amazon.com/images/I/81sD+kAZAFL.jpg',1,NULL,'music/anti-hero.mp3'),
(14,'Shape of You','2017-01-06','03:53:00','https://m.media-amazon.com/images/I/B1TlPSY5bKS.jpg',0,NULL,'music/shape-of-you.mp3'),
(15,'Starboy','2016-09-22','03:50:00','https://m.media-amazon.com/images/I/71fIuxvP+FL.jpg',0,NULL,'music/starboy.mp3'),
(16,'Kiss Me More','2021-04-09','03:28:00','https://m.media-amazon.com/images/I/71xVNFRJBsL.jpg',1,NULL,'music/kiss-me-more.mp3');

INSERT INTO `artisthassong` VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10),
(11,11),
(12,12),
(13,13),
(14,14),
(6,15),
(15,16);

INSERT INTO `user` VALUES
(1,'Admin','admin@phantomwaves.com',NULL,'$12$8POvDZ9DcFgArdiGHEuXweg4nWpJP0369eJeZ00MqyIsjxHnT1hBe',1),
(2,'User','user@user.com',NULL,'$2b$10$5wPzQ7XJYNfvI3bRYHjALOSv6c9F2GhTFi4sSgAQKWqXg3rG/8.PG',0);

INSERT INTO `playlist` VALUES
(1,'Liked','2026-04-20',0,1),
(2,'Liked','2026-04-20',0,2);
