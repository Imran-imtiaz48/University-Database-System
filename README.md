Certainly! Here is the complete documentation for your university database project, including the details of all tables, stored procedures, and additional information to help understand and use the database effectively.

---

# University Database

This project implements a comprehensive database for managing various aspects of a university. It includes tables for departments, students, instructors, courses, enrollments, classrooms, schedules, clubs, scholarships, research projects, alumni, library books, attendance, feedback, advisors, prerequisites, and employment records.

## Table of Contents

- [Database Schema](#database-schema)
  - [Tables](#tables)
    - [Departments](#departments)
    - [Students](#students)
    - [Instructors](#instructors)
    - [Courses](#courses)
    - [Enrollments](#enrollments)
    - [CourseAssignments](#courseassignments)
    - [Classrooms](#classrooms)
    - [CourseSchedules](#courseschedules)
    - [DepartmentsInstructors](#departmentsinstructors)
    - [Clubs](#clubs)
    - [ClubMemberships](#clubmemberships)
    - [Scholarships](#scholarships)
    - [ScholarshipApplications](#scholarshipapplications)
    - [ResearchProjects](#researchprojects)
    - [ResearchTeamMembers](#researchteammembers)
    - [Alumni](#alumni)
    - [Donations](#donations)
    - [LibraryBooks](#librarybooks)
    - [BookLoans](#bookloans)
    - [Attendance](#attendance)
    - [Feedback](#feedback)
    - [StudentAdvisors](#studentadvisors)
    - [Prerequisites](#prerequisites)
    - [Employment](#employment)
- [Stored Procedures](#stored-procedures)
  - [GetStudentDetails](#getstudentdetails)
  - [AddNewStudent](#addnewstudent)
  - [GetInstructorCourses](#getinstructorcourses)
  - [GetCourseEnrollments](#getcourseenrollments)
  - [AddCourseEnrollment](#addcourseenrollment)
  - [AddInstructorToCourse](#addinstructortocourse)
  - [GetStudentEnrollmentHistory](#getstudentenrollmenthistory)
  - [GetCourseSchedule](#getcourseschedule)
  - [GetDepartmentInstructors](#getdepartmentinstructors)
  - [AddClubMembership](#addclubmembership)
  - [GetStudentClubMemberships](#getstudentclubmemberships)
  - [AddScholarshipApplication](#addscholarshipapplication)
  - [GetScholarshipApplications](#getscholarshipapplications)
  - [AddResearchTeamMember](#addresearchteammember)
  - [GetResearchProjectTeamMembers](#getresearchprojectteammembers)
  - [AddAlumniDonation](#addalumnidonation)
  - [GetAlumniDonations](#getalumnidonations)
  - [LoanLibraryBook](#loanlibrarybook)
  - [ReturnLibraryBook](#returnlibrarybook)
  - [RecordAttendance](#recordattendance)
  - [SubmitCourseFeedback](#submitcoursefeedback)
  - [AssignStudentAdvisor](#assignstudentadvisor)
  - [AddCoursePrerequisite](#addcourseprerequisite)
  - [AddEmploymentRecord](#addemploymentrecord)

## Database Schema

### Tables

#### Departments

- **DepartmentID** (INT, Primary Key, Identity)
- **DepartmentName** (VARCHAR(100), NOT NULL)
- **Location** (VARCHAR(100), NOT NULL)

#### Students

- **StudentID** (INT, Primary Key, Identity)
- **FirstName** (VARCHAR(50), NOT NULL)
- **LastName** (VARCHAR(50), NOT NULL)
- **DateOfBirth** (DATE, NOT NULL)
- **Gender** (VARCHAR(10))
- **Email** (VARCHAR(100), NOT NULL, UNIQUE)
- **Phone** (VARCHAR(20))
- **Address** (VARCHAR(255))
- **EnrollmentDate** (DATE, NOT NULL)
- **DepartmentID** (INT, Foreign Key)

#### Instructors

- **InstructorID** (INT, Primary Key, Identity)
- **FirstName** (VARCHAR(50), NOT NULL)
- **LastName** (VARCHAR(50), NOT NULL)
- **Email** (VARCHAR(100), NOT NULL, UNIQUE)
- **Phone** (VARCHAR(20))
- **HireDate** (DATE, NOT NULL)
- **DepartmentID** (INT, Foreign Key)

#### Courses

- **CourseID** (INT, Primary Key, Identity)
- **CourseName** (VARCHAR(100), NOT NULL)
- **CourseDescription** (TEXT)
- **Credits** (INT, NOT NULL)
- **DepartmentID** (INT, Foreign Key)

#### Enrollments

- **EnrollmentID** (INT, Primary Key, Identity)
- **StudentID** (INT, Foreign Key)
- **CourseID** (INT, Foreign Key)
- **EnrollmentDate** (DATE, NOT NULL)
- **Grade** (VARCHAR(2))

#### CourseAssignments

- **AssignmentID** (INT, Primary Key, Identity)
- **CourseID** (INT, Foreign Key)
- **InstructorID** (INT, Foreign Key)
- **AssignmentDate** (DATE, NOT NULL)

#### Classrooms

- **ClassroomID** (INT, Primary Key, Identity)
- **BuildingName** (VARCHAR(100), NOT NULL)
- **RoomNumber** (VARCHAR(10), NOT NULL)
- **Capacity** (INT, NOT NULL)

#### CourseSchedules

- **ScheduleID** (INT, Primary Key, Identity)
- **CourseID** (INT, Foreign Key)
- **ClassroomID** (INT, Foreign Key)
- **DayOfWeek** (VARCHAR(10), NOT NULL)
- **StartTime** (TIME, NOT NULL)
- **EndTime** (TIME, NOT NULL)

#### DepartmentsInstructors

- **DepartmentInstructorID** (INT, Primary Key, Identity)
- **DepartmentID** (INT, Foreign Key)
- **InstructorID** (INT, Foreign Key)

#### Clubs

- **ClubID** (INT, Primary Key, Identity)
- **ClubName** (VARCHAR(100), NOT NULL)
- **Description** (TEXT)
- **EstablishedDate** (DATE)

#### ClubMemberships

- **MembershipID** (INT, Primary Key, Identity)
- **StudentID** (INT, Foreign Key)
- **ClubID** (INT, Foreign Key)
- **MembershipDate** (DATE, NOT NULL)

#### Scholarships

- **ScholarshipID** (INT, Primary Key, Identity)
- **ScholarshipName** (VARCHAR(100), NOT NULL)
- **Amount** (DECIMAL(10, 2), NOT NULL)
- **EligibilityCriteria** (TEXT)
- **ApplicationDeadline** (DATE)

#### ScholarshipApplications

- **ApplicationID** (INT, Primary Key, Identity)
- **StudentID** (INT, Foreign Key)
- **ScholarshipID** (INT, Foreign Key)
- **ApplicationDate** (DATE, NOT NULL)
- **Status** (VARCHAR(50), NOT NULL)

#### ResearchProjects

- **ProjectID** (INT, Primary Key, Identity)
- **ProjectName** (VARCHAR(100), NOT NULL)
- **Description** (TEXT)
- **StartDate** (DATE, NOT NULL)
- **EndDate** (DATE)

#### ResearchTeamMembers

- **TeamMemberID** (INT, Primary Key, Identity)
- **FacultyID** (INT, Foreign Key)
- **ProjectID** (INT, Foreign Key)
- **AssignmentDate** (DATE, NOT NULL)

#### Alumni

- **AlumniID** (INT, Primary Key, Identity)
- **FirstName** (VARCHAR(50), NOT NULL)
- **LastName** (VARCHAR(50), NOT NULL)
- **DateOfBirth** (DATE, NOT NULL)
- **Gender** (VARCHAR(10))
- **Email** (VARCHAR(100), NOT NULL, UNIQUE)
- **Phone** (VARCHAR(20))
- **Address** (VARCHAR(255))
- **GraduationDate** (DATE, NOT NULL)
- **Degree** (VARCHAR(100))
- **DepartmentID** (INT, Foreign Key)

#### Donations

- **DonationID** (INT, Primary Key, Identity)
- **AlumniID** (INT, Foreign Key)
- **DonationAmount** (DECIMAL(10, 2), NOT NULL)
- **DonationDate** (DATE, NOT NULL)
- **Purpose** (VARCHAR(255))

#### LibraryBooks

- **BookID** (INT, Primary Key, Identity)
- **Title** (VARCHAR(255), NOT NULL)
- **Author** (VARCHAR(100))
- **ISBN** (VARCHAR(20), UNIQUE)
- **PublicationYear** (INT)
- **Publisher** (VARCHAR(100))

#### BookLoans

- **LoanID** (INT, Primary Key, Identity)
- **BookID** (INT, Foreign Key)
- **StudentID** (INT, Foreign Key)
- **LoanDate** (DATE, NOT NULL)
- **ReturnDate** (DATE)
- **Status** (VARCHAR(50), NOT NULL)

#### Attendance

- **AttendanceID** (INT, Primary Key, Identity)
- **StudentID** (INT, Foreign Key)
- **CourseID** (INT, Foreign Key)
- **AttendanceDate** (DATE, NOT NULL)
- **Status** (VARCHAR(50), NOT NULL)

#### Feedback

- **FeedbackID** (INT, Primary Key, Identity)
- **StudentID** (INT, Foreign Key)
- **CourseID

** (INT, Foreign Key)
- **InstructorID** (INT, Foreign Key)
- **FeedbackDate** (DATE, NOT NULL)
- **Comments** (TEXT)
- **Rating** (INT, NOT NULL CHECK (Rating >= 1 AND Rating <= 5))

#### StudentAdvisors

- **AdvisorID** (INT, Primary Key, Identity)
- **StudentID** (INT, Foreign Key)
- **FacultyID** (INT, Foreign Key)
- **AssignmentDate** (DATE, NOT NULL)

#### Prerequisites

- **PrerequisiteID** (INT, Primary Key, Identity)
- **CourseID** (INT, Foreign Key)
- **PrerequisiteCourseID** (INT, Foreign Key)

#### Employment

- **EmploymentID** (INT, Primary Key, Identity)
- **AlumniID** (INT, Foreign Key)
- **EmployerName** (VARCHAR(100), NOT NULL)
- **Position** (VARCHAR(100), NOT NULL)
- **StartDate** (DATE, NOT NULL)
- **EndDate** (DATE)
- **Salary** (DECIMAL(10, 2))

## Stored Procedures

### GetStudentDetails

Fetches details of a student by StudentID.

```sql
CREATE PROCEDURE GetStudentDetails
    @StudentID INT
AS
BEGIN
    SELECT * FROM Students WHERE StudentID = @StudentID;
END;
GO
```

### AddNewStudent

Adds a new student to the Students table.

```sql
CREATE PROCEDURE AddNewStudent
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DateOfBirth DATE,
    @Gender VARCHAR(10),
    @Email VARCHAR(100),
    @Phone VARCHAR(20),
    @Address VARCHAR(255),
    @EnrollmentDate DATE,
    @DepartmentID INT
AS
BEGIN
    INSERT INTO Students (FirstName, LastName, DateOfBirth, Gender, Email, Phone, Address, EnrollmentDate, DepartmentID)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Gender, @Email, @Phone, @Address, @EnrollmentDate, @DepartmentID);
END;
GO
```

### GetInstructorCourses

Fetches courses taught by an instructor.

```sql
CREATE PROCEDURE GetInstructorCourses
    @InstructorID INT
AS
BEGIN
    SELECT Courses.CourseID, Courses.CourseName, Courses.Credits
    FROM Courses
    INNER JOIN CourseAssignments ON Courses.CourseID = CourseAssignments.CourseID
    WHERE CourseAssignments.InstructorID = @InstructorID;
END;
GO
```

### GetCourseEnrollments

Fetches students enrolled in a course.

```sql
CREATE PROCEDURE GetCourseEnrollments
    @CourseID INT
AS
BEGIN
    SELECT Students.StudentID, Students.FirstName, Students.LastName, Enrollments.Grade
    FROM Enrollments
    INNER JOIN Students ON Enrollments.StudentID = Students.StudentID
    WHERE Enrollments.CourseID = @CourseID;
END;
GO
```

### AddCourseEnrollment

Enrolls a student in a course.

```sql
CREATE PROCEDURE AddCourseEnrollment
    @StudentID INT,
    @CourseID INT,
    @EnrollmentDate DATE
AS
BEGIN
    INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate)
    VALUES (@StudentID, @CourseID, @EnrollmentDate);
END;
GO
```

### AddInstructorToCourse

Assigns an instructor to a course.

```sql
CREATE PROCEDURE AddInstructorToCourse
    @InstructorID INT,
    @CourseID INT,
    @AssignmentDate DATE
AS
BEGIN
    INSERT INTO CourseAssignments (InstructorID, CourseID, AssignmentDate)
    VALUES (@InstructorID, @CourseID, @AssignmentDate);
END;
GO
```

### GetStudentEnrollmentHistory

Fetches enrollment history of a student.

```sql
CREATE PROCEDURE GetStudentEnrollmentHistory
    @StudentID INT
AS
BEGIN
    SELECT Courses.CourseName, Enrollments.EnrollmentDate, Enrollments.Grade
    FROM Enrollments
    INNER JOIN Courses ON Enrollments.CourseID = Courses.CourseID
    WHERE Enrollments.StudentID = @StudentID;
END;
GO
```

### GetCourseSchedule

Fetches schedule of a course.

```sql
CREATE PROCEDURE GetCourseSchedule
    @CourseID INT
AS
BEGIN
    SELECT CourseSchedules.DayOfWeek, CourseSchedules.StartTime, CourseSchedules.EndTime, Classrooms.BuildingName, Classrooms.RoomNumber
    FROM CourseSchedules
    INNER JOIN Classrooms ON CourseSchedules.ClassroomID = Classrooms.ClassroomID
    WHERE CourseSchedules.CourseID = @CourseID;
END;
GO
```

### GetDepartmentInstructors

Fetches instructors in a department.

```sql
CREATE PROCEDURE GetDepartmentInstructors
    @DepartmentID INT
AS
BEGIN
    SELECT Instructors.InstructorID, Instructors.FirstName, Instructors.LastName, Instructors.Email
    FROM Instructors
    WHERE Instructors.DepartmentID = @DepartmentID;
END;
GO
```

### AddClubMembership

Adds a student to a club.

```sql
CREATE PROCEDURE AddClubMembership
    @StudentID INT,
    @ClubID INT,
    @MembershipDate DATE
AS
BEGIN
    INSERT INTO ClubMemberships (StudentID, ClubID, MembershipDate)
    VALUES (@StudentID, @ClubID, @MembershipDate);
END;
GO
```

### GetStudentClubMemberships

Fetches club memberships of a student.

```sql
CREATE PROCEDURE GetStudentClubMemberships
    @StudentID INT
AS
BEGIN
    SELECT Clubs.ClubName, ClubMemberships.MembershipDate
    FROM ClubMemberships
    INNER JOIN Clubs ON ClubMemberships.ClubID = Clubs.ClubID
    WHERE ClubMemberships.StudentID = @StudentID;
END;
GO
```

### AddScholarshipApplication

Submits a scholarship application for a student.

```sql
CREATE PROCEDURE AddScholarshipApplication
    @StudentID INT,
    @ScholarshipID INT,
    @ApplicationDate DATE,
    @Status VARCHAR(50)
AS
BEGIN
    INSERT INTO ScholarshipApplications (StudentID, ScholarshipID, ApplicationDate, Status)
    VALUES (@StudentID, @ScholarshipID, @ApplicationDate, @Status);
END;
GO
```

### GetScholarshipApplications

Fetches scholarship applications of a student.

```sql
CREATE PROCEDURE GetScholarshipApplications
    @StudentID INT
AS
BEGIN
    SELECT Scholarships.ScholarshipName, ScholarshipApplications.ApplicationDate, ScholarshipApplications.Status
    FROM ScholarshipApplications
    INNER JOIN Scholarships ON ScholarshipApplications.ScholarshipID = Scholarships.ScholarshipID
    WHERE ScholarshipApplications.StudentID = @StudentID;
END;
GO
```

### AddResearchTeamMember

Adds a faculty member to a research project.

```sql
CREATE PROCEDURE AddResearchTeamMember
    @FacultyID INT,
    @ProjectID INT,
    @AssignmentDate DATE
AS
BEGIN
    INSERT INTO ResearchTeamMembers (FacultyID, ProjectID, AssignmentDate)
    VALUES (@FacultyID, @ProjectID, @AssignmentDate);
END;
GO
```

### GetResearchProjectTeamMembers

Fetches team members of a research project.

```sql
CREATE PROCEDURE GetResearchProjectTeamMembers
    @ProjectID INT
AS
BEGIN
    SELECT Instructors.FirstName, Instructors.LastName, ResearchTeamMembers.AssignmentDate
    FROM ResearchTeamMembers
    INNER JOIN Instructors ON ResearchTeamMembers.FacultyID = Instructors.InstructorID
    WHERE ResearchTeamMembers.ProjectID = @ProjectID;
END;
GO
```

### AddAlumniDonation

Records a donation from an alumnus.

```sql
CREATE PROCEDURE AddAlumniDonation
    @AlumniID INT,
    @DonationAmount DECIMAL(10, 2),
    @DonationDate DATE,
    @Purpose VARCHAR(255)
AS
BEGIN
    INSERT INTO Donations (AlumniID, DonationAmount, DonationDate, Purpose)
    VALUES (@AlumniID, @DonationAmount, @DonationDate, @Purpose);
END;
GO
```

### GetAlumniDonations

Fetches donations made by an alumnus.

```sql
CREATE PROCEDURE GetAlumniDonations
    @AlumniID INT
AS
BEGIN
    SELECT Donations.DonationAmount, Donations.DonationDate, Donations.Purpose
    FROM Donations
    WHERE Donations.AlumniID = @AlumniID;
END;
GO
```

### LoanLibraryBook

Records a library book loan.

```sql
CREATE PROCEDURE LoanLibraryBook
    @BookID INT,
    @StudentID INT,
    @LoanDate DATE
AS
BEGIN
    INSERT INTO BookLoans (BookID, StudentID, LoanDate, Status)
    VALUES (@BookID, @StudentID, @LoanDate, 'Loaned');
END;
GO
```

### ReturnLibraryBook

Records the return of a library book.

```sql
CREATE PROCEDURE ReturnLibraryBook
    @LoanID INT,
    @ReturnDate DATE
AS
BEGIN
    UPDATE BookLoans
    SET ReturnDate = @ReturnDate, Status = 'Returned'
    WHERE LoanID = @LoanID;
END;
GO
```

### RecordAttendance

Records attendance for a student in a course.

```sql
CREATE PROCEDURE RecordAttendance
    @StudentID INT,
    @CourseID INT,
    @AttendanceDate DATE,
    @Status VARCHAR(50)
AS
BEGIN
    INSERT INTO Attendance (StudentID, CourseID, AttendanceDate, Status)
    VALUES (@StudentID, @CourseID, @AttendanceDate, @Status);
END;
GO
```

### SubmitCourse

Feedback

Submits feedback for a course by a student.

```sql
CREATE PROCEDURE SubmitCourseFeedback
    @StudentID INT,
    @CourseID INT,
    @InstructorID INT,
    @FeedbackDate DATE,
    @Comments TEXT,
    @Rating INT
AS
BEGIN
    INSERT INTO Feedback (StudentID, CourseID, InstructorID, FeedbackDate, Comments, Rating)
    VALUES (@StudentID, @CourseID, @InstructorID, @FeedbackDate, @Comments, @Rating);
END;
GO
```

### AssignStudentAdvisor

Assigns an advisor to a student.

```sql
CREATE PROCEDURE AssignStudentAdvisor
    @StudentID INT,
    @FacultyID INT,
    @AssignmentDate DATE
AS
BEGIN
    INSERT INTO StudentAdvisors (StudentID, FacultyID, AssignmentDate)
    VALUES (@StudentID, @FacultyID, @AssignmentDate);
END;
GO
```

### AddCoursePrerequisite

Adds a prerequisite to a course.

```sql
CREATE PROCEDURE AddCoursePrerequisite
    @CourseID INT,
    @PrerequisiteCourseID INT
AS
BEGIN
    INSERT INTO Prerequisites (CourseID, PrerequisiteCourseID)
    VALUES (@CourseID, @PrerequisiteCourseID);
END;
GO
```

### AddEmploymentRecord

Adds an employment record for an alumnus.

```sql
CREATE PROCEDURE AddEmploymentRecord
    @AlumniID INT,
    @EmployerName VARCHAR(100),
    @Position VARCHAR(100),
    @StartDate DATE,
    @EndDate DATE,
    @Salary DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Employment (AlumniID, EmployerName, Position, StartDate, EndDate, Salary)
    VALUES (@AlumniID, @EmployerName, @Position, @StartDate, @EndDate, @Salary);
END;
GO
```

## Additional Information

- Ensure all foreign key constraints are properly defined and enforced.
- Maintain data integrity by using appropriate data types and constraints.
- Regularly back up the database to prevent data loss.
- Follow best practices for database design and optimization.

