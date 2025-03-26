
This project explores how clustering Airbnb listings can reveal meaningful customer groups and inform pricing strategy. Using unsupervised learning and boosted tree regression, listings were grouped into clusters based on features like host behavior, property size, and engagement levels.


✨ Key Highlights:


🤖 Clustering Model: Listings were grouped into meaningful segments:

Cluster 2 – “Neglectful Hosts”: Low response and acceptance rates.

Cluster 4 – “Reliable Corporations”: High-volume, verified hosts with consistent behavior.

Cluster 6 – “Pricey Mansions”: Listings with more beds, bathrooms, and overall space — priced well above average.


💰 Price Prediction: A boosted tree model was built to predict listing prices with an RMSE of ~$105.

📊 Top Features Driving Price:

- Number of bathrooms

- Total listings per host

- Number of beds

- Host response rate and acceptance rate


💡 Recommendations:

Airbnb can use these clusters to personalize listing suggestions:

- Suggest Cluster 6 for users needing large accommodations

- Promote Cluster 4 to new users seeking trustworthy hosts

- Incentivize Cluster 2 hosts to improve service quality

- Opportunities exist to enhance price prediction by incorporating listing age, seasonality, or location-based demand (e.g., beach listings 
  in summer)

🛠️ Tools Used:

- R (tidyverse, cluster, xgboost)

- Data visualization in RMarkdown

- Clustering + Regression modeling

