use Reviews;

put file://C:\Users\warneradmin\Documents\Snowflake\csvfiles\users.csv @~/staged;
put file://C:\Users\trent_brunson\Documents\Training\Snowflake\04\demos\users.csv @~/staged;

C:\Users\trent_brunson\Documents\Training\Snowflake\04\demos

list @~;

list @~/staged;

put file://C:\Users\warneradmin\Documents\Snowflake\csvfiles\users.csv @%users/staged;
put file://C:\Users\trent_brunson\Documents\Training\Snowflake\04\demos\users.csv @%users/staged;

list @%users;

CREATE OR REPLACE STAGE shared_stage
  file_format = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

show stages;

put file://C:\Users\warneradmin\Documents\Snowflake\csvfiles\users.csv @shared_stage/staged;
put file://C:\Users\trent_brunson\Documents\Training\Snowflake\04\demos\users.csv @shared_stage/staged;

list @shared_stage;

copy into users from @~/staged file_format = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);

copy into users from @~/staged file_format = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1) ON_ERROR=CONTINUE;

select * from table(validate(users, job_id => '_last'));

truncate table users;

copy into users from @~/staged file_format = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1) VALIDATION_MODE = 'RETURN_ERRORS';

copy into users from @~/staged file_format = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY='"') purge=true;

list @~;

select * from users limit 10;

truncate table users;

copy into users from @shared_stage/staged purge=true;

truncate table users;

copy into reviews from @%users/staged file_format = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

copy into users from @%users/staged file_format = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

list @%users;

remove @%users/staged/;

select *
from table(information_schema.copy_history(table_name=>'users', start_time=> dateadd(hours, -1, current_timestamp())));