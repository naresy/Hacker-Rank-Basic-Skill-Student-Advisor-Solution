SELECT
SUBSTRING(record_date, 1, 7) AS month,
MAX(CASE WHEN data_type = 'max' THEN data_value END) AS monthly_max,
MIN(CASE WHEN data_type = 'min' THEN data_value END) AS monthly_min,
ROUND(AVG(CASE WHEN data_type = 'avg' THEN data_value END)) AS monthly_avg
FROM
temperature_records
GROUP BY
SUBSTRING(record_date, 1, 7)
ORDER BY
month;