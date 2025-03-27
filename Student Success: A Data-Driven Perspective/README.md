
**Student Success: A Data-Driven Perspective**

This project explores the factors that drive student academic success using a combination of machine learning, interpretability techniques, and data visualization. Only 18.8% of students in the dataset are classified as "successful"—defined as scoring above 75 in reading, writing, and math.

A Random Forest model was used to predict success based on pre-test attributes such as gender, race/ethnicity, parental education, lunch status, and test preparation course completion. The model was evaluated using accuracy and AUC on a holdout sample, and explainability was achieved using DALEX’s feature importance and breakdown plots.


**Key Findings:**

- Parental Level of Education is the top predictor of student success.

- Completion of a test preparation course more than triples the chance of success.

- Free/reduced lunch status and race/ethnicity are also influential, indicating broader systemic disparities.

- Certain combinations of attributes, such as being female with a parent who holds a Master’s degree, yield especially high predictions.

- Conversely, not completing a prep course and coming from lower educational backgrounds reduce success likelihood.


**Visual Tools Used:**

- Partial Dependence Plots to analyze feature impact

- Breakdown Plots to explain individual predictions

- Interaction Plots to explore variable combinations (e.g., parental education × test prep)

**Takeaways:**

This analysis emphasizes the need for targeted support programs for underrepresented and disadvantaged students. Potential solutions include free or subsidized prep courses, especially for students with limited educational resources at home.


