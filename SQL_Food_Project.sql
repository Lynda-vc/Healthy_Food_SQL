
-- BUSINESS QUESTION: DO THE HEALTHIER FOODS COST LESS?
	-- 	This code seeks to answer the business question and provide three actionable insights using the data in SQL. 

-- DEFINITIONS:
	--  Healthy food: Includes: vegan, gluten free, vegetarian, organic, dairy free, sugar conscious, paleo friendly, 
	-- 		wholefoods diet, low sodium, kosher, low fat and engine2.
	-- 	Cost: USDA established that to measure the cost of healthy foods, the metric is price per calorie

USE sakila;
SELECT * FROM food_project;

-- DATA CLEANING: PRODUCTS WITHOUT PRICE AND CALORIESPERSERVING WILL NOT BE USED
	SELECT * 
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0 ;

-- SET FINAL PRICE: PRICE COLUMN DOESN'T HAVE THE REAL PRICE AND FOR THIS I WILL DIVIDE IT BY 100
	SELECT 	product,
			price,
			(price/100) AS price_final
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0
	AND servingsizeunits NOT LIKE 'NULL' ;

-- SET COST PER CALORIES: USING THE DEFINITION OF COST FOR THIS ANALYSIS, FINAL PRICE WILL BE DIVIDED BY CALORIES PER SERVING
	SELECT 	product,
			price,
			(price/100/caloriesperserving) AS cost_per_calories
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0
	AND servingsizeunits NOT LIKE 'NULL' ;

-- SET SUM OF DIETS COLUMNS: USING HEALTHY DEFINITION I WILL SUM THE DIETS THAT ARE WITHING THAT DEFINITION
	SELECT 	product,		
			(vegan + glutenfree + ketofriendly + vegetarian + organic + dairyfree + sugarconscious + paleofriendly + wholefoodsdiet + lowsodium + kosher + lowfat + engine2) AS sum_healthy,
			price,
			(price/100/caloriesperserving) AS cost_per_calories
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0
	AND servingsizeunits NOT LIKE 'NULL' ;

-- CALCULATE AVERAGE (SUM OF DIETS COLUMNS) FOR SET HEALTHY AND LESS HEALTHY
	SELECT 			
			AVG(vegan + glutenfree + ketofriendly + vegetarian + organic + dairyfree + sugarconscious + paleofriendly + wholefoodsdiet + lowsodium + kosher + lowfat + engine2) AS avg_sum_healthy
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0
	AND servingsizeunits NOT LIKE 'NULL';

-- FOOD LABEL IS ESTABLISHED USING THE AVERAGE: HEALTHIER > 5 AND LESS HEALTHY < 5
	SELECT 	product,		
			price,
			(price/100/caloriesperserving) AS cost_per_calories,
			CASE WHEN (vegan + glutenfree + ketofriendly + vegetarian + organic + dairyfree + sugarconscious + paleofriendly + wholefoodsdiet + lowsodium + kosher + lowfat + engine2) > 5 THEN 'Healthier'
			ELSE 'Less healthy'
			END AS food_label            
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0
	AND servingsizeunits NOT LIKE 'NULL' ;

-- GROUP AVG COST AND FOOD LABEL (HEALTHIER AND LESS HEALTHY) TO IDENTIFY WHICH COST LESS
	SELECT 
			CASE WHEN (vegan + glutenfree + ketofriendly + vegetarian + organic + dairyfree + sugarconscious + paleofriendly + wholefoodsdiet + lowsodium + kosher + lowfat + engine2) > 5 THEN 'Healthier'
			ELSE 'Less healthy'
			END AS food_label,
			AVG(price/100/caloriesperserving) AS avg_cost
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0
	AND servingsizeunits NOT LIKE 'NULL' 
	GROUP BY food_label ;
    

-- ANSWER TO THE BUSINESS QUESTION: DO THE HEALTHIER FOOD COST LESS?
	-- No. After cleaning and processing the data, it became evident that healthier foods have a slightly higher average cost
    -- compared to less healthy options. Healthier-labeled products averaged $ 0.35, while less healthy products averaged $ 0.22.
    -- A correlation coefficient of 0.069 suggests a weak link between 'cost per calorie' and 'sum_healthy', implying that the 
    -- 'healthy' label isn't strongly tied to pricing.

-- INSIGHT 1: CATEGORY AND AVERAGE COST
	SELECT 	category,	
			AVG(price/100/caloriesperserving) AS avg_cost_per_calories        
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0
	AND servingsizeunits NOT LIKE 'NULL' 
    GROUP BY category
    ORDER BY avg_cost_per_calories DESC;

-- The findings show that supplements have the highest average cost per calorie at $ 1.62, significantly higher than the lowest category,
-- desserts at $ 0.03. According to The Upside journal, “The high cost of supplements is attributed to their specific ingredients", with 
-- some vitamins costing three times more than generics. A potential approach to address this is to replace branded supplements 
-- with generic alternatives to lower retail prices.

-- INSIGHT 2:
	SELECT 	category,
			CASE WHEN (vegan + glutenfree + ketofriendly + vegetarian + organic + dairyfree + sugarconscious + paleofriendly + wholefoodsdiet + lowsodium + kosher + lowfat + engine2) > 5 THEN 'Healthier'
			ELSE 'Less healthy'
			END AS food_label,
            COUNT(*)
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0
	AND servingsizeunits NOT LIKE 'NULL' 
    GROUP BY category,
			food_label
	ORDER BY COUNT(*) ;
    
-- This revealed that the produce category boasts the highest proportion of profucts labeled as less healthy. Despite
-- desserts typically lacking healthy ingredients, it's worth noting that consuming a small serving daily can be a part
-- of a healthy diet, as explained on The Baton Rouge website. Therefore, communication can emphasize the benefits of
-- consuming smallet portions.
    
-- INSIGHT 3:
	SELECT 	category,	
			AVG(price/100/caloriesperserving) AS avg_cost_per_calories        
	FROM food_project
	WHERE price NOT LIKE 0
	AND caloriesperserving NOT LIKE 0
	AND servingsizeunits NOT LIKE 'NULL' 
    GROUP BY category
    ORDER BY avg_cost_per_calories DESC;
    
-- Produce ranks as the sixth most affordable category and offers the highest number of healthier products. This affordability 
-- is largely attributed to seasonal pricing advantages. A strategic approach could involve underlining the low price of 
-- in-season produce and its positive impact on customers well-being.
    
    