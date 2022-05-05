use SNOWFLAKE;

select *
from 
table(information_schema.WAREHOUSE_LOAD_HISTORY(
  date_range_start=>dateadd('day',-14,current_date()), 
  date_range_end=>current_date(), 
  warehouse_name=>'COMPUTE_WH'));
  
select *
from 
table(information_schema.WAREHOUSE_METERING_HISTORY(
  date_range_start=>dateadd('day',-14,current_date()), 
  date_range_end=>current_date(), 
  warehouse_name=>'COMPUTE_WH'));

select *
from
table(information_schema.QUERY_HISTORY(
       end_time_range_start => dateadd('day',-5,current_timestamp()),
       end_time_range_end => current_timestamp(),
       result_limit => 100));

select *
from
table(information_schema.QUERY_HISTORY_BY_USER(
       user_name => 'warneradmin',
       result_limit => 100));
       
select *
from
table(information_schema.QUERY_HISTORY_BY_WAREHOUSE(
       warehouse_name => 'DATALOAD',
       result_limit => 100));
  