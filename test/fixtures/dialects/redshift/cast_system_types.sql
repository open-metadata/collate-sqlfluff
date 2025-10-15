-- test postgresql system types

-- object identifier types
SELECT '1234'::oid;
SELECT 'proname'::regproc;
SELECT 'pronamespace()'::regprocedure;
SELECT 'pg_class'::regclass;
SELECT 'int4'::regtype;
SELECT '+'::regoper;
SELECT '+(integer,integer)'::regoperator;
SELECT '1'::cid;
SELECT '1'::tid;
SELECT '1'::xid;

-- character types
SELECT 'identifier'::name;
SELECT relname::name FROM pg_class;

-- access control types
SELECT '{}'::aclitem[];
