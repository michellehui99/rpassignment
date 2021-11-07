--Comments for the commands in the terminal.

--The movie I chose for this assignment is the movie "The blind side".
--In the terminal I build a recommendation system for different objects. 
--First I looked at the recommendations based on the summary. 
--Before doing the steps for the recommendations, I first created a table 
--and named the data that I was working in 'movies10', I named it movies10 because
--I have tried ten times to create a table. 

--Recommendations based on the summary

pi@raspberrypi:~/RSL $ psql test
psql (11.12 (Raspbian 11.12-0+deb10u1))
Type "help" for help.

-- I searched for the summary of the movie 'the blind side', the word 'homeless' 
was in the summary. So I looked for in my data movies10 to see if there are
any movies with the word 'homeless' in their summery.

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

--In the output, it gives me eight movies with the word 'homeless' in their summary.


test=> UPDATE movies10 SET rank=ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM movies10 WHERE url='the-blind-side')));

UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnSummaryField2 AS SELECT url, rank FROM movies10 WHERE rank <0.99 ORDER BY rank DESC LIMIT 50;
SELECT 50

test=> \copy (SELECT * FROM recommendationsBasedOnSummaryField2) to '/home/pi/RSL/top50recommendations.csv' WITH csv;
COPY 50

--I followed all the commands, so it will give me a top 50 recommendations based on the summary of the movie 'The blind side'

**Recommendations based on the the title
-- I did the same steps for the title text. 

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
-- And last but not least, I did it for the starring text. One of the main actress in the movie is Sandra Bullock.
-- I first tried to search for the starring text with her first and lastname. But that gave me 0 results.
-- Then is just tried her last name and it gave me a result with 20 rows. 
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

--CONCLUSION

--For all the recommendations I got a top 50 recommendations of the movie based on the '... text' I was searching for.
--Looking at the result, it was very accurate. The movie that were recommendend to me was all related to the search.
