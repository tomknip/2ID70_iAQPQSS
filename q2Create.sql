CREATE INDEX idx_gender ON students(gender);
CREATE INDEX idx_studentIdAndDegreeId ON StudentRegistrationsToDegrees(studentId,degreeId);
CREATE MATERIALIZED VIEW pointsPerS(studentId, studentregistrationid, sumECTS, GPA) as SELECT CR.studentid, CR.studentregistrationid, sum(CO.ECTS), sum(CR.Grade * CO.ECTS)/sum(CO.ECTS) FROM courseRegistrations CR, CourseOffers CO WHERE CR.CourseOfferId = CO.CourseOfferId and CR.Grade >= 5 GROUP BY CR.studentid, CR.studentregistrationid;
