# University Database

This initiative aims to develop a comprehensive and integrated database system for a university environment. The proposed system will seamlessly connect departments, students, instructors, and other relevant stakeholders. By encompassing the management of academic data such as courses and enrollment, as well as co-curricular activities like clubs and alumni relations, this centralized platform will enhance administrative efficiency, ensure data accessibility, and empower informed decision-making across the university.

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
- **CourseID** (INT, Foreign Key)
- **InstructorID** (INT, Foreign Key)
- **FeedbackDate** (DATE

, NOT NULL)
- **Comments** (TEXT)

#### StudentAdvisors

- **AdvisorID** (INT, Primary Key, Identity)
- **StudentID** (INT, Foreign Key)
- **InstructorID** (INT, Foreign Key)
- **AssignmentDate** (DATE, NOT NULL)

#### Prerequisites

- **PrerequisiteID** (INT, Primary Key, Identity)
- **CourseID** (INT, Foreign Key)
- **PrerequisiteCourseID** (INT, Foreign Key)

#### Employment

- **EmploymentID** (INT, Primary Key, Identity)
- **StudentID** (INT, Foreign Key)
- **EmployerName** (VARCHAR(100), NOT NULL)
- **JobTitle** (VARCHAR(100), NOT NULL)
- **StartDate** (DATE, NOT NULL)
- **EndDate** (DATE)
- **JobDescription** (TEXT)

## Stored Procedures

### GetStudentDetails
Retrieves detailed information about a student, including personal details, enrolled courses, and club memberships.

```sql
CREATE PROCEDURE GetStudentDetails
    @StudentID INT
AS
BEGIN
    SELECT 
        S.StudentID, 
        S.FirstName, 
        S.LastName, 
        S.DateOfBirth, 
        S.Gender, 
        S.Email, 
        S.Phone, 
        S.Address, 
        S.EnrollmentDate, 
        D.DepartmentName
    FROM 
        Students S
        INNER JOIN Departments D ON S.DepartmentID = D.DepartmentID
    WHERE 
        S.StudentID = @StudentID;

    SELECT 
        E.CourseID, 
        C.CourseName, 
        E.EnrollmentDate, 
        E.Grade
    FROM 
        Enrollments E
        INNER JOIN Courses C ON E.CourseID = C.CourseID
    WHERE 
        E.StudentID = @StudentID;

    SELECT 
        CM.ClubID, 
        C.ClubName, 
        CM.MembershipDate
    FROM 
        ClubMemberships CM
        INNER JOIN Clubs C ON CM.ClubID = C.ClubID
    WHERE 
        CM.StudentID = @StudentID;
END;
```

### AddNewStudent
Inserts a new student record into the Students table.

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
```

### GetInstructorCourses
Retrieves all courses taught by a specific instructor.

```sql
CREATE PROCEDURE GetInstructorCourses
    @InstructorID INT
AS
BEGIN
    SELECT 
        CA.CourseID, 
        C.CourseName, 
        CA.AssignmentDate
    FROM 
        CourseAssignments CA
        INNER JOIN Courses C ON CA.CourseID = C.CourseID
    WHERE 
        CA.InstructorID = @InstructorID;
END;
```

### GetCourseEnrollments
Retrieves all students enrolled in a specific course.

```sql
CREATE PROCEDURE GetCourseEnrollments
    @CourseID INT
AS
BEGIN
    SELECT 
        E.StudentID, 
        S.FirstName, 
        S.LastName, 
        E.EnrollmentDate, 
        E.Grade
    FROM 
        Enrollments E
        INNER JOIN Students S ON E.StudentID = S.StudentID
    WHERE 
        E.CourseID = @CourseID;
END;
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
```

### GetStudentEnrollmentHistory
Retrieves a student's enrollment history.

```sql
CREATE PROCEDURE GetStudentEnrollmentHistory
    @StudentID INT
AS
BEGIN
    SELECT 
        E.CourseID, 
        C.CourseName, 
        E.EnrollmentDate, 
        E.Grade
    FROM 
        Enrollments E
        INNER JOIN Courses C ON E.CourseID = C.CourseID
    WHERE 
        E.StudentID = @StudentID;
END;
```

### GetCourseSchedule
Retrieves the schedule for a specific course.

```sql
CREATE PROCEDURE GetCourseSchedule
    @CourseID INT
AS
BEGIN
    SELECT 
        CS.DayOfWeek, 
        CS.StartTime, 
        CS.EndTime, 
        CL.BuildingName, 
        CL.RoomNumber
    FROM 
        CourseSchedules CS
        INNER JOIN Classrooms CL ON CS.ClassroomID = CL.ClassroomID
    WHERE 
        CS.CourseID = @CourseID;
END;
```

### GetDepartmentInstructors
Retrieves all instructors in a specific department.

```sql
CREATE PROCEDURE GetDepartmentInstructors
    @DepartmentID INT
AS
BEGIN
    SELECT 
        DI.InstructorID, 
        I.FirstName, 
        I.LastName, 
        I.Email, 
        I.Phone, 
        I.HireDate
    FROM 
        DepartmentsInstructors DI
        INNER JOIN Instructors I ON DI.InstructorID = I.InstructorID
    WHERE 
        DI.DepartmentID = @DepartmentID;
END;
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
```

### GetStudentClubMemberships
Retrieves all club memberships for a specific student.

```sql
CREATE PROCEDURE GetStudentClubMemberships
    @StudentID INT
AS
BEGIN
    SELECT 
        CM.ClubID, 
        C.ClubName, 
        CM.MembershipDate
    FROM 
        ClubMemberships CM
        INNER JOIN Clubs C ON CM.ClubID = C.ClubID
    WHERE 
        CM.StudentID = @StudentID;
END;
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
```

### GetScholarshipApplications
Retrieves all scholarship applications for a specific student.

```sql
CREATE PROCEDURE GetScholarshipApplications
    @StudentID INT
AS
BEGIN
    SELECT 
        SA.ScholarshipID, 
        S.ScholarshipName, 
        SA.ApplicationDate, 
        SA.Status
    FROM 
        ScholarshipApplications SA
        INNER JOIN Scholarships S ON SA.ScholarshipID = S.ScholarshipID
    WHERE 
        SA.StudentID = @StudentID;
END;
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
```

### GetResearchProjectTeamMembers
Retrieves all team members of a specific research project.

```sql
CREATE PROCEDURE GetResearchProjectTeamMembers
    @ProjectID INT
AS
BEGIN
    SELECT 
        RTM.FacultyID, 
        F.FirstName, 
        F.LastName, 
        F.Email, 
        RTM.AssignmentDate
    FROM 
        ResearchTeamMembers RTM
        INNER JOIN Faculty F ON RTM.FacultyID = F.FacultyID
    WHERE 
        RTM.ProjectID = @ProjectID;
END;
```

### AddAlumniDonation
Records a donation made by an alumni.

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
```

### GetAlumniDonations
Retrieves all donations made by a specific alumni.

```sql
CREATE PROCEDURE GetAlumniDonations
    @AlumniID INT
AS
BEGIN
    SELECT 
        D.DonationID, 
        D.D

onationAmount, 
        D.DonationDate, 
        D.Purpose
    FROM 
        Donations D
    WHERE 
        D.AlumniID = @AlumniID;
END;
```

This schema and set of procedures are designed to cover a wide range of functionalities for the university database management system. Adjustments and additions can be made to accommodate specific needs and requirements.
