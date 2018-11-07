-- Kaitlin Bleich kbleich
-- Kyaw Soe ksoe

-- 1
-- report all campuses from 'Los Angeles'
SELECT
   C.Campus
FROM
   campuses C
WHERE
   C.County = 'Los Angeles';

-- 2
-- for each year between 1994 and 2000 (inclusive)
-- report students who graduated from 'California Maritime Academy'
-- output year and number of degrees granted
-- sort by year
SELECT 
    D.YR
   ,E.Enrolled
   ,D.Degrees
FROM
   enrollments E,
   degrees D INNER JOIN campuses C ON D.Campusid = C.Id
WHERE
  -- attach enrollments to the other tables
   E.CampusId = C.Id AND
   E.YR = D.YR AND
  -- other parameters
   C.Campus = 'California Maritime Academy' AND
   D.YR >= 1994 AND D.YR <= 2000
ORDER BY
   C.YR;

-- 3
-- report undergrad/grad enrollments in 'Mathematics', 'Engineering', 'Computer...'
-- for both Polytechnic universities in 2004
-- output campus name, discipline, number of students (both)
-- sort by campus name and discipline
SELECT
   C.Campus
   , D.Name
   , DE.UGrad
   , DE.Grad
FROM
   campuses C
   ,disciplines D
   ,discEnr DE
WHERE
   -- connect tables
   C.Id = DE.CampusId AND
   DE.discId = D.Id AND
   -- other criteria
   C.Campus LIKE '%Polytechnic%' AND
   D.Name IN ('Mathematics', 'Engineering', 'Computer and Info. Sciences') AND
   DE.YR = 2004
ORDER BY
   C.Campus
   , D.Name;

-- 4
-- report grad enrollments in 2004 in 'Agriculture', 'Biological Sciences'
-- for any university that offers grad studies in BOTH disciplines
-- one line per university
SELECT 
   C.Campus, DE.Grad as 'Bio', DE2.Grad 'Ag'
FROM
   campuses C,
   -- connect discEnr and disciplines while cutting discs down to Ag and Bio
   discEnr DE INNER JOIN disciplines D ON
      DE.DiscId = D.Id AND D.Name IN ('Agriculture', 'Biological Sciences'),
   discEnr DE2 INNER JOIN disciplines D2 ON
      DE2.DiscId = D2.Id AND D2.Name IN ('Agriculture', 'Biological Sciences')
WHERE
   C.Id=DE.CampusId AND C.Id = DE2.CampusId AND
   -- cutting down dupes
   DE.CampusId = DE2.CampusId AND
   D.Name != D2.Name AND
   DE.DiscId < DE2.DiscId;
   

-- 5
-- find all disciplines and campuses where grad enrollment was 3x higher than UGrad
-- in 2004
-- report campus name and discipline name
SELECT
   C.Campus
   , D.Name
FROM
   campuses C
   , disciplines D
   , discEnr DE
WHERE
   -- connect tables
   C.Id = DE.CampusId AND
   DE.discId = D.Id AND
   -- other criteria
   DE.YR = 2004 AND
   DE.Grad >= (3*DE.UGrad);

-- 6
-- report total student fee at 'Fresno State University' for each year between
-- 2002 and 2004 inclusive
SELECT
    E.YR
   , E.FTE * F.Fee as total
FROM
   fees F
   , enrollments E
   , campuses C
WHERE
   -- connect tables
   F.CampusId = C.Id AND
   E.CampusId = C.Id AND
   F.YR = E.YR AND
   -- other criteria
   C.Campus = 'Fresno State University' AND
   F.YR BETWEEN 2002 AND 2004
ORDER BY
   E.YR;

-- 7
-- find all campuses where enrollment in 2003 was higher than San Jose State
-- report campus, 2003 enrollment number, number of faculty, student-faculty ratio
SELECT
   C2.Campus, E2.FTE, TRUNCATE(E2.FTE/F.FTE, 3) as 'student-to-faculty'
FROM
   campuses C INNER JOIN enrollments E ON
      C.Id = E.CampusId AND E.YR = 2003 AND C.Campus = 'San Jose State University',
   campuses C2 INNER JOIN enrollments E2 ON
      C2.Id = E2.CampusId AND E2.YR = 2003,
   faculty F
WHERE
   F.CampusId = C2.Id AND
   F.YR = 2003 AND
   E2.FTE > E.FTE;
