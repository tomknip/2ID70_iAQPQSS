SELECT 0
SELECT 0
SELECT 0
SELECT count(CASE WHEN S.Gender = 'F'  THEN 1 END)/count(SR.StudentId)::float as percentageFemale FROM Degrees D, StudentRegistrationsToDegrees SR, Students S WHERE SR.DegreeId = D.DegreeId and S.StudentId = SR.StudentId and D.Dept = %1%;
SELECT CR.CourseId, count(CASE WHEN CR.Grade >= %1% THEN 1 END)/count(CR.Grade)::float as percentagePassing FROM CourseRegistrations CR WHERE CR.Grade IS NOT NULL GROUP BY CR.CourseId ORDER BY CR.CourseId;
SELECT 0
SELECT 0
SELECT 0
