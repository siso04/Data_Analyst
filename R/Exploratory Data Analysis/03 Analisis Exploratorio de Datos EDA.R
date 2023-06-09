#El An�lisis Exploratorio de Datos es un elemento b�sico para comprender los datos
#y su comportamiento

library(tidyverse)
library(readxl)
library(stringr)

#El EDA se basa en 3 principios:

#1. Generar preguntas sobre tus datos
#2. Buscar respuestas visualizando, transformando y modelando tus datos
#3. Utilizar lo que aprendiste para refinar sus preguntas y/o generar nuevas preguntas de an�lisis

#Para realizar la limpieza de datos, deber� implementar 
#todas las herramientas de EDA: visualizaci�n, transformaci�n y modelado.

#El objetivo durante EDA es desarrollar una comprensi�n de sus datos. 
#La forma m�s f�cil de hacer esto es utilizar preguntas como herramientas para guiar su investigaci�n.

#Hay dos preguntas b�sicas que debes responder con el EDA:

#1. �Qu� tipo de variaci�n ocurre dentro de mis variables?
#2. �Qu� tipo de covariaci�n ocurre entre mis variables?

#Como en otras partes del curso, utilizaremos principalmente la libreria "tidyverse"
library(tidyverse)

#Vamos a buscar una tabla para realizar todos los an�lisis


fifa <- read.csv("fifa_dplyr.csv", encoding = "UTF-8")
fifa
names(fifa)
summary(fifa)
str(fifa)
glimpse(fifa)

#Aplicaremos un filtro, para utilizar una tabla mas pequena
croacia <- filter(fifa, nationality == "Croatia")
croacia

#----------------------Visualizar distribuciones--------------------------------

#La mejor manera de comprender patrones en los datos, es viendo su distribuci�n

#1. Para Variables categoricas, debemos utilizar un gr�fico de barras

ggplot(data = croacia) + geom_bar(mapping = aes(x = league_name, fill = league_name )) + 
  theme(legend.position = "none")

#Como hay un n�mero que resalta, vamos hacer un conteo por liga, para descubrir donde juegan m�s jugadores
croacia %>% count(league_name) %>% arrange(desc(n))
#Parece que la mayor�a de los croatas, juegan en el resto del mundo: Rest of World

#2. Variable continua
#Para examinar la distribuci�n de una variable continua, utilice un histograma
#El argumento "binwidth" define el grosor de las barras
ggplot(data = croacia) + geom_histogram(mapping = aes(x = height_cm), binwidth = 0.6, fill = "pink")

#Para conocer como se distribuyen los rangos, podemos utilizar "count" y el argumeto "cut_width"
#Esto lo que hace es dividir la variable en varios rangos. El numero que se coloca en la funcion
# esta relacionado con la variable, es decir, mide el valor en numeros absolutos. Si hablamos
# de kilos o centimetros, dividira los rangos cada 10 kilos, o cada 10 centimetros
#Y puede darnos una idea r�pida de la concentraci�n de los valores
croacia %>% 
  count(cut_width(height_cm, 5))
#En este caso utilizamo rangos de 10 cm, y podemos comprobar que la mayor�a de los jugadores
#miden entre 1.75 y 1.95 m

#Podemos replicar el mismo analisis con el peso de los jugadores 
ggplot(data = croacia) + geom_histogram(mapping = aes(x = weight_kg), binwidth = 0.5, fill = "steelblue2")

croacia %>% 
  count(cut_width(weight_kg, 5))

fifa %>% count(cut_width(weight_kg, 7.5))

#-----------�Cu�les son las preguntas que debemos realizarnos?----------------------------

#1) Existen valores t�picos/repetidos/comunes

#1.1 �Qu� valores son los m�s comunes? �Por qu�?
#1.2 �Qu� valores son raros? �Por qu�? �Esto coincide con sus expectativas?
#1.3 �Puedes ver alg�n patr�n inusual? �Qu� podr�a explicarlo?

#2) Observar los datos por clusters o agrupaciones

#2.1 �En qu� se parecen las observaciones dentro de cada conglomerado?
#2.2 �En qu� se diferencian las observaciones entre los grupos,y como se diferencian ellas internamente?
#2.3 �C�mo puedes explicar o describir los grupos?
#2.4 �Por qu� podr�a ser enga�osa la apariencia de los conglomerados?

#3) Valores inusuales o at�picos

#A veces, los valores at�picos son errores de entrada de datos; 
#otras veces, los valores at�picos sugieren nuevas interrogantes para el an�lisis

#Es una buena pr�ctica repetir su an�lisis con y sin los valores at�picos.
#En algunos casos puede ser necesarios descartarlos o convertirlos en NA, y en 
#otros casos deber�n conservarse para el an�lisis

#-----------Ejercicios----------------------------

#Exploraci�n de variables
fifa
names(fifa)

#Podemos ver un resumen de variables especificas, utilizando la funcion "select()"
#Esta opci�n es �til para variables n�mericas
#El primer argumento de select() debe ser la tabla de datos
summary(select(fifa, age, height_cm, weight_kg))

#Ahora vamos hacer un histograma con un ancho (bindwith) de 0.1 para cada variable

ggplot(data = fifa) + geom_histogram(mapping = aes(x = age, fill = "red"), binwidth = 0.3)
ggplot(data = fifa, mapping = aes(x = age)) + geom_histogram(binwidth = 0.3, fill = "red")
ggplot(data = fifa, mapping = aes(x = height_cm)) + geom_histogram(binwidth = 0.3, fill = "blue")
ggplot(data = fifa, mapping = aes(x = weight_kg)) + geom_histogram(binwidth = 0.3, fill = "green")

#Para determinar los valores at�picos podemos utilizar "filter()" y "arrange()"

#filter() nos permitir� ver, si existe algun error o una variable con valor 0
(filter(fifa, age == 0 | height_cm == 0 | weight_kg == 0))
#En este caso, no hay errores o valores 0 en la tabla de datos

#arrange() permitir� visualizar con mayor facilidad esos valores altos de la tabla, 
#que parecen outliers en alguna variable
#Utilizamos la funci�n "head()" para que nos muestre los primeros 10 registros
fifa %>%
  arrange(desc(height_cm)) %>%
  head(10)

#Tambi�n podemos comprobar valores atipicos haciendo un scatterplot
ggplot(data = fifa, mapping = aes(x = height_cm, y = weight_kg)) + geom_point(color = "red") +
  labs( x = "Altura", y = "Peso")

#----------------------Manejando Missing Values (NA)--------------------------------

#En algunos casos podemos transformar los valores atipicos en NA, porque esto puede ayudarnos
#a realizar un analisis de los datos, sin alterar su composicion original

#Si queremos eliminar todos los valores atipicos utilizamos filter()
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

#Pero si queremos transformarlos en NA, debemos utilizar mutate() y ifelse()
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

#Ahora podemos graficar, y los NA ser�n ignorados
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()

#----------------------La covariaci�n--------------------------------

#La covariaci�n es la tendencia de los valores de dos o m�s variables a variar juntos de manera relacionada

#1)Para una sola variable categorica, podemos utilizar una variable como "density"

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

#Una forma m�s sencilla de ver la covariaci�n, es con un "boxplot"
#Una caja que se extiende desde el percentil 25 de la distribuci�n hasta el percentil 75, 
#distancia conocida como rango intercuart�lico (RIC). 
#En el medio del cuadro hay una l�nea que muestra la mediana, es decir, el percentil 50, de la distribuci�n

ggplot(data = fifa, mapping = aes(x = height_cm, y = weight_kg)) + geom_boxplot()

#Podemos rotar el boxplot, para ver las cajas en sentido vertical "coord_flip()"
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()

#2) Para dos variables categoricas

#Para visualizar la covariaci�n entre variables categ�ricas, 
#deber� contar el n�mero de observaciones para cada combinaci�n.
#La forma m�s sencilla de hacerlo es utilizar "geom_count()"

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

#El tama�o de cada c�rculo en la gr�fica muestra cu�ntas observaciones ocurrieron 
#en cada combinaci�n de valores. 
#La covariaci�n aparecer� como una fuerte correlaci�n entre valores espec�ficos de x y valores espec�ficos de y.

diamonds %>% 
  count(color, cut)
fifa %>% count(nationality) %>% arrange(desc(n)) %>% head(15)
conteo <- fifa %>% count(nationality, league_name) %>% arrange((n)) 
conteo
View(conteo)

#----------------------Preguntas sobre patrones y modelos--------------------------------

#1. �Podr�a este patr�n deberse a una coincidencia (es decir, al azar)?
#2. �C�mo puedes describir la relaci�n impl�cita en el patr�n?
#3. �Qu� tan fuerte es la relaci�n impl�cita en el patr�n?
#4. �Qu� otras variables podr�an afectar la relaci�n?
#5. �Cambia la relaci�n si observa subgrupos individuales de datos?

#Los patrones proporcionan una de las herramientas m�s �tiles para los cient�ficos de datos 
#porque revelan la covariaci�n. Si piensas en la variaci�n como un fen�meno que crea incertidumbre, 
#la covariaci�n es un fen�meno que la reduce. Si dos variables covar�an, 
#puedes utilizar los valores de una variable para hacer mejores predicciones sobre los valores de la segunda.

ggplot(data = faithful) + 
  geom_point(mapping = aes(x = eruptions, y = waiting))

#-----------------Como escribir el c�digo de un gr�fico-----------------------

#Version larga
ggplot(data = fifa, mapping = aes(x = height_cm, y = weight_kg)) + geom_point()

#Version corta
ggplot(fifa, aes(weight_kg, height_cm)) + geom_point()

#Utilizado el pipeline
diamonds %>% 
  count(cut, clarity) %>% 
  ggplot(aes(clarity, cut, fill = n)) + 
  geom_tile()
