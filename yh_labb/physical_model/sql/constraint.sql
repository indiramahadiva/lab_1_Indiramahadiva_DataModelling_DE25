-- insert a class with an invalid facility_id:
INSERT INTO
    class (
        class_id,
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
        999,
        'TEST-01',
        1,
        9999,
        1,
        99,
        '2024-01-01',
        '2024-12-31',
        30
    );