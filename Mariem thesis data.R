
library(tidyverse)
library(dplyr)
library(readxl)
library(ggplot2)
library(reshape2)

install.packages("reshape2")


  
# Filter the data to focus on the analgesic columns
analgesic_data <- variation_analegesics[, c("Country", "Paracetamol", "Opiods", "NSAIDs", "Fentanyl", "morphine", 
                           "Non opiod", "Oxycodone", "Codeine", "Diclofenac", "Ibuprofen", 
                           "Tramadol", "Buprenrphine", "Metamizol", "Other analgesics", 
                           "Opiods +Gabapentinoids", "Opiods +Benzodiazepines", "Study design")]

anal_data <-  data[, c("Country", "Opioids", "Non opioids")]
## Assuming your data frame is named 'analgesic_data'

# Replace "morphine" with "Morphine" in the column names
names(analgesic_data) <- gsub(pattern = "morphine", replacement = "Morphine", names(analgesic_data))

# Assuming 'analgesic_data' is the data frame loaded from your Excel sheet
data

# Melt the data for easier plotting
melted_data <- melt(anal_data, id.vars = c("Country"), 
                    variable.name = "Analgesic", value.name = "Usage")


# Plot the data using facets to separate each study period
ggplot(melted_data, aes(x = Country, y = "Usage", fill = Analgesic)) +
  geom_bar(stat = "identity", position = "dodge") +
  
  labs(title = "Variation in the Use of Analgesics Across Different Countries",
       x = "Country", y = "Usage (%)", fill = "Type of Analgesic") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))




#  TO INCLUDE ALL VARIABLEE

# Melt the data for easier plotting
melted_data <- melt(variation_analegesics, id.vars = c("Country", "Study period in years", "Sample", "Mean age"), 
                    variable.name = "Analgesic", value.name = "Usage")
melted_data

# Create the plot
ggplot(melted_data, aes(x = Country)) +
  # Bar plot for Analgesic Usage
  geom_bar(aes(y = Usage, fill = Analgesic), stat = "identity", position = "dodge") +
  
  # Line plot for Mean Age
  geom_line(aes(y = `Mean age` * max(melted_data$Usage, na.rm = TRUE) / max(melted_data$`Mean age`, na.rm = TRUE), 
                group = 1, color = `Mean age`), size = 1) +
  # Points for Mean Age
  geom_point(aes(y = `Mean age` * max(melted_data$Usage, na.rm = TRUE) / max(melted_data$`Mean age`, na.rm = TRUE), 
                 color = `Mean age`), size = 3) +
  # Points for Sample Size
  geom_point(aes(y = Sample * max(melted_data$Usage, na.rm = TRUE) / max(melted_data$Sample, na.rm = TRUE), 
                 color = "Sample Size"), size = 3) +
  labs(title = "Variation in Analgesic Use, Sample Size, and Mean Age Across Countries",
       x = "Country", y = "Usage / Scaled Mean Age / Scaled Sample Size", fill = "Type of Analgesic",
       color = "Metrics") +
  
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


            #         NEW SCRIPTS


#1 Demographics Overview
# Bar Plots for Gender Distribution: Display the gender distribution across different countries.
library(ggplot2)
variation_analegesics
dat
ggplot(variation_analegesics, aes(x = Country)) +
  geom_bar(aes(y = Female, fill = "Female"), stat = "identity", position = "dodge") +
  geom_bar(aes(y = Male, fill = "Male"), stat = "identity", position = "dodge") +
  labs(title = "Gender Distribution by Country", y = "Percentage", x = "Country") +
  scale_fill_manual(values = c("Female" = "pink", "Male" = "blue")) +
  theme_minimal()


# Boxplot for Mean Age: Show the distribution of the mean age of participants across countries.

ggplot(variation_analegesics, aes(x = `Study design`, y = `Mean age`)) +
  geom_boxplot() +
  labs(title = "Mean Age of Participants per Study", y = "Mean Age", x = "Country") +
  theme_minimal()



# Analgesic Use Visualization
# Stacked Bar Chart for Analgesic Use by Country: Summarize the use of different analgesics by country.

variation_analegesics <- variation_analegesics %>% 
  mutate(Year= factor(Year))

analgesic_data <- variation_analegesics %>%
  gather(key = "Analgesic", value = "Usage", Paracetamol:Metamizol) %>%
  filter(!is.na(Usage))

ggplot(analgesic_data, aes(x = Country, y = Usage, fill = Analgesic)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Analgesic Use by Country", y = "Usage (%)", x = "Country") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



# Heatmap for Analgesic Use: Use a heatmap to visualize the intensity of analgesic use across different countries.

library(reshape2)

# Melt the data for heatmap
analgesic_heatmap_data <- melt(variation_analegesics, id.vars = "Country", measure.vars = c("Paracetamol", "Opiods", "NSAIDs", 
                                                                           "Fentanyl", "morphine", "Oxycodone",
                                                                           "Tramadol", "Ibuprofen", "Diclofenac"))

ggplot(analgesic_heatmap_data, aes(x = Country, y = variable)) +
  geom_tile(aes(fill = value), color = "white") +
  scale_fill_gradient(low = "skyblue", high = "red") +
  labs(title = "Heatmap of Analgesic Use by Country", x = "Country", y = "Analgesic") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



# 3. Study Design and Period
# Facet Wrap by Study Design: Visualize how different analgesics are used across study designs.

ggplot(analgesic_data, aes(x = Country, y = Usage, fill = Analgesic)) +
  geom_bar(stat = "identity", position = "dodge") +
  
  labs(title = "Analgesic Use by Study Design", y = "Usage (%)", x = "Country") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Line Chart for Study Period: Show the variation of analgesic use over different study periods.

ggplot(analgesic_data, aes(x = `Study period`, y = Opiods, color = Country)) +
  geom_line() +
  labs(title = "Opiod Use Over Study Period", x = "Study Period (Years)", y = "Opiod Use (%)") +
  theme_minimal()
library(dplyr)






# NUOVA PROVA

# Remove rows with NA values in Opioids and Non opioids columns
df_filtered <- data %>% filter(!is.na(Opioids) & !is.na(`Non opioids`))

# Create a bar plot comparing Opioid and Non-Opioid use across countries
ggplot(df_filtered, aes(x = Country, y = Opioids, fill = "Opioids")) +
  geom_bar(stat = "identity", position = "stack", color = "black") +
  geom_bar(aes(y = `Non opioids`, fill = "Non opioids"), stat = "identity", position = "stack", color = "black") +
  labs(title = "Comparison of Opioid and Non-Opioid Use Across Countries",
       x = "Country",
       y = "Percentage",
       fill = "Drug Type") +
  theme_minimal() +
  scale_fill_manual(values = c("Opioids" = "blue", "Non opioids" = "green")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))








