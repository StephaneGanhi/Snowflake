--Création des différentes tables et peuplement de celles-ci depuis le bucket S3 s3://mc-snowflake/sample/music/.

use warehouse load;

create database music;

use database music;

--create schema public;
use schema public;
A) Création des différentes tables sur le worksheet
CREATE TABLE Artist (
  ArtistId NUMBER PRIMARY KEY,
  Name VARCHAR,
  Birthyear NUMBER,
  Country VARCHAR
);

CREATE TABLE MediaType (
  MediaTypeId NUMBER PRIMARY KEY,
  Name VARCHAR
);


CREATE TABLE Gender (
  GenderId NUMBER PRIMARY KEY,
  Name VARCHAR
);

alter table Gender rename to Genre;

CREATE TABLE Playlist (
  PlaylistId NUMBER PRIMARY KEY,
  Name VARCHAR
);

CREATE TABLE Album (
  AlbumId NUMBER PRIMARY KEY,
  Title VARCHAR,
  ArtistId NUMBER,
  Prod_year NUMBER,
  Cd_year NUMBER,
  FOREIGN KEY (ArtistId) REFERENCES Artist(ArtistId)
);


CREATE TABLE Track (
  TrackId NUMBER PRIMARY KEY,
  Name VARCHAR,
  MediaTypeId NUMBER,
  GenderId NUMBER,
  AlbumId NUMBER,
  Composer VARCHAR,
  Milliseconds NUMBER,
  Bytes NUMBER,
  UnitPrice NUMBER,
  FOREIGN KEY (MediaTypeId) REFERENCES MediaType(MediaTypeId),
  FOREIGN KEY (GenderId) REFERENCES Gender(GenderId),
  FOREIGN KEY (AlbumId) REFERENCES Album(AlbumId)
);


CREATE TABLE PlaylistTrack (
  PlaylistId NUMBER,
  TrackId NUMBER,
  PRIMARY KEY (PlaylistId, TrackId),
  FOREIGN KEY (PlaylistId) REFERENCES Playlist(PlaylistId),
  FOREIGN KEY (TrackId) REFERENCES Track(TrackId)
);

B) Création du stage 
create stage s3_data
  url = 's3://mc-snowflake/sample/music/'
  credentials = (aws_key_id='AKIAXQVBO36EDVJUK3OQ',
                aws_secret_key='JaUd15VUuHWomZhDs+i5LFSnHfNiwYhjCKA7ue1k');


C) Création du File Format
CREATE FILE FORMAT CLASSIC_CSV;
ALTER FILE FORMAT "DEMO"."PUBLIC".CLASSIC_CSV 
SET COMPRESSION = 'AUTO' 
RECORD_DELIMITER = '\n'
FIELD_DELIMITER = ',' 
SKIP_HEADER = 1 
DATE_FORMAT = 'AUTO' 
TIMESTAMP_FORMAT = 'AUTO'
FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE'
TRIM_SPACE = FALSE
ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE 
ESCAPE = 'NONE' 
ESCAPE_UNENCLOSED_FIELD = '\134' 
NULL_IF = ('\\N');
D) Peuplement des tables depuis le bucket s3

copy into Artist
from @s3_data/Artist.csv
file_format = classic_csv
ON_ERROR = 'CONTINUE';


copy into MediaType
from @s3_data/MediaType.csv
file_format = classic_csv
ON_ERROR = 'CONTINUE';


copy into Album
from @s3_data/Album.csv
file_format = classic_csv
ON_ERROR = 'CONTINUE';

copy into Playlist
from @s3_data/Playlist.csv
file_format = classic_csv
ON_ERROR = 'CONTINUE';

copy into PlaylistTrack
from @s3_data/PlaylistTrack.csv
file_format = classic_csv
ON_ERROR = 'CONTINUE';

copy into track
from @s3_data/Track.csv
file_format = classic_csv
ON_ERROR = 'CONTINUE';

copy into Genre
from @s3_data/Genre.csv
file_format = classic_csv
ON_ERROR = 'CONTINUE';
