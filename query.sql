SET NOCOUNT ON;

/*
=> Intermediate Result
7	min	68
7	max	92
7	avg	72
*/
SELECT m, max, min, avg
FROM
(
    SELECT MONTH(record_date) m, data_type, MAX(data_value) data_value
    FROM temperature_records
    WHERE data_type = 'max'
    GROUP BY MONTH(record_date), data_type
UNION ALL
    SELECT MONTH(record_date) m, data_type, MIN(data_value) data_value
    FROM temperature_records
    WHERE data_type = 'min'
    GROUP BY MONTH(record_date), data_type
UNION ALL
    SELECT MONTH(record_date) m, data_type,  CONVERT(INT,ROUND(sum(data_value) / convert(float, count(*)),0)) data_value
    FROM temperature_records
    WHERE data_type = 'avg'
    GROUP BY MONTH(record_date), data_type
) t1
PIVOT(MAX(data_value) FOR data_type IN (max,min,avg)) AS t2;

GO