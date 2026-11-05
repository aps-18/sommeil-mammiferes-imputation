# Sommeil des mammifères (Analyse et imputation des données)

Projet réalisé dans le cadre du cours de biostatistique dispensé par Marie Vaugoyeau, en Master 1 Économétrie Appliquée à l’IAE Nantes.

L’étude porte sur les caractéristiques biologiques et écologiques associées au sommeil des mammifères et sur les effets du traitement des valeurs manquantes.

## Objectif

L’analyse cherche à comprendre les relations entre la durée du sommeil, la morphologie, le cycle de vie et les risques auxquels les espèces sont exposées. Elle examine ensuite dans quelle mesure les imputations préservent les distributions, les corrélations et l’ajustement d’un modèle de régression.

## Données

Le fichier `mammals_base.csv`, disponible dans `data/`, contient **62 espèces de mammifères**. Il comprend un identifiant d’espèce et dix variables regroupées en quatre thèmes.

- **Morphologie** — poids corporel et poids du cerveau.
- **Sommeil** — durées du sommeil total, paradoxal et non paradoxal.
- **Cycle de vie** — espérance de vie et durée de gestation.
- **Risque écologique** — prédation, exposition et danger, codés de 1 à 5.

Le rapport attribue les données à l’étude d’Allison et Cicchetti (1975) et indique que le jeu de données est disponible sur Kaggle.

La base contient des valeurs manquantes d’origine. Pour évaluer les imputations sur des valeurs connues, environ **6 % des cellules hors identifiant d’espèce** sont sélectionnées aléatoirement et remplacées par des valeurs manquantes selon un schéma MCAR (*Missing Completely At Random*).

## Démarche

### 1. Préparation et exploration des données

Les noms des espèces sont traduits, les variables sont renommées et les indicateurs de risque sont convertis en facteurs ordonnés. Des statistiques descriptives et des graphiques permettent d’étudier les distributions et de repérer les valeurs atypiques.

### 2. Analyse des relations entre variables

Les relations entre variables quantitatives sont étudiées à l’aide des **corrélations de Spearman**. Les associations entre variables qualitatives sont examinées avec les **tests du Khi-deux** et le **V de Cramér**. Des analyses de variance de Welch servent à comparer la durée du sommeil selon les niveaux de risque.

### 3. Traitement des valeurs manquantes

Trois méthodes sont appliquées successivement.

- **Sources externes** pour renseigner certaines caractéristiques biologiques des espèces.
- **Régression linéaire** pour estimer certaines valeurs manquantes à partir de variables associées.
- **Imputation multiple avec MICE** pour compléter les valeurs manquantes restantes.

Cinq jeux de données complétés sont obtenus avec MICE. Le document estime un modèle sur chacun d’eux et utilise le **troisième jeu complété** pour les comparaisons finales.

## Quelques résultats

### Corrélations avant et après imputation

Les principales associations restent visibles après imputation, même si certaines corrélations s’atténuent. La corrélation de Spearman entre le poids corporel et le poids du cerveau passe d’environ **0,95 à 0,88**. Les associations entre les durées de sommeil et les indicateurs de risque écologique restent généralement négatives.

### Comparaison du modèle de régression

Le modèle explique le logarithme du poids corporel à partir des logarithmes de l’espérance de vie et de la durée de gestation, ainsi que du niveau de danger traité comme variable catégorielle.

| Modèle | Observations | R² | R² ajusté |
|---|---:|---:|---:|
| Avant imputation | 55 | 0,6724 | 0,6315 |
| Après imputation | 62 | 0,6552 | 0,6176 |

L’imputation permet d’utiliser les **62 espèces**, contre 55 avant imputation. L’ajustement du modèle reste proche, avec une légère baisse du R². La taille de l’échantillon, les hypothèses d’imputation et le choix d’un seul jeu complété pour l’analyse finale encadrent l’interprétation de ces résultats.

## Technologies

**Langage** — R

**Manipulation et visualisation**

- `tidyverse`
- `readr`
- `dplyr`
- `tidyr`
- `ggplot2`
- `patchwork`
- `corrplot`
- `naniar`
- `PerformanceAnalytics`

**Statistiques et imputation**

- `EnvStats`
- `vcd`
- `DescTools`
- `lmtest`
- `mice`

**Document et tableaux**

- Quarto
- `knitr`
- `kableExtra`

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
├── rapport/
│   └── Sommeil_mammifères.pdf
└── sommeil-mammiferes-imputation.Rproj
```

L’analyse s’exécute dans RStudio en ouvrant le fichier `.Rproj`, puis en lançant les blocs du document Quarto avec les bibliothèques R installées.

## Rapport

Le rapport complet présente les analyses, les graphiques et les annexes. [Consulter le rapport](rapport/Sommeil_mammifères.pdf)

## Auteurs

- **Amélie Pires**
- Ikram Abouzayd

Master 1 Économétrie Appliquée — Biostatistique — IAE Nantes, 2025–2026.

## Contact

**Amélie Pires**

Mail [amelie.pires@hotmail.com](mailto:amelie.pires@hotmail.com) · [LinkedIn](https://www.linkedin.com/in/amelie-pires) · [GitHub](https://github.com/aps-18)
