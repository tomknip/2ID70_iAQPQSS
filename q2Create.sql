CREATE INDEX idx_gender ON students(gender);
CREATE INDEX idx_studentIdAndDegreeIdAndGrade ON courseRegistrations(studentId,degreeId,grade);
CREATE MATERIALIZED VIEW pointsPerS(studentId, studentregistrationid, sumECTS, GPA) as SELECT CR.studentid, CR.studentregistrationid, sum(CO.ECTS), sum(CR.Grade * CO.ECTS)/sum(CO.ECTS)::float FROM courseRegistrations CR, CourseOffers CO WHERE CR.CourseOfferId = CO.CourseOfferId and CR.Grade >= 5 GROUP BY CR.studentid, CR.studentregistrationid;
CREATE MATERIALIZED VIEW finishedStud(studentId, studentregistrationid, sumECTS, GPA) as SELECT P.studentId, P.studentregistrationid, P.sumECTS, P.GPA FROM pointsPerS P, studentRegistrationsToDegrees SD, degrees D WHERE P.studentregistrationid = sd.studentregistrationid and D.degreeid = SD.DegreeID and D.totalects <= P.sumECTS;
CREATE MATERIALIZED VIEW finishedStudNoFails(studentId, studentregistrationid, sumECTS, GPA) as SELECT P.studentId, P.studentregistrationid, P.sumECTS, P.GPA FROM courseRegistrations CR, finishedStud FS WHERE CR.StudentId = FS.StudentId HAVING min(CR.grade) >= 5;
CREATE MATERIALIZED VIEW have_not_taken_yet(studentregistrationid, sumECTS) as (
SELECT studentregistrationid, 0 FROM (SELECT studentregistrationid FROM studentRegistrationsToDegrees D EXCEPT SELECT studentregistrationid FROM pointsPerS));
