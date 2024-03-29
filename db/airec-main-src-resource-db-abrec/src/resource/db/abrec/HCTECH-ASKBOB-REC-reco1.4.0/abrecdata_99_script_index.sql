CREATE TABLE IF NOT EXISTS t_user_info_gbd_tag_ins_life
(
    CHECK ( raw_src = 'ins_life' )
) INHERITS (t_user_info);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_t_user_info_ux_code_ins_life ON t_user_info_gbd_tag_ins_life (ux_code);
