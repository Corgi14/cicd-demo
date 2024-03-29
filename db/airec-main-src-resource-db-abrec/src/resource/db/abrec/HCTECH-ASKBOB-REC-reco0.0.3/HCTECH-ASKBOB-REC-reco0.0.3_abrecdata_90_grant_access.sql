-- For version reco0.0.3: add read permission for dbmonopr

-- change table t_reco_history partition function
CREATE OR REPLACE FUNCTION f_abrec_history_callback_rename_partition(jsonb) RETURNS void AS
$$
DECLARE
    db_user TEXT;
BEGIN
    db_user := 'abrecopr';

    IF ($1 ->> 'parttype')::int = 1 THEN -- when partition method is hash
        raise exception 'parent: %, parttype: %, partition: %', $1 ->> 'parent', $1 ->> 'parttype', $1 ->> 'partition';
    ELSIF ($1 ->> 'parttype')::int = 2 THEN -- when partition method is range
        raise notice 'parent: %, parttype: %, partition: %, range_max: %, range_min: %',
            $1 ->> 'parent', $1 ->> 'parttype', $1 ->> 'partition', $1 ->> 'range_max', $1 ->> 'range_min';

        EXECUTE FORMAT('GRANT USAGE, SELECT ON SEQUENCE %s TO %s;', 't_reco_history__id_seq', db_user);
        EXECUTE FORMAT('GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE ON TABLE %s TO %s;', $1 ->> 'parent', db_user);
        EXECUTE FORMAT('GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE ON TABLE %s TO %s;', $1 ->> 'partition', db_user);

        EXECUTE FORMAT('GRANT SELECT ON TABLE %s TO %s;', $1 ->> 'parent', 'dbmonopr');  -- read-only user for monitoring
        EXECUTE FORMAT('GRANT SELECT ON TABLE %s TO %s;', $1 ->> 'partition', 'dbmonopr');  -- read-only user for monitoring

        EXECUTE FORMAT('ALTER TABLE %s RENAME TO t_reco_history_%s;', $1 ->> 'partition', to_char(($1 ->> 'range_min')::timestamp, 'yyyy_mm'));
    END IF;
END;
$$ LANGUAGE plpgsql STRICT;


-- add permission to tables for user dbmonopr
DO
$$
    DECLARE
        t_name  TEXT;
        str_sql TEXT;
        db_user TEXT;
    BEGIN
        db_user := 'dbmonopr';
        FOR t_name IN
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'public'
              AND table_type = 'BASE TABLE'
              AND table_name ILIKE 't_reco_history%'
            ORDER BY table_name
            LOOP
                str_sql := FORMAT('GRANT SELECT ON TABLE %s TO %s;', t_name, db_user);
                EXECUTE str_sql;
                RAISE NOTICE '%', str_sql;
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
        db_users := ARRAY ['abrecopr', 'dbmonopr'];
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
