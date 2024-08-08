-- Stored Procedure to Get Instructor Schedule
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

    SELECT @AverageGrade = AVG(CASE Grade
        WHEN 'A' THEN 4.0
        WHEN 'A-' THEN 3.7
        WHEN 'B+' THEN 3.3
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
        WHEN 'C+' THEN 2.3
        WHEN 'C' THEN 2.0
        WHEN 'C-' THEN 1.7
        WHEN 'D+' THEN 1.3
        WHEN 'D' THEN 1.0
        WHEN 'F' THEN 0.0
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
    SELECT @GPA = AVG(CASE Grade
        WHEN 'A' THEN 4.0
        WHEN 'A-' THEN 3.7
        WHEN 'B+' THEN 3.3
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
        WHEN 'C+' THEN 2.3
        WHEN 'C' THEN 2.0
        WHEN 'C-' THEN 1.7
        WHEN 'D+' THEN 1.3
        WHEN 'D' THEN 1.0
        WHEN 'F' THEN 0.0
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
        SET 
            CourseID = @CourseID,
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

    SELECT @AverageGrade = AVG(CASE Grade
        WHEN 'A' THEN 4.0
        WHEN 'A-' THEN 3.7
        WHEN 'B+' THEN 3.3
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
        WHEN 'C+' THEN 2.3
        WHEN 'C' THEN 2.0
        WHEN 'C-' THEN 1.7
        WHEN 'D+' THEN 1.3
        WHEN 'D' THEN 1.0
        WHEN 'F' THEN 0.0
        ELSE NULL
    END)
    FROM Enrollments e
    JOIN Students s ON e.StudentID = s.StudentID
    WHERE s.DepartmentID = @DepartmentID;

    SELECT @AverageGrade AS DepartmentAverageGrade;
END;
GO
