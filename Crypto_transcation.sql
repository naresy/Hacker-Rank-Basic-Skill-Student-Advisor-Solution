WITH ranked_transactions AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY sender ORDER BY transaction_timestamp) AS rn
FROM transactions
),
time_diff AS (
SELECT *,
DATEDIFF(MINUTE, LAG(transaction_timestamp) OVER (PARTITION BY sender ORDER BY transaction_timestamp), transaction_timestamp) AS time_diff
FROM ranked_transactions
)
SELECT sender,
MIN(transaction_timestamp) AS sequence_start,
MAX(transaction_timestamp) AS sequence_end,
COUNT(*) AS transactions_count,
ROUND(SUM(amount), 6) AS transactions_sum
FROM time_diff
GROUP BY sender, rn - ROW_NUMBER() OVER (PARTITION BY sender ORDER BY transaction_timestamp)
HAVING COUNT(*) >= 2 AND SUM(amount) >= 150
ORDER BY sender, sequence_start, sequence_end;