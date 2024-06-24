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
