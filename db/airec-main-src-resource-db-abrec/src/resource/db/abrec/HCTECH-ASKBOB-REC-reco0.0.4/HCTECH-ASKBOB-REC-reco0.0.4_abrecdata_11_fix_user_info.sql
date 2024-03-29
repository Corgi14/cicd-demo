DROP TABLE IF EXISTS t_user_info_app_life_spk;
CREATE TABLE t_user_info_app_life_spk
(
    CHECK ( raw_src = 'life_spk' )
) INHERITS (t_user_info);
