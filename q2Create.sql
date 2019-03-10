CREATE INDEX idx_gender ON students(gender);
CREATE INDEX idx_studentIdAndDegreeIdAndGrade ON courseRegistrations(studentId,degreeId,grade);
CREATE MATERIALIZED VIEW pointsPerS(studentId, studentregistrationid, sumECTS, GPA) as SELECT CR.studentid, CR.studentregistrationid, sum(CO.ECTS), sum(CR.Grade * CO.ECTS)/sum(CO.ECTS)::float FROM courseRegistrations CR, CourseOffers CO WHERE CR.CourseOfferId = CO.CourseOfferId and CR.Grade >= 5 GROUP BY CR.studentid, CR.studentregistrationid;
CREATE MATERIALIZED VIEW studentNoFails(studentRegistrationId) as SELECT CR.StudentRegistrationID FROM courseRegistrations CR EXCEPT SELECT CR2.StudentRegistrationId FROM CourseRegistrations CR2 WHERE CR2.grade < 5;
