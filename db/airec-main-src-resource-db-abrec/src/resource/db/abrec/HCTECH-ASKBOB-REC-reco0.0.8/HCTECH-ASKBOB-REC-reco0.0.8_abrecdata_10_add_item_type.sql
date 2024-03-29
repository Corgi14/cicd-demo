-- add item sub table for health_plan
DROP TABLE IF EXISTS t_item_health_plan;
CREATE TABLE t_item_health_plan
(
    CHECK ( type = 'health_plan'),
    CONSTRAINT c_item_health_plan_id UNIQUE (id)
) INHERITS (t_item);

-- add item sub table for pedia_check
CREATE TABLE t_item_pedia_check
(
    CHECK ( type = 'pedia_check' ),
    CONSTRAINT c_item_pedia_check_id UNIQUE (id)
) INHERITS (t_item);
