Using the normalized schema
===========================

This folder contains an alternate schema that has been normalized from [the
original
repository](https://github.com/webster/minneapolis-restaurant-health-inspection-data/)
to make writing interesting queries on the data easier.

Example: What are the top 5 Minneapolis postal codes by number of 
restaurants with a critical violation in the last six months?

~~~
SELECT postal, COUNT(DISTINCT business_id) as n_critical
FROM inspection_order
  JOIN business_license USING ( license_number )
  JOIN business USING ( business_id )
WHERE is_critical = 1
  AND inspected_on > DATE_SUB( CURDATE( ), INTERVAL 6 MONTH )
GROUP BY postal 
ORDER BY n_critical DESC
LIMIT 5;
~~~
Result:
~~~
+--------+------------+
| postal | n_critical |
+--------+------------+
| 55401  |         80 |
| 55403  |         59 |
| 55415  |         37 |
| 55407  |         14 |
| 55402  |         11 |
+--------+------------+
~~~

## Organization
There are three files:

1. ```initial_create.sql``` contains the table definitions.
2. ```initial_populate.sql``` contains the data to populate the tables.
3. ```migrate.sql``` transforms the data from InspectionHistory-008 to the new
   tables.

## Installation
```cat initial_create.sql initial_populate.sql | mysql -uUSER -p DATABASE```

Replace ```USER``` and ```DATABASE``` with your own values.

Running ```migrate.sql``` is not necessary, it is meant to document how the
data were transformed.
