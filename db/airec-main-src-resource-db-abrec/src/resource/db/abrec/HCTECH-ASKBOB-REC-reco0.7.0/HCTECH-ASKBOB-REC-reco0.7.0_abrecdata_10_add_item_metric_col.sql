-- For version reco0.7.0:

-- Add t_item metric column

DO
$$
    DECLARE
        str_sql     TEXT;
        table_child TEXT;
    BEGIN
        FOR table_child IN
            SELECT 't_item' AS child
            UNION
            SELECT C.relname AS child
            FROM pg_inherits
                     JOIN pg_class AS C ON (inhrelid = C.oid)
                     JOIN pg_class AS P ON (inhparent = P.oid)
            WHERE P.relname = 't_item'
            LOOP
                str_sql := FORMAT(
                        'ALTER TABLE %s ADD COLUMN IF NOT EXISTS metric JSONB default null;',
                        table_child
                    );
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;
            END LOOP;
    END;
    $$;
