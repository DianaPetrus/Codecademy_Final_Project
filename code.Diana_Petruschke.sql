/*
How many campaigns and sources does CoolTShirts use and how are they related?
Campaigns
*/
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits; 
/*
How many campaigns and sources does CoolTShirts use and how are they related?
Sources
*/
SELECT COUNT(DISTINCT utm_source)
FROM page_visits;
/*
How many campaigns and sources does CoolTShirts use and how are they related?
Relation between the two
*/
SELECT DISTINCT utm_source, 
  utm_campaign
FROM page_visits
ORDER BY 1,2;
/*
What pages are on their website?
*/
SELECT DISTINCT page_name
FROM page_visits;
/*
How many first touches is each campaign responsible for?
*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_campaign AS campaign_name,
       COUNT(*) AS first_touches
FROM ft_attr
GROUP BY 1
ORDER BY 2 DESC;
/*
How many last touches is each campaign responsible for?
*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign AS campaign_name,
       COUNT(*)AS last_touches
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;
/*
Number of all unique visitors to the site
*/
SELECT COUNT(DISTINCT user_id)
FROM page_visits;
/*
How many visitors make a purchase?
*/
SELECT COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase';
/*
How many last touches on the purchase page is each campaign responsible for?
*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign AS campaign_name,
       COUNT(*) AS last_touches
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;
/*
What is the typical user journey?
Following one specific user ID = 10162 that went through the whole funnel
*/
SELECT user_id,
  page_name,
  timestamp,
  utm_campaign,
  utm_source
FROM page_visits
WHERE user_id = 10162;
/*
What is the typical user journey?
First touch of user  10162 
*/
WITH first_touch AS (
    SELECT user_id,
       MIN(timestamp) AS 'first_touch_at'
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
   ft.first_touch_at,
   pv.utm_source
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
   ON ft.user_id = pv.user_id
   AND ft.first_touch_at = pv.timestamp
 WHERE ft.user_id = 10162;
/*
What is the typical user journey?
Last touch of user  10162 
*/
WITH last_touch AS (
    SELECT user_id,
       MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
   lt.last_touch_at,
   pv.utm_source
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
   ON lt.user_id = pv.user_id
   AND lt.last_touch_at = pv.timestamp
WHERE lt.user_id = 10162;
/*
What campaigns should they invest in?
*/
SELECT utm_campaign,
  page_name,
  COUNT(DISTINCT user_id) AS unique_users
FROM page_visits
GROUP BY 1,2
ORDER BY 1,2;
/*
Hits on the purchase page by campaign
*/
SELECT utm_source,
  utm_campaign,
  page_name,
  COUNT(DISTINCT user_id) AS unique_users
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY 1,2
ORDER BY 4 DESC;
/*
Hits on the landing_page by campaign
*/
SELECT utm_source,
  utm_campaign,
  page_name,
  COUNT(DISTINCT user_id) AS unique_users
FROM page_visits
WHERE page_name = '1 - landing_page'
GROUP BY 1,2
ORDER BY 4 DESC;





