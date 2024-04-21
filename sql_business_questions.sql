USE superstore_pbi;

/* Calculate the total sales by continent for all the period in the DB */

SELECT ct.continent AS [Continent], ROUND(SUM(ol.sales), 2) AS [Sum of Sales]
FROM [dbo].[order_line] ol
JOIN [dbo].[order] o ON ol.order_id = o.order_id
JOIN [dbo].[city_state] cs ON o.city_state_id = cs.city_state_id
JOIN [dbo].[country] c ON cs.country_id = c.country_id
JOIN [dbo].[continent] ct ON c.continent_id = ct.continent_id
GROUP BY ct.continent
ORDER BY SUM(ol.sales) DESC;

/* Calculate the profit in Europe and South America in 2011 and 2012 */
SELECT ct.continent AS [Continent], 
       YEAR(o.order_date) AS [Order Year],
       ROUND(SUM(ol.profit), 2) AS [Sum of Profit]
FROM [dbo].[order_line] ol
JOIN [dbo].[order] o ON ol.order_id = o.order_id
JOIN [dbo].[city_state] cs ON o.city_state_id = cs.city_state_id
JOIN [dbo].[country] c ON cs.country_id = c.country_id
JOIN [dbo].[continent] ct ON c.continent_id = ct.continent_id
WHERE (ct.continent = 'Europe' OR ct.continent = 'South America')
  AND (YEAR(o.order_date) = 2011 OR YEAR(o.order_date) = 2012)
GROUP BY ct.continent, YEAR(o.order_date)
ORDER BY ct.continent, YEAR(o.order_date) ASC;

/* Calculate the total sales in Africa for 2013*/

SELECT ROUND(SUM(ol.sales),2) AS [Total Sales in Africa 2013]
FROM [dbo].[order_line] ol
JOIN [dbo].[order] o ON ol.order_id = o.order_id
JOIN [dbo].[city_state] cs ON o.city_state_id = cs.city_state_id
JOIN [dbo].[country] c ON cs.country_id = c.country_id
JOIN [dbo].[continent] ct ON c.continent_id = ct.continent_id
WHERE ct.continent = 'Africa' AND YEAR(o.order_date) = 2013;

/*  What are the top 5 countries by number of orders of all time */

SELECT TOP 5
    c.country,
    COUNT(o.order_id) AS [Total Orders]
FROM dbo.country c
INNER JOIN dbo.city_state cs ON c.country_id = cs.country_id
INNER JOIN dbo.[order] o ON cs.city_state_id = o.city_state_id
GROUP BY c.country
ORDER BY COUNT(o.order_id) DESC;

/* What are the top 5 countries by sales of all time */

SELECT TOP 5
    c.country,
    ROUND(SUM(ol.sales), 2) AS [Total Sales]
FROM dbo.country c
INNER JOIN dbo.city_state cs ON c.country_id = cs.country_id
INNER JOIN dbo.[order] o ON cs.city_state_id = o.city_state_id
INNER JOIN dbo.order_line ol ON o.order_id = ol.order_id
GROUP BY c.country
ORDER BY SUM(ol.sales) DESC;

/* Average sales per each order in United States, Australia and France */

SELECT
    c.country,
    ROUND(SUM(ol.sales)/COUNT(DISTINCT o.order_id), 2) AS [Average Sales per Each Order]
FROM dbo.country c
INNER JOIN dbo.city_state cs ON c.country_id = cs.country_id
INNER JOIN dbo.[order] o ON cs.city_state_id = o.city_state_id
INNER JOIN dbo.order_line ol ON o.order_id = ol.order_id
WHERE c.country IN ('United States', 'Australia', 'France')
GROUP BY c.country
ORDER BY (SUM(ol.sales)/COUNT(DISTINCT o.order_id)) DESC;

/* Number of countries served */

SELECT COUNT(DISTINCT country_id) AS [Number of Countries Served]
FROM dbo.country;

/* Total Profits in 2014 */

SELECT ROUND(SUM(profit), 2) AS [Total Profits 2014]
FROM [dbo].[order_line] ol
JOIN [dbo].[order] o ON ol.order_id = o.order_id
WHERE YEAR(o.order_date) = 2014;

/* Average Profit Per Order in Asia */

SELECT
	YEAR(o.order_date) as [Year],
    ROUND(AVG(ol.profit),2) AS [Average Profit per Order Line]
FROM order_line ol
INNER JOIN [order] o ON ol.order_id = o.order_id
INNER JOIN city_state cs ON o.city_state_id = cs.city_state_id
INNER JOIN country c ON cs.country_id = c.country_id
INNER JOIN continent cn ON c.continent_id = cn.continent_id
WHERE cn.continent = 'Asia' AND YEAR(o.order_date) = 2013
GROUP BY YEAR(o.order_date)
ORDER BY YEAR(o.order_date) DESC;

/* Top 3 Countries in South America by Sales of Technology */

SELECT TOP 3
	c.country AS [Country],
    ROUND(SUM(ol.sales), 2) AS [Total Sales]
FROM dbo.country c
INNER JOIN dbo.city_state cs ON c.country_id = cs.country_id
INNER JOIN dbo.[order] o ON cs.city_state_id = o.city_state_id
INNER JOIN dbo.order_line ol ON o.order_id = ol.order_id
INNER JOIN dbo.product p ON ol.product_id = p.product_id
INNER JOIN dbo.product_subcategory ps ON p.product_subcategory_id = ps.product_subcategory_id
INNER JOIN dbo.product_category pc ON ps.product_category_id = pc.product_category_id
INNER JOIN dbo.continent cn ON c.continent_id = cn.continent_id
WHERE cn.continent = 'South America' AND pc.product_category = 'Technology'
GROUP BY c.country
ORDER BY SUM(ol.sales) DESC;

/* Number of Countries Served in Africa */

SELECT COUNT(DISTINCT c.country_id) AS [Countries Served in Africa]
FROM dbo.country c
INNER JOIN dbo.continent cn ON c.continent_id = cn.continent_id
WHERE cn.continent = 'Africa';