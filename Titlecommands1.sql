ALTER TABLE movies10 ADD lexemesTitle1 tsvector;

UPDATE movies10 SET lexemesTitle1 = to_tsvector(title);

SELECT url FROM movies10 WHERE lexemesTitle1 @@ to_tsquery('blind');
 
UPDATE movies10 SET rank=ts_rank(lexemesTitle1,plainto_tsquery((SELECT title FROM movies10 WHERE url ='the-blind-side')));

\copy (SELECT*FROM recommendationsBasedOnTitleField2) to '/home/pi/RSL/top50recommendationsTitle.csv' WITH csv;
