-- For version reco0.0.5: add read permission for `dbmonopr` and `devsup01` and `opesup`

-- change table t_reco_history partition function
CREATE OR REPLACE FUNCTION f_abrec_history_callback_rename_partition(jsonb) RETURNS void AS
$$
DECLARE
    db_user TEXT;
BEGIN
    db_user := 'abrecopr';

    IF ($1 ->> 'parttype')::int = 1 THEN -- when partition method is hash
        RAISE EXCEPTION 'parent: %, parttype: %, partition: %', $1 ->> 'parent', $1 ->> 'parttype', $1 ->> 'partition';
    ELSIF ($1 ->> 'parttype')::int = 2 THEN -- when partition method is range
        RAISE NOTICE 'parent: %, parttype: %, partition: %, range_max: %, range_min: %',
            $1 ->> 'parent', $1 ->> 'parttype', $1 ->> 'partition', $1 ->> 'range_max', $1 ->> 'range_min';

        EXECUTE FORMAT('GRANT USAGE, SELECT ON SEQUENCE %s TO %s;', 't_reco_history__id_seq', db_user);
        EXECUTE FORMAT('GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE ON TABLE %s TO %s;', $1 ->> 'parent', db_user);
        EXECUTE FORMAT('GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE ON TABLE %s TO %s;', $1 ->> 'partition', db_user);

        -- dbmonopr:  for monitoring; devsup01: for dbsearch dev; opesup: for dbsearch operation
        EXECUTE FORMAT('GRANT SELECT ON TABLE %s TO %s;', $1 ->> 'parent', 'dbmonopr, devsup01, opesup');  -- read-only user
        EXECUTE FORMAT('GRANT SELECT ON TABLE %s TO %s;', $1 ->> 'partition', 'dbmonopr, devsup01, opesup');  -- read-only user

        EXECUTE FORMAT('ALTER TABLE %s RENAME TO t_reco_history_%s;', $1 ->> 'partition', to_char(($1 ->> 'range_min')::timestamp, 'yyyy_mm'));
    END IF;
END;
$$ LANGUAGE plpgsql STRICT;


-- add read permission to tables for user: dbmonopr, devsup01, opesup
DO
$$
    DECLARE
        t_name  TEXT;
        str_sql TEXT;
        db_user TEXT;
    BEGIN
        db_user := 'dbmonopr, devsup01, opesup';
        FOR t_name IN
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'public'
              AND table_type = 'BASE TABLE'
            ORDER BY table_name
            LOOP
                str_sql := FORMAT('GRANT SELECT ON TABLE %s TO %s;', t_name, db_user);
                EXECUTE str_sql;
                RAISE NOTICE '%', str_sql;
            END LOOP;
    END;
$$;
