USE `mydb`;

-- Note: 'Liked' playlists are created automatically
-- DO NOT insert 'Liked' playlist manually here.
-- USERS (automatically triggers creation of 'Liked' playlists)
INSERT INTO `genre` (`idGenre`, `nameGenre`, `descriptionGenre`) VALUES
(1, 'Pop', 'Pop music is built around catchy hooks, polished production and short memorable song structures designed for large audiences. It often blends elements from dance, rock R&B, and electronic music, evolving quickly with mainstream trends.'),
(2, 'Rock', 'Rock is driven by electric guitars, bass and drums, with a strong focus on rhythm and live energy. From classic rock to indie and alternative, the genre emphasizes attitude, riffs and expressive vocals.'),
(3, 'Hip-Hop', 'Hip-Hop combines rhythmic spoken lyrics, beat-driven production and deep cultural storytelling. It includes many substyles such as boom bap, trap and melodic rap, and often reflects social realities and identity.'),
(4, 'R&B', 'R&B (Rhythm and Blues) highlights smooth vocals, emotional melodies and groove-oriented instrumentation. Modern R&B frequently mixes soul pop, and electronic textures while keeping intimate themes like love and vulnerability.'),
(5, 'Jazz', 'Jazz is known for improvisation, swing, harmonic complexity and instrumental dialogue. It spans traditional, bebop, fusion and contemporary forms, and has influenced almost every modern genre.'),
(6, 'Blues', 'Blues is one of the core roots of modern popular music, recognized by expressive phrasing, blue notes and call-and-response patterns. Its lyrics often explore hardship, resilience and personal emotion.'),
(7, 'Classical', 'Classical music is centered on composition, orchestration and dynamic interpretation across periods like Baroque, Romantic and Modern. It is performed by orchestras, ensembles and soloists with strong emphasis on technique and structure.'),
(8, 'Electronic', 'Electronic music is produced mainly with synthesizers, samplers, drum machines and software. It includes styles such as house, techno, trance, drum and bass and ambient, often focusing on texture and rhythm design.'),
(9, 'Reggae', 'Reggae originated in Jamaica and is identified by offbeat guitar chords, warm basslines and steady grooves. It frequently carries themes of freedom, spirituality and social consciousness.'),
(10, 'Country', 'Country music combines storytelling lyrics, acoustic and electric string instruments and roots traditions from folk and blues. Its songs often address everyday life, love, family and personal journeys.'),
(11, 'Metal', 'Metal is characterized by heavy distorted guitars, powerful drumming and intense vocal delivery. The genre includes many branches, from heavy and thrash to symphonic and progressive metal.'),
(12, 'Funk', 'Funk prioritizes groove through syncopated bass, tight drum patterns and rhythmic guitar. It is dance-focused, energetic and has strongly influenced disco, hip-hop and modern pop.');

-- ----------------------------------------
-- USERS (automatically triggers creation of 'Liked' playlists)
-- ----------------------------------------
INSERT INTO `artist` VALUES
(1,'Ado',0,'https://c4.wallpaperflare.com/wallpaper/46/909/96/ado-j-pop-anime-girls-stairs-hatsune-miku-hd-wallpaper-preview.jpg','https://static.wikia.nocookie.net/nicodougasingers/images/b/b8/2025.01_%281_-_v1%29.jpg/revision/latest?cb=20250126182908','https://preview.redd.it/drop-your-ado-wallpapers-v0-jyn9b5sswo7f1.png?width=3337&format=png&auto=webp&s=a1d6aafc1226d08581faa038ebc137518ae97cb4'),
(2,'Joji',0,'https://images5.alphacoders.com/112/1122289.jpgs','https://www.clashmusic.com/wp-content/uploads/2019/05/111_-OnlineImage13.jpg','https://images8.alphacoders.com/112/1122276.jpg'),
(3,'Harry Styles',0,'https://variety.com/wp-content/uploads/2020/12/Harry-Styles-Variety-Hitmakers-2-16x9-1.jpg','https://i.guim.co.uk/img/media/29e24f73e90c1fb9de42a531a73bb7d39efc79c4/0_202_3000_1800/master/3000.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=73a341483d95233a3579b797becdfabc','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNE4uICwkRe3vk3qt5xg4TjPnv9mEKTPhTmw&s'),
(4,'Steve Lacy',0,'https://wallpapercat.com/w/full/1/d/e/2228206-2048x1152-desktop-hd-steve-lacy-background.jpg','https://lastfm.freetls.fastly.net/i/u/ar0/8c7ec4d25b7008b55e6684a7e4671809.jpg','https://images.squarespace-cdn.com/content/v1/5926f98b725e25f7efef5841/1571412909247-GUU2RVTSJZTGJDKU1MPV/700A4171.jpg'),
(5,'Sam Smith',0,'https://www.rollingstone.co.uk/wp-content/uploads/sites/2/2023/01/Sam-Smith-8-1.jpg','https://www.the360mag.com/wp-content/uploads/2024/08/1.png','https://wallpapers.com/images/featured/sam-smith-bp9wedk8a1bh8ph5.jpg'),
(6,'The Weeknd',0,'https://websiteserviceapi.azurewebsites.net/api/Images/1423586/5','https://assets.vogue.com/photos/610d4bc367ad44456aeae681/master/w_2560%2Cc_limit/IMG_0961.jpg','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQRUfrOBipROl8FtqHwQa_fxpEinmLklheXQ&s'),
(7,'Glass Animals',0,'https://api.floodmagazine.com/wp-content/uploads/2024/08/Glass-Animals-credit-Shervin-Lainez-4.jpg','https://www.the360mag.com/wp-content/uploads/2024/12/20241213_025048-scaled.jpg','https://wallpapers.com/images/featured/glass-animals-dm98pjyk3c7pxatk.jpg'),
(8,'Mark Ronson',0,'https://wwd.com/wp-content/uploads/2022/01/mark-ronson-audemars-piguet-1.jpeg','https://ellesg-prod.s3.ap-southeast-1.amazonaws.com/wp-content/uploads/2025/06/ELLESG_Mark_Ronson_Audemars_Piguet.jpg','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRM_RPgnug95gBiAwhQi0Pi7-jCRpwg7DxcIQ&s'),
(9,'Dua Lipa',0,'https://cdn-www.konbini.com/files/2024/03/dualipa_tourne%CC%81enimes.png?width=3840&quality=75&format=webp','https://gcp-na-images.contentstack.com/v3/assets/bltea6093859af6183b/blt3b5f06b40040cc2b/698a559ad0753397f1e70a96/dua-lipa-time100-2024.jpg?branch=production','https://wallpapercat.com/w/small-vertical-retina/a/f/7/106752-1440x2560-mobile-hd-dua-lipa-wallpaper-photo.jpg?id=1644914842'),
(10,'Justin Bieber',1,'https://image.idntimes.com/post/20260416/upload_ed68fb1a8eb5079bdfe9439b87c06c2f_7f857483-b465-42ba-846e-94ea10445c12.jpg','https://pbs.twimg.com/media/HGby3C0bUAAJgaA.jpg','https://wallpapercat.com/w/full/8/5/2/151041-1366x2048-mobile-hd-justin-bieber-background.jpg'),
(11,'Olivia Rodrigo',0,'https://georgetownvoice.com/wp-content/uploads/2021/05/olivia-rodrigo-1-hori.jpg','https://assets.vogue.com/photos/600b0497f9a1b521a80915dc/master/w_2560%2Cc_limit/001-Olivia-Rodrigo-vogue-200121-creditCredit-ERICA-HERNA%25CC%2581NDEZ.jpg','https://media.pitchfork.com/photos/6076fd2e17d37fe4717d4907/master/pass/Olivia-Rodrigo-SOUR.jpeg'),
(12,'Nicky Youre',0,'https://real.fm/assets/Uploads/NickyYoure__FillWzE3MDAsNjUwXQ.jpg','https://artist-assets.hubbardradio.com/4777669-112029_v1000.jpg','https://wallpapercat.com/w/full/a/6/3/2918809-2048x2510-samsung-hd-nicky-youre-singer-wallpaper-image.jpg'),
(13,'Taylor Swift',1,'https://images2.alphacoders.com/758/758246.jpg','https://northerntransmissions.com/wp-content/uploads/2023/07/unnamed-2023-07-11T123536.115.png','https://i.pinimg.com/736x/5e/dc/bd/5edcbdc406d790deefc554e5703879b7.jpg'),
(14,'Ed Sheeran',0,'https://images.thebrag.com/cdn-cgi/image/fit=cover,width=1200,height=800,format=auto/https://images-r2-1.thebrag.com/tmn/uploads/new-merchandise-deals-for-ed-sheeran-prince-rita-ora.jpg','https://cdn.britannica.com/17/249617-050-4575AB4C/Ed-Sheeran-performs-Rockefeller-Plaza-Today-Show-New-York-2023.jpg','https://4kwallpapers.com/images/wallpapers/ed-sheeran-english-2560x1440-9558.jpg'),
(15,'Doja Cat',1,'https://www.billboard.com/wp-content/uploads/media/01-doja-cat-press-photo-2018-billboard-1548.jpg','https://media.wonderlandmagazine.com/uploads/2022/05/Doja-Cat-Elvis-scaled.jpg','https://i.pinimg.com/736x/b2/d5/68/b2d5686acf5791074153982e68b0ce43.jpg'),
(16,'DJ Snake',0,'https://new.brg-radio.com/wp-content/uploads/2024/10/DJ-Snake-@-the-Do-Lab-stage-@-Coachella-2024-scaled-2-scaled-6itqFo.jpeg','https://cdn-images.dzcdn.net/images/artist/f4b1cf6875953f8747a73006928ae172/1900x1900-000000-80-0-0.jpg','https://djsnake.com/wp-content/uploads/2019/10/image-url-6-1.jpg'),
(17,'Post Malone',0,'https://media.gq.com/photos/5e555d0e3cd32e0008c31e37/master/w_1600%2Cc_limit/post-malone-gq-style-cover-spring-summer-2020-04.jpg','https://static01.nyt.com/images/2024/08/11/multimedia/11POST-MALONE-01-bkvf/11POST-MALONE-01-bkvf-mediumSquareAt3X.jpg','https://images4.alphacoders.com/134/1340379.png'),
(18,'Lorde',0,'https://i.redd.it/05uo9a5lzhx61.png','https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Lorde_Glasto2025-9_%28cropped%29.jpg/960px-Lorde_Glasto2025-9_%28cropped%29.jpg','https://wallpapercat.com/w/full/9/5/7/2327352-1920x1200-desktop-hd-lorde-wallpaper.jpg'),
(19,'Billie Eilish',0,'https://wallpapers-clan.com/wp-content/uploads/2024/11/billie-eilish-colorful-stage-desktop-wallpaper-cover.jpg','https://assets.vogue.com/photos/609bb445758287e5e091eeed/master/w_2560%2Cc_limit/Billie-Eilish-Happier-Than-Ever.jpeg','https://wallpapercat.com/w/small-vertical-retina/f/4/3/11705-1920x2688-phone-hd-billie-eilish-background-photo.jpg?id=1644840023'),
(20,'Sabrina Carpenter',1,'https://images.hdqwalls.com/wallpapers/sabrina-carpenter-for-dunkin-cg.jpg','https://groundzero.fr/wp-content/uploads/2023/11/1200x1200bb.jpg','https://wallpapercave.com/wp/wp15388514.jpg');

-- ----------------------------------------
-- SONGS (8 colonnes : id, title, release, duration, cover, highlighted, idGenre, path)
-- ----------------------------------------
INSERT INTO `song` (`idSong`, `titleSong`, `releaseSong`, `durationSong`, `coverSong`, `highlightedSong`, `idGenre`, `pathSong`) VALUES
(1,'Mirror','2022-01-01','03:45','https://m.media-amazon.com/images/I/81yRZl5LtRL.jpg',1,1,'music/mirror.mp3'),
(2,'Glimpse of Us','2022-06-10','03:53','https://m.media-amazon.com/images/I/81lqJcDPfZL.jpg',1,4,'music/glimpse-of-us.mp3'),
(3,'As It Was','2022-04-01','02:47','https://m.media-amazon.com/images/I/61RyXmXm5fL.jpg',1,1,'music/as-it-was.mp3'),
(4,'Bad Habit','2022-07-29','03:52','https://m.media-amazon.com/images/I/81gt2TIexbL.jpg',0,2,'music/bad-habit.mp3'),
(5,'Unholy','2022-09-22','02:36','https://m.media-amazon.com/images/I/61aZhNW9Q0L.jpg',1,1,'music/unholy.mp3'),
(6,'Blinding Lights','2020-11-29','03:20','https://m.media-amazon.com/images/I/717Ypd1t7IL.jpg',1,8,'music/blinding-lights.mp3'),
(7,'Heat Waves','2020-06-29','03:58','https://m.media-amazon.com/images/I/81vMxIyDZ9L.jpg',0,1,'music/heat-waves.mp3'),
(8,'Uptown Funk','2014-11-10','04:30','https://m.media-amazon.com/images/I/71AZUM4CY1L.jpg',0,12,'music/uptown-funk.mp3'),
(9,'Levitating','2020-10-01','03:23','https://m.media-amazon.com/images/I/81dhBdiI4+L.jpg',1,1,'music/levitating.mp3'),
(10,'Peaches','2021-03-19','03:18','https://m.media-amazon.com/images/I/81lleqz5QXL.jpg',0,4,'music/peaches.mp3'),
(11,'Good 4 U','2021-05-14','02:58','https://m.media-amazon.com/images/I/61fin73zyhL.jpg',0,2,'music/good-4-u.mp3'),
(12,'Sunroof','2022-01-21','02:52','https://m.media-amazon.com/images/I/71DdC823BZL.jpg',0,1,'music/sunroof.mp3'),
(13,'Anti-Hero','2022-10-21','03:21','https://m.media-amazon.com/images/I/81sD+kAZAFL.jpg',1,1,'music/anti-hero.mp3'),
(14,'Shape of You','2017-01-06','03:53','https://m.media-amazon.com/images/I/B1TlPSY5bKS.jpg',0,1,'music/shape-of-you.mp3'),
(15,'Starboy','2016-09-22','03:50','https://m.media-amazon.com/images/I/71fIuxvP+FL.jpg',0,8,'music/starboy.mp3'),
(16,'Kiss Me More','2021-04-09','03:28','https://m.media-amazon.com/images/I/71xVNFRJBsL.jpg',1,4,'music/kiss-me-more.mp3');

-- ----------------------------------------
-- ARTIST <-> SONG associations
-- ----------------------------------------
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

-- ----------------------------------------
-- USERS (automatically triggers creation of 'Liked' playlists)
-- ----------------------------------------
INSERT INTO `user` VALUES
(1,'Admin','admin@phantomwaves.com',NULL,'$12$8POvDZ9DcFgArdiGHEuXweg4nWpJP0369eJeZ00MqyIsjxHnT1hBe',1),
(2,'User','user@user.com',NULL,'$2b$10$5wPzQ7XJYNfvI3bRYHjALOSv6c9F2GhTFi4sSgAQKWqXg3rG/8.PG',0);