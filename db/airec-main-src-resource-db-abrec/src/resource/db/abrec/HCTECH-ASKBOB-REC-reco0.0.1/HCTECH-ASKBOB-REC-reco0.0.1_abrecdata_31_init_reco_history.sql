-- reference: https://help.aliyun.com/document_detail/140900.html
-- CREATE EXTENSION IF NOT EXISTS pg_pathman;

-- SELECT current_user, session_user;

DROP TABLE IF EXISTS t_reco_history CASCADE;

DROP SEQUENCE IF EXISTS t_reco_history__id_seq;
CREATE SEQUENCE t_reco_history__id_seq;

CREATE TABLE t_reco_history
(
    _id       BIGINT      NOT NULL DEFAULT nextval('t_reco_history__id_seq'::regclass),
    reco_time TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    context   VARCHAR(32) NOT NULL,
    ux_code   VARCHAR(75) NOT NULL,
    sess_id   VARCHAR(32),
    item_id   VARCHAR(32),
    item_type VARCHAR(32),
    item_time TIMESTAMP,
    spm_a     VARCHAR(100),
    spm_b     VARCHAR(200)
);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_ux_code ON t_reco_history (ux_code);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_ux_code_reco_time ON t_reco_history (ux_code, reco_time);

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
        EXECUTE FORMAT('GRANT SELECT, INSERT,UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE ON TABLE %s TO %s;', $1 ->> 'parent', db_user);
        EXECUTE FORMAT('GRANT SELECT, INSERT,UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE ON TABLE %s TO %s;', $1 ->> 'partition', db_user);

        EXECUTE FORMAT('ALTER TABLE %s RENAME TO t_reco_history_%s;', $1 ->> 'partition', to_char(($1 ->> 'range_min')::timestamp, 'yyyy_mm'));
    END IF;
END;
$$ LANGUAGE plpgsql STRICT;


-- previous schema of these functions dbmgr
SELECT set_init_callback('t_reco_history'::regclass, 'f_abrec_history_callback_rename_partition'::regproc);
SELECT set_auto('t_reco_history'::REGCLASS, true);
SELECT set_enable_parent('t_reco_history'::regclass, false);

SELECT create_range_partitions(
               't_reco_history'::regclass, -- 主表OID
               'reco_time', -- 分区列名
               '2021-12-01 00:00:00'::timestamp, -- 开始值
               interval '1 month', -- 间隔: interval 类型，用于时间分区表
               1, -- 分多少个区
               true -- 是否迁移数据
           );
