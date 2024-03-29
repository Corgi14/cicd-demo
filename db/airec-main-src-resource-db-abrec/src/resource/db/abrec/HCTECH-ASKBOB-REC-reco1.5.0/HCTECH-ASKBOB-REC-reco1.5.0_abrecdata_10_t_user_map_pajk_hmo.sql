DROP TABLE IF EXISTS t_user_map_pajk_hmo CASCADE;

DROP SEQUENCE IF EXISTS t_user_map_pajk_hmo_id_seq;
CREATE SEQUENCE t_user_map_pajk_hmo_id_seq;

CREATE TABLE t_user_map_pajk_hmo
(
    _id        BIGINT       default nextval('t_user_map_pajk_hmo_id_seq'::regclass) not null
        constraint t_user_map_pajk_hmo_pk primary key,
    gmt_create TIMESTAMP(6) default CURRENT_TIMESTAMP                               not null,
    raw_time   TIMESTAMP(6) default null,
    status     SMALLINT     default 0                                               not null,
    ux_code    VARCHAR(75) GENERATED ALWAYS AS (raw_src || ':' || raw_uid) STORED,
    raw_src    VARCHAR(10)                                                          not null,
    raw_uid    VARCHAR(64)                                                          not null,
    user_name  VARCHAR(99)                                                          not null,
    nick_name  VARCHAR(99)  default null,
    group_id   VARCHAR(64)  default null,
    group_name VARCHAR(99)  default null
);


CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_map_pajk_hmo_raw_uid ON t_user_map_pajk_hmo (raw_uid);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_map_pajk_hmo_group_id ON t_user_map_pajk_hmo (group_id);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_map_pajk_hmo_user_name ON t_user_map_pajk_hmo (user_name);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_map_pajk_hmo_nick_name ON t_user_map_pajk_hmo (nick_name);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_map_pajk_hmo_group_name ON t_user_map_pajk_hmo (group_name);
