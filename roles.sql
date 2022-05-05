CREATE USER reportingapp PASSWORD = '123456789' COMMENT = 'User for Reporting Apps' DEFAULT_WAREHOUSE = 'COMPUTE_WH' DEFAULT_NAMESPACE = 'REVIEWS' MUST_CHANGE_PASSWORD = FALSE;

CREATE ROLE "REVIEWREADER";

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE REVIEWREADER;
GRANT USAGE ON DATABASE REVIEWS TO ROLE REVIEWREADER;
GRANT USAGE ON SCHEMA REVIEWS.PUBLIC TO ROLE REVIEWREADER;
GRANT SELECT ON ALL TABLES IN SCHEMA REVIEWS.PUBLIC TO ROLE REVIEWREADER;
GRANT SELECT ON ALL VIEWS IN SCHEMA REVIEWS.PUBLIC TO ROLE REVIEWREADER;
GRANT SELECT ON FUTURE TABLES IN SCHEMA REVIEWS.PUBLIC TO ROLE REVIEWREADER;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA REVIEWS.PUBLIC TO ROLE REVIEWREADER;

GRANT ROLE REVIEWREADER TO USER reportingapp;

ALTER USER reportingapp SET DEFAULT_ROLE='REVIEWREADER';

SHOW GRANTS TO ROLE REVIEWREADER;
SHOW GRANTS OF ROLE REVIEWREADER;