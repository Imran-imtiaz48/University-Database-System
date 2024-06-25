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