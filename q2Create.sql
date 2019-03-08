CREATE MATERIALIZED VIEW pointsPerS(studentId, studentregistrationid, sumECTS, GPA) as
SELECT  CR.studentid, CR.studentregistrationid, sum(ECTS), sum(CR.Grade * C.ECTS)/sum(C.ECTS)
FROM courseRegistrations CR, CourseOffers CO, Courses C
WHERE CR.CourseOfferId = CO.CourseOfferId And CO.CourseId = C.CourseId and CR.Grade >= 5
GROUP BY CR.studentid, CR.studentregistrationid;

CREATE INDEX idx_studRegIdandCourseOfferI on courseRegistrations(studentRegistrationId, courseofferId);
