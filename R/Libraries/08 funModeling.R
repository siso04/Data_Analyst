#En esta lección, presentaremos la forma de hacer un Exploratory Data Analysis
#utilizando principalmente herramientas de la biblioteca "funModeling"

#Fuente: https://livebook.datascienceheroes.com/exploratory-data-analysis.html

library(tidyverse)
library(data.table)
library(funModeling)
library(Hmisc)
library(skimr)
library(psych)

#Datos

fifa <- fread("fifa_dplyr.csv", encoding = "UTF-8")
fifa
str(fifa)

# Podemos hacer un EDA rápido utilizando una función
basic_eda <- function(fifa)
{
  glimpse(fifa)
  print(status(fifa))
  freq(fifa) 
  print(profiling_num(fifa))
  plot_num(fifa)
  describe(fifa)
}

basic_eda(fifa)

mexico <- fifa %>% filter(nationality == "Mexico")
mexico

profiling_num(mexico) #funmodeling
plot_num(mexico) #funmodeling
freq(mexico$height_cm) #funmodeling
describe(mexico) #Hmisc
skim_without_charts(mexico)
status(mexico) #funmodeling
describe(mexico)

freq(mexico$league_name) %>% arrange()


#Utilizaremos los datos de "heart_disease" del paquete "funModeling"

data = heart_disease %>% select(age, max_heart_rate, thal, has_heart_disease)
data

str(data)
glimpse(data)
skim_without_charts(data)
skim(data)

# Obtener las métricas sobre tipos de datos, ceros, números infinitos 
# y valores faltantes con status() de funModeling()
status(heart_disease)
status(data)
status(fifa)

data_integrity(fifa)
data_integrity(mexico)

#Tips

#¿Están todas las variables en el tipo de datos correcto?
#¿Hay muchas variables con muchos ceros o NA?
#¿Alguna variable de alta cardinalidad?

####------------Analizar variables categóricas---------------------####

# La función de frecuencia "freq()" de funModeling se ejecuta automáticamente 
# para todas las variables de factor o carácter
freq(data)
freq(fifa)
freq(mexico$weight_kg)

#Si freq recibe una variable "freq(data$variable)" devuelve una tabla y un gráfico
#Útil para tratar variables de alta cardinalidad (como el código postal)
freq(fifa$height_cm)
freq(fifa$league_name)

#Pare exportar gráficos: freq(data, path_out = ".")

####------------Analizar variables númericas---------------------####

#Gráficos

#Las funciones plot_num y profiling_num de funModeling
#Ejecutan gráficos automáticamente para todas las variables numéricas/enteras

plot_num(data)
plot_num(fifa)

#Para exportar a jpeg: plot_num(data, path_out = ".")

#Tablas

#profiling_num de "funModeling"se ejecuta automáticamente para todas las variables numéricas/enteras
#Ofrece un resumen de las variables y algunos estadísticos
profiling_num(data)
profiling_num(fifa)

####------------Analizar variables númericas y categoricas al mismo tiempo---------------------####

library(Hmisc)

#La función "describe" de la biblioteca "Hmisc" ofrece un resumen con datos de todas las variables
# n  missing distinct     Info     Mean      Gmd      .05      .10      .25      .50      .75      .90      .95 
# valores lowest y highest
describe(data)
describe(fifa)

####------------Correlación de variables---------------------####

# La función correlation_table recupera la métrica R para todas las variables numéricas 
#omitiendo las categóricas/nominales
#correlation_table(data=heart_disease, target="has_heart_disease")
# El nombre de la variable target va en comillas

correlation_table(fifa, "height_cm")

####------------Detectar outliers---------------------####

#Ambas funciones recuperan un vector de dos valores que indica los umbrales para los cuales los valores se consideran atípicos
#tukey_outlier y hampel_outlier

tukey_outlier(fifa$height_cm)
hampel_outlier(fifa$weight_kg)


