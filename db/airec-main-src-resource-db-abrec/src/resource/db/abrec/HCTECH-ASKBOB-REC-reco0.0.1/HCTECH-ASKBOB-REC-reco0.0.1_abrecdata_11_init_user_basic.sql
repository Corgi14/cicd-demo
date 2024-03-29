DROP TABLE IF EXISTS t_user_basic CASCADE;

DROP SEQUENCE IF EXISTS t_user_basic_id_seq;
CREATE SEQUENCE t_user_basic_id_seq START WITH 10000000;

CREATE TABLE t_user_basic
(
    ux_id        BIGINT        default nextval('t_user_basic_id_seq'::regclass) not null
        CONSTRAINT idx_pk_t_user_basic primary key,
    ux_code      VARCHAR(75) GENERATED ALWAYS AS (raw_src || ':' || raw_uid ) STORED
        CONSTRAINT c_unique_user_id UNIQUE,
    gmt_create   TIMESTAMP(6)  default CURRENT_TIMESTAMP                        not null,
    gmt_update   TIMESTAMP(6)  default CURRENT_TIMESTAMP                        not null,
    status       SMALLINT      default 0                                        not null,
    raw_src      VARCHAR(10)                                                    not null,
    raw_uid      VARCHAR(64)                                                    not null,
    ux_codes_rel VARCHAR(75)[] default null,
    info         JSONB         default null
);


COMMENT ON COLUMN t_user_basic.ux_id is 'auto-inc primary key, internal unified user id as bigint';
COMMENT ON COLUMN t_user_basic.ux_code is 'user code in the format of raw_src:raw_uid';
COMMENT ON COLUMN t_user_basic.gmt_create is 'UTC timestamp of record CREATE time';
COMMENT ON COLUMN t_user_basic.gmt_update is 'UTC timestamp of record UPDATE time';
COMMENT ON COLUMN t_user_basic.status is 'status 0 of the item 0 for normal';
COMMENT ON COLUMN t_user_basic.raw_src is 'source channel of the user record';
COMMENT ON COLUMN t_user_basic.raw_uid is 'raw user id from its original channel';
COMMENT ON COLUMN t_user_basic.ux_codes_rel is 'related ux_codes';
COMMENT ON COLUMN t_user_basic.info is 'additional info';

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_basic_gmt_create ON t_user_basic (gmt_create);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_basic_ux_code ON t_user_basic (ux_code);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_basic_ux_codes_rel_gin ON t_user_basic USING GIN (ux_codes_rel);
