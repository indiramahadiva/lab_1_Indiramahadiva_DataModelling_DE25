# LOGICAL MODEL

Now adding:

- ✅ Junction tables (for M:N relationships)
- ✅ Attributes for each entity
- ✅ Primary Keys (PK)
- ✅ Foreign Keys (FK)
- ✅ Preliminary data types
- ✅ Constraints

---

## Logical Model Entities

### 1. STUDENT

```
STUDENT
├── student_id          INTEGER         PK
├── first_name          VARCHAR(50)     NOT NULL
├── last_name           VARCHAR(50)     NOT NULL
├── email               VARCHAR(100)    NOT NULL UNIQUE
├── phone               VARCHAR(20)
├── class_id            INTEGER         FK → CLASS (nullable)
├── enrollment_date     DATE            NOT NULL
└── status              VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE'
```

**Business Rules:**

- `class_id = NULL` → Standalone student
- `class_id NOT NULL` → Program student enrolled in class

---

### 2. SENSITIVE_DATA

```
SENSITIVE_DATA
├── sensitive_id        INTEGER         PK
├── student_id          INTEGER         FK → STUDENT UNIQUE NOT NULL
├── personnummer        VARCHAR(13)     NOT NULL UNIQUE
└── address             VARCHAR(200)
```

**Relationship:** 1:1 with STUDENT via `student_id UNIQUE`

---

### 3. EDUCATOR

```
EDUCATOR
├── educator_id         INTEGER         PK
├── first_name          VARCHAR(50)     NOT NULL
├── last_name           VARCHAR(50)     NOT NULL
├── email               VARCHAR(100)    NOT NULL UNIQUE
├── phone               VARCHAR(20)
└── educator_type       VARCHAR(20)     NOT NULL CHECK (educator_type IN ('CONSULTANT', 'PERMANENT'))
```

**Note:** Supertype for CONSULTANT and PERMANENT_EDUCATOR

---

### 4. CONSULTANT

```
CONSULTANT
├── consultant_id       INTEGER         PK
├── educator_id         INTEGER         FK → EDUCATOR UNIQUE NOT NULL
├── company_id          INTEGER         FK → COMPANY NOT NULL
├── hourly_rate         DECIMAL(10,2)   NOT NULL
├── contract_start      DATE            NOT NULL
└── contract_end        DATE
```

**Relationship:** 1:1 with EDUCATOR (subtype)

---

### 5. PERMANENT_EDUCATOR (BONUS)

```
PERMANENT_EDUCATOR
├── permanent_id        INTEGER         PK
├── educator_id         INTEGER         FK → EDUCATOR UNIQUE NOT NULL
├── facility_id         INTEGER         FK → FACILITY NOT NULL
├── hire_date           DATE            NOT NULL
└── employment_type     VARCHAR(20)     NOT NULL CHECK (employment_type IN ('FULL_TIME', 'PART_TIME'))
```

**Relationship:** 1:1 with EDUCATOR (subtype)

---

### 6. EDUCATIONAL_LEADER

```
EDUCATIONAL_LEADER
├── leader_id           INTEGER         PK
├── first_name          VARCHAR(50)     NOT NULL
├── last_name           VARCHAR(50)     NOT NULL
├── email               VARCHAR(100)    NOT NULL UNIQUE
└── phone               VARCHAR(20)
```

**Business Rule:** Can manage max 3 classes

---

### 7. COMPANY

```
COMPANY
├── company_id          INTEGER         PK
├── company_name        VARCHAR(100)    NOT NULL
├── org_number          VARCHAR(20)     NOT NULL UNIQUE
├── has_f_tax           BOOLEAN         NOT NULL
├── address             VARCHAR(200)
├── contact_person      VARCHAR(100)
├── contact_email       VARCHAR(100)
└── contact_phone       VARCHAR(20)
```

---

### 8. FACILITY

```
FACILITY
├── facility_id         INTEGER         PK
├── facility_name       VARCHAR(100)    NOT NULL
├── city                VARCHAR(50)     NOT NULL
├── address             VARCHAR(200)
└── is_active           BOOLEAN         NOT NULL DEFAULT TRUE
```

**Current:** Stockholm, Göteborg  
**Future:** Expandable to Malmö, Uppsala, etc. (BONUS)

---

### 9. PROGRAM

```
PROGRAM
├── program_id          INTEGER         PK
├── program_code        VARCHAR(20)     NOT NULL UNIQUE
├── program_name        VARCHAR(100)    NOT NULL
├── description         TEXT
├── total_points        INTEGER         NOT NULL
└── is_active           BOOLEAN         NOT NULL DEFAULT TRUE
```

**Business Rule:** Each program must have exactly 3 classes

---

### 10. COURSE

```
COURSE
├── course_id           INTEGER         PK
├── course_code         VARCHAR(20)     NOT NULL UNIQUE
├── course_name         VARCHAR(100)    NOT NULL
├── description         TEXT
└── points              INTEGER         NOT NULL
```

---

### 11. CLASS

```
CLASS
├── class_id            INTEGER         PK
├── class_code          VARCHAR(20)     NOT NULL UNIQUE
├── program_id          INTEGER         FK → PROGRAM NOT NULL
├── facility_id         INTEGER         FK → FACILITY NOT NULL
├── leader_id           INTEGER         FK → EDUCATIONAL_LEADER NOT NULL
├── cohort_number       INTEGER         NOT NULL CHECK (cohort_number IN (1, 2, 3))
├── start_date          DATE            NOT NULL
├── end_date            DATE            NOT NULL
└── max_students        INTEGER         NOT NULL

UNIQUE (program_id, cohort_number)
```

**Business Rule:** `UNIQUE (program_id, cohort_number)` ensures exactly 3 cohorts per program

---

## 🔗 Junction Tables

### 12. PROGRAM_COURSE

```
PROGRAM_COURSE
├── program_id          INTEGER         PK, FK → PROGRAM
├── course_id           INTEGER         PK, FK → COURSE
└── course_order        INTEGER

PRIMARY KEY (program_id, course_id)
```

**Purpose:** Defines which courses belong to each program

**PK Analysis:**

- `program_id`: ✅ PK + FK
- `course_id`: ✅ PK + FK

---

### 13. STUDENT_COURSE (Enrollment)

```
STUDENT_COURSE
├── student_id          INTEGER         PK, FK → STUDENT
├── course_id           INTEGER         PK, FK → COURSE
├── class_id            INTEGER         FK → CLASS (nullable)
├── enrollment_date     DATE            NOT NULL
└── grade               VARCHAR(10)

PRIMARY KEY (student_id, course_id)
```

**Purpose:** Tracks student enrollment in courses

- Program students: `class_id NOT NULL`
- Standalone students: `class_id NULL` (BONUS)

**PK Analysis:**

- `student_id`: ✅ PK + FK
- `course_id`: ✅ PK + FK
- `class_id`: ❌ Only FK (not part of PK, nullable)

---

### 14. EDUCATOR_COURSE (Teaching Assignment)

```
EDUCATOR_COURSE
├── educator_id         INTEGER         PK, FK → EDUCATOR
├── course_id           INTEGER         PK, FK → COURSE
├── class_id            INTEGER         PK, FK → CLASS
└── hours_allocated     INTEGER         NOT NULL

PRIMARY KEY (educator_id, course_id, class_id)
Purpose: Tracks which educators teach which courses in which classes
PK Analysis:

educator_id: ✅ PK + FK
course_id: ✅ PK + FK
class_id: ✅ PK + FK


📊 Complete ERD with Keys
mermaiderDiagram
    STUDENT ||--|| SENSITIVE_DATA : "student_id"
    STUDENT }o--|| CLASS : "class_id"
    STUDENT ||--o{ STUDENT_COURSE : "student_id PK,FK"

    EDUCATOR ||--o{ EDUCATOR_COURSE : "educator_id PK,FK"
    EDUCATOR ||--o| CONSULTANT : "educator_id UNIQUE FK"
    EDUCATOR ||--o| PERMANENT_EDUCATOR : "educator_id UNIQUE FK"

    CONSULTANT }o--|| COMPANY : "company_id FK"
    PERMANENT_EDUCATOR }o--|| FACILITY : "facility_id FK"

    EDUCATIONAL_LEADER ||--o{ CLASS : "leader_id FK"

    COMPANY ||--o{ CONSULTANT : ""

    FACILITY ||--o{ CLASS : "facility_id FK"
    FACILITY ||--o{ PERMANENT_EDUCATOR : ""

    PROGRAM ||--o{ CLASS : "program_id FK"
    PROGRAM ||--o{ PROGRAM_COURSE : "program_id PK,FK"

    COURSE ||--o{ PROGRAM_COURSE : "course_id PK,FK"
    COURSE ||--o{ STUDENT_COURSE : "course_id PK,FK"
    COURSE ||--o{ EDUCATOR_COURSE : "course_id PK,FK"

    CLASS ||--o{ EDUCATOR_COURSE : "class_id PK,FK"
    CLASS ||--o{ STUDENT_COURSE : "class_id FK"

    STUDENT {
        int student_id PK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar phone
        int class_id FK
        date enrollment_date
        varchar status
    }

    SENSITIVE_DATA {
        int sensitive_id PK
        int student_id FK_UK
        varchar personnummer UK
        varchar address
    }

    EDUCATOR {
        int educator_id PK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar phone
        varchar educator_type
    }

    CONSULTANT {
        int consultant_id PK
        int educator_id FK_UK
        int company_id FK
        decimal hourly_rate
        date contract_start
        date contract_end
    }

    PERMANENT_EDUCATOR {
        int permanent_id PK
        int educator_id FK_UK
        int facility_id FK
        date hire_date
        varchar employment_type
    }

    EDUCATIONAL_LEADER {
        int leader_id PK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar phone
    }

    COMPANY {
        int company_id PK
        varchar company_name
        varchar org_number UK
        boolean has_f_tax
        varchar address
        varchar contact_person
        varchar contact_email
        varchar contact_phone
    }

    FACILITY {
        int facility_id PK
        varchar facility_name
        varchar city
        varchar address
        boolean is_active
    }

    PROGRAM {
        int program_id PK
        varchar program_code UK
        varchar program_name
        text description
        int total_points
        boolean is_active
    }

    COURSE {
        int course_id PK
        varchar course_code UK
        varchar course_name
        text description
        int points
    }

    CLASS {
        int class_id PK
        varchar class_code UK
        int program_id FK
        int facility_id FK
        int leader_id FK
        int cohort_number
        date start_date
        date end_date
        int max_students
    }

    PROGRAM_COURSE {
        int program_id PK_FK
        int course_id PK_FK
        int course_order
    }

    STUDENT_COURSE {
        int student_id PK_FK
        int course_id PK_FK
        int class_id FK
        date enrollment_date
        varchar grade
    }

    EDUCATOR_COURSE {
        int educator_id PK_FK
        int course_id PK_FK
        int class_id PK_FK
        int hours_allocated
    }
```
