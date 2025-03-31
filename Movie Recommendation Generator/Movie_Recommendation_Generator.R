
library(shiny)
library(arules)
library(arulesViz)
library(tidyverse)
library(DT)

# Load required data
load("UPDATED-MOVIERECFall2024.RData")  # Ensure POPULARITY and TRANS exist in this file

# Define UI
ui <- fluidPage(
  
  # Title of the app
  titlePanel("Movie Recommendation Generator"),
  
  sidebarLayout(
    sidebarPanel(
      
      # Dropdown menu for selecting games
      selectizeInput(inputId="movies",label="What movies do you like?",choices=NULL,multiple=TRUE), 
      
      # Numeric input for the number of recommendations
      numericInput("number", 
                   label = "Enter Number of Recommendations", 
                   value = 5, 
                   min = 1, 
                   max = 100),
      
      # Slider input for the confidence of recommendations
      sliderInput("confidence", 
                  label = "Confidence of Recommendations", 
                  min = 1, max = 100, value = 50),
      
  
      # Slider input for the popularity cap
      numericInput("popularity", 
                  label = "Max % of Users Who Have Rated the Movie? (0-30)", 
                  min = 0, max = 30, 
                  value = 1),
      
      selectizeInput(
        inputId = "genres", 
        label = "Select a Genre", 
        choices = unique(unlist(strsplit(POPULARITY$genres, "\\|"))),  # Extract unique genres
        multiple = FALSE  # Single genre selection
      ),
      
      sliderInput("RatingOutof5",
                  label = "Select a Minimum Rating",
                  min = 0, max = 5, value = 1
                  ),
      
      selectizeInput(inputId="exclude_movies", 
                     label="Select Movies to Exclude", 
                     choices=NULL, 
                     multiple=TRUE), 
      
      numericInput(
        inputId = "min_year",
        label = "Enter Minimum Year",
        value = 1950, # Default minimum year
        min = 1900,   # Earliest year allowed
        max = 2024    # Latest year allowed
      ),
      numericInput(
        inputId = "max_year",
        label = "Enter Maximum Year",
        value = 2024, # Default maximum year
        min = 1900,   # Earliest year allowed
        max = 2024    # Latest year allowed
      ),
      
    
      
      submitButton("Get Recommendations")
      
      
      
    ),
    
    mainPanel(
      # Output display for the app (could be updated based on input)
      dataTableOutput("recommendations"),
      textOutput("selected_movies"),
      textOutput("num_recommendations_text"),
      textOutput("confidence_text"),
      textOutput("popularity_cap_text"),
      textOutput("exclude_movies_text")
    )
  )
)


input <- list()
input$movies <-  c("Mulholland Drive (2001)", "Memento (2000)", "Inception (2010)", 
                   "Donnie Darko (2001)","Black Swan (2010)","Primer (2004)",
                   "Triangle (2009)","Midsommar (2019)","Predestination (2014)",
                   "Game, The (1997)","Cube (1997)","Creep (2014)")
input$number <- 1500
input$confidence <- 25
input$popularity <- 0.2
input$RatingOutof5 < - 1


# Define server logic
server <- function(input, output, session) {
  
  updateSelectizeInput(session, "movies", choices = POPULARITY$title, server = TRUE)
  updateSelectizeInput(session, "exclude_movies", choices = POPULARITY$title, server = TRUE)
  updateSelectizeInput(session, "genres", choices = unique(unlist(strsplit(POPULARITY$genres, "\\|"))), server = TRUE)
  
  
  output$recommendations <- renderDataTable({
    # Ensure input$movies is valid
    req(input$movies)
    
    validate(
      need(input$min_year <= input$max_year, "Minimum year must be less than or equal to the maximum year.")
    )
    
    
  
    
    # Filter movies by selected genre
    if (!is.null(input$genres)) {
      movies_in_genres <- POPULARITY %>%
        filter(str_detect(genres, paste0("\\b", input$genres, "\\b"))) %>%
        .$title
    } else {
      movies_in_genres <- POPULARITY$title
    }
    
    # Filter out movies that are too popular
    movies.too.popular <- POPULARITY$title[which(POPULARITY$PercentRated > input$popularity)]
    dont.consider.movies <- union(movies.too.popular, input$exclude_movies)
    
    movies_in_year_range <- POPULARITY %>%
      filter(Year >= input$min_year & Year <= input$max_year) %>%
      .$title
    
    # Combine all filters
    movies_to_consider <- intersect(movies_in_genres, movies_in_year_range)
    dont.consider.movies <- union(dont.consider.movies, setdiff(POPULARITY$title, movies_to_consider))
    
    # Ensure input$movies (lhs) are not in the exclusion list (none)
    dont.consider.movies <- setdiff(dont.consider.movies, input$movies)
   
    
    # Generate rules with the filtered movie list
    RULES <- apriori(
      TRANS,
      parameter = list(supp = 4 / length(TRANS), conf = input$confidence / 100, minlen = 2, maxtime = 0),
      appearance = list(none = dont.consider.movies, lhs = input$movies, default = "rhs"),
      control = list(verbose = FALSE)
    )
    
    if (length(RULES) == 0) {
      return(data.frame(message = "No recommendations with these parameters. Add more movies, decrease confidence, or increase popularity!"))
    }
    
    RULES <- RULES[is.significant(RULES, TRANS)]
    RULESDF <- DATAFRAME(RULES, separate = TRUE, setStart = '', itemSep = ' + ', setEnd = '')
    legit.recommendations <- setdiff(RULESDF$RHS, input$movies)
    RULESDF <- RULESDF %>% filter(RHS %in% legit.recommendations)
    
    if (nrow(RULESDF) == 0) {
      return(data.frame(message = "No recommendations with these parameters. Add more movies, decrease confidence, or increase popularity!"))
    }
    
    RECS <- RULESDF %>%
      group_by(RHS) %>%
      summarize(Confidence = max(confidence)) %>%
      mutate(Confidence = round(100 * Confidence, digits = 1))
    
    RESULTS <- RECS %>% left_join(POPULARITY, by = c("RHS" = "title"))
    names(RESULTS) <- c("Movie", "Confidence", "UserPercentRated", "Genres", "RatingOutOf5", "Year")
    RESULTS <- RESULTS %>% 
      arrange(desc(Confidence)) %>% 
      filter(RatingOutOf5 >= input$RatingOutof5) %>%
      head(input$number)
    
    RESULTS$Movie <- as.character(RESULTS$Movie)
    row.names(RESULTS) <- NULL
    RESULTS
  })
    
    
    #Make rules.  Executive decisions:  
    #  * rules must apply to at least 4 gamers to be generated.  supp=5/length(TRANS) controls this
    #  * we'll pass confidence to the conf= argument
    #  * keep minlen=2 so that the simplest rules are If A then B. 
    #  * The lhs= ensures we make recommendations only on the list of games that person plays, 
    #  * maxtime=0 ensures algorithm finishes and all recommendations are found
    #  * verbose=FALSE just makes it so we don't get buried in output
    
  
  # Display selected games
  output$selected_movies <- renderText({
    paste("You selected the following movies: ", paste(input$movies, collapse = ", "))
  })
  
  output$exclude_movies_text <- renderText({
    paste("You excluded the following movies: ", paste(input$exclude_movies, collapse = ", "))
  })
  
  # Display number of recommendations
  output$num_recommendations_text <- renderText({
    paste("Number of recommendations: ", input$number)
  })
  
  # Display confidence level
  output$confidence_text <- renderText({
    paste("Confidence of recommendations: ", input$confidence, "%")
  })
  
  # Display popularity cap
  output$popularity_cap_text <- renderText({
    paste("Max % of Users Who Have Rated the Movie: ", input$popularity)
  })
  
  output$RatingOutof5_text <- renderText({
    paste("Rating: ", input$RatingOutof5)
  })
  
}



 
# Run the app
shinyApp(ui = ui, server = server)

