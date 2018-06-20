-- QUIZ CHURN --
SELECT question,
	COUNT(DISTINCT user_id)
FROM survey
GROUP BY question;

-- AB FUNNEL --
WITH ab_aggregate AS (
	SELECT DISTINCT q.user_id, 
	h.user_id IS NOT NULL AS 'is_home_try_on',
	h.number_of_pairs, 
	p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN home_try_on h
   	ON q.user_id = h.user_id
	LEFT JOIN purchase p
   	ON p.user_id = q.user_id)
SELECT number_of_pairs AS 'test condition',
  COUNT(DISTINCT CASE
        WHEN number_of_pairs = '5 pairs' THEN user_id 
        WHEN number_of_pairs = '3 pairs' THEN user_id
        END) AS 'test count',
  SUM(is_purchase) AS 'purchases'
FROM ab_aggregate
WHERE number_of_pairs IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- STYLE FUNNEL --
WITH style_aggregate AS (
  SELECT DISTINCT q.user_id, 
		q.style,
		p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN purchase p
   	ON p.user_id = q.user_id)
SELECT style,
	COUNT(DISTINCT CASE
        WHEN style = "Women's Styles" THEN user_id 
        WHEN style = "Men's Styles" THEN user_id
        END) AS 'quiz responses',
  SUM(is_purchase) AS 'purchases'
FROM style_aggregate
WHERE style IS NOT "I'm not sure. Let's skip it."
GROUP BY 1
ORDER BY 1;