-- add item sub table for articles: three_hypers and other articles
DROP TABLE IF EXISTS t_item_article;
CREATE TABLE t_item_article
(
    CHECK ( type = 'article'),
    CONSTRAINT c_item_article UNIQUE (id)
) INHERITS (t_item);
