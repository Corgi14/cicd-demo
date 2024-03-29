-- For version reco0.0.4:

-- Fix t_reco_history_partitions
DO
$$
    DECLARE
        year    TEXT;
        i_month INT;
        str_sql TEXT;
    BEGIN
        year = '2022';
        FOR i_month IN
            SELECT month FROM generate_series(0, 5) AS month
            LOOP
                str_sql =
                        E'SELECT add_range_partition(\'t_reco_history\'::regclass, \'2022-01-01 00:00:00\'::timestamp + \'%s month\'::interval,  \'2022-02-01 00:00:00\'::timestamp + \'%s month\' ::interval);';
                -- RAISE NOTICE '%', str_sql;
                str_sql := FORMAT(str_sql, i_month, i_month);
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;
            END LOOP;
    END;
$$;
