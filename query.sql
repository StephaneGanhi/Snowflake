-- Donnez les titres des albums qui ont plus de 1 CD.

SELECT DISTINCT Album.Title
FROM Album
WHERE Cd_year > 1;

-- Donnez les morceaux produits en 2000 ou en 2002

SELECT f.Name AS TrackName, d.Prod_year AS ProductionYear
FROM FactTrack f
JOIN DimAlbum d ON f.AlbumId = d.AlbumId
WHERE d.Prod_year = 2000 OR d.Prod_year = 2002;

-- Donnez le nom et le compositeur des morceaux de Rock et de Jazz.

SELECT f.Name AS TrackName, f.Composer, g.Name AS Genre
FROM FactTrack f
JOIN DimGenre g ON f.GenderId = g.GenderId
WHERE g.Name IN ('Rock', 'Jazz');

-- Donnez les 10 albums les plus longs.

SELECT da.Title AS AlbumTitle, SUM(ft.Milliseconds) AS TotalMilliseconds
FROM FactTrack ft
JOIN DimAlbum da ON ft.AlbumId = da.AlbumId
GROUP BY da.Title
ORDER BY TotalMilliseconds DESC
LIMIT 10;

-- Donnez le nombre d'albums produits pour chaque artiste.


SELECT Artist.Name AS ArtistName, COUNT(Album.AlbumId) AS NumberOfAlbums
FROM Artist
LEFT JOIN Album ON Artist.ArtistId = Album.ArtistId
GROUP BY Artist.Name
ORDER BY NumberOfAlbums DESC;

-- Donnez le nombre de morceaux produits par chaque artiste.

SELECT Artist.Name AS ArtistName, COUNT(Track.TrackId) AS NumberOfTracks
FROM Artist
LEFT JOIN Album ON Artist.ArtistId = Album.ArtistId
LEFT JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Artist.Name
ORDER BY NumberOfTracks DESC;

-- Donnez le genre de musique le plus écouté dans les années 2000.


WITH TracksByGenre AS (
  SELECT
    dg.Name AS Genre,
    COUNT(*) AS NombreEcoutes
  FROM
    FactTrack ft
    JOIN DimGenre dg ON ft.GenderId = dg.GenderId
    JOIN DimAlbum da ON ft.AlbumId = da.AlbumId
  WHERE
    TO_DATE(da.Prod_year || '-01-01') BETWEEN TO_DATE('2000-01-01') AND TO_DATE('2009-12-31')
  GROUP BY
    dg.Name
)
SELECT
  Genre
FROM
  TracksByGenre
WHERE
  NombreEcoutes = (SELECT MAX(NombreEcoutes) FROM TracksByGenre);


--Donnez les noms de toutes les playlists où figurent des morceaux de plus de 4 minutes.

SELECT DISTINCT pl.Name
FROM Playlist pl
JOIN PlaylistTrack plt ON pl.PlaylistId = plt.PlaylistId
JOIN Track t ON plt.TrackId = t.TrackId
WHERE t.Milliseconds > 240000; -- 4 minutes en millisecondes


-- Donnez les morceaux de Rock dont les artistes sont en France

SELECT Track.Name AS Morceau, Artist.Name AS Artiste, Genre.Name AS Genre
FROM Track
JOIN Genre ON Track.GenderId = Genre.GenderId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
WHERE Genre.Name = 'Rock' AND Artist.Country = 'France';

-- Donnez la moyenne des tailles des morceaux par genre musical.

SELECT Genre.Name AS GenreMusical, AVG(Track.Milliseconds) AS MoyenneTaille
FROM Track
JOIN Genre ON Track.GenderId = Genre.GenderId
GROUP BY Genre.Name

-- Donnez les playlist où figurent des morceaux d'artistes nés avant 1990.

SELECT DISTINCT P.Name AS PlaylistName
FROM Playlist P
JOIN PlaylistTrack PT ON P.PlaylistId = PT.PlaylistId
JOIN Track T ON PT.TrackId = T.TrackId
JOIN Album A ON T.AlbumId = A.AlbumId
JOIN Artist AR ON A.ArtistId = AR.ArtistId
WHERE (YEAR(CURRENT_DATE()) - AR.Birthyear) < 1990;
