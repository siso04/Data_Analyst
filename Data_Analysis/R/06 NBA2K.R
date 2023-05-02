# Ejercicio de Análisis de datos con la tabla NBA2K

# Directorio


# Bibliotecas para el analisis
library(tidyverse)
library(forcats)
library(readr)
library(skimr)
library(psych)
library(Hmisc)
library(funModeling)
library(lessR)

# Abrir archivo de datos 
nba2k <- read.csv("nba2020.csv")
nba2k

######################################################################

# 1. Consulta general de los datos
View(nba2k)

# Veamos los nombres de las columnas
nba2k %>% names()
# Tenemos una tabla de 439 filas y 16 columnas
nba2k %>% dim()

nba2k %>% str()
nba2k %>% glimpse()

# La funcion skim_without_charts() es muy util, porque nos indica los tipo de variables
# y su cantidad. En esta tabla tenemos 13 variables de caracter y 3 numericas
nba2k %>% skim_without_charts()

# Otras funciones nos dicen algo similar
nba2k %>% describe()
nba2k %>% describe()
nba2k %>% status()

# El primer problema que podemos observar, es que hay muchas variables que deberian ser numericas
# como jersey, salary, y weight, que aparecen como caracteres.

######################################################################

# 2. Corregir la estructura de la tabla
# Cuando observamos el head y el tail de la tabla, nos damos cuenta que hay dos versiones de datos
# 2020 y 2021, debemos quedarnos solo con los de 2020

unique(nba2k$version)
nba2k %>% head(10)
nba2k %>% tail(10)

# Para corregir este problema utilizaremos filter y sobrescribiremos la tabla
nba2k <- nba2k %>% filter(version == "NBA2k20")
nba2k %>% tail(10)
dim(nba2k)

# Ahora que sabemos que todos los datos son del 2020, podemos sencillamente eliminar la columna "version"
# para ello utilizaremos la funcion select()
nba2k <- nba2k %>% select(-version)
nba2k <- nba2k %>% select(-X.1)
nba2k <- nba2k %>% select(-X)

nba2k %>% names() 

######################################################################

# 3. Corregir los datos de las columnas

# Lo primero que vamos hacer es ver el tipo de dato de cada columna,
# y ver si se corresponde con su contenido
nba2k %>% str()

# Podemos observar que hay columnas numericas, que aparecen como texto (jersey, height, weight, salary)
# Toda esta informacion debe ser corregida
nba2k %>% select(jersey, height, weight, salary) %>% head(10)

# 3.1 Correccion de la columna jersey
# Para corregir esta columna, debemos eliminar el numeral # y convertirla a numero

# Primero, probamos la funcion y luego sobrescribimos la variable
nba2k$jersey %>% str_replace("#", "")
nba2k$jersey <- nba2k$jersey %>% str_replace("#", "")

# Ahora debemos convetir esa variable en numero con la funcion: as.numeric() o as.integer()
nba2k$jersey <- nba2k$jersey %>% as.numeric()

# 3.2 Corregir los datos de la columna b_day
# Los datos de esta columna estan almacenados como caracter, pero es una fecha
unique(nba2k$b_day) %>% head(10)

# Para corregir este problema utilizaremos la funcion as.Date("%m/%d/%y")
# con unos parametros especificos. Debemos sobrescribir la variable original
nba2k$b_day 

nba2k$b_day %>%  as.Date("%m/%d/%y")
nba2k$b_day <- nba2k$b_day %>%  as.Date("%m/%d/%y")
nba2k$b_day %>% class()

# 3.3 Corregir los datos de las columnas height y weight
# Estas dos columnas estan como caracter, y ademas de ello tienen una separacion
# que indica, que se trata de unidades de medida diferentes

nba2k %>% select(height, weight) %>% head(10)

# Primero eliminaremos los separadores con la funcion separate()
# con esto creamos dos columnas nuevas para cada variable
# despues de crear las columnas nuevas, podremos desechar las que no nos interesan, y arreglar 
# solo las necesarias

# Procederemos a separar las columnas y sobreescribir la tabla

nba2k<- nba2k %>% separate(height, into = c('pies', 'metros'), sep = "/") %>% 
  separate(weight, into = c('libras', 'kilos'), sep = "/")

# Ahora vamos a eliminar las columnas libras y pies que no las necesitamos
nba2k<- nba2k %>% select(-libras, -pies)
nba2k %>% names()

# Procedamos a revisar metros y kilos, para saber que debemos arreglar

# La variable metros tiene un espacio en blanco, que debemos eliminar antes de convertirla en numero
# luego debemos sobrescribirla
nba2k$metros %>% head()
nba2k$metros <- nba2k$metros %>% str_replace(" ", "") %>% as.numeric()

# La variable kilos tiene espacios en blanco y caracteres, que debemos eliminar antes 
# de convertirla en numero
nba2k$kilos %>% head()
nba2k$kilos <- nba2k$kilos %>% str_replace(" kg.", "") %>% as.numeric()

# Podemos revisar la estructura de la tabla, y comprobar que los cambios se ejecutaron
nba2k %>% str()

# 3.4  Corregir los datos de la columna salary
# La columna salary, tiene problemas similares a la columna anterior, debemos eliminar
# un simbolo y lugo convertirla en numero

nba2k$salary <- nba2k$salary %>% str_replace("\\$", "") %>% as.numeric()
class(nba2k$salary)

# 3.5 Corregir las columnas draft_round y draft_pick
# Estas dos columnas, debemos transformarlas a numeros, sin embargo, debemos revisar sus valores
# unicos, para comprobar que no hayan textos o elementos que interfieran en esta transformacion

unique(nba2k$draft_round)
unique(nba2k$draft_peak)

# Observamos como las dos columnas tienen un valor de texto que debe ser sustituido o eliminado, 
# para poder convertir estas columnas en numeros
# Como son columnas de texto, podemos utilizar str_replace() y asignar un nuevo valor, que despues
# podamos convertir en un numero

nba2k$draft_round <- nba2k$draft_round %>% str_replace("Undrafted", "3") %>% as.integer()
nba2k$draft_peak <- nba2k$draft_peak %>% str_replace("Undrafted", "0") %>% as.integer()

# Comprobamos la estructura de la tabla, y nos fijamos que cada columna tenga el tipo de dato correcto
nba2k %>% str()

# Ahora vamos a eliminar la columna X que no está sirviendo para nada

nba2k <- nba2k %>% select(-X)
nba2k %>% names

# Vamos a guardar una copia de esta tabla con la funcion write_csv()
# Llamaremos a la nueva tabla: nba2kR 
write.csv(nba2k, "nba2kR.csv")
write.csv(nba2k, "nba2k_clean.csv")

########################################################################

# 4. Trabajar con missing values (NA)

# Primero, vamos a contar cuantos valores nulos hay en nuestra tabla
sum(is.na(nba2k))

# En nuestra tabla no hay valores nulos, sin embargo, en las columnas "team" y "college"
# hay registros que no tienen informacion

# En la columna "team" observamos como hay jugadores sin equipo
unique(nba2k$team)
nba2k %>% filter(team == "") %>% count()

# Mientras que en "college" hay jugadores que no fueron a la universidad
unique(nba2k$college)
nba2k %>% filter(college == "") %>% count()

# Para solucionar este problema, podemos utilizar una sitaxis basica de R con corchetes
# y agregar una condicion a cada tabla
# Lo que vamos hacer es aplicar un filtro, y a ese filtro le asignamos la nueva condicion
# como si fuera una variable con <-

# A los jugadores sin equipo los llamaremos: No_Team
nba2k$team[nba2k$team == ""] <- "No_Team"

# Para los jugadores sin universidad debemos filtrar dos condiciones diferentes
# los que nacieron en Estados Unidos, tendran la condicion: High School
# mientras que los nacidos en el extranjero, tendran la condicion: Studied Abroad
nba2k$college[nba2k$college == "" & nba2k$country == "USA"] <- "High School"
nba2k$college[nba2k$college == "" & nba2k$country != "USA"] <- "Studied Abroad"

# Ahora comprobamos los valores unicos, y vemos como se han agregado las condiciones a cada variable
unique(nba2k$college)
unique(nba2k$team)

# Podemos guardar otra tabla, y esta vez no contendra ningun missing value
write.csv(nba2k, "nba2k_clean.csv")

###############################################################

# 5. Trabajar con variables categoricas

# Veamos cuales son nuestras variables categoricas
nba2k %>% str()
# Tenemos: team, position, country, college y full_name. Esta ultima muy poco util para el analisis

# Supongamos que queremos saber cuantos jugadores tiene cada equipo
nba2k %>% count(team)

# Tambien podemos saber, cuantos jugadores hay de cada pais
nba2k %>% count(country) %>% arrange(desc(n)) %>% head(10)

# ¿Cuales son las universidades que tienen mas jugadores en la NBA?
nba2k %>% count(college) %>% arrange(desc(n)) %>% head(10)

# ¿Cuáles son las posiciones donde hay más jugadores?
nba2k %>% count(position) %>% arrange(desc(n))

# Para que estos resultados sean más fácil de observar, podemos utilizar un grafico
# para hacerlo vamos a incluir a las bibliotecas lessR y Forcats
library(lessR)
library(forcats)

BarChart(data = nba2k, position, sort="-", xlab = "Position", ylab = "Count")
ggplot(nba2k, aes(x = fct_infreq(position))) + 
  geom_bar(fill = "lightsteelblue4") +
  labs(x="Position", y="Count")

###################################################

# 6. Analisis de variables numericas

# Veamos cuales son los jugadores con el salario mas alto utilizando arrange()
nba2k %>% select(-c(draft_year:college)) %>%  arrange(desc(salary)) %>% head(10)

# Si queremos analizar medidas de tendencia central de variables especificas
# podemos seleccionarlas, y luego pasarle funciones como: skim_without_charts() y describe()
nba2k %>% select(metros, kilos, salary)%>% skim_without_charts()
nba2k %>% select(metros, kilos, salary)%>% describe()
nba2k %>% select(metros, kilos, salary)%>% describe.by()

# Tambien podemos graficar variables numericas
BarChart(data = nba2k, metros, sort = "-", xlab = "Metros", ylab = "Count")
Histogram(data = nba2k, metros, density = TRUE)

###################################################

# 7. Trabajar con agrupaciones

# Para crear una agrupacion, utilizamos la funcion group_by y seleccionamos una variables
posiciones <- nba2k %>% group_by(position)
posiciones 

# Al utilizar group_by junto con summarise y otras herramientas de dplyr
# los calculos se realizan, en base a la variable de agrupacion

# Por ejemplo podemos calcular la media de kilos y metros, por cada posicion
posiciones %>% summarise(
  metros = mean(metros),
  kilos = mean(kilos)) %>% 
  arrange((kilos))

# Tambien podemos filtrar por los jugadores mas pesados de cada posicion y tener un grupo de gordos
posiciones %>% filter(kilos == max(kilos))%>% arrange(desc(kilos))

# Por ejemplo, podriamos obtener a los 12 jugadores con el mayor rating, y hacer el mejor equipo de la NBA
posiciones %>% filter(rating >= 90) %>% arrange(desc(rating)) %>% head(12)
posiciones %>% filter(rating == max(rating)) %>% arrange(desc(rating)) %>% head(12)

######################################################

# 8. Trabajar con graficos

nba2k <- read.csv("nba2k_clean.csv")
nba2k <- nba2k %>% select(-X)
nba2k  

# Como escribir el codigo del grafico
# ggplot(tabla, aes(variable1, variable2)) + geom_point()

# Podemos realizar analisis sencillos y rapidos a través de graficos
nba2k %>% names()

# Ver la relacion entre el rating y la altura
ggplot(nba2k, aes(rating, metros)) + geom_point(color = "red") + 
  labs(title = "Relacion entre el rating y la altura")                                                            

# Como se distribuye la altura de todos los jugadores
ggplot(nba2k, aes(metros)) + geom_histogram(fill = "red", bins = 8, alpha = 0.3)

# Como se distribuye el peso
ggplot(nba2k, aes(kilos)) + geom_histogram(fill = "blue", alpha = 0.3, bins = 8)

# Como se distribuyen los jugadores por posicion
ggplot(nba2k, aes(x = fct_infreq(position))) + geom_bar(fill = "red", alpha = 0.8) 
ggplot(nba2k, aes(x = fct_infreq(position))) + geom_bar(fill = "red", alpha = 0.8) + coord_flip() +
  labs(xlab("Conteo"), ylab("Posicion"))
BarChart(data = nba2k, position, horiz = TRUE, sort = "-", fill = "gray", values_color = "black", 
         values_size = 1.2)

library(funModeling)
plot_num(nba2k)

library(dlookr)
plot_correlate(nba2k)

#############################################################

# 9. Biblioteca data.table

library(data.table)

nba2k <- fread("nba2k_clean.csv")
nba2k <- nba2k %>% select(-V1)
nba2k %>% names()

# Esta es la base para manejarnos con una data.table: DT[ i , j , by ]. 
# DT[ i , j , by ]
# tabla[ filas , columnas , by ]

# Seleccion de filas y columnas
nba2k[1:10, 1:5]
nba2k[1:20, .(full_name, rating, team, position)]
nba2k[team == "Brooklyn Nets" & rating >= 80]
nba2k[1:20, mean(rating)]
nba2k[1:20, median(metros)]
nba2k[1:50, .(mean(rating), mean(metros))]
nba2k[, table(college)]

# Agrupaciones Argumento by=

# Agrupar a los equipos, y calcular el rating promedio de cada uno
nba2k[, .(rating_promedio = median(rating)), by=team] %>% arrange(desc(rating_promedio)) %>% head(10)

# Selecciones con .N
# .N en i (fila) nos da la última fila. En j (columna) el número de filas en un grupo.
nba2k[.N, 1:5]
nba2k[, .N, team] 
nba2k[, .N, college] %>% arrange(desc(N)) %>% head(10)

# Reordenar columnas
setcolorder(nba2k, c("full_name", "rating", "metros", "kilos"))
nba2k

############################################################################

# 10. Utilizacion del paquete dlookr
library(dlookr)

nba2k <- read.csv("nba2k_clean.csv")
nba2k <- nba2k %>% select(-X.1, -X)
nba2k %>% head(10)

# Funcion describe()
describe(nba2k)

# Utilizar describe con group_by(), para ver los datos de una sola variable por elemento de grupo
nba2k %>% group_by(team) %>% describe(metros) %>% print(n = 32)

# Funcion diagnose() permite ver los missing values
diagnose(nba2k)
nba2k %>% diagnose(rating, jersey, team, position)

# Diagnosticar valores numericos y variables categoricas
nba2k %>% diagnose_numeric()
nba2k %>% diagnose_category(college)
nba2k %>% diagnose_category(position)

# Diagnosticar valores atipicos - Contar cuantos hay en cada columna de la tabla
diagnose_outlier(nba2k)
diagnose_outlier(nba2k) %>% filter(outliers_cnt > 0)

# Graficar valores atipicos con plot_outlier()
nba2k %>%
  plot_outlier(diagnose_outlier(nba2k) %>%
                 filter(outliers_ratio >= 0.5) %>%
                 select(variables) %>% # La lista se hace con todas las variables
                 unlist())

# Imputar valores atipicos y valores nulos
# Utilizando estas funciones, podemos conocer los indices de los valores atipicos y nulos

# Determinar los valores nulos de una variable
nba2k %>% imputate_na(metros)

# Determinar los valores atipicos
nba2k %>% imputate_outlier(kilos)
nba2k %>% imputate_outlier(salary)

# Si vemos el apartado: attr(,"outlier_pos"). Nos indica el indice de los outlier
# que podemos buscar con una seleccion simple de corchetes
nba2k[c(62,73,228),]
nba2k[c(1,2,4,5,6,8,9,10,11),] %>% select(full_name:salary)

# Tambien podemos crear variables de valores atipicos imputados
salario <- nba2k %>% imputate_outlier(salary, method = "capping")
kilos <- nba2k %>% imputate_outlier(kilos, method = "capping")

# Posteriormente podemos utilizar summary() para comprobar como se comportan los datos
# con o sin outliers
summary(salario)
summary(kilos)

# Podemos graficar con la función plot() y determinar, cómo han cambiado los datos antes y después de la imputación
plot(salario)
plot(kilos)

# Agrupamiento (binning) convertir variables numéricas a categorías
# Esta funcion crea rangos automaticos, y subdivide una variable numerica
metros <- binning(nba2k$metros)
metros

# Test de normalidad y correlación con dlookr - Graficar normalidad y correlación
normality(nba2k)
nba2k

# Podemos calcular y graficar la correlacion
correlate(nba2k)
plot_correlate(nba2k)

##########################################################################

# 11. Utilizacion de la biblioteca lessR
library(lessR)
nba2k <- read.csv("nba2k_clean.csv")

# La sintaxis para seleccionar filas y columnas con lessR es similar a data.table: tabla[.(rows), .(columns)]

# Selecciones por condicionales y nombre de columna
nba2k[.(team == "Boston Celtics"), .(full_name, salary, rating, position)]
nba2k[.(college == "High School"), .(full_name:metros)]

# Selecciones por indice: numero de fila y columna. En este caso, no se ponen los parentesis, ni el punto.
nba2k[1:5, 1:6]
nba2k[5:15, 3:7]

# Pueden utilizarse las dos condiciones
nba2k[1:20, .(full_name:metros)]
nba2k[.(college == "High School"), 1:5]

# Selecciones aleatorias con random(): tabla[.(random(numero)), .(columnas)]
nba2k[.(random(10)), 2:8]

# También podemos definir un porcentaje de filas del total de la tabla, utilizando números desde 0.01 hasta 1
nba2k[.(random(0.2)), 1:5]

# Ordenar las filas con la funcion Sort()
# Para el orden ascendente o descendente debe utilizarse: direction = +/-

# Podemos ordenar toda la tabla en base a una variable
nba2k %>% Sort(salary, direction = "-") %>% head(10)

# Tambien podemos hacer selecciones y luego ordenar por una variable, como en dplyr
nba2k[.(team == "Philadelphia 76ers"), .(full_name, salary, rating, position)] %>% 
  Sort(rating, direction = "-")

# Cambiar el nombre de las columnas con la funcion rename()
# Al cambiar el nombre, no son necesarias las comillas
nba2k %>% names()
nba2k %>% rename(b_day, nacimiento)

# Funcion pivot() - Tablas dinamicas

# En las tablas dinamicas el argumento "compute" es obligatorio
pivot(data = nba2k, compute = mean, metros, by=c(team))

# Si queremos varias estadisticos, debemos utilizar un vector c
pivot(data = nba2k, c(mean,sd,skew,kurtosis), metros, by=c(team))

# Podemos agrupar por varios estadisticos
pivot(data = nba2k, c(mean,sd,skew,kurtosis), metros, by=c(team, college))

# Utilizar tablas de frecuencia
# Para realizar una tabla de frecuencia, debemos colocarle a pìvot(), el argumento "table"
pivot(nba2k, table, metros)
pivot(nba2k, table, salary) %>% Sort(Freq, direction = "-") %>% head(20)

# División de los datos en cuartiles
nba2k %>% pivot(quantile, metros)
nba2k %>% pivot(quantile, kilos)
pivot(nba2k, quantile, kilos, c(team, country))

# Si queremos dividir de acuerdo a otros valores que no sean cuartiles, 
# o cuatro partes debemos utilizar el argumento "q_num ="
nba2k %>% pivot(quantile, metros, q_num = 5, digits_d = 2)

# Ordenar los datos de la función pivot()
pivot(nba2k, max, metros, c(team), sort = "-")

# Tablas de dos dimensiones, argumento "by_cols"
# Evaluar todos los valores de la tabla en base a dos condiciones
pivot(nba2k, mean, metros, kilos, by_cols = team)

########################################################

# 12. Bibliotecas para Análisis Exploratorio Automático

# Biblioteca DataExplorer
install.packages("DataExplorer")
library(DataExplorer)

# Grafico de conexion entre tablas y variables
plot_str(nba2k)
plot_str(nba2k, type = "r")

# Informacion general de la tabla (columnas, tipo y valores nulos)
introduce(nba2k)
plot_intro(nba2k)
plot_missing(nba2k)
plot_bar(nba2k)
plot_bar(nba2k$team)
plot_histogram(nba2k)
plot_qq(nba2k)
plot_boxplot(nba2k, by = "rating")
plot_scatterplot(nba2k, by = "metros", sampled_rows = 100L)

# Correlacion
plot_correlation(na.omit(nba2k), maxcat = 5L)

# Componenetes principales
plot_prcomp(nba2k, variance_cap = 0.9, nrow = 2L, ncol = 2L)

# Crear un reporte completo de los datos en formato HTML
create_report(nba2k)

install.packages("SmartEDA")
library(SmartEDA)

# Función que genera un informe completo
ExpReport(nba2k,op_file='informeEDA.html')

# Resumen de los datos
ExpData(data=nba2k,type=1)
ExpData(data=nba2k,type=2)

# Variables categoricas
ExpCTable(nba2k,Target=NULL,margin=1,clim=10,nlim=3,round=2,bin=NULL,per=T)


# Resumen con algunos estadisticos
ExpData(data=nba2k,type=2, fun = c("mean", "median", "var"))

# Una tabla resumen con multitud de estadísticos de las variables numéricas
ExpNumStat(nba2k,by="A",gp=NULL,Qnt=seq(0,1,0.1),MesofShape=2,Outlier=TRUE,round=2)
ExpNumStat(nba2k,by="A",gp=NULL,round=2)

# Distribucion de variables numericas y categoricas
ExpNumViz(nba2k,target=NULL,nlim=10,Page=c(2,2),sample=4)
ExpCatViz(nba2k,target=NULL,col ="slateblue4",clim=10,margin=2,Page = c(2,2),sample=2)

