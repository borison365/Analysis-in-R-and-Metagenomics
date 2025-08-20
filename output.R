View(X01_participant_metadata_yogurt)
filter(X01_participant_metadata_yogurt$arm=="unchanged_diet" & X01_participant_metadata_yogurt$birth_control=="Depoprovera")
gone <- X01_participant_metadata_yogurt
output <- subset(gone$arm, gone$birth_control)

age <- c(25, 30, 56)
gender <- c("male", "female", "male")
weight <- c(160, 110, 220) 
mydata <- data.frame(age,gender,weight)
viewBView(mydata)
subset(X01_participant_metadata_yogurt, arm=="unchanged_diet" & birth_control=="Depoprovera")
subset(X01_participant_metadata_yogurt, arm=="unchanged_diet" & age>25)
max_age <- subset(X01_participant_metadata_yogurt, arm=="unchanged_diet" & age>25)
length(max_age)
with(acs, tapply(bedrooms, own, length))
with(X01_participant_metadata_yogurt, tapply(arm, birth_control=="Depoprovera", length))
merge(X01_participant_metadata_yogurt, X00_sample_ids_yogurt, by = c("pid", "arm"))
joint <- merge(X00_sample_ids_yogurt, X02_qpcr_results_yogurt, by = c("sample_id"))
View(joint)
tables <- merge(joint, X01_participant_metadata_yogurt, by= c("pid"))
tables <- tables %>%
mutate(arm.x = factor(arm.x, levels = c("unchanged_diet", "yogurt")))
merged<- tables
merged = merged %>%
  mutate(arm.x = factor(arm.x, levels = c("unchanged_diet", "yogurt")))
table(merged$arm.x)
ggplot(merged) +
geom_boxplot(aes(x=arm.x, y = qpcr_bacteria, fill = arm.x ))+
facet_wrap(~time_point) 
  scale_y_log10()
labs(title= "type of diet")
theme_bw()
