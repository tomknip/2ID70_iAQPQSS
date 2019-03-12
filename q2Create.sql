CREATE INDEX idx_gender ON students(gender);
CREATE INDEX idx_studentIdAndDegreeIdAndGrade ON courseRegistrations(studentId,degreeId,grade);
CREATE INDEX idx_CourseIdAndGrade ON courseRegistrations(CourseId,grade); 
CREATE MATERIALIZED VIEW pointsPerS(studentId, studentregistrationid, sumECTS, GPA) as SELECT CR.studentid, CR.studentregistrationid, sum(CO.ECTS), sum(CR.Grade * CO.ECTS)/sum(CO.ECTS)::float FROM courseRegistrations CR, CourseOffers CO WHERE CR.CourseOfferId = CO.CourseOfferId and CR.Grade >= 5 GROUP BY CR.studentid, CR.studentregistrationid;
CREATE MATERIALIZED VIEW have_not_taken_yet(studentregistrationid, sumECTS) as (SELECT studentregistrationid, 0 FROM (SELECT studentregistrationid FROM studentRegistrationsToDegrees D EXCEPT SELECT studentregistrationid FROM pointsPerS) as new);
CREATE MATERIALIZED VIEW nofails(id, regid, gpa) as (with finishedStud(studentId, studentregistrationid, sumECTS, GPA) as (SELECT P.studentId, P.studentregistrationid, P.sumECTS, P.GPA FROM pointsPerS P, studentRegistrationsToDegrees SD, degrees D WHERE P.studentregistrationid = sd.studentregistrationid and D.degreeid = SD.DegreeID and P.sumECTS >= D.totalects) select fi.studentid, fi.studentregistrationid, fi.gpa from finishedstud as fi, courseregistrations as cr where fi.studentregistrationid = cr.studentregistrationid group by fi.studentregistrationid, fi.studentid, fi.GPA having min(cr.grade) >= 5);
CREATE MATERIALIZED VIEW HighestGrade(CourseOfferId, Grade) as (SELECT CR.CourseOfferId, max(CR.Grade) FROM CourseRegistrations CR, CourseOffers CO WHERE CR.CourseOfferId = CO.CourseOfferId and CO.year = 2018 and CO.Quartile = 1 GROUP BY CR.CourseOfferId);
CREATE MATERIALIZED VIEW activeStudents(studentregistrationid, DegreeId) as (SELECT SD.studentregistrationid, D.DegreeId FROM pointsPerS as almost, studentRegistrationsToDegrees SD, degrees D WHERE almost.studentregistrationid = sd.studentregistrationid and D.degreeid = SD.DegreeID and D.totalects > almost.sumECTS UNION SELECT SD.studentregistrationid, SD.DegreeID FROM studentRegistrationsToDegrees SD, have_not_taken_yet HY WHERE SD.studentregistrationid = HY.studentregistrationid);
