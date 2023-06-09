#Organizar los datos, se dice tidy data, y se refiere arreglar problemas de formato
#o representaci�n de los datos en las tablas

#Para ello se utiliza la libreria tidyverse
library(tidyverse)

#Existen muchas formas de organizar los datos en forma tabular, como veremos a continuaci�n

table1
table2
table3
table4a
table4b

#Muchos registros de estas tablas, tienen errores que debe ser corregidos, para poder representar
#los datos de forma correcta
#Los datos deben estar arreglados para facilitar los an�lisis con R

#Las 3 reglas b�sicas de la tidy data son las siguientes

#1. Cada variable/campo debe tener su propia columna.
#2. Cada fila/observaci�n/registro debe tener su propia fila.
#3. Cada valor/dato debe tener su propia celda.

#########################################

#Veamos algunos ejemplos de la table1 que es la �nica arreglada
table1
names(table1)
unique(table1$country)

table1 %>% select(country, population)
table1 %>% arrange(desc(population))
table1 %>% mutate(rate = cases / population * 10000)
table1 %>% count(year, wt = cases)
table1 %>% count(country, wt = population)

ggplot(table1, aes(country, population)) + geom_point(color = "red")
ggplot(table1, aes(cases)) + geom_bar()
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "red") + 
  geom_point(aes(colour = country))

####-----------------Pivoting (tabla din�mica)--------------####

#Por naturaleza, la mayor�a de los datos siempre vendr�n desordenados, por eso debes hacer 3 cosas:

#1. El primer paso siempre es averiguar cu�les son las variables/columna y las observaciones/filas.
#2. Resolver si: Una variable puede estar distribuida en varias columnas.
#3. Resolver si: Una observaci�n puede estar dispersa en varias filas.

#Para resolver estos problemas, se utilizan dos funciones: pivot_longer() y pivot_wider()

##----------pivot_longer()-------------##

#Un problema com�n es un conjunto de datos donde algunos de los nombres de las columnas
#no son nombres de variables, sino valores de una variable.

#En la table4a los a�os 1999 y 2000 son datos, pero aparecen como nombres de columnas,
table4a 
#En este caso 1999 y 2000 deber�an pertenecer a su propia columna de a�os

#pivot_longer() lo que hace es crear una tabla nueva, con variables que nosotros definamos, 
#y asignando los valores que nosotros queramos. Esta funcion hace las tablas m�s largas (verticalmente)

table4a %>% 
  pivot_longer(c("1999", "2000"), names_to = "year", values_to = "cases")


#El primer elemento de la funci�n es la tabla de datos: table4a
#Segundo es el llamado a la funci�n: pivot_longer()
#Tercero, se crea un  vector "c", que contiene los nombres de las columnas: "1999", "2000" (los nombres de las columnas se almacenan como texto)
#Cuarto, se le asigna un nombre a la nueva columna con el argumento:  "names_to =", esta variable
#contendra el nombre de la columna (la etiqueta), pero no los datos
#Quinto: se crea una nueva variable "cases", con el argumento "values_to =" a la cual, 
#se le asignar�n los valores que ten�an antes "1999" y "2000"

#Podemos aplicar el mismo principio para la table4b
table4b

table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

#Si queremos, podemos unir las dos tablas utilizando dplyr::left_join()
#Creamos dos nuevas variables con las tablas arregladas, y despu�s aplicamos "left join"

tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")
left_join(tidy4a, tidy4b)

##----------pivot_wider()-------------##

#pivot_wider() es lo opuesto a pivot_longer() dado que ensancha la tabla horizontalmente
#Se utiliza, cuando una observaci�n est� dispersa en varias filas.

#Por ejemplo, la table2: una observaci�n es un pa�s con un "year", pero cada observaci�n se distribuye en dos filas
#Tambien observamos como "cases" y "population" son dos variables, que est�n como filas/observaciones
table2

#En este caso, vamos a convertir esas filas de "cases" y "population" en columnas, y las sacaremos
#de la columna original que se llama "type" y sacaremos el valor de la columna "count". Al hacer esto 
#la variable "year" no va a repetirse, porque habr�n solo dos observaciones por cada pa�s

table2 %>%
  pivot_wider(names_from = type, values_from = count)
#Extrae los nombres de las nuevas columnas de "type" y los valores de la columna "count"
#"cases" y "population" pasan a ser columnas, y "year" solo aparece una vez cada a�o

#Primero seleccionamos la tabla: table2
#Segundo, aplicamos la funci�n: pivot_wider()
#Tercero, debemos sacar los nombres de las nuevas columnas, de una que ya existe con "names_from ="
#Cuarto, debemos extraer los valores de una columna que ya existe con "values_from ="

####-----------------Separando y uniendo--------------####

##----------separate()-------------##

#En algunos casos, los datos originales estar�n representados en una sola columna,
#y separados por alg�n s�mbolo como: - / * u otro.
#En ese caso, debemos "separar" los datos, para que cada uno tenga su propia columna

#separate() separa una columna en varias columnas, dividiendo donde aparece un car�cter separador.
#Es como aplicar la funcion texto a columna de Excel

#Veamos la tabla table3, y c�ntremonos en la columna "rate" que tiene datos separados por "/"
table3

#separate() toma el nombre de la columna para separar, y los nombres de las columnas de "destino/nuevas"
#La funci�n aplica el separador por defecto
table3 %>% 
  separate(rate, into = c("cases", "population"))
#Esta operaci�n agarra la columna "rates" y la transforma en dos columnas nuevas "cases" y "population"

#Primero, se selecciona la tabla de datos: table3
#Segundo, se aplica la funci�n: separate(). El primer argumento es la columna de datos,
#el segundo argumento es un vector, representado por "into = c()"
#Tercero, en el vector "c" debemos definir los nombres de las nuevas columnas

#Para especificar un separador especifico, podemos utilizar el argumento "sep = "
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

#Por defecto, la salida de "separate()" son datos con caracteres, para evitar problemas con los datos
#p�demos utilizar el argumento "convert = TRUE", que nos dar� como resultado n�meros enteros
table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)

#Por �ltimo, s� tenemos un n�mero, podemos utilizar "sep" y separalo en un n�mero espec�fico de d�gitos
#Por ejemplo, s� tenemos 1999 en la columna "year", podemos separarlo en dos partes 19 y 99
table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

##----------unite()-------------##

#unite() es el inverso de "separate()" porque combina m�ltiples columnas en una sola columna
#Probablemente lo utilizaremos muy poco, pero es importante conocer su funcionamiento

#Por ejemplo, supongamos que queremos unir los datos de los a�os 19 y 99, para ello
#podemos utilizar unite() y definir un "sep="" vac�o, porque por defecto la funci�n utiliza un "_"
table5
table5 %>% 
  unite(new, century, year, sep = "")

#Primero, tabla de datos: table5
#Segundo, funcion: unite()
#Tercero, nombre de la nueva columna, nombre del campo1, nombre del campo2, separador "sep = "

####-----------------Missing Values NA--------------####

#Para saber c�mo trabajar con los Missing Values, debemos tener en cuenta que existen dos tipos:

#1. Impl�citos: simplemente no est�n presentes en los datos
#2. Expl�citos: representados por NA 

#Un valor faltante expl�cito es la presencia de una ausencia, representado por un NA; 
#Un valor perdido impl�cito es la ausencia de un dato, que deber�a estar all�

#Veamos el siguiente tibble
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks

#En la variable "return" el dato del a�o 2015 es simplemente un NA (expl�cito)
#Mientras que el primer cuarto de 2016, no existe entre los datos (impl�cito) y deber�a estar all�

#Una manera de solucionar esto, podr�a ser, volver los implicitos a explicitos
#Lo haremos utilizando "pivot_wider", lo que llenar� los vac�os del a�o 2016
stocks %>% 
  pivot_wider(names_from = year, values_from = return)

#Pero tambi�n podemos hacer lo opuesto, convertir los NA (explicitos) a implicitos,
#porque en muchos casos, no ser�n utilizados para hacer c�lculos
#Esto lo haremos utilizando el argumento "values_drop_na = TRUE" y pivot_longer()
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE
  )

##Completar datos de NA con complete()

#complete() toma un conjunto de columnas y encuentra todas las combinaciones �nicas. 
#Luego se asegura de que el conjunto de datos original contenga todos esos valores, 
#completando NA expl�citos cuando sea necesario.
#Es decir, con complete() se rellenan con NA, todos los espacios vac�os

stocks %>% 
  complete(year, qtr)

##Rellenar los datos que tienen NA con fill()

#fill() Toma un conjunto de columnas en las que desea que los valores faltantes 
#se reemplacen por el valor no faltante m�s reciente (a veces llamado �ltima observaci�n transferida).

#Veamos esta tabla
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment

#Existen dos valores de persona que son NA, si aplicamos "fill()" a la columna "person"
#completar� esos datos, con la �ltima observaci�n. Por defecto toma la �ltima de arriba "down"
#s� queremos la �ltima de abajo "up", para ello debemos utilizar el argumento ".direction = "up""
treatment %>% 
  fill(person, .direction = "up")
treatment %>% 
  fill(person, .direction = "down")

########################################################################

####-----------------Caso de estudio--------------####

#Veamos un ejemplo real, para practicar lo aprendido.
#Utilizaremos datos de tuberculosis, provenientes de la OMS que est�n en tidyr

#Tabla de datos
who
dim(who)
str(who)
names(who)

#El mejor lugar para comenzar a organizar datos es casi siempre juntar las columnas que no son variables
#Por ejemplo: country, iso2 e iso3 se refieren al pa�s, year indica el a�o, pero el resto de las columnas
#parecen ser datos. 

#As� que lo primero que haremos es juntar las columnas que van de la 4 a la 60 en forma de filas
#crearemos un nombre comod�n que llamaremos "key" y para contar utilizaremos un campo "cases"
#Como debemos reducir la dimension a lo largo, utilizaremos pivot_longer(), porque los datos
#en lugar de estar representados horizontalmente, lo estar�n verticalmente

who1 <- who %>% #Tabla de datos
  pivot_longer( #Funcion pivot_longer 
    cols = new_sp_m014:newrel_f65, #Rango de columnas columna4:columna60
    names_to = "key", #Nombre del campo nuevo a partir de las variables
    values_to = "cases", #Campo para contar los totales de cada variable
    values_drop_na = TRUE #Argumento para eliminar la excesiva cantidad de NA
  )
who1

#Ahora es necesario un poco de investigaci�n, para desentra�ar las siglas

# new: indica que los casos son nuevos
# rel, ep, sn y sp: indican el tipo de tuberculosis 
# f y m: indican el g�nero
# n�meros al final: indican rangos de edad (1524 = 15 - 24 years old / 3544 = 35 - 44 years old)

##Dar formato a los datos, para poder utilizar separate()

#Para poder separar los datos de las columna con "separate()" en el futuro, debemos hacer un peque�o
#cambio y agregarle un caracter separador a "newrel"
#Para ello utilizaremos la funcion "str_replace" y sobrescribimos la tabla original

who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2

#Ahora podemos separar los valores de estos strigns "new_sp_m1524" con separate()
#Primero vamos a separarlos en tres columnas: "new", "type", "sexage"

who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")#El campo "key" lo separamos en tres 3 partes en base al "_"
who3

#Antes de continuar, vamos a eliminar los campos new, iso2 e iso3 con la funci�n "select()"
#porque son iguales para todos los registros
who3 %>% 
  count(new)
who4 <- who3 %>% 
  select(-new, -iso2, -iso3)
who4

#Ahora debemos separar la variable "sexage", porque sex y age son variables diferentes
#Para que sea m�s sencillo, utilizaremos "sep = 1", que indica, que separaremos la columna
#desde el primer caracter, es decir, desde la letra "m" o "f" de la columna

who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5

#Una vez completado este paso, nuestra tabla quedar� arreglada, y podremos hacer an�lisis

#El c�digo simplificado, ser�a el siguiente:

who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")
  ) %>%
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)
