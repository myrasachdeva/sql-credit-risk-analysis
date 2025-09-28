/*
Credit Risk Analysis Project (SQL) — Kaggle UCI Dataset
Author: Myra Rohit Sachdeva
Description: SQL analysis of 30,000+ credit card clients.
Includes financial ratios, borrower segmentation,
and a rule-based credit scoring framework.
*/

USE  credit_risk_analysis; 
SELECT * FROM credit_risk LIMIT 10;


-- =====================================
-- total number of clients in dataset
-- =====================================

SELECT COUNT(id) FROM credit_risk ;


-- =====================================================
-- How many clients defaulted, and the  % of the total 
-- =====================================================

SELECT COUNT(*) AS defaults,
ROUND (100* COUNT(*) / (SELECT COUNT(*) FROM credit_risk), 2) AS DF_rate
FROM credit_risk
WHERE default_payment_next_month = 1 ;


-- =========================================
-- average credit limit across all clients
-- =========================================

 SELECT AVG(limit_bal) AS avg_credit_limit
 FROM credit_risk ;
 
 
-- ==========================================================================
 -- the top 10 clients with the highest bill amount in the last month
 -- ========================================================================= 
 
SELECT id, bill_amt6 AS highest_bill_amt
FROM credit_risk
ORDER BY bill_amt6 DESC
LIMIT 10;


-- =========================================================================================
 -- Grouping clients by marital status (marriage) and the default rates (%) for each group.
-- =========================================================================================

SELECT marriage,
    COUNT(*) AS total_clients,
    SUM(CASE WHEN default_payment_next_month = 1 THEN 1 ELSE 0 END) AS defaults,
    ROUND(100.0 * SUM(CASE WHEN default_payment_next_month = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_percent
FROM credit_risk
GROUP BY marriage ;


-- =================================================================================
  -- debt to credit ratio (using limit_bal as a proxy for credit/borrowing capacity)
-- =================================================================================

SELECT id,
ROUND (bill_amt6/NULLIF(limit_bal,0),2) AS DTI_ratio      -- if DTI ratio 
FROM credit_risk                                          -- Low Risk → DTI < 0.3
ORDER BY DTI_ratio DESC ;                                 -- Medium Risk → 0.3 ≤ DTI ≤ 0.6
                                                          -- High Risk → DTI > 0.6



-- customers at risk of default (late payments, high utilization)
-- utilization = credit amount/limit balance 

-- risk rules,
-- High utilization (>0.8) + underpaying → At Risk
-- High utilization (>0.8) + pays in full → Safe high spender
-- Low utilization (<0.3) → Safe low utilization
-- Mid utilization (0.3–0.8) → Medium Risk


SELECT id, limit_bal, pay_6, bill_amt6, utilization, payment_ratio,
    CASE
        WHEN utilization > 0.8 AND payment_ratio < 1
          THEN 'At Risk'
        
        WHEN utilization > 0.8 AND payment_ratio >= 1
          THEN 'Safe High Spender'
        
        WHEN utilization < 0.3
          THEN 'Safe Low Utilization'
          
        ELSE 'Medium Risk'
    END AS risk_flag
FROM ( SELECT id, limit_bal, pay_6, bill_amt6,
        ROUND(bill_amt6 / NULLIF(limit_bal, 0), 2) AS utilization,
        ROUND(pay_6 / NULLIF(bill_amt6, 0), 2) AS payment_ratio
    FROM credit_risk
) t;

-- ==========================================
--  borrower segmentation by risk level
-- ==========================================

SELECT risk_flag,
COUNT(*) AS number_of_clients,
ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM credit_risk), 2) AS percent_of_clients
FROM (SELECT id, limit_bal, pay_6, bill_amt6, utilization, payment_ratio,
    CASE
        WHEN utilization > 0.8 AND payment_ratio < 1
          THEN 'At Risk'
        
        WHEN utilization > 0.8 AND payment_ratio >= 1
          THEN 'Safe High Spender'
        
        WHEN utilization < 0.3
          THEN 'Safe Low Utilization'
          
        ELSE 'Medium Risk'
    END AS risk_flag
FROM ( SELECT id, limit_bal, pay_6, bill_amt6,
        ROUND(bill_amt6 / NULLIF(limit_bal, 0), 2) AS utilization,
        ROUND(pay_6 / NULLIF(bill_amt6, 0), 2) AS payment_ratio
    FROM credit_risk) t1 ) t2
 
GROUP BY risk_flag 
ORDER BY percent_of_clients DESC ;


-- =============================
-- credit scoring system
-- =============================

SELECT 
    id, credit_score,
    
    CASE 
        WHEN credit_score >= 70 THEN 'Low Risk'
        WHEN credit_score BETWEEN 40 AND 69 THEN 'Medium Risk'
        ELSE 'High Risk'
        
    END AS risk_segment
    
FROM (
   SELECT id, 
ROUND (bill_amt6/NULLIF(limit_bal,0 ) ,2) AS utilization,
ROUND (pay_amt6/NULLIF(bill_amt6,0)  ,2) AS payment_ratio,
pay_0,

(

  CASE 
	  WHEN bill_amt6/NULLIF(limit_bal,0 ) > 0.8 THEN 30
	  WHEN bill_amt6/NULLIF(limit_bal,0 ) BETWEEN 0.3 AND 0.8 THEN 15
	  ELSE 5
END 
+
  CASE 
	  WHEN pay_amt6/NULLIF(bill_amt6,0) <1 THEN 30
	  WHEN pay_amt6/NULLIF(bill_amt6,0) >=1 THEN 15
	  ELSE 5
  END 
+
  CASE 
	  WHEN pay_0 = -1 THEN 40
	  WHEN pay_0 BETWEEN 1 AND 2 THEN 20
	  ELSE 0
  END 

  ) AS credit_score
FROM credit_risk

) t 
ORDER BY credit_score DESC;






