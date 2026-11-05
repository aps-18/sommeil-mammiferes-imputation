# Sommeil des mammifères (Analyse et imputation des données)

Projet réalisé dans le cadre du cours de biostatistique enseigné par Marie VAUGOYEAU dans le Master 1 Économétrie Appliquée à l’IAE Nantes, en 2025–2026.

## Objectif

Étudier les relations entre le sommeil des mammifères et leurs caractéristiques biologiques et écologiques. Le projet examine ensuite comment le traitement des valeurs manquantes affecte les distributions, les corrélations et les résultats d’un modèle de régression.

## Données

Le fichier `data/mammals_base.csv` contient **62 espèces de mammifères**. Il comprend un identifiant d’espèce et dix variables portant sur quatre dimensions.

- **Morphologie** — poids corporel et poids du cerveau.
- **Sommeil** — durée du sommeil total, paradoxal et non paradoxal.
- **Cycle de vie** — espérance de vie et durée de gestation.
- **Risque écologique** — prédation, exposition et danger, codés sur une échelle de 1 à 5.

Le rapport attribue les données à l’étude d’Allison et Cicchetti (1975) et indique que le jeu de données est disponible sur Kaggle.

La base comporte des valeurs manquantes d’origine. Pour étudier les imputations à partir de valeurs initialement connues, le projet sélectionne aléatoirement environ **6 % des cellules hors identifiant d’espèce** et les remplace par des valeurs manquantes. Cette simulation suit un schéma MCAR (*Missing Completely At Random*).

## Méthodologie

1. **Préparer les données** en traduisant les noms des espèces, en renommant les variables et en convertissant les indicateurs de risque en facteurs ordonnés.
2. **Explorer les données** à l’aide de graphiques descriptifs, de tests de normalité, de corrélations de Spearman, de tests du Khi-deux, du V de Cramér et d’analyses de variance de Welch.
3. **Traiter les valeurs manquantes** en combinant trois méthodes. Certaines valeurs sont renseignées à partir de sources externes, d’autres sont estimées par régression linéaire, puis les valeurs manquantes restantes sont traitées par imputation multiple avec **MICE**.
4. **Évaluer les effets des imputations** en comparant les valeurs observées et imputées, les distributions, les corrélations et les résultats du modèle final.

MICE produit cinq jeux de données complétés. Le document estime un modèle sur chacun d’eux et retient le **troisième jeu complété** pour les comparaisons finales.

## Principaux résultats

### Corrélations avant et après imputation

Les relations principales restent visibles après imputation, même si certaines corrélations s’atténuent. La corrélation de Spearman entre le poids corporel et le poids du cerveau passe par exemple d’environ **0,95 à 0,88**. Les associations entre les durées de sommeil et les indicateurs de risque écologique restent généralement négatives.

### Comparaison des modèles de régression

Le modèle explique le logarithme du poids corporel à partir des logarithmes de l’espérance de vie et de la durée de gestation, ainsi que du niveau de danger traité comme une variable catégorielle.

| Modèle | Observations | R² | R² ajusté |
|---|---:|---:|---:|
| Avant imputation | 55 | 0,6724 | 0,6315 |
| Après imputation | 62 | 0,6552 | 0,6176 |

Après imputation, le modèle est estimé sur les **62 espèces**, contre 55 initialement. Le R² baisse légèrement et reste proche de sa valeur initiale. Cette comparaison décrit l’ajustement du modèle sur les deux échantillons d’estimation.

### Conclusion et limites

Le projet montre comment combiner plusieurs méthodes d’imputation selon la nature des variables et l’information disponible. Dans cette étude, l’imputation augmente le nombre d’observations utilisables et préserve les grandes tendances observées dans les données.

L’interprétation tient compte de la taille réduite de l’échantillon, des hypothèses propres à chaque méthode et du choix d’un seul jeu complété pour les comparaisons finales.

## Technologies utilisées

- **R** pour la préparation des données, les analyses statistiques et l’imputation.
- **Quarto et knitr** pour documenter l’analyse et produire le rapport.
- **tidyverse**, notamment **readr**, **dplyr**, **tidyr** et **ggplot2**, pour la manipulation et la visualisation des données.
- **mice** pour l’imputation multiple.
- **corrplot**, **naniar** et **PerformanceAnalytics** pour explorer les corrélations et les valeurs manquantes.

## Structure du dépôt

```text
sommeil-mammiferes-imputation/
├── README.md
├── code/
│   ├── Sommeil_mammifères.qmd
│   ├── annexe_code_cache.R
│   └── Logo_IAE.png
├── data/
│   └── mammals_base.csv
└── rapport/
    └── Sommeil_mammifères.pdf
```

Le fichier Quarto contient l’analyse. Il lit `annexe_code_cache.R` pour afficher le code de l’annexe et utilise `Logo_IAE.png` pour la page de présentation.

## Reproduire l’analyse dans RStudio

1. Ouvrir le projet dans RStudio depuis la racine du dépôt.
2. Exécuter le bloc suivant dans la console R pour installer les bibliothèques manquantes.

```r
packages <- c(
  "readr", "stringr", "tidyverse", "dplyr", "ggplot2", "corrplot",
  "tidyr", "PerformanceAnalytics", "patchwork", "kableExtra",
  "EnvStats", "lsr", "vcd", "knitr", "DescTools", "naniar",
  "reshape2", "FNN", "VIM", "mice", "lmtest", "rmarkdown"
)

packages_manquants <- setdiff(packages, rownames(installed.packages()))

if (length(packages_manquants) > 0) {
  install.packages(packages_manquants, repos = "https://cloud.r-project.org")
}
```

3. Ouvrir `code/Sommeil_mammifères.qmd`, redémarrer la session R, puis choisir **Run → Run All Chunks** pour exécuter les blocs dans l’ordre.
4. Pour générer un nouveau PDF, utiliser **Render**. Le rendu PDF nécessite Quarto et une distribution LaTeX, par exemple TinyTeX.

Les figures de l’analyse s’affichent lors de l’exécution des blocs et sont intégrées au rapport lors du rendu. La graine aléatoire fixée dans le document facilite la reproduction des résultats. Les versions de R et des bibliothèques peuvent être consultées avec `sessionInfo()`.

## Rapport

Le rapport présente la démarche complète, les graphiques, les résultats et les annexes. [Consulter le rapport rendu (PDF)](rapport/Sommeil_mammifères.pdf)

## Auteurs

Projet universitaire réalisé par :

- **Amélie Pires**
- Ikram Abouzayd

Master 1 Économétrie Appliquée — Économétrie linéaire avancée — IAE Nantes, 2025-2026.

## Contact

**Amélie Pires**

Mail : [amelie.pires@hotmail.com](mailto:amelie.pires@hotmail.com) · [LinkedIn](https://www.linkedin.com/in/amelie-pires) · [GitHub](https://github.com/aps-18)
