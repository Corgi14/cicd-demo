-- For version reco0.6.0:

-- Add partitions for t_reco_history, from 2022-07 to 2022-12.
DO
$$
    DECLARE
        year    TEXT;
        i_month INT;
        str_sql TEXT;
    BEGIN
        year = '2022';
        FOR i_month IN
            SELECT month FROM generate_series(7, 12) AS month
            LOOP
                str_sql = E'SELECT add_range_partition(\'t_reco_history\'::regclass, \'%s-01-01\'::timestamp + \'%s month\'::interval,  \'%s-01-01\'::timestamp + \'%s month\' ::interval);';
                str_sql := FORMAT(str_sql, year, i_month - 1, year, i_month);
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;
            END LOOP;
    END;
$$;


-- Add partitions for t_log_event, from 2022-07 to 2022-12.
DO
$$
    DECLARE
        year    TEXT;
        i_month INT;
        str_sql TEXT;
    BEGIN
        year = '2022';
        FOR i_month IN
            SELECT month FROM generate_series(7, 12) AS month
            LOOP
                str_sql = E'SELECT add_range_partition(\'t_log_event\'::regclass, \'%s-01-01\'::timestamp + \'%s month\'::interval,  \'%s-01-01\'::timestamp + \'%s month\' ::interval);';
                str_sql := FORMAT(str_sql, year, i_month - 1, year, i_month);
                RAISE NOTICE '%', str_sql;
                EXECUTE str_sql;
            END LOOP;
    END;
$$;
