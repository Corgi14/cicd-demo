DROP TABLE IF EXISTS t_item CASCADE;

DROP SEQUENCE IF EXISTS t_item_id_seq;
CREATE SEQUENCE t_item_id_seq START WITH 1000000;

CREATE TABLE t_item
(
    _id        BIGINT        default nextval('t_item_id_seq'::regclass) not null
        constraint t_content_raw_pk primary key,
    id         VARCHAR(32)                                              not null,
    type       VARCHAR(25)                                              not null,
    status     SMALLINT      default 0                                  not null,
    gmt_create TIMESTAMP(6)  default CURRENT_TIMESTAMP                  not null,
    gmt_update TIMESTAMP(6)  default CURRENT_TIMESTAMP                  not null,
    title      VARCHAR(255)                                             not null,
    author     VARCHAR(40)   default null,
    summary    VARCHAR(1000) default null,
    link       VARCHAR(1000) default null,
    thumbnail  VARCHAR(1000) default null,
    content    TEXT          default null,
    permission JSONB         default null,
    info       JSONB         default null,
    tags       JSONB         default null
);


CREATE OR REPLACE FUNCTION f_t_item_update_timestamp() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    NEW.gmt_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER tg_t_item_update_timestamp
    AFTER UPDATE
    ON t_item
    FOR EACH ROW
EXECUTE PROCEDURE f_t_item_update_timestamp();


COMMENT ON COLUMN t_item._id is 'auto-inc primary key, NOT item_id';
COMMENT ON COLUMN t_item.id is 'raw id of the item';
COMMENT ON COLUMN t_item.type is 'type of the item';
COMMENT ON COLUMN t_item.status is 'status 0 of the item 0 for normal';
COMMENT ON COLUMN t_item.gmt_create is 'UTC timestamp of CREATE time';
COMMENT ON COLUMN t_item.gmt_update is 'UTC timestamp of UPDATE time';
COMMENT ON COLUMN t_item.title is 'title of the content';
COMMENT ON COLUMN t_item.author is 'author of the content';
COMMENT ON COLUMN t_item.summary is 'summary or abstract of the content';
COMMENT ON COLUMN t_item.link is 'optional external link of the content';
COMMENT ON COLUMN t_item.thumbnail is 'optional picture link of the content';
COMMENT ON COLUMN t_item.content is 'detail information of the content';
COMMENT ON COLUMN t_item.info is 'other fields as JSONB format';
COMMENT ON COLUMN t_item.permission is 'permission settings';
COMMENT ON COLUMN t_item.tags is 'tags information';

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_item_type ON t_item (type);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_item_id ON t_item (id);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_item_gmt_update ON t_item (gmt_update);

CREATE INDEX IF NOT EXISTS idx_t_item_tags_v1_gin ON t_item USING gin (to_tsvector('simple', tags -> 'v1'));

CREATE TABLE t_item_service_jgj
(
    CHECK ( type = 'service_jgj' ),
    CONSTRAINT c_item_service_jgj_id UNIQUE (id)
) INHERITS (t_item);
-- ALTER TABLE t_item_service_jgj ADD CONSTRAINT c_item_service_jgj_id UNIQUE (id);

CREATE TABLE t_item_pedia_food
(
    CHECK ( type = 'pedia_food' ),
    CONSTRAINT c_item_pedia_food_id UNIQUE (id)
) INHERITS (t_item);
-- ALTER TABLE t_item_pedia_food ADD CONSTRAINT c_item_pedia_food_id UNIQUE (id);

CREATE TABLE t_item_pedia_sport
(
    CHECK ( type = 'pedia_sport' ),
    CONSTRAINT c_item_pedia_sport_id UNIQUE (id)
) INHERITS (t_item);
-- ALTER TABLE t_item_pedia_sport ADD CONSTRAINT c_item_pedia_sport_id UNIQUE (id);

CREATE TABLE t_item_pedia_disease
(
    CHECK ( type = 'pedia_disease' ),
    CONSTRAINT c_item_pedia_disease_id UNIQUE (id)
) INHERITS (t_item);
-- ALTER TABLE t_item_pedia_disease ADD CONSTRAINT c_item_pedia_disease_id UNIQUE (id);

CREATE TABLE t_item_faq
(
    CHECK ( type = 'faq'),
    CONSTRAINT c_item_faq_id UNIQUE (id)
) INHERITS (t_item);
-- ALTER TABLE t_item_faq ADD CONSTRAINT c_item_faq_id UNIQUE (id);
