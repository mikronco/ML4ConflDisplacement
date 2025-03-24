# Rost and Ronco (2025) Appendix to “Anticipating humanitarian emergencies
# with high risk of conflict-induced displacement crises”
# This R script reproduces Figures 1, 2 and 3, and statistics in the text
# To reproduce other figures in the appendix and main paper...
# ... see separate dataset and code in Python


# Load libraries
library (tidyverse)
library(ggplot2)
library (countrycode)


# Appendix - numbers mentioned in text and Figure 1

# Read dataset
idps <- read.csv("IDP8")

# First, the numbers mentioned in the text are reproduced
# Correlation between conflict and displacement
cor (log (idps$idps + 1), log (idps$ucdp_total + 1))
cor (log (idps$idps + 1), log (idps$acled_total + 1))

# Number of observations with displacement but no conflict
sum (idps$idps > 0 & idps$ucdp_total == 0)
sum (idps$idps > 0 & idps$acled_total == 0)

# Number of observations with conflict but no displacement
sum (idps$idps == 0 & idps$ucdp_total > 0)
sum (idps$idps == 0 & idps$acled_total > 0)


# Appendix - Figure 1: Scatterplots of displacements 
# and total conflict fatalities

# Convert from panel data to data frame
idps_df <- as.data.frame(idps)

# UCDP and IDMC data
ggplot (idps_df) + 
  geom_point (mapping = aes (x = log (ucdp_total + 1), 
                             y = log (idps + 1)), 
              shape = 21, alpha = .5) + 
  geom_smooth(aes(x = log(ucdp_total + 1), 
                  y = log(idps + 1)),
              method = "loess", 
              span = 1,
              se = TRUE, 
              level = .95,
              color = "blue") +
  ggtitle ("UCDP and IDMC data with LOESS smoothing (95% CI)") + 
  xlab ("Total number of people killed (log)") + 
  ylab ("Total number of displacements (log)")

# ACLED and IDMC data
ggplot (idps_df) + 
  geom_point (mapping = aes (x = log (acled_total + 1), 
                             y = log (idps + 1)), 
              shape = 21, 
              alpha = .5) + 
  geom_smooth(aes(x = log(acled_total + 1), 
                  y = log(idps + 1)),
              method = "loess", 
              span = 1,
              se = TRUE, 
              level = .95,
              color = "blue") +
  ggtitle ("ACLED and IDMC data with LOESS smoothing (95% CI)") + 
  xlab ("Total number of people killed (log)") + 
  ylab ("Total number of displacements (log)")

# Appendix - Figure 2: Total fatalities from armed conflict (ACLED and UCDP) 
# and total number of displacements per month in selected countries

# add country name to data frame
idps$country_name <- countrycode (idps$iso, "iso3c", "country.name")
idps$country_name <- ifelse (idps$iso == "XKX", "Kosovo", idps$country_name)

# create function to plot data for a single
# "country" in this function is an iso-3 code
plotSingleCountry <- function(country) {
  
  # Select country's data
  country_df <- idps %>%
    filter(iso == country) %>%
    select(iso, yrmo, idps, ucdp_total, acled_total) %>%
    pivot_longer(cols = c("idps", "ucdp_total", "acled_total"),
                 names_to = "data_type",
                 values_to = "value") %>%
    mutate(yrmo_date = as.Date(paste0(yrmo, "-01"), format = "%Y-%m-%d")) %>%
    select(-yrmo)
  
  # Create the plot
  p <- ggplot(data = country_df) +
    
    # Add conflict events bars with better color contrast and transparency
    geom_bar(data = subset(country_df, data_type %in% c("ucdp_total", "acled_total")),
             aes(x = yrmo_date, y = value * 50, fill = data_type),
             stat = "identity", position = "dodge", alpha = 0.4) +
    
    # Add IDP series points and line
    geom_point(data = subset(country_df, data_type == "idps"),
               aes(x = yrmo_date, y = value),
               color = "#0072B2", size = 1.5, na.rm = TRUE) +
    geom_line(data = subset(country_df, data_type == "idps"),
              aes(x = yrmo_date, y = value, color = "Displacements"),
              na.rm = TRUE, size = 1)  +
    
    # Add title
    ggtitle(idps$country_name[idps$iso == country][1]) +
    
    # X-axis label
    xlab("Year and Month") +
    
    # Y-axis labels and secondary axis
    scale_y_continuous(
      name = "Number of Displaced Persons",
      sec.axis = sec_axis(~ . / 50, name = "Number of People Killed")
    ) +
    
    # Set theme
    theme_minimal() +
    theme(
      axis.line.y.left = element_line(color = "#0072B2"),
      axis.text.y.left = element_text(color = "#0072B2", face = "bold"),
      axis.line.y.right = element_line(color = "#E74C3C"),
      axis.text.y.right = element_text(color = "#E74C3C", face = "bold"),
      axis.title.y.left = element_text(color = "#0072B2"),
      axis.title.y.right = element_text(color = "#E74C3C"),
      plot.title = element_text(hjust = 0.5, face = "bold"),
      legend.position = "top",
      legend.background = element_blank(),
      legend.box.background = element_blank(),
      legend.box.margin = margin(0, 0, 0, 0)
    ) +
    
    # Adjust x-axis ticks
    scale_x_date(date_breaks = "1 year", date_labels = "%b-%y") +
    
    # Adjust legend
    scale_fill_manual(name = NULL, values = c("#009E73", "#E74C3C"),
                      labels = c("People killed (ACLED)", "People killed (UCDP)")) +
    scale_color_manual(name = NULL, values = c("Displacements" = "#0072B2"),
                       labels = "Displacements")
  
  return(p)
}


plotSingleCountry(country = "AZE")
plotSingleCountry(country = "PNG")
plotSingleCountry(country = "AFG")
plotSingleCountry(country = "MOZ")
# Change the ISO codes for the country as required


# Appendix - Figure 3: Vintaging

# Read vintaging dataset
vint_comb_idps <- read.csv("vint_comb_idps")
# This dataset includes the numbers of monthly displacements per country
# Vintage 1 is data downloaded from IDMC in December 2022
# Vintage 2 is data downloaded from IDMC in July 2024

# Generate the scatterplot
ggplot(vint_comb_idps, aes(x = idps_v1, y = idps_v2)) +
  geom_point(alpha = 0.7) +
  labs(
    x = "IDPs Vintage 1",
    y = "IDPs Vintage 2"
  ) +
  scale_x_continuous(
    labels = function(x) x / 1e6,
    name = "Displacements Vintage 1 (millions)") +
  scale_y_continuous(
    labels = function(y) y / 1e6,
    name = "Displacements Vintage 2 (millions)") +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )