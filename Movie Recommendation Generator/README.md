
**🎬 Movie Recommendation Generator**

This interactive Shiny app is a rule-based movie recommendation system that generates personalized suggestions based on the user’s selected preferences and viewing history. Built using the arules package, it utilizes association rule mining to recommend movies similar to the ones the user already enjoys, filtering out overly popular or undesired titles to enhance personalization.

Users can:

- Select their favorite movies from a large database (POPULARITY) as input.

- Exclude certain movies they don't want in their recommendations.

- Set custom filters:

    - Number of desired recommendations.

    - Confidence threshold for rule strength.

    - Maximum popularity percentage to exclude widely rated films.

    - Year range for release dates.

    - Minimum rating (out of 5 stars).

    - Filter by a specific genre (e.g., Thriller, Drama, etc.).

The app generates recommendations using association rules mined from a transaction dataset (TRANS), ensuring all suggestions meet the specified confidence level and fall within the desired constraints. The output is displayed in an interactive table showing the movie title, confidence score, user rating data, genre, and release year.

This tool is ideal for cinephiles who enjoy niche or high-quality recommendations that go beyond mainstream popularity, offering a data-driven way to discover new films aligned with user taste.

Link to Movie Recommendation Generator: https://husnaiqbal.shinyapps.io/MovieRecs/ 

