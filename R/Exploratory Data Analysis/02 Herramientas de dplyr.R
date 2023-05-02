#La mayor parte de los analisis en R, se ejecutan utilizando el paquete "dplyr"
#está incluido dentro de la tidyverse

library(tidyverse)
install.packages("nycflights13")
library(nycflights13)

flights

count(flights, tailnum, origin, sort = TRUE)

#Abrimos en el archivo en la ubicación que esté guardado
fifa20<- read.csv("fifa_dplyr.csv", encoding = "UTF-8")
fifa20

str(fifa20)
glimpse(fifa20)
dim(fifa20)
names(fifa20)

#Hacemos una selección, solo del grupo de variables que queramos
fifa20<- select(fifa20, sofifa_id:player_positions)
names(fifa20)

#Eliminamos varibles adicionales e innecesarias
fifa20<-select(fifa20, -player_url, -league_rank, -potential, -value_eur, -wage_eur)
names(fifa20)

###################################################

write_csv(fifa20, "fifa_dplyr.csv")
fifa<- read.csv("fifa_dplyr.csv", encoding = "UTF-8")
fifa
names(fifa)

#Para realizar arreglos en los datos, es imprescindible aprenderse las herramientas basicas de "dplyr"

#filter()
#arrange()
#select()
#mutate()
#summarise() 
#group_by()

#Todas estas funciones se aplican de la misma forma
#El verdadero poder de estas funciones, radica en utilizarlas de forma combinada

#1 El primer argumento es un data frame/tabla de datos
#2 Los argumentos subsiguientes describen qué hacer con el data frame, 
#  utilizando los nombres de las variables (sin comillas).
#3 El resultado, es un nuevo data frame, de acuerdo a la funcion que aplicamos

#------------filter()-----------------# <-

#filter() permite hacer seleccionar en base a uno o varios criterios
#Para hacerlo se utilizan operadores lógicos: >, >=, <, <=, != (not equal), and == (equal) y between

#Veamos algunos ejemplos:

#Seleccionar jugadores solo de Argentina OR Brasil
arg_bra<- filter(fifa20, nationality == "Argentina" | nationality == "Brazil")
arg_bra

#Podemos hacer un filtro más especifíco con AND
#Por ejemplo jugadores de Argentina con overall >= 80
mejores_arg<- filter(fifa20, nationality == "Argentina" & overall >= 80)
mejores_arg

#Existen filtros más complejos
#Por ejemplo, podemos combinar un pipe %>% con un vector c y el operador %in% (dentro de)
#el vector "c" en este caso actua como el operador OR
#Filtraremos solo los jugadores de Brasil, que juegan en Espana, Inglaterra e Italia
brasil<- fifa %>% filter(nationality == "Brazil")
brasil
brasil_tres_grandes<- brasil %>% filter(league_name %in% c("Spain Primera Division", " Italian Serie A",
                                                    "English Premier League"))
brasil_tres_grandes

#Para filtrar donde existen valores nulos, utilizamos el argumento "is.na"
nulos<- fifa %>% select(short_name, long_name, age, dob) %>% filter(is.na("overall"))
nulos2<- filter(fifa, is.na("sofifa_id"))
nulos2
#Esta tabla, no es un buen ejemplo, porque no tiene valores nulos

#También podemos filtrar, negando una expresión con el signo de exclamación
#El signo de exclamación, se coloca justo antes de la variable (!variable)
#Veamos cuáles jugadores no son de Brasil
no_brasilenos<- filter(fifa, !nationality == "Brazil")
no_brasilenos

#------------arrange()-----------------#

#arrange() funciona de manera similar a filter() excepto que en lugar de seleccionar las filas, 
#cambia el orden de acuerdo al valor que tenga cada variable (es decir mayor o menor/ a hasta la z)

#La forma más fácil de utilizar arrange() es separar los valores por comas
#El orden de las variables, determinar el orden de arreglo de los datos

#Filtro
arg_bra<- filter(fifa, nationality == "Argentina" | nationality == "Brazil")
arg_bra

#Ordena por overall ascendente
arrange(arg_bra, overall, weight_kg, height_cm)

#Si utilizamos "desc()" dentro de "arrange()" obtenemos el orden inverso
#es decir, el valor más alto primero
arrange(arg_bra, desc(overall), weight_kg, height_cm)

#Importante: los valores NA por defecto, siempre se ubicaran al final de la tabla

#Podemos combinar arrange() con filter()
#Para hacerlo, colocamos la función filter() dentro de arrange(filter()) 
brasilenos <- arrange(filter(fifa, nationality == "Brazil"), -overall) 
brasilenos

#Podemos hacer lo mismo con un pipeline %>%, pero en este caso, primero filtramos
#y después arreglamos
brasilenos <- fifa %>% filter(nationality == "Brazil") %>% arrange(-overall)
brasilenos  


#------------select()-----------------#

#Quizas la función más importante de dplyr es select(), porque permite hacer selecciones
#de datos por conjuntos o características específicas

#1. Selecciones básicas
#select(tabla, variable1, variable2, ... variable z)

fisico<- select(fifa, sofifa_id, age, height_cm, weight_kg)
fisico

#También podemos selecionar un rango, utilizando los dos puntos ":"
seleccion1<- select(fifa, sofifa_id:weight_kg)
seleccion1

#Seleccionar por el orden de las variables, cuando hablamos de orden nos referimos a números
#que van de 1 hasta n
#La primera variable sería el 1, y así sucesivamente
names(fifa)
importantes <- select(fifa, 1, 2, 8, 9)
importantes

#Para deseleccionar columnas tenemos dos opciones:
#1) Utilizar símbolo menos y los dos puntos ":" para deseleccionar un rango -(variable_1:variable_n)
deseleccion1 <- select (fifa, -(sofifa_id:dob))
deseleccion1

#2) Utilizar el simbolo menos con una o varias variables
deseleccion2 <- select(fifa, -player_positions)
deseleccion2

deseleccion3 <- select(fifa, -sofifa_id, -player_positions, -long_name)
deseleccion3
names(deseleccion3)

#Otras formas para deseleccionar variables

select(-a, -b, -c, -d, -e)

# OR

select(-c(a, b, c, d, e))

# OR

select(-(a:e))

# OR if you want to keep b

select(-a, -(c:e))

# OR a different way to keep b, by just putting it back in

select(-(a:e), b)


#2. Funciones útiles para conseguir el nombre de las columnas

#Cuando las bases de datos son muy grandes, y queremos seleccionar una varias columnas
#con algun nombre especifico, podemos utilizar alguna de estas funciones:

# Que comience con:   starts_with("abc")
# Que termine con:    ends_with("xyz")
# Que contenga:       contains("ijk")
# Que coincida:       matches("(.)\\1") - Utiliza expresiones regulares
# Rango de números:   num_range("x", 1:3)

datos<- select(fifa, starts_with("a"), starts_with("d"))
datos

datos1 <- select(fifa, contains("s"))
datos1

#3. Renombrar variables/columnas con "rename()" no utlizar select()

#select() no es útil para renombrar variables, porque elimina todas las que no sean listadas
#es mejor utilizar rename()

#rename(data frame, nombre_nuevo = nombre_viejo)
renombradas<- rename(fifa, nombre=short_name, nombre_completo=long_name, liga=league_name)
renombradas

#4. Mover las variables/reordenarlas con "everything()"

#Si utilizamos select() junto con el argumento everything() vamos a continuar seleccionando toda
#la tabla de datos, pero, las variables que escribamos/seleccionemos se moveran al principio
reordenada <- select(fifa, overall, nationality, club_name, everything())
reordenada

#5. Combinar select() y filter() con %>% 
#Las funciones de dplyr pueden ser enormemente poderosas y útiles cuando se combinan
#y utilizando el pipeline podemos aplicarlas en secuencia

###Las variables que se utilicen para filtrar, obligatoriamente deben estar en la selección
argentinos_80 <- fifa %>% select(short_name, nationality, club_name, league_name, overall) %>% 
  filter(overall >= 80 & nationality == "Argentina")
argentinos_80

#Podemos seleccionar y filtrar utilizando el argumento BETWEEN()
#La sintaxis es: between(variable, rango_inicio, rango_fin)
entre_85_y_90 <- fifa %>% select(short_name, nationality, overall) %>%
  filter(between(overall, 85, 90) & nationality == "Argentina")
entre_85_y_90

#Por último, podemos aplicar select(), filter () y arrange() en una misma consulta
#Aplicamos cada función y la anidamos con %>% 
mayores_85 <- fifa %>% select(short_name, nationality, overall) %>% 
  filter(overall >= 85 & nationality == "Brazil") %>% arrange(-overall)
mayores_85

#------------mutate()-----------------# 

#mutate() permite crear nuevas variables, en base a unas ya existentes, es decir,
#podemos sumar, restar, multiplicar o dividir dos o mas variables "originales" y 
#crear una nueva utilizando mutate()
#Las variables creadas con mutate() siempre aparecen al final de la tabla de datos

#Vamos a seleccionar algunas variables, que tienen que ver con la condicion fisica
cond_fis <- fifa %>% select(age, dob, height_cm, weight_kg)
cond_fis

#Con mutate () podemos pasar la altura a metros ^2
mutate(cond_fis, 
       altura2 = height_cm / 100)
#Si queremos hacer algo más complejo, podemos calcular el IMC para cada jugador
mutate(cond_fis,
       imc = weight_kg / (height_cm / 100)^2)

imc <- mutate(cond_fis,
              imc = weight_kg / (height_cm / 100)^2)
imc

#Si quieres realizar calculos con variables, pero solo quedarte con las nuevas utiliza "transmute()"
#Las variables del cálculo se borrarán en la salida
transmute(cond_fis,
       imc = weight_kg / (height_cm / 100)^2)

#Cuando creamos nuevas variables, podemos utilizar muchos operadores como:

#1)Aritmeticos: +, -, *, /, ^
#2)Modulares: %/% (integer division) and %% (remainder), where x == y * (x %/% y) + (x %% y)
#3)Logaritmicos: log(), log2(), log10() 
#4)Acumulativos o de agregacion: cumsum(), cumprod(), cummin(), cummax(); and dplyr provides cummean()
#5)Ranking: min_rank(), row_number(), dense_rank(), percent_rank(), cume_dist(), ntile()

#min_rank() asigna un rango igual al número de valores menor que el valor empatado más uno
#dense_rank() asigna un rango igual al número de valores distintos menos que el valor empatado más uno

#La función mas importante es row_number() 
#row_number() asigna a cada elemento un valor único (id). 
#El resultado es equivalente al número de índice (o fila) de cada elemento después de ordenar el vector,
cond_fis %>% 
  mutate(id = row_number())

#------------summarise() y group_by()-----------------#

#Por si sola la funcion summarise() parece un poco inutil
summarise(cond_fis)

#Su verdadera utilidad podremos verla, cuando la utilicemos en conjunto con "group_by()"
#Esto cambia la unidad de análisis que pasa del conjunto de datos completo, a grupos individuales
#Luego, cuando usen los verbos de dplyr en un data frame agrupado, 
#se aplicarán automáticamente "por grupo" no a todos los datos

#Primero creamos una variable, para almacenar unas variables/columnas especificas
club_nacionalidad <- group_by(fifa, short_name, nationality, club_name)
club_nacionalidad
names(club_nacionalidad)

#Esto transforma la tabla en un tibble
#Pero solo es util para calculos numericos
summarise(club_nacionalidad, heightx = mean(height_cm, na.rm = TRUE))

#Otras funciones con group_by()

#La función group by() se utiliza para agrupar los datos por un campo específico
#Para agrupar definimos una variable, seleccionamos la tabla 
#y luego el campo de agrupación group_by(campo_agrupacion)
club_nacionalidad <- group_by(fifa, short_name, nationality, club_name)
club_nacionalidad

#Para aplicar el operador %>% haríamos lo siguiente
#Variable<- tabla %>% group_by(campo_para_agrupacion)
club_nacionalidad <- fifa %>% group_by(short_name, nationality, club_name)
club_nacionalidad

#summarize(count = n()) nos ofrece un conteo individual de cada categoría
jugadores_liga <- fifa %>% group_by(league_name) %>% summarise(count = n())
jugadores_liga

#Utilizando group_by() también podemos aplicar la función n_distinct
j <- fifa %>% group_by(player_positions) %>% summarize(count = n_distinct(player_positions))
j

#También podemos agrupar utilizando la libreria "pysch"
library(psych)

#La función que debemos utilizar se llama "describeBy()"
#Sintaxis: describeBy(tabla_de_datos, group=tabla_de_datos$variable)

#Primero vamos a crear una variable nueva con los jugadores en Alemania
alemania <- filter(fifa,league_name == "German 1. Bundesliga" )
alemania

#Ahora aplicamos "describe.by"
describe.by(alemania, group = alemania$nationality)

#El resultado es una tabla larga, con valores de cada medida de tendencia central 
#y dispersión por tantos grupos, como se definan las variables
#Este tipo de resumen es útil para variables numéricas, pero agrupandolas por categorias
#Es especialmete útil para categorias pequeñas, como 5 o menos

#Por ejemplo con la funcion anterior, veremos todos los jugadores de la Bundesliga,
#veremos sus variables numericas, pero agrupados por nacionalidad
describe.by(alemania, group = alemania$nationality)

#------------Utilización del pipe symbol %>% -----------------#

#Podemos utilizar el pipe %>% para encadenar una operación tras otra
#y para simplificar la lectura de la consulta

#Por ejemplo, podemos: seleccionar, filtrar y arreglar, en una misma secuencia
alemanes<- fifa %>% select(short_name, club_name, nationality, overall) %>% 
  filter(nationality == "Germany") %>% arrange(desc(overall))
alemanes

#------------Realizar conteos con count() -----------------#

#Para realizar conteos simples con dplyr, podemos utilizar la siguiente sintaxis
alemanes %>% #Tabla
  count(club_name) #Variable para contar

#El resultado es una columna con los elementos de la variable, y otra con el conteo
#Es muy útil para variables categoricas

#Existen otras formas de realizar conteos en las tablas:

#Utilizando group_by(), summarise() y la funcion "n()"
alemanes %>% 
  group_by(club_name) %>% 
  summarise(n = n())

#Utilizando la funcion "tally()" para contar
alemanes %>% 
  group_by(overall) %>% 
  tally() %>% 
  arrange(desc(overall))

#------------Agrupando por múltiples variables----------------#

#Cuando se agrupa por múltiples variables, cada resumen elimina un nivel de la agrupación. 
#Eso facilita la acumulación progresiva de un conjunto de datos, para hacer análisis más específicos o generalizados

#Vamos a crear una nueva variable de agrupación
solo_numeros <- group_by(fifa, age, dob, height_cm, weight_kg, overall, league_name, club_name)
solo_numeros

#Ahora podemos aplicar "summarise" a ese variable agrupada, para realizar algunos cálculos
(equipo <- summarise(solo_numeros, club_name = sum(club_name)))
(liga <- summarise(solo_numeros, league_name = n()))
(altura <- summarise(solo_numeros, overall = mean(overall)))