-- For version reco0.0.8: add read permission for: `dbmonopr`, `devsup01`, `opesup`

DO
$$
    DECLARE
        t_schema     TEXT;
        t_name       TEXT;
        str_sql      TEXT;
        db_user_dml  TEXT;
        db_user_read TEXT;
    BEGIN
        db_user_dml := 'abrecopr';
        db_user_read := 'dbmonopr, devsup01, opesup';
        FOR t_schema, t_name IN
            SELECT table_schema, table_name
            FROM information_schema.tables
            WHERE table_type = 'BASE TABLE'
              AND table_schema IN ('public', 'kg', 'ysz')
            ORDER BY table_schema, table_name
            LOOP
                -- grant permission for schema
                str_sql := FORMAT('GRANT USAGE ON SCHEMA %s TO %s, %s;', t_schema, db_user_dml, db_user_read);
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;

                -- add DML permission to tables for user abrecopr
                str_sql := FORMAT('GRANT SELECT, INSERT,UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE ON TABLE %s.%s TO %s;', t_schema, t_name, db_user_dml);
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;

                -- add read permission to tables for user: dbmonopr, devsup01, opesup
                str_sql := FORMAT('GRANT SELECT ON TABLE %s.%s TO %s;', t_schema, t_name, db_user_read);
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;
            END LOOP;
    END;
$$;
