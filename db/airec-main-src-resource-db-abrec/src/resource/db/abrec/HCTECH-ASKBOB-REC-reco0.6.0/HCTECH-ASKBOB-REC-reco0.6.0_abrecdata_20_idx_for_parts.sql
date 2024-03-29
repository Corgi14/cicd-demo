-- Iterate over each child table of t_reco_history to create index on each child table.
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
            WHERE P.relname = 't_reco_history'
            ORDER BY C.relname
            LOOP
                str_sql := 'CREATE INDEX IF NOT EXISTS idx_%s_reco_time ON %s USING BRIN(reco_time);'; -- CONCURRENTLY
                str_sql = FORMAT(str_sql, table_child, table_child);
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;
            END LOOP;
    END;
$$;

-- Iterate over each child table of t_log_event to create index on each child table.
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
            WHERE P.relname = 't_log_event'
            ORDER BY C.relname
            LOOP
                str_sql := 'CREATE INDEX IF NOT EXISTS idx_%s_reco_time ON %s USING BRIN(st);'; -- CONCURRENTLY
                str_sql = FORMAT(str_sql, table_child, table_child);
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;
            END LOOP;
    END;
$$;
