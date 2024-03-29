-- add user_info child table for Life Insurance - Smart Speaker
DROP TABLE IF EXISTS t_user_info_app_life_spk;
CREATE TABLE t_user_info_app_life_spk
(
    tags JSONB default null,
    CHECK ( raw_src = 'life_spk' )
) INHERITS (t_user_info);
