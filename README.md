# Anticipating Humanitarian Emergencies with High Risk of Conflict-Induced Displacement Crises

This repository contains the code and data for the study "Anticipating Humanitarian Emergencies with High Risk of Conflict-Induced Displacement Crises." The study explores machine learning methods to predict the onset of large-scale, conflict-related internal displacement in countries experiencing humanitarian emergencies. The code uses both python and R. 

## Overview

The study aims to assess the risk of future displacement crises, defined as at least 1,000 new displacements per month due to conflict, one and three months into the future. We compare various machine learning models, including logistic regression, random forest, and gradient boosting machines, against a simple baseline model.

## Key Features

- **Data Sources**: 
  - Uppsala Conflict Data Program (UCDP)
  - Armed Conflict Location and Event Data (ACLED)
  - INFORM project indices
  - Varieties of Democracy (V-Dem)
  - Internal Displacement Monitoring Centre (IDMC)

- **Model Highlights**:
  - Best random forest model identified 24 of 26 displacement cases three months in advance.
  - Focus on predicting displacement onset to aid humanitarian response and preparation.

## Data Availability

The datasets, scripts, and other relevant files are available on XXXX. Data support is derived from publicly available sources such as UCDP, ACLED, INFORM, V-Dem, and IDMC.

## Usage

1. **Installation**: Clone the repository and install the required dependencies by running from terminal `conda env create -f requirements.yml`.
2. **Running Models**: Use the provided scripts to train and evaluate the models.
3. **Code Organization**: Separate Python notebooks are provided for training models for 1-month and 3-month forecasts. An R script is available for reproducing appendix figures.
4. **Data Access**: Data files can be accessed and downloaded from the mentioned sources. Ensure proper citations when using the data.

## Limitations

- Prediction of displacement onset is challenging due to data limitations and rarity of events.
- Models are trained on available data up to June 2024.

## License

This project is licensed under the MIT License. 

---

For any questions or issues, please contact the project maintainers.
