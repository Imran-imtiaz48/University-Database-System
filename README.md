University Database

This repository contains the schema and SQL scripts for a comprehensive university database. The database is designed to manage various aspects of university operations, including students, courses, departments, instructors, enrollments, and more.
Database Structure
The database schema consists of the following tables:
1.	Departments: Stores information about university departments.
2.	Students: Contains details about university students.
3.	Instructors: Stores information about university instructors.
4.	Courses: Manages details about university courses.
5.	Enrollments: Tracks student enrollments in courses.
6.	CourseAssignments: Assigns instructors to courses.
7.	Classrooms: Manages information about university classrooms.
8.	CourseSchedules: Specifies schedules for courses in classrooms.
9.	DepartmentsInstructors: Establishes a many-to-many relationship between departments and instructors.
10.	Degrees: Stores information about academic degrees offered by the university.
11.	DegreeRequirements: Defines required courses for each degree program.
12.	Prerequisites: Specifies course prerequisites.
13.	StudentsCourses: Tracks courses taken by students.
14.	Assignments: Manages assignments for courses.
15.	Grades: Tracks grades for assignments.
16.	Scholarships: Stores information about scholarships offered by the university.
17.	ScholarshipApplications: Tracks applications for scholarships.
18.	LibraryBooks: Manages the inventory of books in the university library.
19.	BookLoans: Tracks book loans to students.
20.	Clubs: Stores information about student clubs.
21.	ClubMemberships: Tracks student memberships in clubs.
22.	Faculty: Stores information about university faculty members.
23.	DepartmentsFaculty: Establishes a many-to-many relationship between departments and faculty.
24.	ResearchProjects: Manages research projects undertaken by the university.
25.	ResearchTeamMembers: Tracks members of research project teams.
26.	Alumni: Stores information about alumni of the university.
27.	Donations: Tracks donations made by alumni.
Stored Procedures
In addition to the database schema, the repository includes several stored procedures to facilitate complex operations within the university database:
1.	EnrollStudentInCourse: Enrolls a student in a course, checking prerequisites.
2.	CalculateStudentGPA: Calculates the GPA for a given student based on their grades.
3.	AssignInstructorToCourse: Assigns an instructor to a course, checking availability.
4.	GetStudentTranscript: Retrieves the transcript for a student, listing all courses and grades.
5.	AwardScholarship: Awards a scholarship to a student based on eligibility criteria.
Usage
To use this repository, follow these steps:
1.	Clone the Repository: Clone this repository to your local machine.

git clone https://github.com/your-username/university-database.git

2.	Set Up the Database: Execute the SQL scripts in your preferred SQL Server management tool to create the database schema and populate it with sample data (if available).
3.	Interact with the Database: Use SQL queries to interact with the database tables and execute stored procedures as needed for university operations.

Contributing
Contributions to improve and expand the functionality of this university database are welcome. Fork the repository, make your changes, and submit a pull request outlining your modifications.

