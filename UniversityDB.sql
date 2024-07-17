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
GO

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
GO

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
GO

-- Create the Courses table
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    CourseDescription TEXT,
    Credits INT NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

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
GO

-- Create the CourseAssignments table
CREATE TABLE CourseAssignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT,
    InstructorID INT,
    AssignmentDate DATE NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);
GO

-- Create the Classrooms table
CREATE TABLE Classrooms (
    ClassroomID INT IDENTITY(1,1) PRIMARY KEY,
    BuildingName VARCHAR(100) NOT NULL,
    RoomNumber VARCHAR(10) NOT NULL,
    Capacity INT NOT NULL
);
GO

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
GO

-- Create the DepartmentsInstructors table (many-to-many relationship between Departments and Instructors)
CREATE TABLE DepartmentsInstructors (
    DepartmentInstructorID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT,
    InstructorID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);
GO

-- Create the Degrees table
CREATE TABLE Degrees (
    DegreeID INT IDENTITY(1,1) PRIMARY KEY,
    DegreeName VARCHAR(100) NOT NULL,
    Level VARCHAR(50) NOT NULL, 
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

-- Create the DegreeRequirements table to specify required courses for each degree
CREATE TABLE DegreeRequirements (
    RequirementID INT IDENTITY(1,1) PRIMARY KEY,
    DegreeID INT,
    CourseID INT,
    FOREIGN KEY (DegreeID) REFERENCES Degrees(DegreeID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

-- Create the Prerequisites table to specify course prerequisites
CREATE TABLE Prerequisites (
    PrerequisiteID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT,
    PrerequisiteCourseID INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (PrerequisiteCourseID) REFERENCES Courses(CourseID)
);
GO

-- Create the StudentsCourses table to track courses taken by each student
CREATE TABLE StudentsCourses (
    StudentCourseID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

-- Create the Assignments table to track assignments for each course
CREATE TABLE Assignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT,
    AssignmentName VARCHAR(100) NOT NULL,
    Description TEXT,
    DueDate DATE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO

-- Create the Grades table to track grades for assignments
CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    StudentCourseID INT,
    AssignmentID INT,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentCourseID) REFERENCES StudentsCourses(StudentCourseID),
    FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID)
);
GO

-- Create the Events table to schedule university events
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName VARCHAR(100) NOT NULL,
    EventDate DATE,
    Location VARCHAR(100),
    Description TEXT
);
GO

-- Create the EventAttendees table to track attendees for events
CREATE TABLE EventAttendees (
    EventAttendeeID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT,
    StudentID INT,
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
GO

-- Create the Scholarships table
CREATE TABLE Scholarships (
    ScholarshipID INT IDENTITY(1,1) PRIMARY KEY,
    ScholarshipName VARCHAR(100) NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    EligibilityCriteria TEXT,
    ApplicationDeadline DATE
);
GO

-- Create the ScholarshipApplications table
CREATE TABLE ScholarshipApplications (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    ScholarshipID INT,
    StudentID INT,
    ApplicationDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL,  
    FOREIGN KEY (ScholarshipID) REFERENCES Scholarships(ScholarshipID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
GO

-- Create the LibraryBooks table
CREATE TABLE LibraryBooks (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255),
    ISBN VARCHAR(20) UNIQUE,
    PublicationYear INT,
    CopiesAvailable INT NOT NULL
);
GO

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
GO

-- Create the Clubs table
CREATE TABLE Clubs (
    ClubID INT IDENTITY(1,1) PRIMARY KEY,
    ClubName VARCHAR(100) NOT NULL,
    Description TEXT,
    PresidentID INT,
    FOREIGN KEY (PresidentID) REFERENCES Students(StudentID)
);
GO

-- Create the ClubMemberships table
CREATE TABLE ClubMemberships (
    MembershipID INT IDENTITY(1,1) PRIMARY KEY,
    ClubID INT,
    StudentID INT,
    JoinDate DATE NOT NULL,
    FOREIGN KEY (ClubID) REFERENCES Clubs(ClubID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
GO

-- Create the Faculty table
CREATE TABLE Faculty (
    FacultyID INT IDENTITY(1,1) PRIMARY KEY,
    FacultyName VARCHAR(100) NOT NULL,
    DeanID INT,
    FOREIGN KEY (DeanID) REFERENCES Instructors(InstructorID)
);
GO

-- Create the DepartmentsFaculty table (many-to-many relationship between Departments and Faculty)
CREATE TABLE DepartmentsFaculty (
    DepartmentFacultyID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT,
    FacultyID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID)
);
GO

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
GO

-- Create the ResearchTeamMembers table
CREATE TABLE ResearchTeamMembers (
    TeamMemberID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID INT,
    InstructorID INT,
    Role VARCHAR(100) NOT NULL,  
    FOREIGN KEY (ProjectID) REFERENCES ResearchProjects(ProjectID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);
GO

-- Create the Alumni table
CREATE TABLE Alumni (
    AlumniID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    GraduationYear INT NOT NULL,
    DegreeID INT,
    FOREIGN KEY (DegreeID) REFERENCES Degrees(DegreeID)
);
GO

-- Create the Donations table
CREATE TABLE Donations (
    DonationID INT IDENTITY(1,1) PRIMARY KEY,
    AlumniID INT,
    Amount DECIMAL(10, 2) NOT NULL,
    DonationDate DATE NOT NULL,
    FOREIGN KEY (AlumniID) REFERENCES Alumni(AlumniID)
);
GO

-- Create the AlumniEvents table
CREATE TABLE AlumniEvents (
    AlumniEventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName VARCHAR(100) NOT NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(100),
    Description TEXT
);
GO

-- Create the AlumniEventAttendees table
CREATE TABLE AlumniEventAttendees (
    AlumniEventAttendeeID INT IDENTITY(1,1) PRIMARY KEY,
    AlumniEventID INT,
    AlumniID INT,
    FOREIGN KEY (AlumniEventID) REFERENCES AlumniEvents(AlumniEventID),
    FOREIGN KEY (AlumniID) REFERENCES Alumni(AlumniID)
);
GO
