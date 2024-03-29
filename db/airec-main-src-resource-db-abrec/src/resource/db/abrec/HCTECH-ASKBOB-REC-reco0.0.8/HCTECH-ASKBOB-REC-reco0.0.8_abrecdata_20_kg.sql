DROP TABLE IF EXISTS public.t_rec_kg_hypernym, public.t_kg_taxonomy, kg.t_rec_kg_hypernym;
CREATE TABLE kg.t_rec_kg_hypernym
(
    instance   VARCHAR(64) PRIMARY KEY,
    status     SMALLINT     DEFAULT 0                 NOT NULL,
    gmt_create TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    gmt_update TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    level      JSONB
);
COMMENT ON TABLE kg.t_rec_kg_hypernym IS '图谱关系-原子标签及其上位关系';
COMMENT ON COLUMN kg.t_rec_kg_hypernym.instance IS '原始的原子标签';
COMMENT ON COLUMN kg.t_rec_kg_hypernym.status IS '记录的状态，值为0表示正常可用的状态';
COMMENT ON COLUMN kg.t_rec_kg_hypernym.level IS '原子标签的上位';


DROP TABLE IF EXISTS public.t_rec_kg_triples, kg.t_rec_kg_triples;
CREATE TABLE kg.t_rec_kg_triples
(
    "_id"      VARCHAR(32) PRIMARY KEY,
    h_id       VARCHAR(50),
    h_type     VARCHAR(20) GENERATED ALWAYS AS ( SUBSTRING(h_id FROM '^[A-Z]+') ) STORED,
    h_name     VARCHAR(255),
    r_type     VARCHAR(10),
    r_group    VARCHAR(2)   DEFAULT '0',
    t_id       VARCHAR(50),
    t_type     VARCHAR(20) GENERATED ALWAYS AS ( SUBSTRING(t_id FROM '^[A-Z]+') ) STORED,
    t_name     VARCHAR(255),
    status     SMALLINT     DEFAULT 1,
    gmt_create TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    gmt_update TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    source     VARCHAR(20),
    prop       JSONB
);

COMMENT ON TABLE kg.t_rec_kg_triples IS '图谱关系';
COMMENT ON COLUMN kg.t_rec_kg_triples.h_id IS '头实体id';
COMMENT ON COLUMN kg.t_rec_kg_triples.t_id IS '尾实体id';
COMMENT ON COLUMN kg.t_rec_kg_triples.r_group IS '关系组';
COMMENT ON COLUMN kg.t_rec_kg_triples."source" IS '来源';
COMMENT ON COLUMN kg.t_rec_kg_triples.status IS '状态';
