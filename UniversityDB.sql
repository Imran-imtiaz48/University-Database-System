-- Create the university database
CREATE DATABASE university;
GO

-- Use the university database
USE university;
GO

-- Create the Departments table
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL
);

-- Create the Students table
CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10),
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(255),
    EnrollmentDate DATE NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create the Instructors table
CREATE TABLE Instructors (
    InstructorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    HireDate DATE NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create the Courses table
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    CourseDescription TEXT,
    Credits INT NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create the Enrollments table
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE NOT NULL,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Create the CourseAssignments table
CREATE TABLE CourseAssignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT,
    InstructorID INT,
    AssignmentDate DATE NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

-- Create the Classrooms table
CREATE TABLE Classrooms (
    ClassroomID INT IDENTITY(1,1) PRIMARY KEY,
    BuildingName VARCHAR(100) NOT NULL,
    RoomNumber VARCHAR(10) NOT NULL,
    Capacity INT NOT NULL
);

-- Create the CourseSchedules table
CREATE TABLE CourseSchedules (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT,
    ClassroomID INT,
    DayOfWeek VARCHAR(10) NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (ClassroomID) REFERENCES Classrooms(ClassroomID)
);

-- Create the DepartmentsInstructors table (many-to-many relationship between Departments and Instructors)
CREATE TABLE DepartmentsInstructors (
    DepartmentInstructorID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT,
    InstructorID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);
-- Create the Degrees table
CREATE TABLE Degrees (
    DegreeID INT IDENTITY(1,1) PRIMARY KEY,
    DegreeName VARCHAR(100) NOT NULL,
    Level VARCHAR(50) NOT NULL,  -- e.g., Bachelor's, Master's, PhD
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create the DegreeRequirements table to specify required courses for each degree
CREATE TABLE DegreeRequirements (
    RequirementID INT IDENTITY(1,1) PRIMARY KEY,
    DegreeID INT,
    CourseID INT,
    FOREIGN KEY (DegreeID) REFERENCES Degrees(DegreeID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Create the Prerequisites table to specify course prerequisites
CREATE TABLE Prerequisites (
    PrerequisiteID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT,
    PrerequisiteCourseID INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (PrerequisiteCourseID) REFERENCES Courses(CourseID)
);

-- Create the StudentsCourses table to track courses taken by each student
CREATE TABLE StudentsCourses (
    StudentCourseID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Create the Assignments table to track assignments for each course
CREATE TABLE Assignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT,
    AssignmentName VARCHAR(100) NOT NULL,
    Description TEXT,
    DueDate DATE,
    PRIMARY KEY (CourseID, AssignmentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Create the Grades table to track grades for assignments
CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    StudentCourseID INT,
    AssignmentID INT,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentCourseID) REFERENCES StudentsCourses(StudentCourseID),
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID)
);

-- Create the Events table to schedule university events
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName VARCHAR(100) NOT NULL,
    EventDate DATE,
    Location VARCHAR(100),
    Description TEXT
);

-- Create the EventAttendees table to track attendees for events
CREATE TABLE EventAttendees (
    EventAttendeeID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT,
    StudentID INT,
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
-- Create the Scholarships table
CREATE TABLE Scholarships (
    ScholarshipID INT IDENTITY(1,1) PRIMARY KEY,
    ScholarshipName VARCHAR(100) NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    EligibilityCriteria TEXT,
    ApplicationDeadline DATE
);

-- Create the ScholarshipApplications table
CREATE TABLE ScholarshipApplications (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    ScholarshipID INT,
    StudentID INT,
    ApplicationDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL,  -- e.g., Pending, Approved, Rejected
    FOREIGN KEY (ScholarshipID) REFERENCES Scholarships(ScholarshipID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
-- Create the LibraryBooks table
CREATE TABLE LibraryBooks (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255),
    ISBN VARCHAR(20) UNIQUE,
    PublicationYear INT,
    CopiesAvailable INT NOT NULL
);

-- Create the BookLoans table
CREATE TABLE BookLoans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    StudentID INT,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES LibraryBooks(BookID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- Create the Clubs table
CREATE TABLE Clubs (
    ClubID INT IDENTITY(1,1) PRIMARY KEY,
    ClubName VARCHAR(100) NOT NULL,
    Description TEXT,
    PresidentID INT,
    FOREIGN KEY (PresidentID) REFERENCES Students(StudentID)
);

-- Create the ClubMemberships table
CREATE TABLE ClubMemberships (
    MembershipID INT IDENTITY(1,1) PRIMARY KEY,
    ClubID INT,
    StudentID INT,
    JoinDate DATE NOT NULL,
    FOREIGN KEY (ClubID) REFERENCES Clubs(ClubID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- Create the Faculty table
CREATE TABLE Faculty (
    FacultyID INT IDENTITY(1,1) PRIMARY KEY,
    FacultyName VARCHAR(100) NOT NULL,
    DeanID INT,
    FOREIGN KEY (DeanID) REFERENCES Instructors(InstructorID)
);

-- Create the DepartmentsFaculty table (many-to-many relationship between Departments and Faculty)
CREATE TABLE DepartmentsFaculty (
    DepartmentFacultyID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT,
    FacultyID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID)
);

-- Create the ResearchProjects table
CREATE TABLE ResearchProjects (
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName VARCHAR(255) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    Budget DECIMAL(15, 2),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create the ResearchTeamMembers table
CREATE TABLE ResearchTeamMembers (
    TeamMemberID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID INT,
    InstructorID INT,
    Role VARCHAR(100) NOT NULL,  -- e.g., Principal Investigator, Co-Investigator
    FOREIGN KEY (ProjectID) REFERENCES ResearchProjects(ProjectID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

-- Create the Alumni table
CREATE TABLE Alumni (
    AlumniID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    GraduationYear INT NOT NULL,
    DegreeID INT,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(255),
    EmploymentStatus VARCHAR(100),
    FOREIGN KEY (DegreeID) REFERENCES Degrees(DegreeID)
);

-- Create the Donations table
CREATE TABLE Donations (
    DonationID INT IDENTITY(1,1) PRIMARY KEY,
    AlumniID INT,
    Amount DECIMAL(10, 2) NOT NULL,
    DonationDate DATE NOT NULL,
    Purpose VARCHAR(255),
    FOREIGN KEY (AlumniID) REFERENCES Alumni(AlumniID)
);

-- Stored Procedure to Enroll a Student in a Course
CREATE PROCEDURE EnrollStudentInCourse
    @StudentID INT,
    @CourseID INT,
    @EnrollmentDate DATE
AS
BEGIN
    DECLARE @HasPrerequisites BIT;

    -- Check if the student has completed all prerequisites
    SELECT @HasPrerequisites = CASE
        WHEN EXISTS (
            SELECT 1
            FROM Prerequisites p
            LEFT JOIN StudentsCourses sc ON p.PrerequisiteCourseID = sc.CourseID AND sc.StudentID = @StudentID
            WHERE p.CourseID = @CourseID AND (sc.Grade IS NULL OR sc.Grade IN ('F', 'D', 'D+'))
        )
        THEN 0
        ELSE 1
    END;

    IF @HasPrerequisites = 1
    BEGIN
        INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate)
        VALUES (@StudentID, @CourseID, @EnrollmentDate);
        PRINT 'Student enrolled successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Student does not meet the prerequisites for this course.';
    END
END;
GO

-- Stored Procedure to Calculate GPA for a Student
CREATE PROCEDURE CalculateStudentGPA
    @StudentID INT
AS
BEGIN
    DECLARE @GPA FLOAT;

    SELECT @GPA = AVG(CASE
        WHEN Grade = 'A' THEN 4.0
        WHEN Grade = 'A-' THEN 3.7
        WHEN Grade = 'B+' THEN 3.3
        WHEN Grade = 'B' THEN 3.0
        WHEN Grade = 'B-' THEN 2.7
        WHEN Grade = 'C+' THEN 2.3
        WHEN Grade = 'C' THEN 2.0
        WHEN Grade = 'C-' THEN 1.7
        WHEN Grade = 'D+' THEN 1.3
        WHEN Grade = 'D' THEN 1.0
        WHEN Grade = 'F' THEN 0.0
        ELSE NULL
    END)
    FROM Enrollments
    WHERE StudentID = @StudentID;

    SELECT @GPA AS GPA;
END;
GO

 -- Stored Procedure to Assign Instructor to a Course
 CREATE PROCEDURE AssignInstructorToCourse
    @InstructorID INT,
    @CourseID INT,
    @AssignmentDate DATE
AS
BEGIN
    DECLARE @InstructorAvailable BIT;

    -- Check if the instructor is already assigned to another course at the same time
    SELECT @InstructorAvailable = CASE
        WHEN EXISTS (
            SELECT 1
            FROM CourseAssignments ca
            JOIN CourseSchedules cs ON ca.CourseID = cs.CourseID
            WHERE ca.InstructorID = @InstructorID
            AND cs.DayOfWeek IN (
                SELECT cs2.DayOfWeek
                FROM CourseSchedules cs2
                WHERE cs2.CourseID = @CourseID
            )
            AND cs.StartTime <= (SELECT EndTime FROM CourseSchedules WHERE CourseID = @CourseID)
            AND cs.EndTime >= (SELECT StartTime FROM CourseSchedules WHERE CourseID = @CourseID)
        )
        THEN 0
        ELSE 1
    END;

    IF @InstructorAvailable = 1
    BEGIN
        INSERT INTO CourseAssignments (CourseID, InstructorID, AssignmentDate)
        VALUES (@CourseID, @InstructorID, @AssignmentDate);
        PRINT 'Instructor assigned to the course successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Instructor is not available at the scheduled times for this course.';
    END
END;
GO

-- Stored Procedure to Get Student Transcript
CREATE PROCEDURE GetStudentTranscript
    @StudentID INT
AS
BEGIN
    SELECT 
        c.CourseName,
        c.Credits,
        e.Grade,
        e.EnrollmentDate,
        d.DegreeName
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    LEFT JOIN DegreeRequirements dr ON c.CourseID = dr.CourseID
    LEFT JOIN Degrees d ON dr.DegreeID = d.DegreeID
    WHERE e.StudentID = @StudentID
    ORDER BY e.EnrollmentDate;
END;
GO

-- Stored Procedure to Award Scholarship to Student
CREATE PROCEDURE AwardScholarship
    @ScholarshipID INT,
    @StudentID INT,
    @AwardDate DATE
AS
BEGIN
    DECLARE @Eligibility BIT;

    -- Check if the student meets the eligibility criteria
    SELECT @Eligibility = CASE
        WHEN EXISTS (
            SELECT 1
            FROM ScholarshipApplications sa
            JOIN Scholarships s ON sa.ScholarshipID = s.ScholarshipID
            WHERE sa.StudentID = @StudentID
            AND sa.ScholarshipID = @ScholarshipID
            AND sa.Status = 'Approved'
        )
        THEN 1
        ELSE 0
    END;

    IF @Eligibility = 1
    BEGIN
        -- Award the scholarship
        INSERT INTO ScholarshipApplications (ScholarshipID, StudentID, ApplicationDate, Status)
        VALUES (@ScholarshipID, @StudentID, @AwardDate, 'Awarded');
        PRINT 'Scholarship awarded successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Student does not meet the eligibility criteria for this scholarship.';
    END
END;
GO
