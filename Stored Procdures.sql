--  Stored Procedure to Get Instructor's Schedule

CREATE PROCEDURE GetInstructorSchedule
    @InstructorID INT
AS
BEGIN
    SELECT 
        c.CourseName,
        cs.DayOfWeek,
        cs.StartTime,
        cs.EndTime,
        cl.BuildingName,
        cl.RoomNumber
    FROM CourseAssignments ca
    JOIN Courses c ON ca.CourseID = c.CourseID
    JOIN CourseSchedules cs ON c.CourseID = cs.CourseID
    JOIN Classrooms cl ON cs.ClassroomID = cl.ClassroomID
    WHERE ca.InstructorID = @InstructorID
    ORDER BY cs.DayOfWeek, cs.StartTime;
END;
GO

-- Stored Procedure to Calculate Departmental Average Grade

CREATE PROCEDURE CalculateDepartmentAverageGrade
    @DepartmentID INT
AS
BEGIN
    DECLARE @AverageGrade FLOAT;

    SELECT @AverageGrade = AVG(CASE
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
    FROM Enrollments e
    JOIN Students s ON e.StudentID = s.StudentID
    WHERE s.DepartmentID = @DepartmentID;

    SELECT @AverageGrade AS DepartmentAverageGrade;
END;
GO

-- Stored Procedure to Generate Student Report 

CREATE PROCEDURE GenerateStudentReport
    @StudentID INT
AS
BEGIN
    -- Student Details
    SELECT 
        FirstName,
        LastName,
        DateOfBirth,
        Gender,
        Email,
        Phone,
        Address,
        EnrollmentDate
    FROM Students
    WHERE StudentID = @StudentID;

    -- Enrolled Courses and Grades
    SELECT 
        c.CourseName,
        c.Credits,
        e.Grade
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE e.StudentID = @StudentID;

    -- GPA Calculation
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

-- Stored Procedure to Manage Course Schedules
CREATE PROCEDURE ManageCourseSchedule
    @ScheduleID INT = NULL,
    @CourseID INT,
    @ClassroomID INT,
    @DayOfWeek VARCHAR(10),
    @StartTime TIME,
    @EndTime TIME
AS
BEGIN
    IF @ScheduleID IS NULL
    BEGIN
        -- Insert new schedule
        INSERT INTO CourseSchedules (CourseID, ClassroomID, DayOfWeek, StartTime, EndTime)
        VALUES (@CourseID, @ClassroomID, @DayOfWeek, @StartTime, @EndTime);
    END
    ELSE
    BEGIN
        -- Update existing schedule
        UPDATE CourseSchedules
        SET CourseID = @CourseID,
            ClassroomID = @ClassroomID,
            DayOfWeek = @DayOfWeek,
            StartTime = @StartTime,
            EndTime = @EndTime
        WHERE ScheduleID = @ScheduleID;
    END
END;
GO

-- Stored Procedure to Generate Financial Aid Report

CREATE PROCEDURE GenerateFinancialAidReport
AS
BEGIN
    SELECT 
        s.FirstName,
        s.LastName,
        sch.ScholarshipName,
        sch.Amount,
        sa.ApplicationDate,
        sa.Status
    FROM ScholarshipApplications sa
    JOIN Scholarships sch ON sa.ScholarshipID = sch.ScholarshipID
    JOIN Students s ON sa.StudentID = s.StudentID
    WHERE sa.Status = 'Awarded'
    ORDER BY s.LastName, s.FirstName;
END;
GO

-- Stored Procedure to Assign Student to Dormitory

CREATE PROCEDURE AssignStudentToDormitory
    @StudentID INT,
    @DormitoryID INT,
    @RoomNumber VARCHAR(10)
AS
BEGIN
    DECLARE @CurrentOccupancy INT;
    DECLARE @RoomCapacity INT;

    -- Check current occupancy
    SELECT @CurrentOccupancy = COUNT(*)
    FROM DormitoryAssignments
    WHERE DormitoryID = @DormitoryID AND RoomNumber = @RoomNumber;

    -- Get room capacity
    SELECT @RoomCapacity = Capacity
    FROM DormitoryRooms
    WHERE DormitoryID = @DormitoryID AND RoomNumber = @RoomNumber;

    IF @CurrentOccupancy < @RoomCapacity
    BEGIN
        INSERT INTO DormitoryAssignments (StudentID, DormitoryID, RoomNumber)
        VALUES (@StudentID, @DormitoryID, @RoomNumber);
        PRINT 'Student assigned to dormitory successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Room capacity exceeded. Cannot assign student to this room.';
    END
END;
GO

-- Stored Procedure to Retrieve Research Project Details

CREATE PROCEDURE GetResearchProjectDetails
    @ProjectID INT
AS
BEGIN
    -- Project Details
    SELECT 
        ProjectName,
        StartDate,
        EndDate,
        Budget
    FROM ResearchProjects
    WHERE ProjectID = @ProjectID;

    -- Team Members
    SELECT 
        i.FirstName,
        i.LastName,
        rtm.Role
    FROM ResearchTeamMembers rtm
    JOIN Instructors i ON rtm.InstructorID = i.InstructorID
    WHERE rtm.ProjectID = @ProjectID;
END;
GO

-- Stored Procedure to Add a New Course with Prerequisites
CREATE PROCEDURE AddCourseWithPrerequisites
    @CourseName VARCHAR(100),
    @CourseDescription TEXT,
    @Credits INT,
    @DepartmentID INT,
    @Prerequisites TABLE (PrerequisiteCourseID INT)
AS
BEGIN
    DECLARE @CourseID INT;

    -- Insert new course
    INSERT INTO Courses (CourseName, CourseDescription, Credits, DepartmentID)
    VALUES (@CourseName, @CourseDescription, @Credits, @DepartmentID);

    -- Get the new CourseID
    SET @CourseID = SCOPE_IDENTITY();

    -- Insert prerequisites
    INSERT INTO Prerequisites (CourseID, PrerequisiteCourseID)
    SELECT @CourseID, PrerequisiteCourseID
    FROM @Prerequisites;
END;
GO

-- Stored Procedure to Retrieve Course Enrollment Details
CREATE PROCEDURE GetCourseEnrollmentDetails
    @CourseID INT
AS
BEGIN
    SELECT 
        s.StudentID,
        s.FirstName,
        s.LastName,
        e.EnrollmentDate,
        e.Grade
    FROM Enrollments e
    JOIN Students s ON e.StudentID = s.StudentID
    WHERE e.CourseID = @CourseID
    ORDER BY s.LastName, s.FirstName;
END;
GO

-- Stored Procedure to Update Student Information
CREATE PROCEDURE UpdateStudentInfo
    @StudentID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DateOfBirth DATE,
    @Gender VARCHAR(10),
    @Email VARCHAR(100),
    @Phone VARCHAR(20),
    @Address VARCHAR(255)
AS
BEGIN
    UPDATE Students
    SET
        FirstName = @FirstName,
        LastName = @LastName,
        DateOfBirth = @DateOfBirth,
        Gender = @Gender,
        Email = @Email,
        Phone = @Phone,
        Address = @Address
    WHERE StudentID = @StudentID;
END;
GO

-- Stored Procedure to Retrieve Course Prerequisites
CREATE PROCEDURE GetCoursePrerequisites
    @CourseID INT
AS
BEGIN
    SELECT 
        p.PrerequisiteCourseID,
        c.CourseName
    FROM Prerequisites p
    JOIN Courses c ON p.PrerequisiteCourseID = c.CourseID
    WHERE p.CourseID = @CourseID;
END;
GO

-- Stored Procedure to Generate Department Report
CREATE PROCEDURE GenerateDepartmentReport
    @DepartmentID INT
AS
BEGIN
    -- Department Courses
    SELECT 
        CourseID,
        CourseName,
        Credits
    FROM Courses
    WHERE DepartmentID = @DepartmentID;

    -- Department Instructors
    SELECT 
        i.InstructorID,
        i.FirstName,
        i.LastName,
        i.Email
    FROM Instructors i
    JOIN DepartmentsInstructors di ON i.InstructorID = di.InstructorID
    WHERE di.DepartmentID = @DepartmentID;

    -- Department Average Grade
    DECLARE @AverageGrade FLOAT;
    SELECT @AverageGrade = AVG(CASE
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
    FROM Enrollments e
    JOIN Students s ON e.StudentID = s.StudentID
    WHERE s.DepartmentID = @DepartmentID;

    SELECT @AverageGrade AS DepartmentAverageGrade;
END;
GO

-- Stored Procedure to Assign Student to Club

CREATE PROCEDURE AssignStudentToClub
    @StudentID INT,
    @ClubID INT,
    @MembershipDate DATE
AS
BEGIN
    DECLARE @IsMember BIT;

    -- Check if the student is already a member
    SELECT @IsMember = CASE
        WHEN EXISTS (
            SELECT 1
            FROM ClubMemberships
            WHERE StudentID = @StudentID AND ClubID = @ClubID
        )
        THEN 1
        ELSE 0
    END;

    IF @IsMember = 0
    BEGIN
        -- Assign student to the club
        INSERT INTO ClubMemberships (StudentID, ClubID, MembershipDate)
        VALUES (@StudentID, @ClubID, @MembershipDate);
        PRINT 'Student assigned to the club successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Student is already a member of this club.';
    END
END;
GO

-- Stored Procedure to Retrieve Alumni Donations

CREATE PROCEDURE GetAlumniDonations
    @AlumniID INT
AS
BEGIN
    SELECT 
        DonationID,
        DonationAmount,
        DonationDate,
        Purpose
    FROM Donations
    WHERE AlumniID = @AlumniID
    ORDER BY DonationDate;
END;
GO

-- Stored Procedure to Calculate Course Completion Rate

CREATE PROCEDURE CalculateCourseCompletionRate
    @CourseID INT
AS
BEGIN
    DECLARE @TotalEnrolled INT;
    DECLARE @TotalCompleted INT;
    DECLARE @CompletionRate FLOAT;

    -- Total students enrolled
    SELECT @TotalEnrolled = COUNT(*)
    FROM Enrollments
    WHERE CourseID = @CourseID;

    -- Total students completed (assuming grades other than 'F' are considered as completed)
    SELECT @TotalCompleted = COUNT(*)
    FROM Enrollments
    WHERE CourseID = @CourseID AND Grade <> 'F';

    -- Calculate completion rate
    SET @CompletionRate = CASE
        WHEN @TotalEnrolled = 0 THEN 0
        ELSE CAST(@TotalCompleted AS FLOAT) / @TotalEnrolled * 100
    END;

    SELECT @CompletionRate AS CompletionRate;
END;
GO

-- Stored Procedure to Calculate Instructor Workload
CREATE PROCEDURE CalculateInstructorWorkload
    @InstructorID INT,
    @Semester VARCHAR(20)
AS
BEGIN
    SELECT 
        i.InstructorID,
        i.FirstName,
        i.LastName,
        COUNT(ca.CourseID) AS TotalCourses
    FROM Instructors i
    JOIN CourseAssignments ca ON i.InstructorID = ca.InstructorID
    JOIN Courses c ON ca.CourseID = c.CourseID
    JOIN CourseSchedules cs ON c.CourseID = cs.CourseID
    WHERE i.InstructorID = @InstructorID
      AND cs.Semester = @Semester
    GROUP BY i.InstructorID, i.FirstName, i.LastName;
END;
GO

-- Stored Procedure to Generate Course Attendance Report
CREATE PROCEDURE GenerateCourseAttendanceReport
    @CourseID INT
AS
BEGIN
    SELECT 
        s.StudentID,
        s.FirstName,
        s.LastName,
        a.AttendanceDate,
        a.Status
    FROM Attendance a
    JOIN Students s ON a.StudentID = s.StudentID
    WHERE a.CourseID = @CourseID
    ORDER BY s.LastName, s.FirstName, a.AttendanceDate;
END;
GO

-- Stored Procedure to Update Instructor Contact Information
CREATE PROCEDURE UpdateInstructorContactInfo
    @InstructorID INT,
    @Email VARCHAR(100),
    @Phone VARCHAR(20)
AS
BEGIN
    UPDATE Instructors
    SET
        Email = @Email,
        Phone = @Phone
    WHERE InstructorID = @InstructorID;
END;
GO

-- Stored Procedure to Retrieve Library Book Loan History
CREATE PROCEDURE GetBookLoanHistory
    @BookID INT
AS
BEGIN
    SELECT 
        bl.LoanID,
        s.StudentID,
        s.FirstName,
        s.LastName,
        bl.LoanDate,
        bl.ReturnDate,
        bl.Status
    FROM BookLoans bl
    JOIN Students s ON bl.StudentID = s.StudentID
    WHERE bl.BookID = @BookID
    ORDER BY bl.LoanDate;
END;
GO

-- Stored Procedure to Calculate Scholarship Distribution
CREATE PROCEDURE CalculateScholarshipDistribution
AS
BEGIN
    SELECT 
        d.DepartmentID,
        d.DepartmentName,
        SUM(sch.Amount) AS TotalScholarshipAmount
    FROM Scholarships sch
    JOIN ScholarshipApplications sa ON sch.ScholarshipID = sa.ScholarshipID
    JOIN Students s ON sa.StudentID = s.StudentID
    JOIN Departments d ON s.DepartmentID = d.DepartmentID
    WHERE sa.Status = 'Awarded'
    GROUP BY d.DepartmentID, d.DepartmentName
    ORDER BY TotalScholarshipAmount DESC;
END;
GO

-- Stored Procedure to Assign Faculty to Research Project
CREATE PROCEDURE AssignFacultyToResearchProject
    @FacultyID INT,
    @ProjectID INT
AS
BEGIN
    DECLARE @HasConflict BIT;

    -- Check for scheduling conflicts
    SELECT @HasConflict = CASE
        WHEN EXISTS (
            SELECT 1
            FROM ResearchTeamMembers rtm
            JOIN ResearchProjects rp ON rtm.ProjectID = rp.ProjectID
            WHERE rtm.FacultyID = @FacultyID
              AND rp.ProjectID = @ProjectID
        )
        THEN 1
        ELSE 0
    END;

    IF @HasConflict = 0
    BEGIN
        INSERT INTO ResearchTeamMembers (FacultyID, ProjectID)
        VALUES (@FacultyID, @ProjectID);
        PRINT 'Faculty member assigned to research project successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Scheduling conflict detected. Cannot assign faculty member to this research project.';
    END
END;
GO

-- Stored Procedure to Generate Instructor Performance Report
CREATE PROCEDURE GenerateInstructorPerformanceReport
    @InstructorID INT
AS
BEGIN
    -- Instructor Details
    SELECT 
        FirstName,
        LastName,
        Email,
        Phone,
        HireDate
    FROM Instructors
    WHERE InstructorID = @InstructorID;

    -- Course Feedback and Ratings
    SELECT 
        c.CourseName,
        f.FeedbackDate,
        f.Comments,
        f.Rating
    FROM Feedback f
    JOIN Courses c ON f.CourseID = c.CourseID
    WHERE f.InstructorID = @InstructorID
    ORDER BY f.FeedbackDate;

    -- Average Rating
    DECLARE @AverageRating FLOAT;
    SELECT @AverageRating = AVG(f.Rating)
    FROM Feedback f
    WHERE f.InstructorID = @InstructorID;

    SELECT @AverageRating AS AverageRating;
END;
GO


-- Stored Procedure to Assign Student Advisor
CREATE PROCEDURE AssignStudentAdvisor
    @StudentID INT,
    @FacultyID INT
AS
BEGIN
    -- Check if the student already has an advisor
    IF EXISTS (SELECT 1 FROM StudentAdvisors WHERE StudentID = @StudentID)
    BEGIN
        -- Update the existing advisor
        UPDATE StudentAdvisors
        SET FacultyID = @FacultyID
        WHERE StudentID = @StudentID;
        PRINT 'Student advisor updated successfully.';
    END
    ELSE
    BEGIN
        -- Assign a new advisor
        INSERT INTO StudentAdvisors (StudentID, FacultyID)
        VALUES (@StudentID, @FacultyID);
        PRINT 'Student advisor assigned successfully.';
    END
END;
GO

-- Stored Procedure to Generate Alumni Employment Report
CREATE PROCEDURE GenerateAlumniEmploymentReport
AS
BEGIN
    SELECT 
        a.AlumniID,
        a.FirstName,
        a.LastName,
        e.EmployerName,
        e.Position,
        e.StartDate,
        e.Salary
    FROM Alumni a
    JOIN Employment e ON a.AlumniID = e.AlumniID
    ORDER BY a.LastName, a.FirstName;
END;
GO

-- Stored Procedure to Update Course Credits
CREATE PROCEDURE UpdateCourseCredits
    @CourseID INT,
    @NewCredits INT
AS
BEGIN
    UPDATE Courses
    SET Credits = @NewCredits
    WHERE CourseID = @CourseID;
END;
GO

-- Stored Procedure to Generate Class Roster
CREATE PROCEDURE GenerateClassRoster
    @CourseID INT
AS
BEGIN
    SELECT 
        s.StudentID,
        s.FirstName,
        s.LastName,
        s.Email,
        s.Phone
    FROM Enrollments e
    JOIN Students s ON e.StudentID = s.StudentID
    WHERE e.CourseID = @CourseID
    ORDER BY s.LastName, s.FirstName;
END;
GO

-- Stored Procedure to Generate Faculty Research Report
CREATE PROCEDURE GenerateFacultyResearchReport
    @FacultyID INT
AS
BEGIN
    SELECT 
        rp.ProjectID,
        rp.ProjectName,
        rp.StartDate,
        rp.EndDate,
        rp.Status
    FROM ResearchTeamMembers rtm
    JOIN ResearchProjects rp ON rtm.ProjectID = rp.ProjectID
    WHERE rtm.FacultyID = @FacultyID
    ORDER BY rp.StartDate;
END;
GO

-- Stored Procedure to Retrieve Student's Academic Transcript
CREATE PROCEDURE GetStudentTranscript
    @StudentID INT
AS
BEGIN
    SELECT 
        c.CourseName,
        e.EnrollmentDate,
        e.Grade,
        c.Credits
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE e.StudentID = @StudentID
    ORDER BY e.EnrollmentDate;

    -- Calculate GPA
    DECLARE @TotalCredits INT;
    DECLARE @TotalPoints FLOAT;
    DECLARE @GPA FLOAT;

    SELECT 
        @TotalCredits = SUM(c.Credits),
        @TotalPoints = SUM(CASE
            WHEN e.Grade = 'A' THEN 4.0 * c.Credits
            WHEN e.Grade = 'A-' THEN 3.7 * c.Credits
            WHEN e.Grade = 'B+' THEN 3.3 * c.Credits
            WHEN e.Grade = 'B' THEN 3.0 * c.Credits
            WHEN e.Grade = 'B-' THEN 2.7 * c.Credits
            WHEN e.Grade = 'C+' THEN 2.3 * c.Credits
            WHEN e.Grade = 'C' THEN 2.0 * c.Credits
            WHEN e.Grade = 'C-' THEN 1.7 * c.Credits
            WHEN e.Grade = 'D+' THEN 1.3 * c.Credits
            WHEN e.Grade = 'D' THEN 1.0 * c.Credits
            WHEN e.Grade = 'F' THEN 0.0 * c.Credits
            ELSE 0.0
        END)
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE e.StudentID = @StudentID;

    SET @GPA = CASE
        WHEN @TotalCredits = 0 THEN 0
        ELSE @TotalPoints / @TotalCredits
    END;

    SELECT @GPA AS GPA;
END;
GO

-- Stored Procedure to Assign Multiple Students to a Course
CREATE PROCEDURE AssignStudentsToCourse
    @CourseID INT,
    @StudentIDs dbo.IntList READONLY,
    @EnrollmentDate DATE
AS
BEGIN
    INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate)
    SELECT StudentID, @CourseID, @EnrollmentDate
    FROM @StudentIDs;
END;
GO

-- Stored Procedure to Generate Comprehensive Student Profile
CREATE PROCEDURE GenerateStudentProfile
    @StudentID INT
AS
BEGIN
    -- Personal Details
    SELECT 
        FirstName,
        LastName,
        DateOfBirth,
        Gender,
        Email,
        Phone,
        Address,
        EnrollmentDate
    FROM Students
    WHERE StudentID = @StudentID;

    -- Enrollment Information
    SELECT 
        c.CourseName,
        e.EnrollmentDate,
        e.Grade,
        c.Credits
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE e.StudentID = @StudentID
    ORDER BY e.EnrollmentDate;

    -- Calculate GPA
    DECLARE @TotalCredits INT;
    DECLARE @TotalPoints FLOAT;
    DECLARE @GPA FLOAT;

    SELECT 
        @TotalCredits = SUM(c.Credits),
        @TotalPoints = SUM(CASE
            WHEN e.Grade = 'A' THEN 4.0 * c.Credits
            WHEN e.Grade = 'A-' THEN 3.7 * c.Credits
            WHEN e.Grade = 'B+' THEN 3.3 * c.Credits
            WHEN e.Grade = 'B' THEN 3.0 * c.Credits
            WHEN e.Grade = 'B-' THEN 2.7 * c.Credits
            WHEN e.Grade = 'C+' THEN 2.3 * c.Credits
            WHEN e.Grade = 'C' THEN 2.0 * c.Credits
            WHEN e.Grade = 'C-' THEN 1.7 * c.Credits
            WHEN e.Grade = 'D+' THEN 1.3 * c.Credits
            WHEN e.Grade = 'D' THEN 1.0 * c.Credits
            WHEN e.Grade = 'F' THEN 0.0 * c.Credits
            ELSE 0.0
        END)
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE e.StudentID = @StudentID;

    SET @GPA = CASE
        WHEN @TotalCredits = 0 THEN 0
        ELSE @TotalPoints / @TotalCredits
    END;

    SELECT @GPA AS GPA;
END;
GO

-- Stored Procedure to Assign Multiple Instructors to a Course
CREATE PROCEDURE AssignInstructorsToCourse
    @CourseID INT,
    @InstructorIDs dbo.IntList READONLY,
    @AssignmentDate DATE
AS
BEGIN
    INSERT INTO CourseAssignments (CourseID, InstructorID, AssignmentDate)
    SELECT @CourseID, InstructorID, @AssignmentDate
    FROM @InstructorIDs;
END;
GO

-- Stored Procedure to Retrieve Courses Taught by Instructor
CREATE PROCEDURE GetCoursesTaughtByInstructor
    @InstructorID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        c.CourseID,
        c.CourseName,
        cs.DayOfWeek,
        cs.StartTime,
        cs.EndTime
    FROM CourseAssignments ca
    JOIN Courses c ON ca.CourseID = c.CourseID
    JOIN CourseSchedules cs ON c.CourseID = cs.CourseID
    WHERE ca.InstructorID = @InstructorID
      AND cs.StartDate >= @StartDate
      AND cs.EndDate <= @EndDate
    ORDER BY cs.StartDate;
END;
GO

-- Stored Procedure to Track Course Material Distribution
CREATE PROCEDURE TrackCourseMaterialDistribution
    @CourseID INT,
    @StudentID INT,
    @MaterialName VARCHAR(255),
    @DistributionDate DATE
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM CourseMaterials
        WHERE CourseID = @CourseID
          AND StudentID = @StudentID
          AND MaterialName = @MaterialName
    )
    BEGIN
        INSERT INTO CourseMaterials (CourseID, StudentID, MaterialName, DistributionDate)
        VALUES (@CourseID, @StudentID, @MaterialName, @DistributionDate);
        PRINT 'Material distributed successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Material already distributed to this student.';
    END
END;
GO

-- Stored Procedure to Calculate Department GPA
CREATE PROCEDURE CalculateDepartmentGPA
    @DepartmentID INT
AS
BEGIN
    DECLARE @TotalCredits INT;
    DECLARE @TotalPoints FLOAT;
    DECLARE @GPA FLOAT;

    SELECT 
        @TotalCredits = SUM(c.Credits),
        @TotalPoints = SUM(CASE
            WHEN e.Grade = 'A' THEN 4.0 * c.Credits
            WHEN e.Grade = 'A-' THEN 3.7 * c.Credits
            WHEN e.Grade = 'B+' THEN 3.3 * c.Credits
            WHEN e.Grade = 'B' THEN 3.0 * c.Credits
            WHEN e.Grade = 'B-' THEN 2.7 * c.Credits
            WHEN e.Grade = 'C+' THEN 2.3 * c
