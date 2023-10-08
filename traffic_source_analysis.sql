# finding out largest revenue using website session and order table
# and finding the conversion rate
use mavenfuzzyfactory;
SELECT 
    utm_content,
    COUNT(DISTINCT (website_sessions.website_session_id)) AS sessions,
    COUNT(DISTINCT (orders.order_id)) AS total_orders,
    (COUNT(DISTINCT (orders.order_id)) / COUNT(DISTINCT (website_sessions.website_session_id))) AS session_to_order_conv_rt
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.website_session_id BETWEEN 1000 AND 2000
GROUP BY 1
ORDER BY 2 DESC;



# finding bulk website sessions, breakdown by UTM source, campaign, referring domain

SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT (website_sessions.website_session_id)) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-04-12'
GROUP BY utm_source , utm_campaign , http_referer
ORDER BY sessions DESC;



-- Finding session or oder conversion rate on different conditions to findout marketing campaign performance

SELECT 
    COUNT(DISTINCT (website_sessions.website_session_id)) AS sessions,
    COUNT(DISTINCT (orders.order_id)) AS orders,
    (COUNT(DISTINCT (orders.order_id)) / COUNT(DISTINCT (website_sessions.website_session_id))) AS cvr
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
    website_sessions.created_at < '2012-04-14'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY utm_source , utm_campaign , http_referer
ORDER BY sessions DESC;



# Trend analysis for website session to find out the result after implementing new strategy

SELECT 
    WEEK(created_at) as weeks,
    YEAR(created_at) as years,
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT (website_session_id)) AS sessions
FROM
    website_sessions
WHERE
    website_session_id BETWEEN 100000 AND 115000
GROUP BY 1 , 2;



# Creating order segments

SELECT 
    primary_product_id,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 1 THEN order_id
            ELSE NULL
        END) AS single_item_orders,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 2 THEN order_id
            ELSE NULL
        END) AS two_item_orders,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 3 THEN order_id
            ELSE NULL
        END) AS three_item_orders
FROM
    orders
WHERE
    order_id BETWEEN 31000 AND 32000
GROUP BY 1;



# gsearch nonbrand trended session volume, by week after reducing bidding budget on paid ad campaign

SELECT 
    WEEK(created_at) AS weeks,
    MIN(DATE(created_at)) AS Date,
    COUNT(DISTINCT (website_session_id)) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-05-12'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at) , WEEK(created_at);


-- Finding session to order conversion rate by device type to optimize campaign 

SELECT 
    website_sessions.device_type,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    (COUNT(DISTINCT (orders.order_id)) / COUNT(DISTINCT (website_sessions.website_session_id))) AS cvr
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
    website_sessions.created_at < '2012-05-12'
    AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY website_sessions.device_type;



# gsearch nonbrand and device type trended session volume, by week after reducing bidding budget

SELECT 
    MIN(DATE(created_at)) AS Week_start_date,
    COUNT(DISTINCT CASE
            WHEN device_type = 'mobile' THEN website_session_id
            ELSE NULL
        END) AS mobile_session,
    COUNT(DISTINCT CASE
            WHEN device_type = 'desktop' THEN website_session_id
            ELSE NULL
        END) AS desktop_session
FROM
    website_sessions
WHERE
    created_at  >'2012-04-15' 
    AND created_at < '2012-06-09'
    AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at) , WEEK(created_at);