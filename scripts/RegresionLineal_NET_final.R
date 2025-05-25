library(skimr)
library(glmnet)
library(caret)
library(dplyr)

# Cargar datos
train <- readRDS("../data/train.rds")
test <- readRDS("../data/test.rds")

# Combinar datos con identificación de conjunto
data <- bind_rows(train %>% mutate(dataset = "train"),
                  test %>% mutate(dataset = "test"))

# quitandole el formato geometry train
data <- st_drop_geometry(data)

# Revisando los datos
skim(data)

# Función para imputar por moda algunas variables con NAs
imputar_moda <- function(x) {
  moda <- names(which.max(table(x)))
  x[is.na(x)] <- moda
  return(x)
}
# Aplicar a cada variable
data$has_balcon <- imputar_moda(data$has_balcon)
data$has_chimenea <- imputar_moda(data$has_chimenea)
data$has_gimnasio <- imputar_moda(data$has_gimnasio)
data$has_piscina <- imputar_moda(data$has_piscina)
data$has_duplex <- imputar_moda(data$has_duplex)

# Seleccionando las variables 
variables_selected <- c(
  "property_id", "price_millions", "upl", "property_type", "parqueaderos", "parque", "avenidas", "gimnasio", 
  "duplex", "piscina", "desposito", "surface_total", "surface_covered", 
  "rooms", "bedrooms", "bathrooms", "cai_mts", "tm_mts", "sitp_100m", 
  "ciclorutas_mts", "invasiones_100m", "median_m2", "terraza", "area_imputed", 
  "parque_mts", "univ_mts", "hospital_mts", "lujo", "balcon", "remodelado", 
  "vista", "has_balcon", "has_chimenea", "has_gimnasio", "has_piscina", 
  "has_duplex", "rooms_density", "covered_ratio", "years_since_construction", 
  "transport_score", "environment_score", "text_pca_1", 
  "text_pca_2", "text_pca_3", "text_pca_4", "text_pca_5", "text_pca_6", 
  "text_pca_7", "text_pca_8", "text_pca_9", "text_pca_10", "text_pca_11", 
  "text_pca_12", "text_pca_13", "text_pca_14", "text_pca_15", "text_pca_16", 
  "text_pca_17", "text_pca_18", "text_pca_19", "text_pca_20", "text_pca_21", 
  "text_pca_22", "text_pca_23", "text_pca_24", "text_pca_25", "text_pca_26", 
  "text_pca_27", "text_pca_28", "text_pca_29", "text_pca_30", "text_pca_31", 
  "text_pca_32", "text_pca_33", "text_pca_34", "text_pca_35", "text_pca_36", 
  "text_pca_37", "text_pca_38", "text_pca_39", "text_pca_40", "text_pca_41", 
  "text_pca_42", "text_pca_43", "text_pca_44", "text_pca_45", "text_pca_46", 
  "text_pca_47", "text_pca_48", "text_pca_49", "text_pca_50", "dataset"
) 

# Seleccionando las variables para entrenamiento y test 
df_data <- data %>% dplyr::select(all_of(variables_selected))

# Separando las bases de train y test sin NAs. 
train_df <- df_data %>% 
  filter(dataset == "train") %>% 
  select(-dataset)  # Ya no necesitamos select(-geometry) porque st_drop_geometry ya lo hizo

test_df <- df_data %>% 
  filter(dataset == "test") %>% 
  select(-dataset)

# Especificando la ecuación del modelo 
model_form <-  price_millions ~ upl + property_type + parqueaderos + parque + avenidas + 
  gimnasio + duplex + piscina + desposito + surface_total + surface_covered + 
  rooms + bedrooms + bathrooms + cai_mts + tm_mts + sitp_100m + 
  ciclorutas_mts + invasiones_100m + median_m2 + terraza + area_imputed + 
  parque_mts + univ_mts + hospital_mts + lujo + balcon + remodelado + 
  vista + has_balcon + has_chimenea + has_gimnasio + has_piscina + 
  has_duplex + rooms_density + covered_ratio + years_since_construction + 
  transport_score + environment_score + text_pca_1 + text_pca_2 + 
  text_pca_3 + text_pca_4 + text_pca_5 + text_pca_6 + text_pca_7 + 
  text_pca_8 + text_pca_9 + text_pca_10 + text_pca_11 + text_pca_12 + text_pca_13 +
  text_pca_14 + text_pca_15 + text_pca_16 + text_pca_17 + text_pca_18 + text_pca_19 +
  text_pca_20 + text_pca_21 + text_pca_22 + text_pca_23 + text_pca_24 + text_pca_25 +
  text_pca_26 + text_pca_27 + text_pca_28 + text_pca_29 + text_pca_30 +
  text_pca_31 + text_pca_32 + text_pca_33 + text_pca_34 + text_pca_35 +
  text_pca_36 + text_pca_37 + text_pca_38 + text_pca_39 + text_pca_40

## Configurando el fitcontrol
set.seed(308873)  
fitControl <- trainControl( 
  method = "cv",
  number = 8
  ) 

# estableciendo la grilla de busqueda
tuneGrid <- expand.grid(
  alpha = seq(0.1, 1, length.out = 10),  # Más concentrado cerca de 1
  lambda = 10^seq(-2, 1, length.out = 20)  # Escala logarítmica
)

# Entreenando el modelo
ENet_reg <- train(model_form,
            data=train_df,
            method = 'glmnet', 
            trControl = fitControl,
            tuneGrid = tuneGrid, 
            metric = "MAE" 
            #preProcess = c("center", "scale", "nzv")
            )  

# Revisando toda la grilla de resultados 
ENet_reg

# Revisando los mejores parámetros
ENet_reg$bestTune

# Haciendo el gráfico: 
reg_NET_plot <- ggplot(ENet_reg$results,  
       aes(x=lambda, y=MAE, color=factor(alpha))) +
  geom_line() +
  geom_point(size=2, alpha=0.5) +
  scale_color_viridis_d(name="Mixing Percentage (α)",
                        breaks = seq(0, 1, 0.1)) + # Only show multiples of 0.1 in legend
  labs(x="Penalty (λ)", 
       y="Mean Absolute Error",
       title="Elastic Net Performance Across Different Parameter Values") +
  theme_minimal() +
  theme(legend.position="right")

# Exportando el gráfico
ggsave(filename = "../results/figures/Elastic_net_performance.png", 
       plot = reg_NET_plot,                      
       width = 10,                               
       height = 7,                               
       dpi = 300) 

# Haciendo las predicciones
test_df$pred_price <- predict(ENet_reg, newdata = test_df)

# Verificar y eliminar duplicados por property_id (nos quedamos con el primero)
submission <- test_df %>%
  distinct(property_id, .keep_all = TRUE) %>%
  select(property_id, price = pred_price)  # Renombrar la columna a 'price'

# Devolviendo la transformación de millones 
submission$price <- submission$price * 1e6 

# La variable tiene algunos valores negativos, por lo que se imputan con la mediana
median_pos <- median(submission$price[submission$price >= 0], na.rm = TRUE)
submission$price[submission$price < 0] <- median_pos

# Guardar resultados
write_csv(submission, "../results/predictions/ElasticNet_regression_aph0_9_lamb1.csv")


 








