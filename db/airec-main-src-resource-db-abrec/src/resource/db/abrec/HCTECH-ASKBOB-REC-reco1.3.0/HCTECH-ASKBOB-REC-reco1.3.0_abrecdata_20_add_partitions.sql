DO
$$
    DECLARE
        year    TEXT;
        i_month INT;
        sql     TEXT;
        span    TEXT;
    BEGIN
        year = '2023';
        FOR i_month IN
            SELECT month FROM generate_series(0, 12) AS month
            LOOP
                span = E'\'%s-01-01\'::timestamp + \'%s month\'::interval,  \'%s-02-01\'::timestamp + \'%s month\'::interval';
                span := FORMAT(span, year, i_month, year, i_month);
                sql = E'SELECT ' ||
                      FORMAT(E'add_range_partition(\'t_reco_history\'::regclass, %s),', span) || -- Add partitions for t_reco_history
                      FORMAT(E'add_range_partition(\'t_log_event\'::regclass,    %s),', span) || -- Add partitions for t_user_event
                      FORMAT(E'add_range_partition(\'t_user_event\'::regclass,   %s);', span); -- Add partitions for t_log_event
                RAISE NOTICE '%', sql;
                EXECUTE sql;
            END LOOP;
    END;
$$;
