#En R las bases de datos relaciones se definen por tres operaciones:

#1 Mutating joins: que agregan nuevas variables a un data frame a partir de observaciones coincidentes en otro
#2 Filtering joins: filtra observaciones, que pueden coincidir o no con las de otra tabla
#3 Set operations: que tratan las observaciones como si fueran elementos fijos

#Los análisis de bases de datos relaciones, se realizarán con "dplyr"
#A lo largo de esta lección, utilizaremos los datos de nycflights13
airlines #Aerolínea y su acrónimo
airports #Aeropuertos y código "faa"
planes   #Aviones, identificados por su "tailnum"
weather  #Tiempo (meteorológico), en el aeropuerto de NYC

library(tidyverse)
library(nycflights13)

#La tabla "flights" contiene elementos relacionales de las cuatro tablas arriba mencionadas 
#airlines, airports, planes y weather
flights
dim(flights)
names(flights)
str(flights)
summary(flights)

#flights se conecta a airlines a través de la variable "carrier" 
#flights se conecta a airports de dos maneras: via "origin" y "dest" 
#flights se conecta a planes a través de la variable "tailnum"
#flights se conecta a weather a través de "origin" (the location), year, month, day y hour (the time)

######----------------Ejercicios--------------------------######

#1. Imagina que quisieras dibujar (aproximadamente) la ruta que sigue cada avión desde su origen hasta su destino. 
#¿Qué variables necesitarías? ¿Qué tablas necesitarías combinar?

#Necesitamos la tabla "flights" que tiene el origen y destino de cada vuelo, y la tabla
#"airports" que ubica cada aeropuerto por latitud y longitud
#Recordemos que "flights" se conecta con "airports" por las variables origin y dest
flights
names(flights)
airports
names(airports)

flights_latlon <- flights %>%
  inner_join(select(airports, origin = faa, origin_lat = lat, origin_lon = lon),
             by = "origin"
  ) %>%
  inner_join(select(airports, dest = faa, dest_lat = lat, dest_lon = lon),
             by = "dest"
  )

####----------------Primary and Foreign key (ID único)-------------------####

#Las keys o ID son identificadores únicos para cada elemento, que no pueden repetirse
#y que funcionan para conectar las tablas entre sí

#La "primary key" identifica de forma única una observación en su propia tabla
#La "foreign key" identifica de forma única una observación en otra tabla (es la conexión con otra tabla)

#Es poco común, pero una variable puede ser primary y foreign key al mismo tiempo

#En algunos casos, será difícil identificar la Primary Key de una tabla, e incluso, podría estar ausente. 
#Sino podemos encontrar una Primary Key, podemos crearla con "mutate() and row_number()"
#Esto se llama "surrogate key" o clave sustituta, el argumento clave es "row_number()"

#Vamos a crear una surrogate key, para la tabla "flights", creando la variable "flights2"

flights2<- flights %>% #Tabla
  arrange(year, month, day, sched_dep_time, carrier, flight) %>% #Orden en que queremos que aparezcan las columnas
  mutate(flight_id = row_number()) %>% #Vamos a transformar el número de la fila, en una variable que llamaremos "flight_id"
  glimpse() #Vistazo a la tabla

flights2 #El campo ID aparece al final de la tabla

####----------------Mutating joins-------------------####

#Un mutate join le permite combinar variables de dos tablas. Primero hace coincidir 
#las observaciones por sus keys, luego copia las variables de una tabla a la otra.

#Como ocurre con mutate() las funciones de combinación, agregan variables a la derecha de la tabla
#y puede ser díficil verlas al momento de imprimir en consola

#Para que sea más sencillo, haremos una selección de menos variables
flights3 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights3

#Hagamos un left_join() de "flights3" con "airlines" a través del campo "carrier"
#esto permitirá agregar la columna "name" a la tabla "flights3"
flights3 %>% #Tabla
  select(-origin, -dest) %>% #Quitamos las columnas origin y dest  
  left_join(airlines, by = "carrier") #Campo para unir "carrier"
flights3

#Podemos hacer el mismo "left join" solo utilizando la funcion "mutate()" y el argumento "match"
flights3 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

#####----------------Definir la Primary Key-------------------####

#Generalmente, conocemos o podremos definir un ID común entre las tablas
#y unirlo por by = "key".
#Pero se puede utilizar otros valores distintos a los ID, para unir tablas

#El valor por defecto de by = NULL, es decir, copia el ID que aparece en ambas tablas

flights3%>% 
  left_join(weather)
#Joining, by = c("year", "month", "day", "hour", "origin")

flights3 %>% 
  left_join(planes, by = "tailnum")

#Puedes realizar un join tras otro. Si se encuentran variables duplicadas, de forma predeterminada, 
#dplyr distinguirá las dos agregando .x e .y

airport_locations <- airports %>%
  select(faa, lat, lon)
airport_locations

flights %>%
  select(year:day, hour, origin, dest) %>%
  left_join(
    airport_locations,
    by = c("origin" = "faa")
  ) %>%
  left_join(
    airport_locations,
    by = c("dest" = "faa")
  )

####--------------------dplyr y SQL------------------------------####

#Los joins utilizados en dplyr provienen de lenguaje SQL

#dplyr	                                 SQL
#inner_join(x, y, by = "z")	     SELECT * FROM x INNER JOIN y USING (z)
#left_join(x, y, by = "z")	       SELECT * FROM x LEFT OUTER JOIN y USING (z)
#right_join(x, y, by = "z")	     SELECT * FROM x RIGHT OUTER JOIN y USING (z)
#full_join(x, y, by = "z")	       SELECT * FROM x FULL OUTER JOIN y USING (z)

#####----------------Filtrando Joins-------------------####

#La funcion filter() utilizada en joins, aplica a las filas (observaciones), no a las columnas
#Los "semi-joins" son útiles para hacer coincidir las tablas de resumen filtradas con las filas originales
#Los "semi-joins" funcionan como un SELECT de SQL, porque solo muestran los resultados que aplican
#a una determinada condición

#Vamos a crear una variable con los 10 destinos más frecuentes
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

#Y ahora queremos, que solo esos 10 registros se unan (join) con la tabla "flights"
#para ellos utilizamos un semi-join
united <- flights %>% 
  semi_join(top_dest)
united

#El opuesto del semi-join, es el anti-join, que muestra todos los registros de una tabla
#sin importar, que estos no tengan datos
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

#####---------------Set operations (Operaciones adicionales)-------------------####

# intersect(x, y): devuelve observaciones tanto en x como en y.
# union(x, y):     devuelve observaciones únicas en x e y.
# setdiff(x, y):   devuelve observaciones en x, pero no en y.

#Veamos estos dos tribble
df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)
df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)
df1
df2

intersect(df1, df2) #devuelve solo elementos en común en las dos tablas
union(df1, df2)     #devuelve todos los registros, es como un full join
setdiff(df1, df2)   #devuelve lo que está en df1, pero que no coincide con df2
setdiff(df2, df1)   #devuelve lo que está en df2, pero que no coincide con df1

