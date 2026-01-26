# Physical Model

---

## Project Structure

```
physical_model/
├── docker-compose.yml
├── .env
├── sql/
│   ├── create_tables.sql
│   ├── insert_data.sql
│   └── test_queries.sql
└── README.md
```

---

## Database Information

- **Database Type:** PostgreSQL
- **Schema:** public
- **Owner:** postgres
- **Deployment:** Docker Container

---

## Docker Setup Commands

### Start PostgreSQL Container

```bash
docker compose up -d
```

### Stop Container

```bash
docker compose down -v
```

### Check Running Containers

```bash
docker ps
```

### Connect to PostgreSQL

```bash
docker exec -it postgres bash
psql -U postgres -d yrkco_db
```

### Inside psql

```bash
\dt                    # List tables
\d table_name          # Describe table
\i sql/create.sql         # Run SQL file
\i sql/insert.sql         # Run SQL file
\i sql/test.sql         # Run SQL file
```

---

### Key Components

- **Image:** `postgres:latest`
- **Port Mapping:** `5432:5432` (host:container)
- **Volume:** `postgres_data` - persistent storage for database
- **Bind Mount:** `./sql:/sql` - maps local sql folder to container

## Validation Results

### Row Counts

- FACILITY: 3
- COMPANY: 2
- EDUCATIONAL_LEADER: 3
- EDUCATOR: 4
- CONSULTANT: 2
- PERMANENT_EDUCATOR: 2
- PROGRAM: 3
- COURSE: 6
- CLASS: 3
- STUDENT: 5
- SENSITIVE_DATA: 5
- PROGRAM_COURSE: 6
- STUDENT_COURSE: 7
- EDUCATOR_COURSE: 5

### Successful JOIN Operations

✅ Class with educational leader  
✅ Courses in a class  
✅ Educators teaching courses  
✅ Students enrolled in class  
✅ Consultants with company info

---

## Quick Reference

### Docker Commands

```bash
docker compose up -d        # Start container
docker compose down -v      # Stop and remove volumes
docker ps                   # List running containers
docker exec -it postgres bash  # Access container
```

### PostgreSQL Commands (inside container)

```bash
psql -U postgres -d yrkco_db   # Connect to database
\dt                            # List tables
\d table_name                  # Describe table
\q                             # Quit psql
```

---
