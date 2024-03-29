DROP TABLE IF EXISTS t_user_info CASCADE;

DROP SEQUENCE IF EXISTS t_usr_info_id_seq;
CREATE SEQUENCE t_usr_info_id_seq;

CREATE TABLE t_user_info
(
    _id        BIGINT       default nextval('t_usr_info_id_seq'::regclass) not null
        constraint t_user_info_pk primary key,
    gmt_create TIMESTAMP(6) default CURRENT_TIMESTAMP                      not null,
    status     SMALLINT     default 0                                      not null,
    ux_code    VARCHAR(75) GENERATED ALWAYS AS (raw_src || ':' || raw_uid ) STORED,
    raw_src    VARCHAR(10)                                                 not null,
    raw_uid    VARCHAR(64)                                                 not null,
    raw_time   TIMESTAMP(6) default CURRENT_TIMESTAMP,
    info       JSONB        default null
);


COMMENT ON COLUMN t_user_info._id is 'auto-inc primary key';
COMMENT ON COLUMN t_user_info.gmt_create is 'UTC timestamp of CREATE time';
COMMENT ON COLUMN t_user_info.status is 'status 0 of the item 0 for normal';
COMMENT ON COLUMN t_user_info.raw_src is 'source channel of the information';
COMMENT ON COLUMN t_user_info.raw_uid is 'raw user id from its original channel';
COMMENT ON COLUMN t_user_info.raw_time is 'raw time update by its original channel';
COMMENT ON COLUMN t_user_info.info is 'detailed info';

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_info_raw_uid ON t_user_info (raw_uid);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_info_ux_code ON t_user_info (ux_code);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_info_raw_time ON t_user_info (raw_time);

DROP TABLE IF EXISTS t_user_info_app_jgj;
CREATE TABLE t_user_info_app_jgj
(
    CHECK ( raw_src = 'app_jgj' )
) INHERITS (t_user_info);

DROP TABLE IF EXISTS t_user_info_gbd_tag_ins_prop;
CREATE TABLE t_user_info_gbd_tag_ins_prop
(
    CHECK ( raw_src = 'gbd_tag_ins_prop' )
) INHERITS (t_user_info);

DROP TABLE IF EXISTS t_user_info_gbd_tag_ins_life;
CREATE TABLE t_user_info_gbd_tag_ins_life
(
    CHECK ( raw_src = 'gbd_tag_ins_life' )
) INHERITS (t_user_info);

DROP TABLE IF EXISTS t_user_info_gbd_tag_ins_annuity;
CREATE TABLE t_user_info_gbd_tag_ins_annuity
(
    CHECK ( raw_src = 'gbd_tag_ins_annuity' )
) INHERITS (t_user_info);

DROP TABLE IF EXISTS t_user_info_gbd_tag_ins_annuity;
CREATE TABLE t_user_info_gbd_tag_ins_health
(
    CHECK ( raw_src = 'gbd_tag_ins_health' )
) INHERITS (t_user_info);
