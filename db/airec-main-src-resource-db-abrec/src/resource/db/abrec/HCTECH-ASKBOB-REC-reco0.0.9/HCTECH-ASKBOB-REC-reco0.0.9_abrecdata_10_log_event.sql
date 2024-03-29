-- reference: https://help.aliyun.com/document_detail/140900.html

DROP TABLE IF EXISTS t_log_event CASCADE;
CREATE TABLE t_log_event
(
    st    timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ct    timestamp,
    ip    inet,
    label varchar(100) NOT NULL DEFAULT '',
    eid   varchar(100) NOT NULL,
    prop  jsonb
);

COMMENT ON TABLE t_log_event IS 'Event log table from frontend';
COMMENT ON COLUMN t_log_event.st IS 'Server-side timestamp of event';
COMMENT ON COLUMN t_log_event.ct IS 'Client-side timestamp of event';
COMMENT ON COLUMN t_log_event.ip IS 'Access IP address of client';
COMMENT ON COLUMN t_log_event.label IS 'Label of the event';
COMMENT ON COLUMN t_log_event.eid IS 'Event id of event';
COMMENT ON COLUMN t_log_event.prop IS 'Event log data';


CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_eid ON t_log_event (eid);

CREATE OR REPLACE FUNCTION f_abrec_event_callback_rename_partition(jsonb) RETURNS void AS
$$
DECLARE
    db_user_dml  TEXT;
    db_user_read TEXT;
BEGIN
    db_user_dml := 'abrecopr';
    db_user_read := 'dbmonopr, devsup01, opesup';

    IF ($1 ->> 'parttype')::int = 1 THEN -- when partition method is hash
        RAISE EXCEPTION 'parent: %, parttype: %, partition: %', $1 ->> 'parent', $1 ->> 'parttype', $1 ->> 'partition';
    ELSIF ($1 ->> 'parttype')::int = 2 THEN -- when partition method is range
        RAISE NOTICE 'parent: %, parttype: %, range: (%, %), partition: %, to_rename: %',
            $1 ->> 'parent', $1 ->> 'parttype', $1 ->> 'range_min', $1 ->> 'range_max', $1 ->> 'partition', to_char(($1 ->> 'range_min')::timestamp, 'yyyy_mm');

        -- Grant access for read-only user
        EXECUTE FORMAT('GRANT SELECT ON TABLE %s, %s TO %s;', $1 ->> 'parent', $1 ->> 'partition', db_user_read);
        -- Grant access for DML user
        EXECUTE FORMAT('GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER,TRUNCATE ON TABLE %s, %s TO %s;', $1 ->> 'parent', $1 ->> 'partition', db_user_dml);

        EXECUTE FORMAT('ALTER TABLE %s RENAME TO t_log_event_%s;', $1 ->> 'partition', to_char(($1 ->> 'range_min')::timestamp, 'yyyy_mm'));
    END IF;
END;
$$ LANGUAGE plpgsql STRICT;


-- previous schema of these functions dbmgr
SELECT set_init_callback('t_log_event'::regclass, 'f_abrec_event_callback_rename_partition'::regproc);
SELECT set_auto('t_log_event'::REGCLASS, true);
SELECT set_enable_parent('t_log_event'::regclass, false);

SELECT create_range_partitions(
               't_log_event'::regclass, -- 主表OID
               'st', -- 分区列名: 使用埋点日志到达采集服务器的时间进行分区
               '2022-02-01 00:00:00'::timestamp, -- 开始值
               interval '1 month', -- 间隔: interval 类型，用于时间分区表
               1, -- 分多少个区
               true -- 是否迁移数据
           );


-- Create partitions for t_log_event
DO
$$
    DECLARE
        year    TEXT;
        i_month INT;
        sql     TEXT;
    BEGIN
        year = '2022';
        FOR i_month IN
            SELECT month FROM generate_series(2, 5) AS month
            LOOP
                sql = E'SELECT add_range_partition(\'t_log_event\'::regclass, \'%s-01-01\'::timestamp + \'%s month\'::interval,  \'%s-02-01\'::timestamp + \'%s month\'::interval);';
                sql := FORMAT(sql, year, i_month, year, i_month);
                RAISE NOTICE '%', sql;
                EXECUTE sql;
            END LOOP;
    END;
$$;
