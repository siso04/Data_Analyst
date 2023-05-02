#El paquete {sqldf} consiste en una función sqldf(). Dicha función se acompaña con el comando 
#SELECT de SQL seguido de la sintaxis tradicional de SQL (Structured Query Language)
#También veremos su uso equivalente en algunas funciones de R

#Fuente: https://rquer.netlify.app/sql/ 

library(sqldf)
library(tidyverse)
library(Hmisc)
library(funModeling)
library(readr)

emperors <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-13/emperors.csv")
emperors

loans <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-11-26/loans.csv")
loans

install

status(emperors)
glimpse(emperors)
describe(emperors)

status(loans)
glimpse(loans)
describe(loans)

####---------------------Utilización del paquete "sqldf"--------------------------####

#El paquete {sqldf} se compone de una función sqldf() que nos sirve para utilizar 
#la sintaxis de SQL en el entorno de R

# Cuando utilicemos sqldf, las instruccione SQL dentro del parentesis, van en comillas ""
# Ejemplo: sqldf("SELECT * FROM emperors LIMIT 6")

####-----------SELECT ------------####

#La funcion SELECT es exactamente igual al select() de dplyr

sqldf("SELECT name, dynasty, birth, killer, cause FROM emperors LIMIT 10")
emperors %>% select(name, dynasty, birth, killer, cause) %>% head(10)

####----------AS-----------####

#Modificar el nombre de las columnas del dataset resultante con la funcion AS

sqldf("SELECT name AS nombre,
      dynasty AS dinastia,
      birth AS nacimiento,
      killer AS asesino, 
      cause AS causa 
      FROM emperors
      LIMIT 10")

####-----------ORDER BY----------####

#Podemos utilizar ORDER BY para ordenar las observaciones del dataset 
#al estilo de la función arrange() del paquete {dplyr}

# Orden ascendente ASC

sqldf("SELECT name, dynasty, birth, killer, cause 
      FROM emperors 
      ORDER BY birth ASC
      LIMIT 10")

# Orden descendente DESC

sqldf('SELECT name, dynasty, birth, killer, cause 
      FROM emperors 
      ORDER BY birth DESC 
      LIMIT 10')

# Ordenar por múltiples variables

sqldf('SELECT name, dynasty, birth, cause, killer 
      FROM emperors 
      ORDER BY dynasty ASC, cause ASC, killer ASC 
      LIMIT 20')

#Podemos hacer exactamente lo mismo con la función arrange() de dplyr
emperors %>% select(name, dynasty, birth, killer, cause) %>% arrange(dynasty, cause, killer) %>% head(20)

####-----------COUNT / DISTINCT-------####

#La función COUNT nos permite identificar el número de filas que no contienen valores NA.
sqldf('SELECT COUNT(name) AS num_cols
      FROM emperors')
# Para contar los NA, podemos utilizar funciones de R
sum(is.na(emperors$birth))
colSums(is.na(emperors))

#El comando DISTINCT nos devuelve las observaciones, eliminando las posibles repeticiones. 
#Sería como aplicar la función unique(), solo que la salida de unique() es una lista
names <- sqldf('SELECT DISTINCT name 
      FROM emperors')
names

#Podemos utilizar COUNT conjuntamente con DISTINCT en una misma expresión para obtener 
#la cuenta de los valores únicos.
sqldf('SELECT COUNT(DISTINCT name) AS num_unique
      FROM emperors')

#Funcion unique()
unique(emperors$name)

####-----------WHERE-----------####

#WHERE nos permite establecer algún criterio de selección a la hora de extraer información del dataframe. 

#1. WHERE en SQL funciona en gran medida como la función filter() de {dplyr}

sqldf('SELECT name, birth_cty, killer 
      FROM emperors 
      WHERE cause = "Assassination"
      ORDER BY name ASC')

##2. WHERE . AND / OR

#Podemos utilizar las funciones AND y OR para restringir aún más la búsqueda

sqldf('SELECT name, birth_cty, killer 
      FROM emperors 
      WHERE cause = "Assassination" 
      AND killer = "Praetorian Guard"')

sqldf('SELECT name, birth_cty, killer 
      FROM emperors 
      WHERE killer = "Praetorian Guard" 
      OR killer = "Own Army"')

#Podemos hacer lo mismo en R utilizando OR y AND, o la barra | y el ampersand &

emperors %>%
  select(name, birth_cty, killer) %>%
  filter(killer == "Praetorian Guard")

emperors %>%
  select(name, birth_cty, killer) %>%
  filter(killer == "Praetorian Guard" | killer == "Own Army")

##3. WHERE . IN / NOT IN

#Podemos utilizar WHERE IN o WHERE NOT IN para detectar grupos de observaciones según un criterio de identificación

sqldf('SELECT name, dynasty, birth, cause 
      FROM emperors 
      WHERE dynasty IN ("Flavian", "Gordian") 
      LIMIT 20')

sqldf('SELECT name, dynasty, birth, cause 
      FROM emperors 
      WHERE dynasty NOT IN ("Flavian", "Gordian") 
      LIMIT 20')

#Tradicionalmente en R se utiliza %in% para obtener el resultado obtenido con LIKE en SQL

emperors %>%
  select(name, dynasty, birth, cause) %>%
  filter(dynasty %in% c("Flavian", "Gordian")) %>%
  head(20)

#Para conseguir en R un operador similar a la negación (NOT IN) de SQL debemos descargar 
#el paquete {Hmisc} que incluye la función %nin% que sería la expresión equivalente a NOT IN
library(Hmisc)

emperors %>%
  select(name, dynasty, birth, cause) %>%
  filter(dynasty %nin% c("Flavian", "Gordian")) %>%
  head(20)

#4. WHERE . NULL / IS NULL / IS NOT NULL con la función COUNT

#En SQL los missing values se representan por NULL. Para identificar el número de NA`s o NULL values 
#podemos utilizar el operador COUNT conjuntamente con IS NULL.

sqldf('SELECT COUNT(*)
     FROM emperors
     WHERE birth_cty IS NULL')

sum(is.na(emperors$birth_cty))

sqldf('SELECT COUNT(*)
     FROM emperors
     WHERE birth_cty IS NOT NULL')

emperors %>% count(birth_cty)

#5. WHERE . LIKE / NOT LIKE

#Podemos seleccionar por ejemplo textos, que culminen de manera similar

sqldf('SELECT name, name_full
      FROM emperors 
      WHERE name LIKE "%ius"')

#Podemos negar la expresion con NOT LIKE

sqldf('SELECT name, name_full
      FROM emperors 
      WHERE name NOT LIKE "%ius"
      LIMIT 15')

####-----------GROUP BY----------####

#GROUP_BY permite agrupar los resultados al estilo de la función group_by() de {dplyr}

sqldf('SELECT dynasty, count(*) AS total
      FROM emperors 
      GROUP BY dynasty')

#En R el mismo resultado se obtendría con las funciones group_by() y summarise() de las siguiente forma

emperors %>%
  group_by(dynasty) %>%
  summarise(total = n())

####-----------HAVING----------####

#Una vez agrupados los resultados necesitamos HAVING en caso de querer aplicar un filtro adicional. 
#HAVING funciona como un filtro adicional, se agrega otra condición al resultado

sqldf('SELECT dynasty, count(*) AS total
      FROM emperors 
      GROUP BY dynasty
      HAVING COUNT(name) > 5')

####---------SUM, AVG, MAX, MIN---------####

#Con el paquete {sqldf} podemos también realizar operaciones matemáticas siguiendo la sintaxis de SQL

#SUM
sqldf('SELECT SUM(total) 
      FROM loans 
      WHERE year = 15')

#Podemos utilizar SUM con GROUP BY
sqldf('SELECT year, SUM(total) AS Total 
      FROM loans 
      GROUP BY year')

sqldf('SELECT year, quarter, SUM(total) AS Cuatrimestre 
      FROM loans 
      GROUP BY year, quarter')

#AVG
sqldf('SELECT AVG(starting) 
      FROM loans 
      WHERE agency_name = "Account Control Technology, Inc."')

#MAX y MIN
sqldf('SELECT MAX(voluntary_payments), MIN(voluntary_payments)
      FROM loans')

sqldf('SELECT MAX(total) as Mayor_prestamo 
      FROM loans 
      WHERE quarter = 1 AND year = 16')

#En R las operaciones observadas se pueden realizar fácilmente con la función summarise() del paquete {dplyr}
#La función summarise() se complementa muy bien con la función group_by()

loans %>%
  summarise(num_observaciones = n(), 
            total_loans = sum(total))

loans %>%
  filter (year == 15) %>%
  summarise(total_loans = sum(total))

loans %>%
  group_by(year, quarter) %>%
  summarise(total = sum(total))

loans %>%
  filter(year == 15) %>%
  arrange(desc(total)) %>%
  head(n=1) %>%
  select(agency_name)

####---------BETWEEN . AND---------####

#El comando BETWEEN nos permite seleccionar información que se encuentre en un rango determinado. 

sqldf('SELECT year, agency_name, voluntary_payments AS Pagos_Voluntarios
      FROM loans 
      WHERE voluntary_payments 
      BETWEEN 20000 AND 100000')

#Para obtener el mismo resultado en R podemos utilizar la función filter() junto a select().

loans %>%
  select(year, agency_name, voluntary_payments) %>%
  filter(voluntary_payments > 20000 & voluntary_payments < 100000)

####---------FILTROS CONDICIONALES---------####

# = igual
# <> no igual
# < menor que
# > mayor que
# <= menor que o igual a
# >= mayor que o igual a

sqldf('SELECT agency_name, voluntary_payments 
      FROM loans 
      WHERE voluntary_payments > 12000000')

#En R sencillamente utilizaríamos la función filter() de dplyr
loans %>% select(agency_name, voluntary_payments) %>% filter(voluntary_payments > 12000000) %>% 
  arrange(desc(voluntary_payments))

####---------CASE WHEN . THEN--------####

#Con los filtros mencionados en el punto previo y el comando CASE WHEN podemos establecer 
#nuestras propias categorías y agrupaciones de los datos.

summary(loans$total)

sqldf('SELECT agency_name, year, total,
      CASE WHEN total < 32888118 THEN "entre el Min y 1stQ"
      WHEN total BETWEEN 32888118 AND 72669212 THEN "entre 1stQ y Media"
      WHEN total BETWEEN 72669212 AND 106005716 THEN "entre Media y Mean"
      WHEN total BETWEEN 106005716 AND 167945568 THEN "entre Mean y 3rdQ"
      ELSE "entre 3rdQ y Max" END
      AS ranking
      FROM loans
      LIMIT 10')

#En R existe una operativa similar para realizar la misma operación utilizando la función case_when()

loans %>%
  mutate(
    ranking = case_when(
      total < 32888118 ~ "entre el Min y 1stQ",
      total > 32888118 & total < 72669212 ~ "entre 1stQ y Media",
      total > 72669212 & total < 106005716 ~ "entre Media y Mean",
      total > 106005716 & total < 167945568  ~ "entre Mean y 3rdQ",
      TRUE ~"entre 3rdQ y Max"
    )) %>%
  select(agency_name, year, total, ranking) %>% arrange(desc(total))

