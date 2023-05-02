#En esta lección aprenderemos como utilizar algunas herramientas del paquete dlookr

#dlookr es util para:
#Diagnósticar detalles de las tablas de forma rápida: diagnose(), diagnose_numeric(), diagnose_category()
#Realizar analisis exploratorios rápidos: describe()
#Aplicar test de normalidad y obtener la correlación de las variables: normality(), correlate()
#Gráficar la correlación y la normalidad: plot_correlate(), plot_normality()
#Conocer valores nulos y outliers: imputate_na(), imputate_outlier ()
#Despúes de imputar, podemos ver resumenes y graficar con: summary() y plot()


#Primero llamamos a la libreria
library(dlookr)
library(tidyverse)

#Ahora abriremos un archivo de prueba
fifa <- read.csv("fifa_dplyr.csv", encoding = "UTF-8")
fifa

#---------------DIAGNOSTICO GENERAL DE LOS DATOS------------------

####-------Funcion diagnose()

#La funcion diagnose() te permite ver un resumen de los datos y el tipo de variable
#Es muy util porque resalta la existencia de "missing values"
diagnose(fifa)
diagnose(storms)

#Si queremos visualizar solo las caracteristicas de algunas variables, podemos hacerlo de esta forma:

#Seleccionando las columnas por nombre
diagnose(fifa, age, height_cm, weight_kg)
fifa %>% diagnose(age, height_cm, weight_kg)

#Seleccionandolas por un rango utilizando los dos puntos ":"
fifa %>% diagnose(short_name:weight_kg)

#Tambien eliminando selecciones especificas con el signo de menos "-"
diagnose(fifa, -(short_name:weight_kg))

#Esta funcion es similar a diagnose(), pero ofrece informacion mas completa de variables numericas
#como minimos y maximos, media, mediana entre otras
diagnose_numeric(fifa, age, overall)
diagnose_numeric(storms)

# zero, minus, and outlier son medidas útiles para diagnosticar la integridad de los datos. 
#Por ejemplo, los datos numéricos en algunos casos no pueden tener cero o números negativos

####-------Funcion diagnose_category()

#Esta funcion se aplica igual a la anterior, pero para variables categoricas, como las que son
#formadas por texto

diagnose_category(fifa)
diagnose_category(fifa, nationality)

#Podemos ver las variables, los niveles, el numero de observaciones, la frecuencia (veces que se repite),
#el ratio (cuanto representa del total) y el rango de importancia

####-------Funcion diagnose_outlier()

#Esta funcion permite diagnosticar los valores atipicos de la tabla 

diagnose_outlier(fifa, age) 
#Podemos ver el numero de outliers, el porcentaje o ratio, la media de los outliers

#Las variables numéricas que contengan valores atípicos se encuentran fácilmente con filter() de DPLYR
diagnose_outlier(fifa) %>% filter(outliers_cnt > 0)

#Para graficar los outliers utilizamos la funcion plot_outlier()
#Estos graficos pueden ser utiles para decidir, si debemos eliminar los valores atipicos

solo_numeros <- select(fifa, age, weight_kg, height_cm)
solo_numeros
diagnose_outlier(solo_numeros)

solo_numeros %>%
  plot_outlier(diagnose_outlier(solo_numeros) %>%
                 filter(outliers_ratio >= 0.5) %>%
                 select(variables) %>%
                 unlist())



#---------------EDA ANALISIS EXPLORATORIO DE LOS DATOS------------------

library(ISLR)
str(Carseats)

#Como sucede con los datos de diagnostico, lo primero que haremos es ver
#una descripcion general de la tabla de datos con la funcion describe()
describe(carseats)
describe(fifa)

#La funcion describe() puede ser utilizada en conjunto con group_by() de DPLYR
#Esto lo que hace es ofrecernos un resumen de esa variable(s) para analizar sus valores
#de forma individual
Carseats %>% group_by(US) %>% describe(Sales, Income)
fifa %>% group_by(nationality) %>% describe(weight_kg) %>% filter(nationality == "Argentina")

####Normalidad y correlación

#Podemos aplicar un test de normalidad con la funcion normality() 
#Una distribucion "Normal" Se caracteriza por ser simétrica alrededor de la media 
#y porque la media y la mediana coinciden. Su gran ventaja 
#es que permite calcular probabilidades de aparición de datos y, de ese modo, 
#poder inferir datos de la población a partir de los obtenidos de la muestra
normality(Carseats)
normality(fifa)

#Tambien podemos graficar la "normalidad" para saber como se comportan los datos
plot_normality(Carseats, Sales, CompPrice)
plot_normality(fifa, weight_kg)
plot_normality(fifa, weight_kg, height_cm)

#Tambien podemos calcular el Coeficiente de Correlacion con la funcion correlate() 
correlate(carseats)
correlate(fifa)

#Para poder ver la correlacion de dos variables, podemos utilizar filter() de DPLYR
carseats %>% correlate(Sales:Income) %>% filter(as.integer(var1) > as.integer(var2))
fifa %>% correlate(weight_kg:height_cm) %>% filter(as.integer(var1) > as.integer(var2))

#Para visualizar la correlacion podemos utilizar la funcion plot_correlate()
plot_correlate(carseats)
plot_correlate(solo_numeros)
plot_correlate(fifa)

#Podemos ver la correlacion solo de un grupo de variables 
plot_correlate(Carseats, Sales, Price)
plot_correlate(fifa, weight_kg, height_cm)

#---------------------------VALORES NULOS Y OUTLIERS---------------------------

#La libreria dlookr, tiene una funcion para imputar valores nulos que es imputate_na()

#Primero se define una nueva variable y se aplica la funcion impute_na()
income <- imputate_na(Carseats, Income, US, method = "rpart")
income
#Lo que hace la funcion, es eliminar los valores nulos de esa nueva variable

#Ahora podemos utilizar la funcion summary() para ver los datos, antes y despues de la imputacion
summary(income)

#Podemos graficar con la funcion plot() y determinar, como han cambiado los datos antes y despues
plot(income)

#Otra funcion de dlookr, es imputar valores atipicos con imputate_outlier()
#Primero se define una nueva variable y se aplica la funcion imputate_outlier()
price <- imputate_outlier(Carseats, Price, method = "capping")
na_storms <- imputate_outlier(storms, tropicalstorm_force_diameter, method = "capping")
na_storms
#Lo que hace la funcion, es eliminar los valores atipicos de esa nueva variable

#Ahora podemos utilizar la funcion summary() para ver los datos, antes y despues de eliminar outliers
summary(price)
summary(na_storms)

#Podemos graficar con la funcion plot() y determinar, como han cambiado los datos antes y despues
plot(price)
plot(na_storms)

#--------------AGRUPAMIENTO (BINNING) VARIABLES NUMERICAS A CATEGORICAS-----------------

#La funcion binning()transforma una variable numérica en una variable categórica dividiéndola en intervalos
#El metodo utilizado por defecto en la funcion, es la division en cuantiles (10 partes)

#Para aplicar la funcion debemos crear una nueva variable y asignar la funcion binning()
bin <- binning(Carseats$Income)
bin

intensidad <- binning(storms$wind)
intensidad

#Para comprobar como ha sido el resultado de la funcion podemos utilizar summary()
summary(bin)
summary(intensidad)

#Finalmente podemos graficar el resultado de variable, para concoer su comportamiento
plot(bin)
plot(intensidad)

