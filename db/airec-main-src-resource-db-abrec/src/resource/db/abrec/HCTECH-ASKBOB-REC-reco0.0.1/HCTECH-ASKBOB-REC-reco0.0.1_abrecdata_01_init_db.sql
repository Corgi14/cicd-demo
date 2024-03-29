DO
$$
    DECLARE
        name_ext text     = 'pg_pathman';
        status   smallint = 0;
    BEGIN
        SELECT rds_manage_extension('create', name_ext) INTO status;
        status := 1;
        RAISE NOTICE 'Extension % created.', name_ext;
    EXCEPTION
        WHEN OTHERS THEN
            SELECT COUNT(*) AS is_avaliable FROM pg_available_extensions WHERE name = name_ext INTO status;
            RAISE NOTICE 'Extension % status: %', name_ext, status;
    END;
$$;
