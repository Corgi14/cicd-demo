-- add item child table for pedia_drug
DROP TABLE IF EXISTS t_item_pedia_drug;
CREATE TABLE t_item_pedia_drug
(
    CHECK ( type = 'pedia_drug' ),
    CONSTRAINT c_item_pedia_drug_id UNIQUE (id)
) INHERITS (t_item);

DROP TABLE IF EXISTS t_item_pedia_hospital;
CREATE TABLE t_item_pedia_hospital
(
    CHECK ( type = 'pedia_hospital' ),
    CONSTRAINT c_item_pedia_hospital_id UNIQUE (id)
) INHERITS (t_item);

DROP TABLE IF EXISTS t_item_pedia_doctor;
CREATE TABLE t_item_pedia_doctor
(
    CHECK ( type = 'pedia_doctor' ),
    CONSTRAINT c_item_pedia_doctor_id UNIQUE (id)
) INHERITS (t_item);

DROP TABLE IF EXISTS t_item_pedia_department;
CREATE TABLE t_item_pedia_department
(
    CHECK ( type = 'pedia_department' ),
    CONSTRAINT c_item_pedia_department_id UNIQUE (id)
) INHERITS (t_item);
