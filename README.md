# Delivery Logistics Performance & Operational Efficiency Analysis

## 📌 Project Overview

This project analyzes delivery logistics data to understand delivery performance, operational efficiency, customer satisfaction, and delivery costs.

The analysis follows an end-to-end data analytics workflow using **Excel, Python, SQL, and Power BI**, starting from data cleaning and exploratory analysis through to business analysis and dashboard development.

---

## 🎯 Business Problem

Delivery operations involve multiple factors such as delivery mode, weather conditions, delivery partners, distance, cost, and customer experience.

This project aims to answer key business questions such as:

- What proportion of deliveries are delivered, delayed, and failed?
- Which delivery modes experience higher delay and failure rates?
- How do weather conditions relate to delivery delays?
- How does delivery performance vary across partners and regions?
- How does delivery distance relate to delivery cost?
- How does customer satisfaction vary by delivery outcome?
- Which delivery partners have higher average delivery costs?

---

## 📊 Dataset

The dataset contains **25,000 delivery records** and 15 original fields covering:

- Delivery partner
- Package type
- Vehicle type
- Delivery mode
- Region
- Weather condition
- Distance
- Package weight
- Actual delivery time
- Expected delivery time
- Delivery status
- Delay indicator
- Customer rating
- Delivery cost

Additional analytical fields were created during data preparation, including:

- Clean delivery time
- Clean expected delivery time
- Delay hours
- On-time flag
- Delivery time validity
- Distance range

---

## 🛠️ Tools & Technologies

- **Excel** – Data profiling, validation, Power Query cleaning and exploratory analysis
- **Python** – Exploratory data analysis, statistical analysis, correlations and visualization
- **SQL / MySQL** – Business analysis, CTEs, aggregations and window functions
- **Power BI** – Interactive dashboard and business reporting

---

## 🧹 Data Cleaning & Preparation

The dataset required preparation before analysis.

Key steps included:

- Profiling columns and checking data quality
- Checking missing and blank values
- Investigating repeated delivery IDs
- Converting delivery-time fields into usable numeric values
- Creating cleaned actual and expected delivery-time fields
- Calculating delay hours
- Creating a timing-based on-time flag
- Creating distance ranges for cost analysis
- Investigating zero-hour delivery-time records

### Data Quality Note

The dataset contains repeated `delivery_id` values. These records were retained because the repeated IDs contained different delivery attributes and therefore could not be treated as simple duplicate transactions.

A total of **255 records** contained an actual delivery time of zero hours. These records were retained and documented as a data-quality anomaly rather than being removed.

The source `delayed` field and the timing-based `on_time_flag` were also kept as separate concepts because they do not produce identical classifications.

---

## 📈 Key Analysis

### Delivery Performance

Overall delivery status:

| Status | Percentage |
|---|---:|
| Delivered | 73.32% |
| Delayed | 21.36% |
| Failed | 5.31% |

### Delivery Mode

Express deliveries had a delay rate of **73.78%**, while Same Day deliveries had a delay rate of **32.54%**.

Two Day deliveries had a delay rate of **0.43%**, while Standard deliveries had no recorded delays in the source status classification.

Express also had the highest failure rate at **14.42%**.

### Weather

Delay rates varied considerably across weather conditions:

- Stormy: **41.45%**
- Rainy: **37.35%**
- Foggy: **30.32%**
- Clear: **17.43%**
- Hot: **17.12%**
- Cold: **16.02%**

### Delivery Partners

Partner delay rates ranged from approximately **24.80% to 28.27%**, showing relatively smaller differences between partners compared with the differences observed across delivery modes and weather conditions.

### Customer Satisfaction

Average customer rating by delivery status:

| Delivery Status | Average Rating |
|---|---:|
| Delivered | 4.21 |
| Delayed | 2.40 |
| Failed | 1.31 |

The analysis also showed a negative relationship between delay and customer rating, with a correlation of approximately **-0.54**.

### Delivery Cost

Average delivery cost was approximately **₹864.94**.

Distance showed a very strong positive relationship with delivery cost, with a correlation of approximately **0.99**.

Average cost also increased consistently across distance ranges:

| Distance Range | Average Cost |
|---|---:|
| 0–50 km | ₹239.56 |
| 50–100 km | ₹487.95 |
| 100–150 km | ₹737.07 |
| 150–200 km | ₹988.23 |
| 200–250 km | ₹1,239.30 |
| 250+ km | ₹1,487.10 |

---

## 📊 Power BI Dashboard

The Power BI dashboard contains three analytical pages.

### 1. Executive Overview

Provides a high-level view of:

- Total deliveries
- Delivered percentage
- Delayed percentage
- Failed percentage
- Average delivery cost
- Average customer rating
- Delay rate by delivery mode
- Delivery status distribution

### 2. Delivery Performance Analysis

Focuses on operational performance across:

- Weather conditions
- Delivery partners
- Delivery modes
- Regions

### 3. Customer & Cost Analysis

Examines:

- Distance vs delivery cost
- Average cost by distance range
- Customer rating by delivery status
- Customer rating by delay status
- Average delivery cost by partner

---

## 💡 Key Findings

1. **Express delivery showed the highest delay and failure rates** among the delivery modes analyzed.
2. **Stormy and rainy weather were associated with higher delay rates** than the other weather categories.
3. **Customer ratings were substantially lower for delayed and failed deliveries** compared with delivered deliveries.
4. **Delivery distance had a very strong positive relationship with delivery cost.**
5. **Average delivery cost increased consistently as delivery distance increased.**
6. Partner delay rates were relatively close to one another compared with the larger differences observed across delivery modes and weather conditions.

---

## 📁 Project Structure

```text
Delivery Logistics Analysis/
│
├── README.md
│
├── Excel/
│   └── Delivery_Logistics.xlsx
│
├── Power BI/
│   └── delivery_logistics_dashboard.pbix
│
├── Python/
│   └── Delivery_Logistics_EDA.ipynb
│
├── Raw Data/
│   └── Delivery_Logistics.csv
│
├── SQL/
│   ├── delivery_logistics_analysis_cleaning.sql
│   └── delivery_logistics_analysis_business_questions.sql
│
└── Documentation/