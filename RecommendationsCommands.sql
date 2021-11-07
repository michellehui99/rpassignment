MOVIE CHOICE: THE BLIND SIDE

**Recommendations based on the the summary

pi@raspberrypi:~/RSL $ psql test
psql (11.12 (Raspbian 11.12-0+deb10u1))
Type "help" for help.

test=> SELECT url FROM movies10 WHERE lexemesSummary @@ to_tsquery('homeless');
          url           
------------------------
 the-blind-side
 blue-ruin
 central-station
 drillbit-taylor
 here-on-earth
 my-own-private-idaho
 resurrecting-the-champ
 the-soloist
(8 rows)


test=> UPDATE movies10 SET rank=ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM movies10 WHERE url='the-blind-side')));

UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnSummaryField2 AS SELECT url, rank FROM movies10 WHERE rank <0.99 ORDER BY rank DESC LIMIT 50;
SELECT 50

test=> \copy (SELECT * FROM recommendationsBasedOnSummaryField2) to '/home/pi/RSL/top50recommendations.csv' WITH csv;
COPY 50

**Recommendations based on the the title

test=> ALTER TABLE movies10 ADD lexemesTitle1 tsvector;
ALTER TABLE
test=> UPDATE movies10 SET lexemesTitle1 = to_tsvector(title);
UPDATE 5229
test=> SELECT url FROM movies10 WHERE lexemesTitle1 @@ to_tsquery('blind');
             url              
------------------------------
 blind-date-1987
 blind-mountain
 the-blind-side
 blind-spot-hitlers-secretary
 the-blind-swordsman-zatoichi
(5 rows)

test=> UPDATE movies10 SET rank=ts_rank(lexemesTitle1,plainto_tsquery((SELECT title FROM movies10 WHERE url ='the-blind-side')));
UPDATE 5229
SELECT 50
test=> \copy (SELECT*FROM recommendationsBasedOnTitleField2) to '/home/pi/RSL/top50recommendationsTitle.csv' WITH csv;
COPY 50

**Recommendations based on the starring

test=> ALTER TABLE movies10 ADD lexemesStarring tsvector;
ALTER TABLE
test=> UPDATE movies10 SET lexemesStarring=to_tsvector(Starring);
UPDATE 5229
test=> SELECT url FROM movies10 WHERE lexemesStarring @@ to_tsquery('Sandra-Bullock');
 url 
-----
(0 rows)

test=> SELECT url FROM movies10 WHERE lexemesStarring @@ to_tsquery('Bullock');
                url                 
------------------------------------
 a-time-to-kill
 the-blind-side
 the-heat
 crash
 demolition-man
 gravity
 while-you-were-sleeping
 hope-floats
 all-about-steve
 gun-shy
 minions
 miss-congeniality
 miss-congeniality-2-armed-fabulous
 the-lake-house
 the-net
 forces-of-nature
 practical-magic
 the-proposal
 speed
 two-weeks-notice
(20 rows)

test=> UPDATE movies10 SET rank = ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM movies10 WHERE url='Bullock')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnStarringField AS SELECT url, rank FROM movies10 WHERE rank <0.99 ORDER BY rank DESC LIMIT 50;
SELECT 0
test=> UPDATE movies10 SET rank = ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM movies10 WHERE url='the-blind-side')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnStarringField2 AS SELECT url, rank FROM movies10 WHERE rank <0.99 ORDER BY rank DESC LIMIT 50;
SELECT 50
test=> \copy (SELECT*FROM recommendationsBasedOnStarringField2) to '/home/pi/RSL/top50recommendationsStarring.csv' WITH csv;

