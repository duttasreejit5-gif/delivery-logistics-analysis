use delivery_logistics;

-- ============================================
-- Delivery Logistics Performance Analysis
-- Business Questions
-- ============================================
-- Q1. What is the overall delivery status distribution?
select delivery_status, count(*) as total_deliveries,
round(count(*) * 100.0 / (select count(*) from delivery_data),2) as percentage
from delivery_data
group by delivery_status
order by total_deliveries desc;
-- Insight: Delivered is the largest status category, accounting for 73.32% of all records.

-- Q2. Which delivery modes have the highest recorded delay rates?
select delivery_mode,
	    count(*) as total_deliveries,
        sum(case when delayed_flag = 'yes' then 1 else 0 end) as delayed_deliveries,
       round((sum(case when delayed_flag = 'yes' then 1 else 0 end) / count(*)) * 100.0,2)
       as delay_rate
from delivery_data
group by delivery_mode
order by delay_rate desc;
-- Insight: Express has the highest recorded delay rate at 73.78%, followed by Same Day at 32.54%.

-- Q3. Which delivery modes have the highest failure rates?
select delivery_mode,
		count(delivery_id) as total_deliveries,
        sum(case when delivery_status = 'failed' then 1 else 0 end) as failed_deliveries,
        round((sum(case when delivery_status = 'failed' then 1 else 0 end) / count(delivery_id)) * 100.0,2)
        as failure_rate
from delivery_data
group by delivery_mode
order by failure_rate desc;
-- Insight: Express has the highest recorded failure rate at 14.42%.

-- Q4. Which weather conditions have the highest recorded delay rates?
select weather_condition,
		count(delivery_id) as total_deliveries,
        sum(case when delayed_flag = 'yes' then 1 else 0 end) as delayed_deliveries,
        round((sum(case when delayed_flag = 'yes' then 1 else 0 end) / count(delivery_id)) * 100.0,2)
        as delay_rate
from delivery_data
group by weather_condition
order by delay_rate desc;
-- Insight: Stormy weather has the highest recorded delay rate at 41.45%, followed by rainy weather at 37.35%.

-- Q5. Which delivery partners have the highest recorded delay rates?
select delivery_partner,
	   count(delivery_id) as total_deliveries,
       sum(case when delayed_flag = 'yes' then 1 else 0 end)
       as delayed_deliveries,
       round((sum(case when delayed_flag = 'yes' then 1 else 0 end) / count(delivery_id)) * 100.0,2)
       as delay_rate
from delivery_data
group by delivery_partner
order by delay_rate desc;
-- Insight: Recorded partner delay rates range from approximately 24.80% to 28.27%, showing relatively small differences across partners.

-- Q6. How does the recorded delay rate vary across regions?
select region,
		count(delivery_id) as total_deliveries,
        sum(case when delayed_flag = 'yes' then 1 else 0 end)
        as delayed_deliveries,
        round((sum(case when delayed_flag = 'yes' then 1 else 0 end) / count(delivery_id)) * 100.0,2)
        as delay_rate
from delivery_data
group by region
order by delay_rate desc;
-- Insight: Central has the highest recorded regional delay rate at 27.25%, while East has the lowest at 25.80%.

-- Q7. How does average delivery cost vary across delivery modes?
select delivery_mode,
		count(delivery_id) as total_deliveries,
		round(avg(delivery_cost),2) as average_delivery_cost
from delivery_data
group by delivery_mode
order by average_delivery_cost desc;
-- Insight: Average delivery cost varies across delivery modes, providing a basis for comparing cost efficiency by mode.

-- Q8. How does average customer rating vary by delivery status?
select delivery_status,
		count(delivery_id) as total_deliveries,
        round(avg(delivery_rating),2) as avg_customer_rating
from delivery_data
group by delivery_status
order by avg_customer_rating desc;
-- Insight: Average customer rating is highest for delivered orders at 4.21 and lowest for failed deliveries at 1.31.

-- Q9. How does average customer rating vary between deliveries recorded as delayed and not delayed?
select delayed_flag,
		count(delivery_id) as total_deliveries,
        round(avg(delivery_rating),2) as avg_customer_rating
from delivery_data
group by delayed_flag
order by avg_customer_rating desc;
-- Insight: Deliveries recorded as delayed have a substantially lower average customer rating than deliveries recorded as not delayed.

-- Q10. How does average delivery cost vary across distance ranges?
select case
			when distance_km < 50 then '0-50km'
            when distance_km < 100 then '50-100km'
            when distance_km < 150 then '100-150km'
            when distance_km < 200 then '150-200km'
            when distance_km < 250 then '200-250km'
            else '250+ km'
            end as distance_range,
		count(delivery_id) as total_deliveries,
        round(avg(delivery_cost),2) as avg_delivery_cost
from delivery_data
group by distance_range
order by
		case distance_range
			when '0-50km' then 1
            when '50-100km' then 2
            when '100-150km' then 3
            when '150-200km' then 4
            when '200-250km' then 5
            when '250+ km' then 6
		end;
-- Insight: Average delivery cost increases consistently as the delivery distance range increases.

-- Q11. Which delivery mode and weather combinations have the highest recorded delay rates?
select delivery_mode,
		weather_condition,
        count(delivery_id) as total_deliveries,
        sum(case when delayed_flag = 'yes' then 1 else 0 end)
        as delayed_deliveries,
        round((sum(case when delayed_flag = 'yes' then 1 else 0 end) / count(delivery_id)) * 100.0,2)
        as delay_rate
from delivery_data
group by delivery_mode,
		weather_condition
order by delay_rate desc;
-- Insight: Combining delivery mode and weather condition helps identify operating conditions associated with higher recorded delay rates.

-- Q12. Which delivery partners have a recorded delay rate above the overall dataset delay rate?
select delivery_partner,
		count(delivery_id) as total_deliveries,
        sum(case when delayed_flag= 'yes' then 1 else 0 end)
        as delayed_deliveries,
        round((sum(case when delayed_flag= 'yes' then 1 else 0 end) / count(delivery_id)) * 100.0,2)
        as delay_rate
from delivery_data
group by delivery_partner
having
	sum(case when delayed_flag = 'yes' then 1 else 0 end) / count(delivery_id) *100.0
    >
		(select sum(case when delayed_flag = 'yes' then 1 else 0 end) / count(delivery_id) *100.0
			from delivery_data)
order by delay_rate desc;
-- Insight: This query identifies delivery partners whose recorded delay rate is above the overall dataset delay-rate benchmark.

-- Q13. Which delivery modes have a positive average delay based on actual versus expected delivery time?
with mode_performance as
(
select delivery_mode,
		count(delivery_id) as total_deliveries,
        round(avg(delay_hours),2) as avg_delay_hours
from delivery_data
group by delivery_mode
)
select delivery_mode,
		total_deliveries,
        avg_delay_hours
from mode_performance
where avg_delay_hours > 0
order by avg_delay_hours desc;
-- Insight: Express is the only delivery mode with a positive average timing-based delay, at approximately 1.71 hours.

-- Q14. How do delivery partners rank by average delivery cost?
select delivery_partner,
    round(avg(delivery_cost), 2) as average_delivery_cost,
    dense_rank() over (
        order by avg(delivery_cost) desc
    ) as cost_rank
from delivery_data
group by delivery_partner
order by cost_rank;
-- Insight: DHL has the highest average delivery cost at ₹872.83, while Delhivery has the lowest at ₹848.11.