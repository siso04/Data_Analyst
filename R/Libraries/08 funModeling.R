#En esta lecci�n, presentaremos la forma de hacer un Exploratory Data Analysis
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

# Podemos hacer un EDA r�pido utilizando una funci�n
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

# Obtener las m�tricas sobre tipos de datos, ceros, n�meros infinitos 
# y valores faltantes con status() de funModeling()
status(heart_disease)
status(data)
status(fifa)

data_integrity(fifa)
data_integrity(mexico)

#Tips

#�Est�n todas las variables en el tipo de datos correcto?
#�Hay muchas variables con muchos ceros o NA?
#�Alguna variable de alta cardinalidad?

####------------Analizar variables categ�ricas---------------------####

# La funci�n de frecuencia "freq()" de funModeling se ejecuta autom�ticamente 
# para todas las variables de factor o car�cter
freq(data)
freq(fifa)
freq(mexico$weight_kg)

#Si freq recibe una variable "freq(data$variable)" devuelve una tabla y un gr�fico
#�til para tratar variables de alta cardinalidad (como el c�digo postal)
freq(fifa$height_cm)
freq(fifa$league_name)

#Pare exportar gr�ficos: freq(data, path_out = ".")

####------------Analizar variables n�mericas---------------------####

#Gr�ficos

#Las funciones plot_num y profiling_num de funModeling
#Ejecutan gr�ficos autom�ticamente para todas las variables num�ricas/enteras

plot_num(data)
plot_num(fifa)

#Para exportar a jpeg: plot_num(data, path_out = ".")

#Tablas

#profiling_num de "funModeling"se ejecuta autom�ticamente para todas las variables num�ricas/enteras
#Ofrece un resumen de las variables y algunos estad�sticos
profiling_num(data)
profiling_num(fifa)

####------------Analizar variables n�mericas y categoricas al mismo tiempo---------------------####

library(Hmisc)

#La funci�n "describe" de la biblioteca "Hmisc" ofrece un resumen con datos de todas las variables
# n  missing distinct     Info     Mean      Gmd      .05      .10      .25      .50      .75      .90      .95 
# valores lowest y highest
describe(data)
describe(fifa)

####------------Correlaci�n de variables---------------------####

# La funci�n correlation_table recupera la m�trica R para todas las variables num�ricas 
#omitiendo las categ�ricas/nominales
#correlation_table(data=heart_disease, target="has_heart_disease")
# El nombre de la variable target va en comillas

correlation_table(fifa, "height_cm")

####------------Detectar outliers---------------------####

#Ambas funciones recuperan un vector de dos valores que indica los umbrales para los cuales los valores se consideran at�picos
#tukey_outlier y hampel_outlier

tukey_outlier(fifa$height_cm)
hampel_outlier(fifa$weight_kg)


