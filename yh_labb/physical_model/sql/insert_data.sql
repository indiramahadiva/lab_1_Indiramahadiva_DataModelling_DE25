-- Insert FACILITY data
INSERT INTO
    FACILITY (facility_name, city, address, is_active)
VALUES
    (
        'IT-Högskolan Stockholm',
        'Stockholm',
        'Kistagången 16, 164 40 Kista',
        TRUE
    ),
    (
        'IT-Högskolan Göteborg',
        'Göteborg',
        'Lindholmspiren 7, 417 56 Göteborg',
        TRUE
    ),
    (
        'IT-Högskolan Malmö',
        'Malmö',
        'Smidesvägen 12, 211 20 Malmö',
        TRUE
    );

-- Insert COMPANY data
INSERT INTO
    COMPANY (
        company_name,
        org_number,
        has_f_tax,
        address,
        contact_person,
        contact_email,
        contact_phone
    )
VALUES
    (
        'Tech Consulting AB',
        '556789-1234',
        TRUE,
        'Sveavägen 44, 111 34 Stockholm',
        'Anna Svensson',
        'anna@techconsult.se',
        '08-123 45 67'
    ),
    (
        'Edukation Partner HB',
        '969876-5432',
        TRUE,
        'Storgatan 23, 411 38 Göteborg',
        'Erik Karlsson',
        'erik@edukation.se',
        '031-987 65 43'
    );

-- Insert EDUCATIONAL_LEADER data
INSERT INTO
    EDUCATIONAL_LEADER (first_name, last_name, email, phone)
VALUES
    (
        'Maria',
        'Andersson',
        'maria.andersson@ithogskolan.se',
        '070-111 22 33'
    ),
    (
        'Johan',
        'Nilsson',
        'johan.nilsson@ithogskolan.se',
        '070-222 33 44'
    ),
    (
        'Sara',
        'Bergström',
        'sara.bergstrom@ithogskolan.se',
        '070-333 44 55'
    );

-- Insert EDUCATOR data
INSERT INTO
    EDUCATOR (
        first_name,
        last_name,
        email,
        phone,
        educator_type
    )
VALUES
    (
        'Peter',
        'Johansson',
        'peter.johansson@ithogskolan.se',
        '070-444 55 66',
        'PERMANENT'
    ),
    (
        'Linda',
        'Eriksson',
        'linda.eriksson@ithogskolan.se',
        '070-555 66 77',
        'PERMANENT'
    ),
    (
        'Mikael',
        'Larsson',
        'mikael.larsson@techconsult.se',
        '070-666 77 88',
        'CONSULTANT'
    ),
    (
        'Karin',
        'Pettersson',
        'karin.pettersson@edukation.se',
        '070-777 88 99',
        'CONSULTANT'
    );

-- Insert CONSULTANT data
INSERT INTO
    CONSULTANT (
        educator_id,
        company_id,
        hourly_rate,
        contract_start,
        contract_end
    )
VALUES
    (3, 1, 950.00, '2024-01-15', '2024-12-31'),
    (4, 2, 850.00, '2024-08-01', NULL);

-- Insert PERMANENT_EDUCATOR data
INSERT INTO
    PERMANENT_EDUCATOR (
        educator_id,
        facility_id,
        hire_date,
        employment_type
    )
VALUES
    (1, 1, '2020-08-15', 'FULL_TIME'),
    (2, 2, '2021-01-10', 'FULL_TIME');

-- Insert PROGRAM data
INSERT INTO
    PROGRAM (
        program_code,
        program_name,
        description,
        total_points,
        is_active
    )
VALUES
    (
        'WU23',
        'Webbutvecklare',
        'Utbildning i webbutveckling med fokus på front-end och back-end',
        400,
        TRUE
    ),
    (
        'DS23',
        'Data Science',
        'Utbildning i dataanalys, machine learning och AI',
        400,
        TRUE
    ),
    (
        'CY23',
        'Cybersäkerhet',
        'Utbildning i IT-säkerhet och penetrationstestning',
        400,
        TRUE
    );

-- Insert COURSE data
INSERT INTO
    COURSE (course_code, course_name, description, points)
VALUES
    (
        'WEB101',
        'Introduktion till Webbutveckling',
        'Grundläggande HTML, CSS och JavaScript',
        50
    ),
    (
        'WEB201',
        'Backend-utveckling',
        'Node.js, databaser och API:er',
        50
    ),
    (
        'WEB301',
        'Frontend Frameworks',
        'React och Vue.js',
        50
    ),
    (
        'DATA101',
        'Python för Data Science',
        'Pandas, NumPy och visualisering',
        50
    ),
    (
        'DATA201',
        'Machine Learning Basics',
        'Supervised och unsupervised learning',
        50
    ),
    (
        'CYB101',
        'IT-säkerhet Grund',
        'Nätverk, kryptering och säkerhetsprotokoll',
        50
    );

-- Insert PROGRAM_COURSE data
INSERT INTO
    PROGRAM_COURSE (program_id, course_id, course_order)
VALUES
    (1, 1, 1),
    (1, 2, 2),
    (1, 3, 3),
    (2, 4, 1),
    (2, 5, 2),
    (3, 6, 1);

-- Insert CLASS data
INSERT INTO
    CLASS (
        class_code,
        program_id,
        facility_id,
        leader_id,
        cohort_number,
        start_date,
        end_date,
        max_students
    )
VALUES
    (
        'WU23-K1-STO',
        1,
        1,
        1,
        1,
        '2024-01-15',
        '2025-12-20',
        30
    ),
    (
        'WU23-K2-GBG',
        1,
        2,
        2,
        2,
        '2024-08-20',
        '2026-06-15',
        25
    ),
    (
        'DS23-K1-STO',
        2,
        1,
        3,
        1,
        '2024-01-10',
        '2025-12-15',
        20
    );

-- Insert STUDENT data
INSERT INTO
    STUDENT (
        first_name,
        last_name,
        email,
        phone,
        class_id,
        enrollment_date,
        status
    )
VALUES
    (
        'Emma',
        'Lundberg',
        'emma.lundberg@student.se',
        '070-111 11 11',
        1,
        '2024-01-15',
        'ACTIVE'
    ),
    (
        'Oskar',
        'Sjöberg',
        'oskar.sjoberg@student.se',
        '070-222 22 22',
        1,
        '2024-01-15',
        'ACTIVE'
    ),
    (
        'Julia',
        'Hedlund',
        'julia.hedlund@student.se',
        '070-333 33 33',
        1,
        '2024-01-15',
        'ACTIVE'
    ),
    (
        'Viktor',
        'Holm',
        'viktor.holm@student.se',
        '070-444 44 44',
        2,
        '2024-08-20',
        'ACTIVE'
    ),
    (
        'Sofia',
        'Forsberg',
        'sofia.forsberg@student.se',
        '070-555 55 55',
        3,
        '2024-01-10',
        'ACTIVE'
    );

-- Insert SENSITIVE_DATA
INSERT INTO
    SENSITIVE_DATA (student_id, personnummer, address)
VALUES
    (
        1,
        '199801151234',
        'Vasagatan 10, 111 20 Stockholm'
    ),
    (
        2,
        '199912202345',
        'Kungsgatan 25, 111 35 Stockholm'
    ),
    (
        3,
        '200005103456',
        'Drottninggatan 15, 111 51 Stockholm'
    ),
    (4, '199707154567', 'Avenyn 12, 411 36 Göteborg'),
    (
        5,
        '199909205678',
        'Storgatan 8, 111 22 Stockholm'
    );

-- Insert STUDENT_COURSE data
INSERT INTO
    STUDENT_COURSE (
        student_id,
        course_id,
        class_id,
        enrollment_date,
        grade
    )
VALUES
    (1, 1, 1, '2024-01-15', 'VG'),
    (1, 2, 1, '2024-04-01', 'G'),
    (2, 1, 1, '2024-01-15', 'G'),
    (2, 2, 1, '2024-04-01', NULL),
    (3, 1, 1, '2024-01-15', 'VG'),
    (4, 1, 2, '2024-08-20', NULL),
    (5, 4, 3, '2024-01-10', 'VG');

-- Insert EDUCATOR_COURSE data
INSERT INTO
    EDUCATOR_COURSE (educator_id, course_id, class_id, hours_allocated)
VALUES
    (1, 1, 1, 120),
    (1, 2, 1, 100),
    (2, 1, 2, 120),
    (3, 3, 1, 80),
    (4, 4, 3, 100);