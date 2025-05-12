### Author: Alyssa Gurkas
### Date: 5/12/2025
### Code Outlining How to Create an Animated Time-Series Plot

# load-libraries
library(gifski) # save gif file
library(dplyr) # subsetting data
library(ggplot2) # plotting data
library(gganimate) # animating data
library(tidyverse) # cleaning data

### Loading the NBA Data, Source:https://www.nba.com/stats/alltime-leaders.
nba_df <- read_csv("https://raw.githubusercontent.com/amgurkas/data-acquisition/refs/heads/main/Portfolio_Ex_Code/nba-top-10-career-scoring-leaders-yearly.csv")

### Exploratory Data Analysis
# filtering by range range between 1960 and 1969
nba_df_1960s_random_10 <- nba_df %>% 
  filter(YearEnd >= 1960 & YearEnd <= 1969) %>% 
  sample_n(10)
nba_df_1960s_random_10

# or: same as above but with between() method
nba_df_1960s_random_10 <- nba_df %>% 
  filter(between(YearEnd,1960,1969)) %>% 
  sample_n(10)

# filter() for just LeBron
lebron <- nba_df %>% 
  filter(Player=="LeBron James")

nba_grouped <- nba_df %>% 
  # group by player
  group_by(Player) %>% 
  # calc # of years top player & create col name Top_10_Yrs
  summarize(Top_10_Yrs=n()) %>% 
  # arrange by # of years
  arrange(desc(Top_10_Yrs)) 

# get sum total of Top 10 points by year
nba_df_sum <- nba_df %>% 
  group_by(YearEnd) %>% 
  summarize(TotPts = sum(CareerPts)) %>% 
  arrange(desc(TotPts)) 


### Plotting the Data

# saving animated plot as obj
anim <- nba_df |> 
  # setting coordinates and filling by player
  ggplot(aes(x = -Rank, y = CareerPts, fill = Player)) + 
  # placing player name inside the bars
  geom_tile(aes(y = CareerPts / 2, height = CareerPts), 
            width = 0.9) + 
  # setting text inside bars to be white
  geom_text(aes(label = Player), col = "white", 
            hjust = "right", nudge_y = -1000) +
  # geom_text(aes(label = comma(CareerPts, accuracy = 1)),
  #           hjust = "left", nudge_y = 1000) +
  geom_text(aes(label = as.character(CareerPts)),
            hjust = "left", nudge_y = 1000) +
  # flipping coordinates
  coord_flip(clip = "off", expand = FALSE) + 
  # setting y-axis (appears as x-axis b/c coord flip)
  ylab("Career Points") + 
  # setting plot title
  ggtitle("NBA All-Time Scoring Leaders") + 
  scale_x_discrete("") +
  scale_y_continuous(limits = c(-1000, 49000),
                     labels = scales::comma) + 
  theme_minimal() +
  # setting locations of titles
  theme(plot.title = element_text(hjust = 0.5, size = 20),
        legend.position = "none",
        panel.grid.minor = element_line(linetype = "dashed"),
        panel.grid.major = element_line(linetype = "dashed")) + 
  # setting transition time
  transition_time(YearEnd) 
  # changing title by year appearing
  labs(subtitle = "Top 10 Scorers as of {round(frame_time, 0)}") + 
  # setting plot title alignment & font size
  theme(plot.subtitle = element_text(hjust = 0.5, size = 12))

# animating the plot
animate(anim,
        end_pause = 50, 
        nframes = 12*(2020-1950), 
        fps = 12,
        width = 8, 
        height = 4.5, 
        res = 150, 
        units="in",
        device = "ragg_png",
        renderer = gifski_renderer()
        )