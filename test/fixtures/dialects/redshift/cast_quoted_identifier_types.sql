-- Test casting to quoted identifier data types
-- These tests verify that quoted identifiers like "char", regprocedure, oid, aclitem
-- are properly recognized as valid data types in cast expressions

-- Test "char" type (single-byte character)
SELECT 'r'::"char" AS relkind;

SELECT b.relkind
FROM pg_class b
WHERE b.relkind = 'r'::"char" OR b.relkind = 'v'::"char";

-- Test CASE expression with "char" casting
SELECT
    CASE
        WHEN relkind = 'r'::"char" THEN 'table'::text
        ELSE 'view'::text
    END AS objtype
FROM pg_class;

-- Test regprocedure type
SELECT p.oid::regprocedure AS procoid
FROM pg_proc p;

-- Test oid type
SELECT *
FROM pg_default_acl
WHERE defaclnamespace = 0::oid;

-- Test aclitem array type
SELECT *
FROM pg_default_acl
WHERE defaclacl = '{}'::aclitem[];

-- Test combination of quoted identifier types in complex query
SELECT
    pg_get_userbyid(relowner)::character varying AS owner,
    relname::character varying AS name,
    CASE
        WHEN relkind = 'r'::"char" THEN 'table'::text
        WHEN relkind = 'v'::"char" THEN 'view'::text
        ELSE 'other'::text
    END AS type
FROM pg_class
WHERE relkind = 'r'::"char"
   OR relkind = 'v'::"char";
