-- For version reco0.0.3: add index for child tables (previously added only for parent table)

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_info_ux_code_app_jgj ON t_user_info_app_jgj (ux_code);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_info_ux_code_ins_prop ON t_user_info_gbd_tag_ins_prop (ux_code);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_info_ux_code_ins_life ON t_user_info_gbd_tag_ins_life (ux_code);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_info_ux_code_ins_annu ON t_user_info_gbd_tag_ins_annuity (ux_code);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_info_ux_code_ins_health ON t_user_info_gbd_tag_ins_health (ux_code);


CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_item_tags_faq_v1_gin ON t_item_faq USING gin (to_tsvector('simple', tags -> 'v1'));
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_item_tags_pedia_disease_v1_gin ON t_item_pedia_disease USING gin (to_tsvector('simple', tags -> 'v1'));
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_item_tags_pedia_food_v1_gin ON t_item_pedia_food USING gin (to_tsvector('simple', tags -> 'v1'));
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_item_tags_pedia_sport_v1_gin ON t_item_pedia_sport USING gin (to_tsvector('simple', tags -> 'v1'));
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_item_tags_service_jgj_v1_gin ON t_item_service_jgj USING gin (to_tsvector('simple', tags -> 'v1'));
