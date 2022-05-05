create database reviews;

show databases;

create or replace TABLE REVIEWS (
	REVIEW_ID VARCHAR(100),
	BUSINESS_ID VARCHAR(100),
	USER_ID VARCHAR(100),
	STARS NUMBER(38,4),
	USEFUL NUMBER(38,4),
	REVIEW_DATE DATE
);