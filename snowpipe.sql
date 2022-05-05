Use Reviews;

CREATE STAGE "REVIEWS"."PUBLIC".AzureDataLake URL = 'azure://snowflakecourse.blob.core.windows.net/snowflake-stage' CREDENTIALS = (AZURE_SAS_TOKEN = '*****************************************************');

show stages;

list @azuredatalake;

create or replace file format CSVFORMAT_QUOTES TYPE = 'CSV' FIELD_DELIMITER = ',' FIELD_OPTIONALLY_ENCLOSED_BY='"';

select file.$1, file.$2, file.$3, file.$4, file.$5, file.$6
from @azuredatalake/dataimports/reviews/reviews1.csv (file_format => CSVFORMAT_QUOTES) file
LIMIT 1;

create or replace pipe  reviews_pipe as
copy into reviews from @azuredatalake/dataimports/reviews/
file_format = CSVFORMAT_QUOTES;

select count(*) from reviews;

select system$pipe_status('reviews_pipe');

alter pipe reviews_pipe refresh;
    
select *
from table(information_schema.copy_history(table_name=>'reviews', start_time=> dateadd(hours, -1, current_timestamp())));