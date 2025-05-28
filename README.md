# Integrantes
- **María Camila Caraballo** - 201613424 - mc.caraballo@uniandes.edu.co
- **Javier Amaya Nieto** - 202214392 - j.amayan@uniandes.edu.co
- **Mateo Isaza Díaz** - 202412526 - m.isazad@uniandes.edu.co
- **Nicolás Moreno Enriquez** - 201615907 - na.morenoe@uniandes.edu.co
# Propósito
Responder a los planteamientos del problem set 3 del curso de Big data y Machine learning 2025-1.
# Introducción

La estimación de precios en el sector inmobiliario ha cobrado importancia con el uso de herramientas de machine learning, capaces de identificar patrones complejos en grandes volúmenes de datos. Sin embargo, casos como el de Zillow, que en 2021 cerró su programa de compra de viviendas tras pérdidas millonarias por errores sistemáticos de predicción, evidencian la necesidad de modelos precisos y contextualizados. En este trabajo se propone un ejercicio de predicción de precios de vivienda en Chapinero, Bogotá, con el fin de identificar oportunidades de inversión eficientes. Se emplean distintas técnicas de aprendizaje automático y se parte de la teoría de precios hedónicos la cual explica el valor de los inmuebles a partir de atributos observables como área, ubicación y antigüedabd (entre otros). La hipótesis es que una correcta especificación funcional y selección de variables permite aproximar de forma robusta el precio de la vivienda en esta localidad.

# Ejecución del código
El código de este proyecto se estructuró en dos secciones principales. La primera está dedicada a la limpieza de datos y la construcción de variables relevantes para el análisis, con el objetivo de generar las bases definitivas de entrenamiento y evaluación. Para correr cada uno de los diferentes modelos se debe seguir el orden de numeración secuencial con el que inicia el nombre de cada uno de los arcihvos. Estos scripts tienen los códigos de los distintos algoritmos de predicción utilizados: regresión lineal, árboles de decisión (CART), random forest, redes neuronales, modelos de boosting, super learners, así como algunas variaciones orientadas a mejorar el desempeño predictivo. 

Aclaración: Para la ejecución del código de "0_Data_cleaning" es necesario descargar algunos recursos adicionales correspondientes a datos espaciales y se pueden encontrar al siguiente link: https://uniandes-my.sharepoint.com/:f:/g/personal/j_amayan_uniandes_edu_co/Eo3akWzU5txAhdDf9-alDAwB8JMnQrixpRyKQuqcfH_oBw?e=kpCB6Z

# Ambiente de desarrollo

R version 4.4.1 (2024-06-14)
Platform: aarch64-apple-darwin20
Running under: macOS 15.3.1

Matrix products: default
BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.0

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: America/Bogota
tzcode source: internal

# Repositorio

```plaintext
taller_3_bdml/
├───data
│   ├── train.rds
│   ├── test.rds
├───results
│   ├───predictions
│   └───tables
├── document
│   ├── Documento_predict_poverty.pdf
├── scripts
│   ├──0_Data_cleaning.Rmd
│   ├──1_RegresionLineal_NET_final.R
│   ├──2_CARTS.Rmd
│   ├──3_Random_forest.Rmd
│   ├──4_RedesNeuronales.Rmd
│   ├──5_7_Xgboost_y_optimizacion_bayesiana.Rmd
│   ├──6_Superlearner.Rmd
│   ├──8_XGBoost_CVnormal.Rmd
|   ├──9_XGboost_CV_espacial.Rmd
|   ├──taller3_bd_ml.Rproj
├── README
└── .gitignore
```
