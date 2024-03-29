-- remove old constraint of checking raw_src = 'jgj'
ALTER TABLE t_user_info_app_jgj
    DROP CONSTRAINT IF EXISTS t_user_info_app_jgj_raw_src_check;

-- add new constraint of check raw_src starts with 'jgj'
ALTER TABLE t_user_info_app_jgj
    ADD CONSTRAINT t_user_info_app_jgj_raw_src_check CHECK ( SUBSTRING(raw_src, '^[A-Z]+') = 'jgj');
