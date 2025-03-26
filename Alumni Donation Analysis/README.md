
🎓 Alumni Donation Prediction and Insights

This project explores what drives alumni to donate and how much they contribute. I worked with two datasets:

- DONATED — whether an alumnus donated in 2023 (Yes/No)

- CASH — log-transformed total cash donated

Using random forest models and DALEX explainers, I aimed to both predict alumni behavior and interpret the "why" behind each prediction.


🧠 Key Goals

Predict the likelihood of donation and amount donated

Understand which features influence those outcomes the most


🔍 What I Did

Built random forest models to predict donation behavior

Used DALEX to generate:

🔹 Feature importance plots

🔹 Partial dependence plots

🔹 Interaction analysis

🔹 Breakdown plots (for individual-level explanations)

Compared a full model (with third-party predictors) vs a reduced model, showing that external data boosted performance by ~17.7%

Built decision trees and mined association rules to further interpret donor behaviors


📈 Results & Insights

Achieved up to 93.2% model accuracy

Top predictors: NumYearsDonate, Amount1stGift, BequestLikelihood, GradYear, AthleticsDonor

Found that:

- Donating 3+ times in 9 years was a major indicator of future donations

- Newer grads tend to donate more likely due to senior gifts

- Larger first-time gifts and high bequest scores significantly boosted donation predictions

- Breakdown plots revealed how personal characteristics affect each individual’s prediction


💡 Why This Matters

The model helps do the following:

- Identify high-potential donors

- Understand which alumni traits matter most

- Tailor communication based on donation drivers

This blend of machine learning + explainability gives real, actionable insights for fundraising strategy.


