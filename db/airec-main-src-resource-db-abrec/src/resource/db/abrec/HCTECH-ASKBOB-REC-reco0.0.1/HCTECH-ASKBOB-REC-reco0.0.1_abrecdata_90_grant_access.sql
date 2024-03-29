-- tables
DO
$$
    DECLARE
        t_name  TEXT;
        str_sql TEXT;
        db_user TEXT;
    BEGIN
        db_user := 'abrecopr';
        FOR t_name IN
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'public'
              AND table_type = 'BASE TABLE'
            ORDER BY table_name
            LOOP
                str_sql := FORMAT('GRANT SELECT, INSERT,UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE ON TABLE %s TO %s;', t_name, db_user);
                EXECUTE str_sql;
                RAISE NOTICE '%', str_sql;
            END LOOP;
    END;
$$;


DO
$$
    DECLARE
        db_user         TEXT;
        table_catalog   TEXT;
        table_schema    TEXT;
        table_name      TEXT;
        privilege_types TEXT[];
    BEGIN
        db_user := 'abrecopr';
        FOR table_catalog, table_schema, table_name, privilege_types IN
            SELECT p.table_catalog, p.table_schema, p.table_name, array_agg(p.privilege_type ORDER BY privilege_type)::TEXT AS privilege_types
            FROM information_schema.table_privileges p
            WHERE grantee = db_user
            GROUP BY p.table_catalog, p.table_schema, p.table_name

            LOOP
                RAISE NOTICE 'Permission of user [%] to [%.%.%] = %.', db_user, table_catalog, table_schema, table_name, privilege_types;
            END LOOP;
    END;
$$;

-- sequences

DO
$$
    DECLARE
        s_name  TEXT;
        str_sql TEXT;
        db_user TEXT;
    BEGIN
        db_user := 'abrecopr';
        FOR s_name IN
            SELECT sequence_name
            FROM information_schema.sequences
            WHERE sequence_schema = 'public'
            ORDER BY sequence_name
            LOOP
                str_sql := FORMAT('GRANT USAGE, SELECT ON SEQUENCE %s TO %s;', s_name, db_user);
                EXECUTE str_sql;
                RAISE NOTICE '%', str_sql;
            END LOOP;
    END;
$$;
