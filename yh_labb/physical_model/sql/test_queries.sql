-- ============================================
-- QUERY 1: Class information with leader
-- ============================================
SELECT
    c.class_code AS "Class Code",
    p.program_name AS "Program",
    f.facility_name AS "Facility",
    CONCAT (el.first_name, ' ', el.last_name) AS "Educational Leader",
    c.start_date AS "Start Date",
    c.max_students AS "Max Students"
FROM
    CLASS c
    JOIN PROGRAM p ON c.program_id = p.program_id
    JOIN FACILITY f ON c.facility_id = f.facility_id
    JOIN EDUCATIONAL_LEADER el ON c.leader_id = el.leader_id
WHERE
    c.class_code = 'WU23-K1-STO';

-- ============================================
-- QUERY 2: Courses in a specific class
-- ============================================
SELECT
    c.class_code AS "Class Code",
    co.course_code AS "Course Code",
    co.course_name AS "Course Name",
    co.points AS "Points"
FROM
    CLASS c
    JOIN PROGRAM p ON c.program_id = p.program_id
    JOIN PROGRAM_COURSE pc ON p.program_id = pc.program_id
    JOIN COURSE co ON pc.course_id = co.course_id
WHERE
    c.class_code = 'WU23-K1-STO'
ORDER BY
    pc.course_order;

-- ============================================
-- QUERY 3: Educators teaching in a class
-- ============================================
SELECT
    c.class_code AS "Class Code",
    co.course_name AS "Course Name",
    CONCAT (e.first_name, ' ', e.last_name) AS "Educator",
    e.educator_type AS "Type",
    ec.hours_allocated AS "Hours"
FROM
    EDUCATOR_COURSE ec
    JOIN CLASS c ON ec.class_id = c.class_id
    JOIN COURSE co ON ec.course_id = co.course_id
    JOIN EDUCATOR e ON ec.educator_id = e.educator_id
WHERE
    c.class_code = 'WU23-K1-STO';

-- ============================================
-- QUERY 4: Students in a class
-- ============================================
SELECT
    c.class_code AS "Class Code",
    CONCAT (s.first_name, ' ', s.last_name) AS "Student Name",
    s.email AS "Email",
    s.status AS "Status"
FROM
    STUDENT s
    JOIN CLASS c ON s.class_id = c.class_id
WHERE
    c.class_code = 'WU23-K1-STO'
ORDER BY
    s.last_name;

-- ============================================
-- QUERY 5: Consultants with company info
-- ============================================
SELECT
    CONCAT (e.first_name, ' ', e.last_name) AS "Consultant Name",
    comp.company_name AS "Company",
    c.hourly_rate AS "Hourly Rate",
    c.contract_start AS "Contract Start"
FROM
    EDUCATOR e
    JOIN CONSULTANT c ON e.educator_id = c.educator_id
    JOIN COMPANY comp ON c.company_id = comp.company_id;