#El paquete data.table es una alternativa a dplyr, puede ser eficiente manejando grandes 
#volumenes de datos, pero su sintaxis no es tan intuitiva

library(data.table)


##-----------Importar y exportar datos-------------------##

#El package data.table tiene sus propias funciones para importar y exportar datos. 
#Las funciones son 
#fread() para leer y 
#fwrite() para guardar las tablas 

#Aquí tenemos los argumentos más importantes de estas funciones:
  
# x: el objeto que queremos exportar. En caso de importar, esto no hace falta.
# file: el lugar donde queremos guardar el archivo y su extensión.
# sep: el delimitador entre columnas. En un archivo csv por lo general es ","
# dec: el separador decimal.
# dateTimeAs: formato en el que guardar objetos de fecha. Por defecto es "ISO".

fifa <- fread("fifa_dplyr.csv", encoding = "UTF-8")
str(fifa)

##-----------Sintaxis base-------------------##

#Esta es la base para manejarnos con una data.table: DT[ i , j , by ]. 
#Tiene cuatro partes que hemos llamado DT, i, j y by:

# DT: corresponde al nombre de nuestra tabla de datos  
# i: corresponde a las filas/registros con las que queremos trabajar.
# j: corresponde a las columnas y la usaremos para hacer cálculos y resúmenes, seleccionar variables y crear nuevas variables.
# by: corresponde a las agrupaciones que queremos hacer.

#DT[ i , j , by ]

##-----------¿Como trabajar con las filas i?---------------##

#La parte "i" de la función, se utiliza para seleccionar filas

#Selecciona las primeras 10 filas, con las columnas de la uno a la cinco
fifa[1:10, 1:5]
fifa[1:20, 2:6]

#Tambien podemos hacer selecciones condicionales, como con filter() de dplyr
#Primero definimos el filtro, y luego seleccionamos el numero de filas que queremos ver
fifa[nationality == "Argentina" | nationality == "Brazil"] [1:10]
fifa[nationality == "Argentina" & overall >= 85] [1:10]

##-----------¿Como trabajar con las columnas j?---------------##

#La parte j se usa para seleccionar columnas, crear nuevas variables y aplicar funciones sobre ellas ellas.

#1. Operaciones y resumenes de variales

#Calcular la media del overall, en los primeros 50 registros
fifa[1:50, mean(overall)]
fifa[1:50, sd(overall)]

#Ver un resumen rapido de la columna, similar a la funcion count()
fifa[, table(league_name)]
fifa[, table(player_positions)]

#2.Seleccionar varias columnas .()

#Si queremos seleccionar varias columnas en la parte j debemos usar el verbo .()
fifa[1:50, .(mean(overall), mean(age))]

# data.table permite agregar alias de manera sencilla
fifa[1:50, .(media_overall = mean(overall), media_edad = mean(age))]

#3. Seleccionar columnas por numero o nombre (para seleccionar por nombre hay que utilizar ".()")

#Seleccionar las columnas desde la 1 hasta la 7
fifa[1:20, 1:7]

#Seleccionar las columnas short_name, age, dob and weight_kg con ".()"
fifa[1:20, .(short_name, age, dob, weight_kg)]
fifa[1:10, .(age, dob, overall)]

#4. Crear variables como mutate() de dplyr

#Mediante ":=" podemos crear nuevas columnas
#La nueva columna aparecera al final
fifa[, pesoporaltura := weight_kg*height_cm] [1:10]

#Podemos crear varias variables en una sola linea de codigo, pero debemos usar este simbolo `:=` para hacerlo
fifa[, `:=` (pesoporedad = age*weight_kg, edadporaltura = age*height_cm)] [1:10]

#Utilizando un vector "c" seria de esta forma 
IRIS[, c("sepal_area", "petal_area") := .(Sepal.Length*Sepal.Width, Petal.Length*Petal.Width)][1:3]

##-----------¿Como trabajar con las agrupaciones de by?---------------##

#Se trata de aplicar un doble filtro, el "by" actua como una nueva condicion
fifa[, .(mean(overall)), by=nationality] [1:10]
fifa[, .(mean(weight_kg)), by=nationality] [1:10]

##-----------Otras funciones utiles---------------##

# .N 
# .N en i (fila) nos da la última fila. En j (columna) el número de filas en un grupo.

fifa[.N, 1:5]
fifa[1:20, .N]
fifa[ , .N , nationality]

# .I 
# .I en j (columna) nos da un vector con los números de fila de los datoS en la tabla (filtrados por i )
# Esta funcion es util, para determinar la ubicacion de un registro (indice) con una condicion especifica

var1 <- fifa[, .I[nationality == "Argentina"]]
var1

# .SD
# .SD en j (columna) nos trabaja sobre el subgrupo de datos seleccionados en by.
fifa[, .SD[1], nationality]  ## primera fila de cada grupoIRIS
fifa[, .SD[.N], nationality] ## última fila de cada grupo

# .GRP
# .GRP en j (columna) nos da la indexación de los grupos que tenemos.
fifa[, i := .GRP, by = league_name]
fifa

#####---------------------------------------------------------------------------------------------------

#Ejercicios

library(nycflights13)
flights

#Lo primero que debemos hacer es convertir la tabla a formato data.table()

vuelos = as.data.table(flights)
vuelos

vuelos[1:10, 1:6]
vuelos[carrier == "AA" | carrier == "DL"]
vuelos[carrier == "AA" | carrier == "DL"]

##-----------Concatenar---------------##

# En data.table podemos concatenar acciones con diferentes [] seguidos
(DT <- data.table(V1=c(1L,2L), V2=LETTERS[1:3],  V3=round(rnorm(4),4),V4=1:12))

DT[,V4.cumsum:=cumsum(V4)] [order(-V3)] [V4<6]

##-----------Joins---------------##

# Se puede usar sintaxis data.table (DT) o la función merge()

# INNER: en DT = X[Y, nomatch=0].        En merge() = merge(X, Y, all=FALSE)
# LEFT OUTER: en DT = Y[X].              En merge() = merge(X, Y, all.x=TRUE)
# RIGHT OUTER: en DT = X[Y].             En merge() = merge(X, Y, all.y=TRUE)
# FULL OUTER: en DT no se puede.         En merge() = merge(X, Y, all=TRUE)

##-----------Funciones set()---------##

# 1. Renombrar variables/cambiar nombre con setnames()

setnames(fifa, "short_name", "nombre")
names(fifa)

setnames(fifa, c("nationality", "club_name", "league_name"), c("nacionalidad", "equipo", "liga"))
names(fifa)

# 2. Reordenar como aparecen las columnas con setcolorder()

setcolorder(fifa, c("nombre", "nacionalidad")) #Coloca estas columnas de primero
fifa

# 3. Ordenar con setorder() y setorderv() (es como la funcion arrange() de dplyr)

#3.1 Ordenar por una variable
setorder(fifa, "nacionalidad")
setorder(fifa, "liga")
fifa

#3.2 Ordenar por dos variables
setorderv(fifa, c("nacionalidad", "liga"))
fifa

# 4.Ordenar con setkey() y setkeyv()
#Estas funciones, ordenan de forma "oficial" los datos

setkey(fifa, "nacionalidad")
str(fifa)

setkeyv(fifa, c("nacionalidad", "liga"))
str(fifa)

# 5. Quitar columna/s con := NULL

fifa[, c("player_positions", "pesoporaltura", "long_name") := NULL]
str(fifa)