-- Create FACILITY table
CREATE TABLE
    IF NOT EXISTS FACILITY (
        facility_id SERIAL PRIMARY KEY,
        facility_name VARCHAR(100) NOT NULL,
        city VARCHAR(50) NOT NULL,
        address VARCHAR(200),
        is_active BOOLEAN NOT NULL DEFAULT TRUE
    );

-- Create COMPANY table
CREATE TABLE
    IF NOT EXISTS COMPANY (
        company_id SERIAL PRIMARY KEY,
        company_name VARCHAR(100) NOT NULL,
        org_number VARCHAR(20) NOT NULL UNIQUE,
        has_f_tax BOOLEAN NOT NULL,
        address VARCHAR(200),
        contact_person VARCHAR(100),
        contact_email VARCHAR(100),
        contact_phone VARCHAR(20)
    );

-- Create EDUCATIONAL_LEADER table
CREATE TABLE
    IF NOT EXISTS EDUCATIONAL_LEADER (
        leader_id SERIAL PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        phone VARCHAR(20)
    );

-- Create EDUCATOR table
CREATE TABLE
    IF NOT EXISTS EDUCATOR (
        educator_id SERIAL PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        phone VARCHAR(20),
        educator_type VARCHAR(20) NOT NULL CHECK (educator_type IN ('CONSULTANT', 'PERMANENT'))
    );

-- Create CONSULTANT table (subtype)
CREATE TABLE
    IF NOT EXISTS CONSULTANT (
        consultant_id SERIAL PRIMARY KEY,
        educator_id INTEGER NOT NULL UNIQUE,
        company_id INTEGER NOT NULL,
        hourly_rate NUMERIC(10, 2) NOT NULL,
        contract_start DATE NOT NULL,
        contract_end DATE,
        FOREIGN KEY (educator_id) REFERENCES EDUCATOR (educator_id),
        FOREIGN KEY (company_id) REFERENCES COMPANY (company_id)
    );

-- Create PERMANENT_EDUCATOR table (subtype - BONUS)
CREATE TABLE
    IF NOT EXISTS PERMANENT_EDUCATOR (
        permanent_id SERIAL PRIMARY KEY,
        educator_id INTEGER NOT NULL UNIQUE,
        facility_id INTEGER NOT NULL,
        hire_date DATE NOT NULL,
        employment_type VARCHAR(20) NOT NULL CHECK (employment_type IN ('FULL_TIME', 'PART_TIME')),
        FOREIGN KEY (educator_id) REFERENCES EDUCATOR (educator_id),
        FOREIGN KEY (facility_id) REFERENCES FACILITY (facility_id)
    );

-- Create PROGRAM table (FIXED TYPO!)
CREATE TABLE
    IF NOT EXISTS PROGRAM (
        program_id SERIAL PRIMARY KEY,
        program_code VARCHAR(20) NOT NULL UNIQUE,
        program_name VARCHAR(100) NOT NULL,
        description TEXT,
        total_points INTEGER NOT NULL,
        is_active BOOLEAN NOT NULL DEFAULT TRUE
    );

-- Create COURSE table
CREATE TABLE
    IF NOT EXISTS COURSE (
        course_id SERIAL PRIMARY KEY,
        course_code VARCHAR(20) NOT NULL UNIQUE,
        course_name VARCHAR(100) NOT NULL,
        description TEXT,
        points INTEGER NOT NULL
    );

-- Create CLASS table
CREATE TABLE
    IF NOT EXISTS CLASS (
        class_id SERIAL PRIMARY KEY,
        class_code VARCHAR(20) NOT NULL UNIQUE,
        program_id INTEGER NOT NULL,
        facility_id INTEGER NOT NULL,
        leader_id INTEGER NOT NULL,
        cohort_number INTEGER NOT NULL CHECK (cohort_number IN (1, 2, 3)),
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        max_students INTEGER NOT NULL,
        FOREIGN KEY (program_id) REFERENCES PROGRAM (program_id),
        FOREIGN KEY (facility_id) REFERENCES FACILITY (facility_id),
        FOREIGN KEY (leader_id) REFERENCES EDUCATIONAL_LEADER (leader_id),
        UNIQUE (program_id, cohort_number)
    );

-- Create STUDENT table
CREATE TABLE
    IF NOT EXISTS STUDENT (
        student_id SERIAL PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        phone VARCHAR(20),
        class_id INTEGER,
        enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
        status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
        FOREIGN KEY (class_id) REFERENCES CLASS (class_id)
    );

-- Create SENSITIVE_DATA table
CREATE TABLE
    IF NOT EXISTS SENSITIVE_DATA (
        sensitive_id SERIAL PRIMARY KEY,
        student_id INTEGER NOT NULL UNIQUE,
        personnummer VARCHAR(13) NOT NULL UNIQUE,
        address VARCHAR(200),
        FOREIGN KEY (student_id) REFERENCES STUDENT (student_id)
    );

-- Create PROGRAM_COURSE junction table
CREATE TABLE
    IF NOT EXISTS PROGRAM_COURSE (
        program_id INTEGER NOT NULL,
        course_id INTEGER NOT NULL,
        course_order INTEGER,
        PRIMARY KEY (program_id, course_id),
        FOREIGN KEY (program_id) REFERENCES PROGRAM (program_id),
        FOREIGN KEY (course_id) REFERENCES COURSE (course_id)
    );

-- Create STUDENT_COURSE junction table (FIXED TYPO! - BONUS: supports standalone students)
CREATE TABLE
    IF NOT EXISTS STUDENT_COURSE (
        student_id INTEGER NOT NULL,
        course_id INTEGER NOT NULL,
        class_id INTEGER,
        enrollment_date DATE NOT NULL,
        grade VARCHAR(10),
        PRIMARY KEY (student_id, course_id),
        FOREIGN KEY (student_id) REFERENCES STUDENT (student_id),
        FOREIGN KEY (course_id) REFERENCES COURSE (course_id),
        FOREIGN KEY (class_id) REFERENCES CLASS (class_id)
    );

-- Create EDUCATOR_COURSE junction table
CREATE TABLE
    IF NOT EXISTS EDUCATOR_COURSE (
        educator_id INTEGER NOT NULL,
        course_id INTEGER NOT NULL,
        class_id INTEGER NOT NULL,
        hours_allocated INTEGER NOT NULL,
        PRIMARY KEY (educator_id, course_id, class_id),
        FOREIGN KEY (educator_id) REFERENCES EDUCATOR (educator_id),
        FOREIGN KEY (course_id) REFERENCES COURSE (course_id),
        FOREIGN KEY (class_id) REFERENCES CLASS (class_id)
    );