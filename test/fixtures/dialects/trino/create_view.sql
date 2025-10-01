CREATE VIEW my_view AS SELECT 1;

CREATE VIEW my_schema.my_view AS SELECT * FROM my_table;

CREATE VIEW my_view SECURITY DEFINER AS SELECT * FROM my_table;

CREATE VIEW my_view SECURITY INVOKER AS SELECT * FROM my_table;

CREATE OR REPLACE VIEW my_view SECURITY DEFINER AS SELECT * FROM my_table;

CREATE VIEW catalog.schema.view_name SECURITY DEFINER AS
SELECT col1, col2
FROM catalog.schema.table_name;

CREATE VIEW my_view (col1, col2) SECURITY INVOKER AS
SELECT a, b FROM my_table;

CREATE VIEW my_view COMMENT 'This is a view comment' AS SELECT 1;

CREATE VIEW my_view
COMMENT 'A test view'
SECURITY DEFINER
AS SELECT * FROM my_table;

CREATE OR REPLACE VIEW my_view
COMMENT 'View with all options'
SECURITY INVOKER
AS SELECT * FROM my_table;
