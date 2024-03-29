SET SEARCH_PATH = 'public';

DROP TABLE IF EXISTS t_user_info_gbd_tag_ins_prop, t_user_info_gbd_tag_ins_life, t_user_info_gbd_tag_ins_health;


DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 't_user_info_gbd_tag_ins_annuity') THEN
        EXECUTE 'ALTER TABLE t_user_info_gbd_tag_ins_annuity RENAME TO t_user_info_pajk_hmo;';
    END IF;
END$$;


ALTER TABLE t_user_info_pajk_hmo
    DROP CONSTRAINT t_user_info_gbd_tag_ins_annuity_raw_src_check;


ALTER TABLE t_user_info_pajk_hmo
    ADD CONSTRAINT t_user_info_pajk_hmo_raw_src_check
        CHECK ((raw_src)::text = 'wx-cdm'::text);
