# ============================================================
# ANNEXE — Code caché
# Projet : Sommeil des mammifères
# ============================================================


# --- setup 
knitr::opts_chunk$set(
  warning = FALSE,
  message = FALSE
)

# --- Import des packages 
packages <- c(
  "stringr", "tidyverse", "dplyr", "ggplot2", "corrplot", "tidyr",
  "PerformanceAnalytics", "patchwork", "kableExtra", "EnvStats",
  "lsr", "vcd", "knitr", "DescTools", "naniar", "reshape2",
  "FNN", "VIM", "mice"
)
packages_manquants <- packages[!packages %in% installed.packages()[, "Package"]]
if (length(packages_manquants) > 0) {
  install.packages(packages_manquants)
}
invisible(lapply(packages, library, character.only = TRUE))

# --- Traduction français
trad <- c(
  "Africanelephant" = "Éléphant d'Afrique",
  "Africangiantpouchedrat" = "Rat géant africain à poche",
  "ArcticFox" = "Renard arctique",
  "Arcticgroundsquirrel" = "Écureuil terrestre arctique",
  "Asianelephant" = "Éléphant d'Asie",
  "Baboon" = "Babouin",
  "Bigbrownbat" = "Grande chauve-souris brune",
  "Braziliantapir" = "Tapir du Brésil",
  "Cat" = "Chat",
  "Chimpanzee" = "Chimpanzé",
  "Chinchilla" = "Chinchilla",
  "Cow" = "Vache",
  "Deserthedgehog" = "Hérisson du désert",
  "Donkey" = "Âne",
  "EasternAmericanmole" = "Taupe d’Amérique de l'Est",
  "Echidna" = "Échidné",
  "Europeanhedgehog" = "Hérisson d’Europe",
  "Galago" = "Galago",
  "Genet" = "Genette",
  "Giantarmadillo" = "Tatou géant",
  "Giraffe" = "Girafe",
  "Goat" = "Chèvre",
  "Goldenhamster" = "Hamster doré",
  "Gorilla" = "Gorille",
  "Grayseal" = "Phoque gris",
  "Graywolf" = "Loup gris",
  "Groundsquirrel" = "Écureuil terrestre",
  "Guineapig" = "Cochon d’Inde",
  "Horse" = "Cheval",
  "Jaguar" = "Jaguar",
  "Kangaroo" = "Kangourou",
  "Lessershort-tailedshrew" = "Musaraigne à courte queue",
  "Littlebrownbat" = "Petite chauve-souris brune",
  "Man" = "Homme",
  "Molerat" = "Rat-taupe",
  "Mountainbeaver" = "Aplodontie",
  "Mouse" = "Souris",
  "Muskshrew" = "Musaraigne musquée",
  "NAmericanopossum" = "Opossum d’Amérique du Nord",
  "Nine-bandedarmadillo" = "Tatou à neuf bandes",
  "Okapi" = "Okapi",
  "Owlmonkey" = "Douroucouli",
  "Patasmonkey" = "Singe patas",
  "Phanlanger" = "Phalanger",
  "Pig" = "Cochon",
  "Rabbit" = "Lapin",
  "Raccoon" = "Raton laveur",
  "Rat" = "Rat",
  "Redfox" = "Renard roux",
  "Rhesusmonkey" = "Singe rhésus",
  "Rockhyrax(Heterob)" = "Damane des rochers (Heterohyrax)",
  "Rockhyrax(Procaviahab)" = "Damane des rochers (Procavia)",
  "Roedeer" = "Chevreuil",
  "Sheep" = "Mouton",
  "Slowloris" = "Loris lent",
  "Starnosedmole" = "Condylure étoilé",
  "Tenrec" = "Tenrec",
  "Treehyrax" = "Damane arboricole",
  "Treeshrew" = "Musaraigne arboricole",
  "Vervet" = "Singe vervet",
  "Wateropossum" = "Opossum aquatique",
  "Yellow-belliedmarmot" = "Marmotte à ventre jaune"
)

# --- Application traduction + renommage 
mammals_original$species_fr <- trad[mammals_original$species]

names(mammals_original)[names(mammals_original) == "body_wt"]        <- "poids_corporel"
names(mammals_original)[names(mammals_original) == "brain_wt"]       <- "poids_cerveau"
names(mammals_original)[names(mammals_original) == "non_dreaming"]   <- "sommeil_non_paradoxal"
names(mammals_original)[names(mammals_original) == "dreaming"]       <- "sommeil_paradoxal"
names(mammals_original)[names(mammals_original) == "total_sleep"]    <- "sommeil_total"
names(mammals_original)[names(mammals_original) == "life_span"]      <- "esperance_vie"
names(mammals_original)[names(mammals_original) == "gestation"]      <- "duree_gestation"
names(mammals_original)[names(mammals_original) == "predation"]      <- "predation"
names(mammals_original)[names(mammals_original) == "exposure"]       <- "exposition"
names(mammals_original)[names(mammals_original) == "danger"]         <- "danger"

# --- Nettoyage structurel (echo=FALSE, results='hide')
mammals_original <- mammals_original[ , -1]
mammals_original <- mammals_original[, c(ncol(mammals_original), 1:(ncol(mammals_original)-1))]

# --- vars_quali / vars_quanti / couleur
vars_quali <- c("predation", "exposition", "danger")

vars_quanti <- c("poids_corporel", "poids_cerveau", "sommeil_non_paradoxal",
                 "sommeil_paradoxal", "sommeil_total", "esperance_vie",
                 "duree_gestation")

couleur <- c(
  "1" = "lightgoldenrod1",
  "2" = "darksalmon",
  "3" = "darkolivegreen2",
  "4" = "mistyrose2",
  "5" = "paleturquoise3"
)

# --- Pie charts 
pie_var <- function(var){
  df <- mammals %>%
    count(.data[[var]]) %>%
    mutate(
      perc = round(n / sum(n) * 100, 1),
      label = paste0(perc, "%")
    )
  ggplot(df, aes(x = "", y = n, fill = as.factor(.data[[var]]))) +
    geom_bar(stat = "identity", width = 1, color = "white") +
    coord_polar("y") +
    geom_text(aes(label = label),
              position = position_stack(vjust = 0.5),
              size = 4, color = "black") +
    scale_fill_manual(values = couleur) +
    labs(title = paste("Répartition de", var), fill = var) +
    theme_void() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      legend.position = "bottom"
    )
}

p1 <- pie_var("predation")
p2 <- pie_var("exposition")
p1 | p2

p3 <- pie_var("danger")
p3

# --- Diagrammes en barres 
for (var in vars_quali) {
  plot <- mammals |>
    ggplot() +
    aes_string(x = var, fill = var) +
    geom_bar() +
    scale_fill_manual(values = couleur) +
    theme_classic() +
    labs(title = paste("Distribution de", var), x = var, fill = var)
}
plot

# --- Boxplots 
mammals |>
  pivot_longer(cols = where(is.numeric)) |>
  ggplot(aes(y = value, x = "")) +
  geom_boxplot(fill = "lightblue", alpha = 0.8) +
  geom_jitter(color = "darkblue", alpha = 0.2) +
  facet_wrap(~ name, scales = "free_y") +
  theme_light()

# --- Histogrammes 
mammals |>
  pivot_longer(cols = all_of(vars_quanti)) |>
  ggplot(aes(x = value, fill = name)) +
  geom_histogram(bins = 15, color = "black", alpha = 0.8) +
  facet_wrap(~ name, scales = "free", ncol = 3) +
  theme_light() +
  scale_fill_brewer(palette = "Pastel1") +
  guides(fill = "none") +
  labs(title = "Histogrammes")

# --- Tableau stats descriptives 
stats <- mammals |>
  summarise(
    across(
      .cols = all_of(vars_quanti),
      .fns = list(
        moyenne = ~mean(.x, na.rm=TRUE),
        mediane = ~median(.x, na.rm=TRUE),
        minimum = ~min(.x, na.rm=TRUE),
        maximum = ~max(.x, na.rm=TRUE),
        sd = ~sd(.x, na.rm=TRUE)
      ),
      .names = "{.col}_{.fn}"
    )
  ) |>
  pivot_longer(everything()) |>
  mutate(
    variable = sub("_[^_]+$", "", name),
    mesure   = sub("^.*_", "", name)
  ) |>
  select(variable, mesure, value) |>
  pivot_wider(names_from = mesure, values_from = value) |>
  arrange(variable)

stats %>%
  kable(
    caption = "Statistiques descriptives des variables quantitatives",
    digits = 2,
    align = "c"
  ) %>%
  kable_styling(
    full_width = FALSE,
    bootstrap_options = c("striped", "hover", "condensed"),
    font_size = 13
  ) %>%
  row_spec(0, bold = TRUE) %>%
  column_spec(1, bold = TRUE)

# --- Rosner tests 
rosnerTest(mammals$duree_gestation, k = 2, alpha = 0.05)
rosnerTest(mammals$esperance_vie, k = 2, alpha = 0.05)
rosnerTest(mammals$poids_cerveau, k = 6, alpha = 0.05)
rosnerTest(mammals$poids_corporel, k = 6, alpha = 0.05)
rosnerTest(mammals$poids_corporel, k = 6, alpha = 0.05)

# --- Normalité Shapiro 
res_norm <- sapply(vars_quanti, function(v){
  shapiro.test(mammals[[v]])$p.value
})

data.frame(
  p_value = res_norm,
  normalite = ifelse(res_norm > 0.05, "normal", "pas normal")
)



# --- Nuage de point
ggplot(mammals, aes(x = poids_corporel, y = poids_cerveau)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(
    title = "Relation entre le poids du corps et le poids du cerveau",
    x = "Poids corporel (kg)",
    y = "Poids du cerveau (g)"
  ) +
  theme_minimal()

ggplot(mammals, aes(x = sommeil_non_paradoxal, y = sommeil_total)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(
    title = "Lien entre le sommeil non paradoxal et le sommeil total",
    x = "Sommeil non paradoxal (heures)",
    y = "Sommeil total (heures)"
  ) +
  theme_minimal()

ggplot(mammals, aes(x = poids_corporel, y = sommeil_total)) +
  geom_point(color = "blue", alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(
    title = "Relation entre le poids corporel et le sommeil total",
    x = "Poids corporel (kg)",
    y = "Sommeil total (heures)"
  ) +
  theme_minimal()

# --- Corrplot Spearman 
cor_matrix <- cor(mammals[, vars_quanti], use = "complete.obs", method = "spearman")

corrplot(cor_matrix,
         method = "color",
         type = "upper",
         addCoef.col = "black",
         tl.col = "black",
         tl.cex = 0.8,
         number.cex = 0.7,
         tl.srt = 45,
         col = colorRampPalette(c("blue", "white", "red"))(200))

# --- Heatmaps quali x quali 
mammals |>
  count(predation, exposition) |>
  ggplot(aes(x = predation, y = exposition, fill = n)) +
  geom_tile(color = "white") +
  theme_bw() +
  labs(title = "Relation entre prédation et exposition",
       x = "Prédation", y = "Exposition", fill = "Fréquence")

mammals |>
  count(predation, danger) |>
  ggplot(aes(x = predation, y = danger, fill = n)) +
  geom_tile(color = "white") +
  theme_bw() +
  labs(title = "Relation entre prédation et danger",
       x = "Prédation", y = "Danger", fill = "Fréquence")

mammals |>
  count(exposition, danger) |>
  ggplot(aes(x = exposition, y = danger, fill = n)) +
  geom_tile(color = "white") +
  theme_bw() +
  labs(title = "Relation entre exposition et danger",
       x = "Exposition", y = "Danger", fill = "Fréquence")

# --- Khi² 
vars_quali <- c("predation", "exposition", "danger")

chi2_results <- data.frame(
  var1 = character(),
  var2 = character(),
  chi2 = numeric(),
  df = numeric(),
  p_value = numeric(),
  stringsAsFactors = FALSE
)

for(i in 1:(length(vars_quali)-1)){
  for(j in (i+1):length(vars_quali)){
    x <- vars_quali[i]
    y <- vars_quali[j]
    res <- chisq.test(table(mammals[[x]], mammals[[y]]))
    chi2_results <- rbind(
      chi2_results,
      data.frame(
        var1 = x,
        var2 = y,
        chi2 = round(res$statistic, 3),
        df = res$parameter,
        p_value = round(res$p.value, 5)
      )
    )
  }
}

chi2_results

# --- Cramer's V 
mat_cramer <- matrix(NA,
                     nrow = length(vars_quali),
                     ncol = length(vars_quali),
                     dimnames = list(vars_quali, vars_quali))

for(i in 1:length(vars_quali)){
  for(j in 1:length(vars_quali)){
    tbl <- table(mammals[[vars_quali[i]]], mammals[[vars_quali[j]]])
    mat_cramer[i, j] <- assocstats(tbl)$cramer
  }
}

mat_cramer

# --- Violin plot
for (v in vars_quali) {
  ggp <- ggplot(mammals, aes_string(x = v, y = "sommeil_total", fill = v)) +
    geom_violin(trim = FALSE, alpha = 0.7) +
    geom_boxplot(width = 0.1, outlier.shape = NA, alpha = 0.3) +
    labs(title = paste("Distribution du sommeil total selon", v),
         x = v, y = "Sommeil total") +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
ggp

# --- ANOVA Welch + eta² 
library(DescTools)

resume_anova <- function(var){
  f <- as.formula(paste("sommeil_total ~", var))
  welch <- oneway.test(f, data = mammals, var.equal = FALSE)
  eta <- etaSquared(aov(f, data = mammals))[1, 1]
  data.frame(variable = var, p_value = welch$p.value, eta2 = eta)
}

vars_quali <- c("predation", "exposition", "danger")
resultats_quali <- do.call(rbind, lapply(vars_quali, resume_anova))
print(resultats_quali)

# --- Heatmap NA
mammals %>%
  mutate(observation = row_number()) %>%
  gather(variable, value, -observation) %>%
  mutate(na_flag = ifelse(is.na(value), 1, 0)) %>%
  ggplot(aes(x = variable, y = observation, fill = na_flag)) +
  geom_tile(color = "white", linewidth = 0.2) +
  scale_fill_gradient(low = "#e0f3db", high = "#0868ac",
                      name = "Valeurs\nmanquantes",
                      breaks = c(0, 1),
                      labels = c("Présent", "Manquant")) +
  labs(title = "Heatmap des valeurs manquantes",
       x = "Variables", y = "Observations") +
  theme_minimal(base_size = 13) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(size = 14, face = "bold", hjust = 0.5))

# --- UpSet NA
naniar::gg_miss_upset(
  mammals,
  nsets = ncol(mammals),
  nintersects = 100,
  sets.bar.color = "blue",
  main.bar.color = "red"
)

# --- Vérif NA après imputation externe
colSums(is.na(mammals_m1[, c("duree_gestation","poids_cerveau","poids_corporel")]))

colSums(is.na(mammals_final))

# --- Distribution de la durée de gestation avant et après imputations par sources externes

par(mfrow = c(1, 2))

hist(mammals$duree_gestation,
     main = "Avant imputation\nDurée de gestation",
     xlab = "Jours",
     col = "grey",
     border = "white")

hist(mammals_final$duree_gestation,
     main = "Après imputation\nDurée de gestation",
     xlab = "Jours",
     col = "pink",
     border = "white")

# --- Distribution de la durée du sommeil total avant et après imputations par régression

par(mfrow = c(1, 2))

hist(mammals$sommeil_total,
     main = "Avant imputation\nSommeil total",
     xlab = "Heures",
     col = "grey",
     border = "white")

hist(mammals_final$sommeil_total,
     main = "Après imputation (régression)\nSommeil total",
     xlab = "Heures",
     col = "lightgreen",
     border = "white")

# --- Distribution niveau de prédation avant et après imputations multiples

par(mfrow = c(1, 2))

# Avant imputation (base avec NA artificiels)
prop_avant <- prop.table(table(mammals$predation))

# Après imputation (base finale)
prop_apres <- prop.table(table(mammals_final$predation))

barplot(
  prop_avant,
  main = "Avant imputation\nPrédation",
  ylab = "Proportion",
  col = "grey"
)

barplot(
  prop_apres,
  main = "Après imputation\nPrédation",
  ylab = "Proportion",
  col = "orange"
)

# --- compare_methode1 
compare_methode1 <- function(varname, n = 10) {
  idx <- is.na(mammals[[varname]]) & !is.na(mammals_original[[varname]])
  data.frame(
    species = mammals_original$species_fr[idx],
    Valeur_reelle = mammals_original[[varname]][idx],
    Valeur_imputee = mammals_m1[[varname]][idx],
    Difference = mammals_m1[[varname]][idx] - mammals_original[[varname]][idx]
  )[1:n, ]
}

compare_methode1("duree_gestation", n = 4)

compare_methode1("poids_corporel", n = 3)

compare_methode1("poids_cerveau", n = 2)

# --- Résumé erreurs méthode 1 
vars_m1 <- c("duree_gestation","poids_corporel","poids_cerveau")

resume_methode_b <- do.call(
  rbind,
  lapply(vars_m1, function(v){
    idx <- is.na(mammals[[v]]) & !is.na(mammals_original[[v]])
    diff1 <- mammals_m1[[v]][idx] - mammals_original[[v]][idx]
    data.frame(
      Variable = v,
      MAE = mean(abs(diff1)),
      RMSE = sqrt(mean(diff1^2)),
      Biais_moyen = mean(diff1)
    )
  })
)

resume_methode_b

# --- Détails régression 
vars_reg <- c("sommeil_total","esperance_vie")

details_regression <- do.call(
  rbind,
  lapply(vars_reg, function(v){
    idx <- is.na(mammals[[v]]) & !is.na(mammals_original[[v]])
    data.frame(
      Variable = v,
      species = mammals_original$species_fr[idx],
      Valeur_reelle  = mammals_original[[v]][idx],
      Valeur_imputee = mammals_reg[[v]][idx],
      Difference = mammals_reg[[v]][idx] - mammals_original[[v]][idx]
    )
  })
)

details_regression <- details_regression[!is.na(details_regression$Valeur_imputee), ]
details_regression$Difference <- round(details_regression$Difference, 3)
details_regression

# --- Résumé erreurs régression 
resume_regression <- do.call(
  rbind,
  lapply(vars_reg, function(v){
    idx <- is.na(mammals[[v]]) & !is.na(mammals_original[[v]])
    diff <- mammals_reg[[v]][idx] - mammals_original[[v]][idx]
    data.frame(
      Variable = v,
      MAE = mean(abs(diff)),
      RMSE = sqrt(mean(diff^2)),
      Biais_moyen = mean(diff)
    )
  })
)

resume_regression

# --- Scatter réel vs imputé
par(mfrow = c(1, length(vars_reg)),
    mar = c(5, 4, 3, 2),
    oma = c(5, 0, 0, 0))

for (v in vars_reg) {
  idx <- is.na(mammals[[v]]) & !is.na(mammals_original[[v]])
  plot(
    mammals_original[[v]][idx],
    mammals_reg[[v]][idx],
    xlab = paste(v, "réel"),
    ylab = paste(v, "imputé"),
    main = paste("réel vs imputé"),
    pch = 19,
    col = "blue"
  )
  abline(0, 1, col = "red", lty = 2)
}

mtext(
  "Points bleus : valeurs imputées    |    Droite rouge : valeurs réelles",
  side = 1, outer = TRUE, line = 2, cex = 0.9
)

par(mfrow = c(1,1))

# --- Stats descriptives avant/après MICE 
vars_mice_only <- c(
  "sommeil_total","esperance_vie","sommeil_non_paradoxal","sommeil_paradoxal",
  "predation","exposition","danger","poids_cerveau"
)

summary_avant_mice <- summary(mammals_reg[, vars_mice_only])
summary_apres_mice <- summary(mammals_final[, vars_mice_only])

summary_avant_mice
summary_apres_mice

# --- Histogrammes avant/après MICE 
par(mfrow = c(1, 2))

hist(mammals_reg$sommeil_total,
     main = "Avant imputation multiple\nSommeil total",
     col = "grey", border = "white", xlab = "Heures")

hist(mammals_final$sommeil_total,
     main = "Après imputation multiple\nSommeil total",
     col = "purple", border = "white", xlab = "Heures")

par(mfrow = c(1, 1))

# --- Préparation corrélations MICE
mice_avant_corr <- mammals_reg[, vars_mice_only]
mice_apres_corr <- mammals_final[, vars_mice_only]

ord_vars <- c("predation","exposition","danger")

mice_avant_corr[ord_vars] <- lapply(mice_avant_corr[ord_vars], function(x)
  as.numeric(as.character(x))
)

mice_apres_corr[ord_vars] <- lapply(mice_apres_corr[ord_vars], function(x)
  as.numeric(as.character(x))
)

# --- Corrplot Avant MICE 
cor_avant_mice <- cor(mice_avant_corr, method = "spearman", use = "pairwise.complete.obs")

corrplot(
  cor_avant_mice,
  method = "color",
  addCoef.col = "black",
  number.cex = 0.6,
  tl.cex = 0.8,
  title = "Avant imputation multiple",
  mar = c(0, 0, 2, 0),
  cl.cex = 0.8
)

# --- Corrplot Après MICE
cor_apres_mice <- cor(mice_apres_corr, method = "spearman")

corrplot(
  cor_apres_mice,
  method = "color",
  addCoef.col = "black",
  number.cex = 0.6,
  tl.cex = 0.8,
  title = "Après imputation multiple",
  mar = c(0, 0, 2, 0),
  cl.cex = 0.8
)

# --- Corrélations globales avant/après 
vars_corr <- c(
  "poids_corporel","poids_cerveau","duree_gestation",
  "sommeil_total","sommeil_non_paradoxal","sommeil_paradoxal",
  "esperance_vie","predation","exposition","danger"
)

data_avant <- mammals_original[, vars_corr]
data_apres <- mammals_final[, vars_corr]

data_avant <- as.data.frame(lapply(data_avant, as.numeric))
data_apres <- as.data.frame(lapply(data_apres, as.numeric))

cor_avant <- cor(data_avant, method = "spearman", use = "pairwise.complete.obs")
cor_apres <- cor(data_apres, method = "spearman", use = "complete.obs")

# --- Corrplot Avant imputation 
par(mar = c(1, 1, 4, 1))

corrplot(
  cor_avant,
  method = "color",
  type = "upper",
  col = colorRampPalette(c("#2166AC", "white", "#B2182B"))(200),
  tl.cex = 0.7,
  addCoef.col = "black",
  number.cex = 0.6
)

mtext("Avant imputation", side = 3, line = 2, cex = 1.2, font = 2)
par(mar = c(5, 4, 4, 2))

# --- Corrplot Après imputation
par(mar = c(1, 1, 4, 1))

corrplot(
  cor_apres,
  method = "color",
  type = "upper",
  col = colorRampPalette(c("#2166AC", "white", "#B2182B"))(200),
  tl.cex = 0.7,
  addCoef.col = "black",
  number.cex = 0.6
)

mtext("Après imputation", side = 3, line = 2, cex = 1.2, font = 2)
par(mar = c(5, 4, 4, 2))

# --- Modèle avant imputation 
vars_model <- c("poids_corporel","esperance_vie","duree_gestation","danger")
data_avant_model <- mammals_original[, vars_model]

model_avant <- lm(poids_corporel ~ esperance_vie + duree_gestation + danger,
                  data = data_avant_model)

summary(model_avant)

# --- Modèle après imputation 
data_apres_model <- mammals_final[, vars_model]

model_apres <- lm(poids_corporel ~ esperance_vie + duree_gestation + danger,
                  data = data_apres_model)

summary(model_apres)

# --- Tableau comparaison modèles 
comparison_models <- data.frame(
  Modele = c("Avant imputation", "Après imputation"),
  N_obs = c(nobs(model_avant), nobs(model_apres)),
  R2 = c(summary(model_avant)$r.squared, summary(model_apres)$r.squared),
  R2_ajuste = c(summary(model_avant)$adj.r.squared, summary(model_apres)$adj.r.squared)
)

comparison_models
