create schema star_schema;
use schema star_schema;



INSERT ALL 
INTO DimAlbum (AlbumId, Title, Prod_year, Cd_year, ArtistName, Birthyear, Country)
SELECT al.AlbumId, al.Title, al.Prod_year, al.Cd_year, ar.Name, ar.Birthyear, ar.Country
FROM Album al 
JOIN Artist ar ON al.ArtistId = ar.ArtistId;

INSERT ALL
INTO DimMediaType (MediaTypeId, Name)
SELECT MediaTypeId, Name
FROM MediaType;

INSERT ALL 
INTO DimGenre (GenderId, Name)
SELECT GenderId, Name
FROM Genre;

INSERT ALL 
INTO DimPlaylistTrack (PlaylistId, TrackId, Name)
SELECT plt.PlaylistId, plt.TrackId, pl.Name
FROM PlaylistTrack plt
JOIN Playlist pl ON plt.PlaylistId = pl.PlaylistId;

INSERT ALL 
INTO FactTrack (TrackId, AlbumId, PlaylistId, MediaTypeId, GenderId, Name, Composer, Milliseconds, Bytes, UnitPrice)
SELECT T.TrackId, al.AlbumId, plt.PlaylistId, T.MediaTypeId, G.GenderId, T.Name, T.Composer, T.Milliseconds, T.Bytes, T.UnitPrice
FROM Track T
JOIN Album al ON T.AlbumId = al.AlbumId
JOIN PlaylistTrack plt ON T.TrackId = plt.TrackId
JOIN Genre G ON T.GenderId = G.GenderId
JOIN MediaType mt ON T.MediaTypeId = mt.MediaTypeId;
