-- set analysis date explicitly 
SET @analysis_date = '2024-08-31';

-- 1: Build a Unified Issue-Level Analytical Base Table

CREATE TABLE books_analysis_base AS
SELECT
	ist.issued_id,
    ist.issued_member_id AS member_id,
    ist.issued_book_isbn AS isbn,
    b.category,
    b.rental_price,
    m.reg_date,
    ist.issued_date,
	rst.return_date,
	DATEDIFF(COALESCE(rst.return_date,@analysis_date),ist.issued_date) AS days_held,
    
    CASE
		WHEN DATEDIFF(COALESCE(rst.return_date,@analysis_date),ist.issued_date) <= 30 THEN 0 
        ELSE DATEDIFF(COALESCE(rst.return_date,@analysis_date),ist.issued_date) - 30
	END 
    AS overdue_days,
    
    CASE
		WHEN DATEDIFF(COALESCE(rst.return_date,@analysis_date),ist.issued_date) > 30 THEN 1 
        ELSE 0
	END 
    AS is_overdue
    
FROM issued_status ist
LEFT JOIN return_status rst
ON ist.issued_id = rst.issued_id
LEFT JOIN books b
ON ist.issued_book_isbn = b.isbn
LEFT JOIN members m
ON ist.issued_member_id = m.member_id;

SELECT * FROM books_analysis_base;


-- 2: Identify Member-Level Risk and Fine Exposure

SELECT
	member_id,
    COUNT(issued_id) AS total_issued,
    SUM(is_overdue) AS total_overdue_books,
    SUM(overdue_days) AS total_overdue_days,
    SUM(overdue_days*0.50) AS total_acc_fine
FROM books_analysis_base
GROUP BY member_id
ORDER BY 3 DESC, 4 DESC, 5 DESC;

-- 3: Identify High-Risk Members

WITH cte_member_risk AS (
	SELECT
		member_id,
		COUNT(issued_id) AS total_issued,
		SUM(is_overdue) AS total_overdue_books,
		SUM(overdue_days) AS total_overdue_days,
		SUM(overdue_days*0.50) AS total_acc_fine
	FROM books_analysis_base
	GROUP BY member_id
)
SELECT 
	member_id,
    total_issued,
    total_overdue_books,
    (total_overdue_books/total_issued) AS overdue_rate,
    total_acc_fine
FROM cte_member_risk 
WHERE (total_overdue_books/total_issued) > 0.40
OR total_acc_fine > (SELECT AVG(total_acc_fine) FROM cte_member_risk)
ORDER BY overdue_rate DESC, total_acc_fine DESC;

-- 4: Analyze Branch-Level Revenue vs Risk Exposure

SELECT 
		e.branch_id,
        COUNT(ist.issued_id) AS total_vol,
		SUM(rental_price) AS total_revenue,
		SUM(0.50 * overdue_days) AS pending_fine
FROM books_analysis_base ba
JOIN issued_status ist 
  ON ba.issued_id = ist.issued_id
JOIN employees e 
  ON ist.issued_emp_id = e.emp_id
  GROUP BY e.branch_id
;

-- 5: Member Cohort Analysis (New vs Existing Members)

WITH cte_member_type AS (
		SELECT 
			*,
			CASE
				WHEN reg_date >= '2024-04-01' THEN 'New'
				ELSE 'Old'
			END
			AS member_type
		FROM books_analysis_base
)
SELECT
	member_type,
    COUNT(issued_id) AS borrowing_vol,
    AVG(days_held) AS avg_days_held,
    ROUND(AVG(is_overdue),2) AS overdue_rate
FROM cte_member_type
GROUP BY member_type
;

-- 6: Analyze Risk and Revenue by Book Category

SELECT
	category,
    COUNT(*) AS total_issued,
    SUM(rental_price) AS total_revenue,
    ROUND(AVG(days_held),2) AS avg_days_held,
    ROUND(SUM(is_overdue)/COUNT(*),2) AS overdue_rate
FROM books_analysis_base
GROUP BY category
ORDER BY total_issued DESC, overdue_rate DESC;

-- 7: Evaluate Employee Workload Distribution

SELECT
    e.emp_id,
    e.emp_name,
    br.branch_id,
    COUNT(i.issued_id) AS issues_processed,
    ROUND(
        COUNT(i.issued_id) * 100.0 /
        (SELECT COUNT(*) FROM issued_status),
        2
    ) AS workload_pct
FROM issued_status i
JOIN employees e
    ON i.issued_emp_id = e.emp_id
JOIN branch br
    ON e.branch_id = br.branch_id
GROUP BY e.emp_id, e.emp_name, br.branch_id
ORDER BY issues_processed DESC
;

-- 8: Pareto Analysis on Overdue Behavior

WITH member_risk_summary AS(
		SELECT
			member_id,
			SUM(overdue_days) AS total_overdue_days
		FROM books_analysis_base
		GROUP BY member_id
)
SELECT 
	member_id,
    total_overdue_days,
    SUM(total_overdue_days) OVER() AS overall_overdue_days,
    ROUND(
		SUM(total_overdue_days) OVER(ORDER BY total_overdue_days DESC)
        /
        NULLIF(SUM(total_overdue_days) OVER(),0),
    2) AS cumulative_share
FROM member_risk_summary
ORDER BY total_overdue_days DESC
;
  
