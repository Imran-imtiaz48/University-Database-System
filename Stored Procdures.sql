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

