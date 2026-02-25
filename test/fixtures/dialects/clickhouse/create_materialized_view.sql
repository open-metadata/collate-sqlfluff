CREATE MATERIALIZED VIEW IF NOT EXISTS db.table_mv
TO db.table
AS
    SELECT
        column1,
        column2
    FROM db.table_kafka;

CREATE MATERIALIZED VIEW table_mv
TO table
AS
    SELECT
        column1,
        column2
    FROM table_kafka;

CREATE MATERIALIZED VIEW IF NOT EXISTS db.table_mv
ON CLUSTER mycluster
TO db.table
AS
    SELECT
        column1,
        column2
    FROM db.table_kafka;

CREATE MATERIALIZED VIEW table_mv
TO table
ENGINE = MergeTree()
AS
    SELECT
        column1,
        column2
    FROM table_kafka;

CREATE MATERIALIZED VIEW table_mv
ENGINE = MergeTree()
AS
    SELECT
        column1,
        column2
    FROM table_kafka;

CREATE MATERIALIZED VIEW table_mv
ENGINE = MergeTree()
POPULATE
AS
    SELECT
        column1,
        column2
    FROM table_kafka;

CREATE MATERIALIZED VIEW db.mv_table
ENGINE MergeTree
ORDER BY ()
AS SELECT * FROM db.table;

-- Refreshable Materialized Views

CREATE MATERIALIZED VIEW db.mv_refresh
REFRESH EVERY 1 HOUR
TO db.target_table
AS SELECT * FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_after
REFRESH AFTER 30 MINUTE
TO db.target_table
AS SELECT * FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_append
REFRESH EVERY 1 DAY
APPEND
TO db.target_table
AS SELECT * FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_offset
REFRESH EVERY 1 HOUR OFFSET 5 MINUTE
TO db.target_table
AS SELECT * FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_randomize
REFRESH EVERY 1 HOUR RANDOMIZE FOR 10 MINUTE
TO db.target_table
AS SELECT * FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_depends
REFRESH EVERY 1 HOUR DEPENDS ON db.other_mv
TO db.target_table
AS SELECT * FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_with_columns
REFRESH EVERY 1 HOUR
APPEND
TO db.target_table
(
    `id` UUID,
    `name` String,
    `created_at` DateTime
)
AS SELECT id, name, created_at FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_definer
REFRESH EVERY 1 HOUR
TO db.target_table
DEFINER = admin
SQL SECURITY DEFINER
AS SELECT * FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_security_none
REFRESH EVERY 1 HOUR
TO db.target_table
SQL SECURITY NONE
AS SELECT * FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_empty
REFRESH EVERY 1 HOUR
TO db.target_table
EMPTY
AS SELECT * FROM db.source_table;

CREATE MATERIALIZED VIEW db.mv_refresh_full
REFRESH EVERY 1 HOUR OFFSET 5 MINUTE RANDOMIZE FOR 10 MINUTE DEPENDS ON db.other_mv
APPEND
TO db.target_table
(
    `id` UUID,
    `value` Decimal(18, 4)
)
DEFINER = CURRENT_USER
SQL SECURITY DEFINER
AS SELECT id, value FROM db.source_table;
