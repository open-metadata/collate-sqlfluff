-- Test array type syntax with square brackets in type definitions
-- Testing that array notation [] is properly recognized as part of data types

-- Test array type casting with system types
SELECT '{}'::aclitem[];

SELECT defaclacl = '{}'::aclitem[]
FROM pg_default_acl;

-- Test integer array
SELECT '{1,2,3}'::integer[];

-- Test text array
SELECT ARRAY['a','b','c']::text[];

-- Test varchar array with size
SELECT ARRAY['hello','world']::varchar(100)[];

-- Test multi-dimensional array (using different syntax to avoid Jinja conflict)
SELECT ARRAY[ARRAY[1,2],ARRAY[3,4]]::integer[][];
