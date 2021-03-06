use reviews;

create or replace file format CSVFORMAT_QUOTES TYPE = 'CSV' FIELD_DELIMITER = ',' FIELD_OPTIONALLY_ENCLOSED_BY='"';

show schemas;

CREATE OR REPLACE STAGE shared_stage
  file_format = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

show stages;

CREATE OR REPLACE STAGE tbdell
  file_format = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

select * from reviews limit 100;

select top 100 * from reviews;

-- 01a411fe-0000-06fa-0000-00000fd1297d

select * from reviews offset 0 fetch 100;

-- date bucket filter

select business_id,
    stars,
    Max(review_date)
from reviews
group by :datebucket(review_date),
        business_id,
        stars
limit 100;

-- date range filter
select TOP 100 *
from reviews
where review_date = :daterange;

-- sub query
select bus.name,
    city,
    state
from public.businesses bus
where bus.business_id in (select revs.business_id
                         from public.reviews revs
                          group by revs.business_id
                          order by avg(stars) desc
                         limit 10);
                         
select distinct name,
    city,
    state,
    rank()
        over (order by stars desc) as rank
from businesses 
where  state='NV'
order by name
limit 100;

set city='Windsor';

SELECT $city;

with businesses_place
        (business_id, name, city, state)
    as
        (select business_id, name, city, state
            FROM businesses
            WHERE city = $city
        )
    select name, city, state, avg(stars) avg_stars, sum(useful) sum_useful
    from businesses_place bp join reviews rv on bp.business_id=rv.business_id
    group by name, city, state
    order by avg_stars desc;

-- approx function & JSON
with approx_businesses as (
  SELECT approx_top_k(business_id, 10) AS business_json
  FROM reviews
),
 flattened AS(
  SELECT value[0]::string AS business_id, value[1]::int AS frequency
FROM approx_businesses, lateral flatten(business_json))
SELECT DISTINCT name, frequency from flattened fl JOIN businesses bu WHERE fl.business_id=bu.business_id;

// Getting results back from the cache (accessible to executing user for 24 hours)
SELECT * FROM TABLE(result_scan('*********************************'));
SELECT * FROM TABLE(result_scan('01a4123c-0000-06ff-0000-00000fd11ac9'));

// Querying ouput of commands
SHOW TABLES;

SELECT * FROM TABLE(result_scan('**********************************'))
AS x
WHERE x."rows">500000;    

SELECT * FROM TABLE(result_scan('01a4123d-0000-06fa-0000-00000fd12ab5'))
AS x
WHERE x."rows">500000;    
