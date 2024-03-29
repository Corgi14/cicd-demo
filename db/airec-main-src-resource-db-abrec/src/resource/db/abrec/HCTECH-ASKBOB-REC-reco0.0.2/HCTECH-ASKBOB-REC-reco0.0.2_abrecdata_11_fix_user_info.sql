DROP TABLE IF EXISTS t_user_info_gbd_tag_ins_prop;
CREATE TABLE t_user_info_gbd_tag_ins_prop
(
    CHECK ( raw_src = 'ins_prop' )
) INHERITS (t_user_info);

DROP TABLE IF EXISTS t_user_info_gbd_tag_ins_life;
CREATE TABLE t_user_info_gbd_tag_ins_life
(
    CHECK ( raw_src = 'ins_life' )
) INHERITS (t_user_info);

DROP TABLE IF EXISTS t_user_info_gbd_tag_ins_annuity;
CREATE TABLE t_user_info_gbd_tag_ins_annuity
(
    CHECK ( raw_src = 'ins_annu' )
) INHERITS (t_user_info);

DROP TABLE IF EXISTS t_user_info_gbd_tag_ins_health;
CREATE TABLE t_user_info_gbd_tag_ins_health
(
    CHECK ( raw_src = 'ins_health' )
) INHERITS (t_user_info);
