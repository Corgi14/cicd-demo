-- Iterate over each child table to create trigger/index on each child table.
DO
$$
    DECLARE
        str_sql     TEXT;
        table_child TEXT;
    BEGIN
        FOR table_child IN
            SELECT C.relname AS child
            FROM pg_inherits
                     JOIN pg_class AS C ON (inhrelid = C.oid)
                     JOIN pg_class AS P ON (inhparent = P.oid)
            WHERE P.relname = 't_user_info'
            LOOP
                str_sql := FORMAT(
                        'CREATE INDEX IF NOT EXISTS idx_%s_raw_uid ON %s (raw_uid);',
                        table_child, table_child
                    );
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;
            END LOOP;
    END;
$$;
