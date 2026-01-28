# YrkesCo Database - Conceptual Data Model

## Overview

Database for **YrkesCo**, a vocational school managing students, educators, consultants, permanent staff, programs, courses, and facilities.

---

## Core Entities (11)

### People Domain (6 entities)

| Entity                 | Description                                         |
| ---------------------- | --------------------------------------------------- |
| **STUDENT**            | Students enrolled in programs or standalone courses |
| **SENSITIVE_DATA**     | GDPR-protected personal information                 |
| **EDUCATOR**           | Supertype for all teaching staff                    |
| **CONSULTANT**         | External educators from consulting companies        |
| **PERMANENT_EDUCATOR** | Internal staff based at facilities                  |
| **EDUCATIONAL_LEADER** | Class managers (utbildningsledare)                  |

### Organizational Domain (2 entities)

| Entity       | Description                                                    |
| ------------ | -------------------------------------------------------------- |
| **COMPANY**  | Consultant employers with contract details                     |
| **FACILITY** | Physical locations (Stockholm, Göteborg, expandable) **BONUS** |

### Educational Structure (3 entities)

| Entity      | Description                                           |
| ----------- | ----------------------------------------------------- |
| **PROGRAM** | Educational programs (e.g., Data Engineering 400p)    |
| **COURSE**  | Individual courses (can be in programs or standalone) |
| **CLASS**   | Specific cohort/instance of program (e.g., KATA-24)   |

---

## Relationship Statements

### 1. STUDENT ↔ SENSITIVE_DATA

```
STUDENT ||--|| SENSITIVE_DATA
```

**Reading:** One student has one sensitive data record; one sensitive data record belongs to one student  
**Type:** 1:1 (mandatory both sides)  
**Business Rule:** GDPR compliance - sensitive data separated

---

### 2. STUDENT ↔ CLASS

```
STUDENT }o--|| CLASS
```

**Reading:** Zero or many students are enrolled in one class; one class has one or many students  
**Type:** M:1 (optional from student side)  
**Business Rule:**

- `class_id = NULL` → Standalone student
- `class_id NOT NULL` → Program student

---

### 3. STUDENT ↔ COURSE (via STUDENT_COURSE junction)

```
STUDENT }o--o{ COURSE
```

**Reading:** One student enrolls in zero or many courses; one course has zero or many students enrolled  
**Type:** M:N (requires junction table STUDENT_COURSE)  
**Business Rule:** Tracks enrollment, grades, and standalone vs. program courses

---

### 4. EDUCATOR ↔ CONSULTANT

```
EDUCATOR ||--o| CONSULTANT
```

**Reading:** One educator can be one consultant; one consultant is one educator  
**Type:** 1:1 (subtype relationship)  
**Business Rule:** Mutually exclusive with PERMANENT_EDUCATOR

---

### 5. EDUCATOR ↔ PERMANENT_EDUCATOR (BONUS)

```
EDUCATOR ||--o| PERMANENT_EDUCATOR
```

**Reading:** One educator can be one permanent educator; one permanent educator is one educator  
**Type:** 1:1 (subtype relationship)  
**Business Rule:** Mutually exclusive with CONSULTANT

---

### 6. EDUCATOR ↔ COURSE (via EDUCATOR_COURSE junction)

```
EDUCATOR }o--o{ COURSE
```

**Reading:** One educator teaches zero or many courses; one course is taught by zero or many educators  
**Type:** M:N (requires junction table EDUCATOR_COURSE)  
**Business Rule:** Tracks teaching assignments across classes

---

### 7. CONSULTANT ↔ COMPANY

```
CONSULTANT }o--|| COMPANY
```

**Reading:** Zero or many consultants work for one company; one company employs zero or many consultants  
**Type:** M:1  
**Business Rule:** Company can exist before hiring consultants (pre-registration)

---

### 8. PERMANENT_EDUCATOR ↔ FACILITY (BONUS)

```
PERMANENT_EDUCATOR }o--|| FACILITY
```

**Reading:** Zero or many permanent educators are based at one facility; one facility has zero or many permanent educators based there  
**Type:** M:1  
**Business Rule:** Permanent staff assigned to home facility

---

### 9. EDUCATIONAL_LEADER ↔ CLASS

```
EDUCATIONAL_LEADER ||--o{ CLASS
```

**Reading:** One educational leader manages one or many classes (max 3); one class is managed by one educational leader  
**Type:** 1:M (constrained to max 3)  
**Business Rule:** Each leader manages maximum 3 classes

---

### 10. FACILITY ↔ CLASS

```
FACILITY ||--o{ CLASS
```

**Reading:** One facility hosts one or many classes; one class is hosted at one facility  
**Type:** 1:M  
**Business Rule:** Multi-facility support (Stockholm, Göteborg, expandable)

---

### 11. PROGRAM ↔ CLASS

```
PROGRAM ||--|{ CLASS
```

**Reading:** One program runs as one or many classes (exactly 3); one class is an instance of one program  
**Type:** 1:M (constrained to exactly 3)  
**Business Rule:** Each program MUST have exactly 3 cohorts

---

### 12. PROGRAM ↔ COURSE (via PROGRAM_COURSE junction)

```
PROGRAM }o--o{ COURSE
```

**Reading:** One program contains zero or many courses; one course belongs to zero or many programs  
**Type:** M:N (requires junction table PROGRAM_COURSE)  
**Business Rule:** Defines curriculum structure

---

## M:N Relationships (Become Junction Tables)

| Relationship      | Junction Table    | Description                                      |
| ----------------- | ----------------- | ------------------------------------------------ |
| STUDENT ↔ COURSE  | `STUDENT_COURSE`  | Tracks enrollment, grades, class context         |
| EDUCATOR ↔ COURSE | `EDUCATOR_COURSE` | Tracks teaching assignments with hours allocated |
| PROGRAM ↔ COURSE  | `PROGRAM_COURSE`  | Defines curriculum structure with course order   |
