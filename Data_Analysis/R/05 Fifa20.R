#Cargamos las librerias para el analisis

#Borrar Global Environment: rm(list = ls())


library(tidyverse)
library(readxl)
library(skimr)
library(psych)

#count total missing values in each column
sapply(diamonds, function(x) sum(is.na(x)))

#Ubicamos el archivo que queremos abrir con setwd()


####---------------------------####

#Creamos una variable y abrimos el archivo
fifa20<- read.csv("players_20.csv", encoding = "UTF-8")

#Vemos el contenido completo de la tabla
View(fifa20)

#Podemos ver sus dimensiones dim() y estructura str()
dim(fifa20)
str(fifa20)
glimpse(fifa20$dob)
skim_without_charts(fifa20)
describe(fifa20) 

#Podemos ver el nombre de cada columna en orden alfabetico
ls(fifa20)

#Tambien podemos ver los nombres de las columas, en el mismo orden que tienen en la tabla
names(fifa20)

#Ahora vamos a sobrescribir la tabla, seleccionando un grupo especifico de columnas
#Estas columnas irán desde "short_name:overall", para aplicar la seleccion
#utilizaremos al funcion "select" de "dplyr"
fifa20<-select(fifa20, short_name:player_positions)

#Ahora veamos nuestra solo con el grupo de variables seleccionadas y la lista de variables con names()
View(fifa20)
names(fifa20)

#Como no necesitamos algunas variables, vamos a sobrescribir nuevamente la tabla para eliminarla
fifa20<- select(fifa20, -league_rank, -potential, -value_eur, -wage_eur)

#Revisemos nuevamente la tabla, y comprobemos las columnas que la componen, su dimension y estructura
names(fifa20)
dim(fifa20)
str(fifa20)

#Vamos a cambiar el nombre de las columnas que están en inglés y vamos a pasarlo a español
#para ello, utilizaremos la funcion rename() "dplyr" nombre_nuevo = nombre_viejo
fifa20<- rename(fifa20, nombre=short_name, nombre_completo=long_name, 
                edad=age, nacimiento=dob, altura_cm=height_cm, peso_kg=weight_kg, 
                nacionalidad=nationality, equipo=club_name, liga=league_name, general=overall,
                posicion=player_positions)

#Esta sera la tabla con la que vamos a trabajar
names(fifa20)
fifa20 %>% head(20)

#Para tener un respaldo, vamos a "write" salvar esta tabla
write_csv(fifa20, "fifa23.csv")


##################################

#Utilizando la funcion summary() podemos ver un resumen de los datos y algunas mediciones
#, y glimpse() nos permite determinar rápidamente el tipo de dato
summary(fifa20)
glimpse(fifa20)

#Podemos utilizar la funcion unique(), para ver las clases unicas de un campo,
#por ejemplo veamos los nombres de todas las ligas que tenemos en la tabla
unique(fifa20$liga)
#Para contarlas, utilizaremos la funcion count()
count(fifa20, liga)
fifa20 %>% count(liga) %>% arrange(desc(n))
fifa20 %>% count(liga)
#Esto indica, que en la base de datos, tenemos 40 ligas diferentes

#Para comprobar algunos datos importantes podemos utilizar un filtro simple
#aplicando la funcion "subset"
#Por ejemplo, veamos cuales jugadores tienen un general igual o mayor a 90
los_mejores<- subset(fifa20, general >= 90)
View(los_mejores)

#La salida es una lista, para verlo como data frame, debemos crear una nueva variable
los_mejores<- subset(fifa20, general >= 90)
as.data.frame(los_mejores)
View(los_mejores)

#Utilizando la funcion count() junto con la tabla recien creada, podemos saber la nacionalidad
#de los mejores jugadores
count(los_mejores, nombre, nacionalidad, general, sort = TRUE)

#Para ordenarlos por ciertas caracteristicas, podemos utilizar "arrange()" de dplyr

#Ordenar por general de mayor a menor (desc)
arrange(los_mejores, desc(general))

#Ordenar por pais en orden alfabetico
arrange(los_mejores, nacionalidad)

##################Analisis a traves de graficos###########################

###########Gráficos#################

#Relación entre la altura y el peso
ggplot(data = fifa20) + geom_point(mapping = aes(x = altura_cm, y = peso_kg, color = "red"))

#Agreguemos ahora el atributo liga, con el argumento "color", para saber sí hay relación entre los jugadores
#más altos, y la liga donde juegan
ggplot(data = fifa20) + geom_point(mapping = aes(x =altura_cm, y = peso_kg, color = liga)) + 
  theme(legend.position = "none")
#No hay relación directa entre ambas condiciones

#Veamos si cambiando el tamaño (size) podemos ver alguna diferencia
ggplot(data = fifa20) + geom_point(mapping = aes(x = altura_cm, y = peso_kg, size = liga, color = liga)) +
  theme(legend.position = "none")

#Como tenemos muchos registros, vamos a simplificar la base de datos, y crear una nueva tabla
#solo con jugadores con un general igual o mayor a 85
mayores_85<- filter(fifa20, general >= 85, na.rm = TRUE)
mayores_85
dim(mayores_85)

#Vamos a contar, como se distribuyen estos jugadores de acuerdo a liga donde juegan
count(mayores_85, liga) %>% arrange(desc(n))
#La mayoria pertenece a la liga espanola

#Veamos la misma relacion peso y altura, con esta nueva tabla
ggplot(data = mayores_85) + geom_point(mapping = aes(x = altura_cm, y = peso_kg))
ggplot(data = mayores_85, aes(altura_cm, peso_kg)) + geom_point(color = "red") 


#Agreguemos ahora, la liga donde juegan, y veamos como se distribuyen
ggplot(data = mayores_85) + geom_point(mapping = aes(x = altura_cm, y = peso_kg, color = liga))
ggplot(data = mayores_85, aes(altura_cm, peso_kg, color = liga)) + geom_point()

#Para que sea mas facil de ver, agreguemos el atributo "shape"
ggplot(data = mayores_85) + geom_point(mapping = aes(x = altura_cm, y = peso_kg, color = liga, shape = liga))
ggplot(data = mayores_85, aes(altura_cm, peso_kg, color = liga, shape = liga)) + geom_point()

#Parece ser, que hay un grupo de jugadores, que mide mas de 1,90 y pesa mas de 90 kg
#veamos quienes son:
grandotes<- filter(mayores_85, altura_cm >= 190, peso_kg >= 90, na.rm = TRUE)
grandotes

#Cuando contamos por posicion
grandotes %>% count(posicion) %>% arrange(desc(n))

#Podemos ver que la mayoria son porteros, lo cual es bastante logico para esta posicion

###########Grafico facet################

#Podemos hacer graficos pequeños o facets, para ver como se distribuyen peso y altura en cada liga
ggplot(data = mayores_85) + geom_point(mapping = aes(x = altura_cm, y = peso_kg)) +
  facet_wrap(~liga, nrow = 2)
#Esto indica que la Premier y la liga italiana, tienen a los jugadores mas grandes

###########Otros graficos################

#En caso de no querer utilizar puntos, podemos hacer un grafico de linea suavizada
#para poder ver las relaciones entre variables
ggplot(data = mayores_85) + geom_smooth(mapping = aes(x = altura_cm, y = peso_kg))
ggplot(data = mayores_85, aes(x = altura_cm, y = peso_kg)) + geom_smooth()

#Gráfico de líneas y puntos
#Podemos combinar el un gráfico de líneas con un gráfico de puntos
ggplot(data = mayores_85)+ geom_point(mapping = aes(x = altura_cm, y = peso_kg, color = "red")) +
  geom_smooth(mapping = aes(x = altura_cm, y = peso_kg))

#Podemos simplificar un gráfico combinado, aplicando el código de la forma siguiente:
#Y así podemos poner el color que queramos a cada elemento de forma individual

ggplot(data = mayores_85, mapping = aes(x = altura_cm, y = peso_kg)) + 
  geom_point(color= "red")+
  geom_smooth(color= "black")

#También podemos agregar un aestethic adicional al punto o la línea si queremos
#En este caso, queremos diferenciar los puntos, por el nombre de la liga
ggplot(data = mayores_85, mapping = aes(x = altura_cm, y = peso_kg))+
  geom_point(mapping = aes(color = liga)) + 
  geom_smooth()

#Una última opción, para hacer el gráfico más detallado es aplicarle un filtro
#El filtro se aplica al argumento "data" de cada "geom_"
#Veamos solo los datos de la Liga Española
ggplot(data = mayores_85, mapping = aes(x = altura_cm, y = peso_kg), na.rm = TRUE) +
  geom_point(data = filter(mayores_85, liga == "Spain Primera Division"), color = "red") +
  geom_smooth(data = filter(mayores_85, liga == "Spain Primera Division"))

#####Graficos de barra#####

#Veamos como se distribuye altura de los jugadores
ggplot(data = mayores_85) + geom_bar(aes(x = altura_cm), na.rm = TRUE)
ggplot(data = mayores_85, aes(altura_cm)) + geom_bar()

#Podemos hacer un grafico de barras que indique la proporcion (porcentaje)
#de jugadores que pertenece a cada liga
#Para ello utilizamos la funcion  "stat(prop), group = 1"
ggplot(data = mayores_85) + geom_bar(mapping = aes(x = liga, y = stat(prop), group = 1))
ggplot(data = mayores_85, aes(liga, stat(prop), group = 1)) + geom_bar()

#Para poder ordenar las barras de mayor a menor, debemos utilizar la libreria "forcats"
#especificamente el argumento "fct_infreq", para orden inverso debemos utilizar "fct_rev"
library(forcats)
mayores_85 %>% ggplot(aes(x = fct_infreq(liga))) + geom_bar(fill="red") +
  theme(axis.text.x = element_text(size = 6)) + labs(x="Liga", y="Porcentaje")

#Si queremos, podemos rellenar las barras, utilizando el argumento "fill"
mayores_85 %>% ggplot(aes(x = fct_infreq(liga), fill = liga)) + geom_bar()

#Pero como los gráficos de barra deben ser de un solo color, no podemos utilizar una variable
mayores_85 %>% ggplot(aes(x = fct_infreq(liga))) + geom_bar(fill = "cadetblue1")

#####Diagrama de caja#####

ggplot(data = mayores_85, mapping = aes(x = liga, y = altura_cm)) + geom_boxplot()

#Si es más fácil visualizar los gráficos en forma horizontal, podemos utilizar "coord_flip()"
#Podemos aplicar esto a las variables: altura_cm y peso_kg
ggplot(data = mayores_85, mapping = aes(x=liga, y = altura_cm)) + geom_boxplot() +
  coord_flip()

#Podemos colorear con "fill" y suprimir la leyenda con theme(legend.position="none")
ggplot(data = mayores_85, mapping = aes(x=liga, y = peso_kg, fill = liga)) + geom_boxplot() +
  coord_flip() + theme(legend.position = "none")

###Graficos mas completos (con leyendas y etiquetas)###

#Para realizar gráficos más completos, agregaremos dos librerias
library(viridis)
library(ggrepel)

#Para agregar etiquetas a nuestro gráfico, utilizamos el argumento "labs()"
#Podemos utilizar "labs", para titulo, subtitulo, y fuente (caption)
#También podemos etiquer los ejes x e y

labs(
  ...,
  title = waiver(),
  subtitle = waiver(),
  caption = waiver(),
  tag = waiver(),
  alt = waiver(),
  alt_insight = waiver()
)

xlab(label)
ylab(label)
ggtitle(label, subtitle = waiver())
colour = "Nombre de la leyenda"

#Titulo de los ejes (los dos juntos) con la funcion "theme"
g+theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))

#Tamaño de las etiquetas de los ejes
#g+theme(axis.text = element_text(size = 8))

#Para ver los colores, utilizamos la funcion colors()
colors()

#Ejemplo de gráfico con etiquetas
ggplot(data = fifa20, mapping = aes(x = altura_cm, y = peso_kg)) + geom_point(color = "blue") + 
  labs(title = "Relación entre la altura y el peso de los jugadores",
       subtitle = "Jugadores de todas las ligas", caption = "Fuente: FIFA 2020") + 
  labs(x = "Altura (cm)") + labs(y = "Peso (kg)") + theme(axis.text=element_text(size=10),
                                                          axis.title=element_text(size=10,face="bold"))
#Otro ejemplo
ggplot(
  data = mpg,
  mapping = aes(x = fct_reorder(class, hwy), y = hwy)
) +
  geom_boxplot() +
  coord_flip() +
  labs(
    title = "Compact Cars have > 10 Hwy MPG than Pickup Trucks",
    subtitle = "Comparing the median highway mpg in each class",
    caption = "Data from fueleconomy.gov",
    x = "Car Class",
    y = "Highway Miles per Gallon"
  ) + theme(axis.text = element_text(size = 8))


argentina<- filter(fifa20, nacionalidad == "Argentina" & general >= 80)
argentina
library(forcats)
ggplot(data = argentina, mapping = aes(x = fct_infreq(liga))) + geom_bar(fill = "red") +
  labs(x = "Liga") + labs(y = "Jugadores") + labs(title = "Jugadores argentinos por Liga",
                                                  subtitle = "Incluye jugadores con overall >= 80") +
  theme(axis.text.x = element_text(size=8), axis.text.y = element_text(size = 8))

#Filtramos solo los jugadores de Argentina, que juegan en Espana, Inglaterra e Italia
esp_ita_ing<- argentina %>% filter(liga %in% c("Spain Primera Division", " Italian Serie A", 
                                               "English Premier League"))

ggplot(data = argentina, mapping = aes(x = fct_infreq(liga))) + geom_bar(fill = "aquamarine3")+
  labs(
    title = "Jugadores argentinos en las mejores ligas",
    subtitle = "Jugadores con overall mayor a 80",
    x = "Liga",
    y = "Jugadores"
  ) + theme(axis.text = element_text(size = 6)) + theme(legend.position = "none")

####Escalas de color predeterminadas####

#Son utilizadas para gráficos de puntos
#Las alternativas útiles son las escalas ColorBrewer que se han ajustado a mano 
#para que funcionen mejor para las personas con tipos comunes de daltonismo.

#Gráfico con colores por defecto
ggplot(argentina, aes(altura_cm, peso_kg)) + geom_point(aes(color = liga))

install.packages("RColorBrewer")
library(RColorBrewer)
display.brewer.all()
#Gráfico con ColorBrewer
ggplot(argentina, aes(altura_cm, peso_kg)) + geom_point(aes(color = liga, shape = liga)) + 
  scale_color_brewer(palette = "Accent") 

######################################################

####También podemos graficar con el paquete "lessR"####

library(lessR)
#Para poder utilizar el paquete, la tabla debe ser obligatoriamente un data frame
#Para convertir nuestra tabla a data frame, utilizaremos la funcion "as.data.frame"
#Todas las opciones de lessR: https://rdrr.io/cran/lessR/man/style.html

brasil<- filter(fifa20, nacionalidad == "Brazil" & general >=82)
brasil

#Los gráficos de lessR después de ejecutarse, arrojan un resumen de los datos
#Estos gráficos tienen configuraciones predeterminadas, que facilitan su visualización

#Grafico de barra
#BarChart(variable, data = tabla_datos)
BarChart(altura_cm, data = brasil, sort = "-")
BarChart(peso_kg, data = brasil)
BarChart(liga, data = brasil, sort = "-", cex.axis = 0.6)


#A un gráfico de barra en lessR podemos agregarle muchas caracteristicas:

#fill=relleno
#fill=colores en plural para degradado ("reds", "rusts", "browns", "olives", "greens"...)
#color=color de linea de borde de las barras
#trans= transparencia va de 0.1 a 1
#values_color= color de los datos
#sort= ordenar los datos de mayor a menor (signo menos - ) o viceversa (signo más + )
#values_size = color de los números dentro de las barras
#rotate_x= para rotar las etiquetas del eje x va de 0.1 a 1

BarChart(liga, data = brasil,fill="cyan", color="gray", 
         trans=.1, values_color="black", sort="-", 
         xlab = "Liga", ylab = "Porcentaje")

#Podemos poner las barras horizontales con el argumento "horiz=TRUE"
BarChart(liga, data = brasil, values="off", fill = "emeralds", horiz=TRUE, sort="-") 

#Para realizar un degradado, utilizamos el argumento "fill=" y un color en plural
BarChart(liga, data = brasil, fill = "magentas", color = "gray",values_color="black", sort="-")
# "reds", "rusts", "browns", "olives", "greens", "emeralds", "turquoises", 
#"aquas", "blues", "purples", "violets", "magentas", and "grays"

#Existe una paleta de colores similar que se llama "color-blind family"
#Opciones:  "viridis", "cividis", "magma", "inferno", "plasma"
BarChart(liga, data = brasil, fill = "plasma", sort = "-")

#Para realizar un grafico de barra con mas de una variable o de variables apiladas
#debemos utilizar el argumento "by=variable"
#La segunda variable determina la distribucion de los stacks
BarChart(liga, data = brasil, by = general,  sort = "-")

#Utilizando "stack100 = TRUE", las barras ocuparan todo el alto del grafico
BarChart(liga, data = brasil, by = general,  sort = "-", stack100 = TRUE, fill = "viridis")

#Y si queremos barras horizontales aplicamos "horiz=TRUE"
BarChart(liga, data = brasil, by = general, sort = "-", fill = "blues", horiz = TRUE, 
         stack100 = TRUE, values_color="black")

#Utilizando el argumento "by1" crearemos graficos pequenos en serie
#Sería el equivalente a los gráficos facet de ggplot()
BarChart(general, data = brasil, by1 = liga, fill = "red")

##Graficos circulares o de torta##

#Para crear un grafico circular, debemos utilizar la funcion PieChart()
#PieChart(variable, data = tabla_datos)

PieChart(liga, data = brasil)
#Este gráfico permite ver los porcentajes de forma inmediata

#Para que aparezca el circulo completo, utilizaremos el argumento "hole=0", va del 0 a 1.0
PieChart(liga, data = brasil, hole=0, quiet=TRUE)

###Histogramas con lessR

#Para realizar un histograma, solo debemos utilizar la funcion "Histogram(nombre_variable)"
Histogram(data = brasil, altura_cm)
Histogram(data = brasil, peso_kg, fill = "reds")
Histogram(data = brasil, peso_kg, fill = "blue")

#Para entender mejor la distribucion, podemos agregar un grafico de densidad al histograma
#Gráfica de densidad: Una curva suave que estima la distribución subyacente en los datos.
Histogram(data = brasil, peso_kg, density = TRUE)

###Diagramas de dispersion con lessR

#Para hacer un diagrama de dispersión, solo debemos utilizar la funcion Plot() y dos variables
Plot(data = brasil, altura_cm, peso_kg, color = "red")

#POdemos hacer un diagrama de dispersion con tres variables
#La tercera variable se agrega con el argumento "size=" y sirve para indicar el tamano del circulo
Plot(data = brasil, altura_cm, general, size = peso_kg)

#Otra opcion para multiples variables, es una matriz de diagramas de dispersion
#Para construirla debemos utilizar un vector "c"
Plot(data= brasil, c(altura_cm, peso_kg, general), fit="lm")
#Super util para comparar la correlacion entre multiples variables

#Podemos hacer graficos con variables continuas y categoricas
#Para agregar una variable categorica, utilizamos el argumento "by="
Plot(data = brasil, altura_cm, peso_kg, by = liga)

#Gráfico de violin
#Plot(datos, variable)
Plot(data = brasil, altura_cm)

#Graficos solo con variables categoricas

#Podemos realizar cualquier tipo de grafico, solo utilizando variables categoricas
#Debemos pensar si alguno de estos graficos, puede ser util para nuestro analisis
Plot(data = brasil, liga, posicion)