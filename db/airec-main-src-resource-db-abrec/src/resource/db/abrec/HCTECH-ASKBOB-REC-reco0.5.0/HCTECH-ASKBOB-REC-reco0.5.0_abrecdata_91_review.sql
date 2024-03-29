-- For version reco0.5.0

-- Vacuum database
VACUUM FULL VERBOSE ANALYZE;


-- Review extension
DO
$$
    DECLARE
        name        TEXT;
        version     TEXT;
        schema      TEXT;
        description TEXT;
    BEGIN

        FOR name, version, schema, description IN
            SELECT e.extname AS "Name", e.extversion AS "Version", n.nspname AS "Schema", c.description AS "Description"
            FROM pg_catalog.pg_extension e
                     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = e.extnamespace
                     LEFT JOIN pg_catalog.pg_description c ON c.objoid = e.oid AND c.classoid = 'pg_catalog.pg_extension'::pg_catalog.regclass
            ORDER BY n.nspname, e.extname

            LOOP
                RAISE NOTICE 'PG extension in [%] schema: [% v%]: %.', schema, name, version, description;
            END LOOP;
    END;
$$;


-- list DB size
DO
$$
    DECLARE
        dbname TEXT;
        size   TEXT;
    BEGIN

        FOR dbname, size IN
            SELECT pg_database.datname AS dbname, pg_size_pretty(pg_database_size(pg_database.datname)) AS size
            FROM pg_database
            ORDER BY pg_database_size(pg_database.datname) DESC

            LOOP
                RAISE NOTICE 'PG database [%] size = %.', dbname, size;
            END LOOP;
    END;
$$;


-- list table size
DO
$$
    DECLARE
        table_catalog TEXT;
        table_schema  TEXT;
        table_name    TEXT;
        table_type    TEXT;
        table_size    TEXT;
    BEGIN

        FOR table_catalog, table_schema, table_name, table_type, table_size IN
            SELECT t.table_catalog, t.table_schema, t.table_name, t.table_type, pg_size_pretty(pg_relation_size('"' || t.table_schema || '"."' || t.table_name || '"')) AS pg_relation_size
            FROM information_schema.tables t
            WHERE t.table_schema = 'public'
            ORDER BY t.table_type, t.table_name, pg_relation_size DESC

            LOOP
                RAISE NOTICE 'PG % [%.%.%] size = %.', table_type, table_catalog, table_schema, table_name, table_size;
            END LOOP;
    END;
$$;


-- review permission of users
DO
$$
    DECLARE
        db_users        TEXT[];
        db_user         TEXT;
        table_catalog   TEXT;
        table_schema    TEXT;
        table_name      TEXT;
        privilege_types TEXT[];
    BEGIN
        db_users := ARRAY ['abrecopr', 'dbmonopr', 'devsup01', 'opesup'];
        FOR table_catalog, table_schema, table_name, db_user, privilege_types IN
            SELECT p.table_catalog, p.table_schema, p.table_name, p.grantee AS db_user, array_agg(p.privilege_type ORDER BY privilege_type)::TEXT AS privilege_types
            FROM information_schema.table_privileges p
            WHERE p.grantee = ANY (db_users)
            GROUP BY p.table_catalog, p.table_schema, p.table_name, p.grantee
            ORDER BY table_catalog, table_schema, db_user, table_name

            LOOP
                RAISE NOTICE 'Permission of user [%] to [%.%.%] = %.', db_user, table_catalog, table_schema, table_name, privilege_types;
            END LOOP;
    END;
$$;
