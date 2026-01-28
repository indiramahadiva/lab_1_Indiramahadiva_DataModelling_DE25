# 3NF Compliance for YrkesCo Database

## Overview

This document demonstrates that my YrkesCo database logical model achieves **Third Normal Form (3NF)** by verifying compliance with **1NF → 2NF → 3NF**.

---

## Normal Form Definitions

Based on the course framework:

### **First Normal Form (1NF)**

- Row order doesn't matter
- Primary key in each table
- No repeating groups
- Uniform column data (no mixed data types)

### **Second Normal Form (2NF)**

- Must be in 1NF
- **No partial dependencies** - non-prime attributes must depend on the **entire** primary key, not just part of it

### **Third Normal Form (3NF)**

- Must be in 2NF
- **No transitive dependencies** - non-prime attributes depend on "the key, the whole key, and nothing but the key"

---

## 1NF Verification

### Requirements Checklist:

| Requirement               | Status |
| ------------------------- | ------ |
| Row order doesn't matter  | ✅     |
| Primary key in each table | ✅     |
| No repeating groups       | ✅     |
| Uniform column data       | ✅     |

### Evidence:

All my tables satisfy 1NF because:

**Example: STUDENT table**

- Has primary key `student_id`
- No arrays/lists (no `courses: ["KATA", "MAGI", "FYS"]`)
- All columns have single values
- Each column has consistent data type

**Example: EDUCATOR table**

- Has primary key `educator_id`
- No repeating groups
- Single `educator_type` value (not array)

**Resolving M:N Relationships**

I used junction tables to avoid repeating groups:

- `PROGRAM_COURSE` - resolves M:N between Program and Course
- `STUDENT_COURSE` - resolves M:N between Student and Course
- `EDUCATOR_COURSE` - resolves M:N between Educator and Course

**Result:** ALL TABLES PASS 1NF

---

## 2NF Verification

### Requirements:

- Must be in 1NF (verified above)
- **No partial dependencies**

### What is a Partial Dependency?

When a non-prime attribute depends on **only part** of a composite primary key.

### Analysis:

**Tables with Composite Keys:**

**1. PROGRAM_COURSE**

```
Composite PK: (program_id, course_id)
Non-prime: course_order
```

Does `course_order` depend on just `program_id`? No  
Does `course_order` depend on just `course_id`? No  
Does `course_order` depend on BOTH? YES

Explanation: Course order is the sequence of a specific course within a specific program - needs both keys.

**2. STUDENT_COURSE**

```
Composite PK: (student_id, course_id)
Non-prime: class_id, enrollment_date, grade
```

- `enrollment_date` -> when did this student enroll in this course? (needs both keys)
- `grade` -> what grade did this student get in this course? (needs both keys)
- `class_id` -> in which class did this student take this course? (needs both keys)

No partial dependencies

**3. EDUCATOR_COURSE**

```
Composite PK: (educator_id, course_id, class_id)
Non-prime: hours_allocated
```

`hours_allocated` -> how many hours does this educator teach this course in this class? (needs all three keys)

No partial dependencies

**Tables with Simple Keys:**

For tables with simple primary keys (STUDENT, EDUCATOR, COURSE, CLASS, etc.), partial dependencies are **impossible** because there's only one key column.

**Result:** ALL TABLES PASS 2NF

---

## 3NF Verification

### Requirements:

- Must be in 2NF (verified above)
- **No transitive dependencies**

### What is a Transitive Dependency?

When a non-prime attribute depends on another non-prime attribute:

```
PK -> non-prime attribute A -> non-prime attribute B
```

### Analysis of My Tables:

**STUDENT**

```sql
student_id -> first_name, last_name, email, phone, class_id, enrollment_date, status
```

Does `student_id → class_id → class_name` exist? NO  
Why? Because `class_name` is NOT stored in STUDENT table.

Key point: `class_id` is a **foreign key** (pointer to CLASS table), not a transitive dependency.

No transitive dependencies

**CLASS**

```sql
class_id → class_code, program_id, facility_id, leader_id, cohort_number, start_date, end_date, max_students
```

Does `class_id -> program_id -> program_name` exist? NO  
Does `class_id -> facility_id -> facility_name` exist? NO  
Does `class_id -> leader_id -> leader_name` exist? NO

Why? Because program_name, facility_name, and leader_name are stored in their respective tables (PROGRAM, FACILITY, EDUCATIONAL_LEADER), not in CLASS.

No transitive dependencies

**CONSULTANT**

```sql
consultant_id -> educator_id, company_id, hourly_rate, contract_start, contract_end
```

Does `consultant_id → company_id → company_name` exist? NO  
Why? Because company_name is stored in COMPANY table, not CONSULTANT.

No transitive dependencies

**COURSE**

```sql
course_id -> course_code, course_name, description, points
```

Question: Does `course_id → course_code → course_name`?

Analysis:

- `course_code` and `course_name` are independent attributes
- Both depend directly on `course_id`
- Neither determines the other

No transitive dependencies

**Junction Tables:**

All junction tables either:

- Have all attributes as part of the primary key, OR
- Have non-key attributes that directly depend on the entire composite key

No transitive dependencies

**Result:** ALL TABLES PASS 3NF

## Conclusion

My YrkesCo database model achieves 3NF because:

1. **1NF:** All tables have atomic values, primary keys, no repeating groups, and uniform data types
2. **2NF:** No partial dependencies - all non-key attributes depend on entire primary keys
3. **3NF:** No transitive dependencies - all non-key attributes depend directly on primary keys
