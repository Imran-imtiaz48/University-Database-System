-- Create the view for student details
CREATE VIEW vw_StudentDetails AS
SELECT 
    s.StudentID,
    s.FirstName,
    s.LastName,
    s.DateOfBirth,
    s.Gender,
    s.Email,
    s.Phone,
    s.Address,
    s.EnrollmentDate,
    d.DepartmentName
FROM 
    Students s
LEFT JOIN 
    Departments d ON s.DepartmentID = d.DepartmentID;
GO

-- Create the view for instructor details
CREATE VIEW vw_InstructorDetails AS
SELECT 
    i.InstructorID,
    i.FirstName,
    i.LastName,
    i.Email,
    i.Phone,
    i.HireDate,
    d.DepartmentName
FROM 
    Instructors i
LEFT JOIN 
    Departments d ON i.DepartmentID = d.DepartmentID;
GO

-- Create the view for course details
CREATE VIEW vw_CourseDetails AS
SELECT 
    c.CourseID,
    c.CourseName,
    c.CourseDescription,
    c.Credits,
    d.DepartmentName
FROM 
    Courses c
LEFT JOIN 
    Departments d ON c.DepartmentID = d.DepartmentID;
GO

-- Create the view for enrollment details
CREATE VIEW vw_EnrollmentDetails AS
SELECT 
    e.EnrollmentID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    c.CourseName,
    e.EnrollmentDate,
    e.Grade
FROM 
    Enrollments e
JOIN 
    Students s ON e.StudentID = s.StudentID
JOIN 
    Courses c ON e.CourseID = c.CourseID;
GO

-- Create the view for course schedule details
CREATE VIEW vw_CourseScheduleDetails AS
SELECT 
    cs.ScheduleID,
    c.CourseName,
    cl.BuildingName,
    cl.RoomNumber,
    cs.DayOfWeek,
    cs.StartTime,
    cs.EndTime
FROM 
    CourseSchedules cs
JOIN 
    Courses c ON cs.CourseID = c.CourseID
JOIN 
    Classrooms cl ON cs.ClassroomID = cl.ClassroomID;
GO

-- Create the view for department instructors
CREATE VIEW vw_DepartmentInstructors AS
SELECT 
    d.DepartmentName,
    i.FirstName,
    i.LastName,
    i.Email,
    i.Phone
FROM 
    DepartmentsInstructors di
JOIN 
    Departments d ON di.DepartmentID = d.DepartmentID
JOIN 
    Instructors i ON di.InstructorID = i.InstructorID;
GO

-- Create the view for club memberships
CREATE VIEW vw_ClubMemberships AS
SELECT 
    cm.MembershipID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    cl.ClubName,
    cm.MembershipDate
FROM 
    ClubMemberships cm
JOIN 
    Students s ON cm.StudentID = s.StudentID
JOIN 
    Clubs cl ON cm.ClubID = cl.ClubID;
GO

-- Create the view for scholarship applications
CREATE VIEW vw_ScholarshipApplications AS
SELECT 
    sa.ApplicationID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    sc.ScholarshipName,
    sa.ApplicationDate,
    sa.Status
FROM 
    ScholarshipApplications sa
JOIN 
    Students s ON sa.StudentID = s.StudentID
JOIN 
    Scholarships sc ON sa.ScholarshipID = sc.ScholarshipID;
GO

-- Create the view for alumni employment
CREATE VIEW vw_AlumniEmployment AS
SELECT 
    e.EmploymentID,
    a.FirstName,
    a.LastName,
    e.EmployerName,
    e.Position,
    e.StartDate,
    e.EndDate,
    e.Salary
FROM 
    Employment e
JOIN 
    Alumni a ON e.AlumniID = a.AlumniID;
GO

-- Create the view for library book loans
CREATE VIEW vw_LibraryBookLoans AS
SELECT 
    bl.LoanID,
    b.Title AS BookTitle,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    bl.LoanDate,
    bl.ReturnDate,
    bl.Status
FROM 
    BookLoans bl
JOIN 
    Books b ON bl.BookID = b.BookID
JOIN 
    Students s ON bl.StudentID = s.StudentID;
GO

-- Create the view for attendance records
CREATE VIEW vw_AttendanceRecords AS
SELECT 
    a.AttendanceID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    c.CourseName,
    a.AttendanceDate,
    a.Status
FROM 
    Attendance a
JOIN 
    Students s ON a.StudentID = s.StudentID
JOIN 
    Courses c ON a.CourseID = c.CourseID;
GO

-- Create the view for course feedback
CREATE VIEW vw_CourseFeedback AS
SELECT 
    f.FeedbackID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    c.CourseName,
    i.FirstName AS InstructorFirstName,
    i.LastName AS InstructorLastName,
    f.FeedbackDate,
    f.Comments,
    f.Rating
FROM 
    Feedback f
JOIN 
    Students s ON f.StudentID = s.StudentID
JOIN 
    Courses c ON f.CourseID = c.CourseID
JOIN 
    Instructors i ON f.InstructorID = i.InstructorID;
GO

-- Create the view for student advisors
CREATE VIEW vw_StudentAdvisors AS
SELECT 
    sa.AdvisorID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    f.FirstName AS FacultyFirstName,
    f.LastName AS FacultyLastName,
    sa.AssignmentDate
FROM 
    StudentAdvisors sa
JOIN 
    Students s ON sa.StudentID = s.StudentID
JOIN 
    Faculty f ON sa.FacultyID = f.FacultyID;
GO

-- Create the view for course prerequisites
CREATE VIEW vw_CoursePrerequisites AS
SELECT 
    p.PrerequisiteID,
    c.CourseName AS MainCourse,
    pc.CourseName AS PrerequisiteCourse
FROM 
    Prerequisites p
JOIN 
    Courses c ON p.CourseID = c.CourseID
JOIN 
    Courses pc ON p.PrerequisiteCourseID = pc.CourseID;
GO
