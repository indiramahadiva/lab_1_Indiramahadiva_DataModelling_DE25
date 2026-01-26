// YrkesCo Database - Physical Model
// Database: PostgreSQL

Table STUDENT {
student_id INTEGER [primary key, increment]
first_name VARCHAR(50) [not null]
last_name VARCHAR(50) [not null]
email VARCHAR(100) [not null, unique]
phone VARCHAR(20)
class_id INTEGER [ref: > CLASS.class_id, note: "NULL = standalone student, NOT NULL = program student"]
enrollment_date DATE [not null, default: `CURRENT_DATE`]
status VARCHAR(20) [not null, default: 'ACTIVE']

Note: "Students enrolled in programs or standalone courses"
}

Table SENSITIVE_DATA {
sensitive_id INTEGER [primary key, increment]
student_id INTEGER [not null, unique, ref: - STUDENT.student_id, note: "1:1 relationship with STUDENT"]
personnummer VARCHAR(13) [not null, unique]
address VARCHAR(200)

Note: "GDPR-protected personal information - separate for access control"
}

Table EDUCATOR {
educator_id INTEGER [primary key, increment]
first_name VARCHAR(50) [not null]
last_name VARCHAR(50) [not null]
email VARCHAR(100) [not null, unique]
phone VARCHAR(20)
educator_type VARCHAR(20) [not null, note: "CHECK: 'CONSULTANT' or 'PERMANENT'"]

Note: "Supertype for all teaching staff"
}

Table CONSULTANT {
consultant_id INTEGER [primary key, increment]
educator_id INTEGER [not null, unique, ref: - EDUCATOR.educator_id, note: "1:1 subtype relationship"]
company_id INTEGER [not null, ref: > COMPANY.company_id]
hourly_rate NUMERIC(10,2) [not null]
contract_start DATE [not null]
contract_end DATE

Note: "External educators from consulting companies"
}

Table PERMANENT_EDUCATOR {
permanent_id INTEGER [primary key, increment]
educator_id INTEGER [not null, unique, ref: - EDUCATOR.educator_id, note: "1:1 subtype relationship"]
facility_id INTEGER [not null, ref: > FACILITY.facility_id]
hire_date DATE [not null]
employment_type VARCHAR(20) [not null, note: "CHECK: 'FULL_TIME' or 'PART_TIME'"]

Note: "BONUS: Internal staff based at facilities"
}

Table EDUCATIONAL_LEADER {
leader_id INTEGER [primary key, increment]
first_name VARCHAR(50) [not null]
last_name VARCHAR(50) [not null]
email VARCHAR(100) [not null, unique]
phone VARCHAR(20)

Note: "Class managers (utbildningsledare) - manages max 3 classes"
}

Table COMPANY {
company_id INTEGER [primary key, increment]
company_name VARCHAR(100) [not null]
org_number VARCHAR(20) [not null, unique]
has_f_tax BOOLEAN [not null]
address VARCHAR(200)
contact_person VARCHAR(100)
contact_email VARCHAR(100)
contact_phone VARCHAR(20)

Note: "Consultant employers with contract details"
}

Table FACILITY {
facility_id INTEGER [primary key, increment]
facility_name VARCHAR(100) [not null]
city VARCHAR(50) [not null]
address VARCHAR(200)
is_active BOOLEAN [not null, default: true]

Note: "BONUS: Physical locations (Stockholm, Göteborg, expandable)"
}

Table PROGRAM {
program_id INTEGER [primary key, increment]
program_code VARCHAR(20) [not null, unique]
program_name VARCHAR(100) [not null]
description TEXT
total_points INTEGER [not null]
is_active BOOLEAN [not null, default: true]

Note: "Educational programs - each must have exactly 3 cohorts"
}

Table COURSE {
course_id INTEGER [primary key, increment]
course_code VARCHAR(20) [not null, unique]
course_name VARCHAR(100) [not null]
description TEXT
points INTEGER [not null]

Note: "Individual courses (can be in programs or standalone)"
}

Table CLASS {
class_id INTEGER [primary key, increment]
class_code VARCHAR(20) [not null, unique]
program_id INTEGER [not null, ref: > PROGRAM.program_id]
facility_id INTEGER [not null, ref: > FACILITY.facility_id]
leader_id INTEGER [not null, ref: > EDUCATIONAL_LEADER.leader_id]
cohort_number INTEGER [not null, note: "CHECK: 1, 2, or 3"]
start_date DATE [not null]
end_date DATE [not null]
max_students INTEGER [not null]

Indexes {
(program_id, cohort_number) [unique, note: "Ensures exactly 3 cohorts per program"]
}

Note: "Specific cohort/instance of program (e.g., KATA-24)"
}

// Junction Tables

Table PROGRAM_COURSE {
program_id INTEGER [primary key, ref: > PROGRAM.program_id]
course_id INTEGER [primary key, ref: > COURSE.course_id]
course_order INTEGER

Indexes {
(program_id, course_id) [pk]
}

Note: "Defines which courses belong to each program"
}

Table STUDENT_COURSE {
student_id INTEGER [primary key, ref: > STUDENT.student_id]
course_id INTEGER [primary key, ref: > COURSE.course_id]
class_id INTEGER [ref: > CLASS.class_id, note: "NULL = standalone student, NOT NULL = program student"]
enrollment_date DATE [not null]
grade VARCHAR(10)

Indexes {
(student_id, course_id) [pk]
}

Note: "BONUS: Tracks enrollment, grades, and standalone vs. program courses"
}

Table EDUCATOR_COURSE {
educator_id INTEGER [primary key, ref: > EDUCATOR.educator_id]
course_id INTEGER [primary key, ref: > COURSE.course_id]
class_id INTEGER [primary key, ref: > CLASS.class_id]
hours_allocated INTEGER [not null]

Indexes {
(educator_id, course_id, class_id) [pk]
}

Note: "Tracks which educators teach which courses in which classes"
}
