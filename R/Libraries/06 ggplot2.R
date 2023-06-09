#En esta lecci�n aprenderemos como hacer gr�ficos con una mayor cantidad de detalles y especificaciones
#Para una gu�a con todos los detalles, consultar la Cheat Sheet de ggplot2

#Utilizaremos las siguientes bibliotecas:

library(tidyverse)
library(viridis)
library(ggrepel)

#Utilizaremos la base de datos de fifa

fifa <- read.csv("fifa_dplyr.csv", encoding = "UTF-8")
fifa
dim(fifa)

#Aplicaremos un filtro, para reducir la dimension de la base de datos

arg_bra <- fifa %>% filter(nationality == "Argentina" | nationality == "Brazil")
arg_bra
dim(arg_bra)

#Vamos a eliminar la columna "Long name y players positions" porque ocupan mucho espacio

arg_bra <- arg_bra %>% select(-long_name, -player_positions)
arg_bra

###-------------------Etiquetado----------------------###

#Para agregar etiquetas a nuestro gr�fico, utilizamos el argumento "labs()"
#Podemos utilizar "labs", para titulo, subtitulo, y fuente

#Etiquetas m�s comunes de la funci�n labs()

# T�tulo:    title =
# Subitiulo: subtitle =
# Fuente:    caption =
# Eje x:     x =
# Eje y:     y =
# T�tulo de la leyenda: colour =
#
#

#Ejemplo

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(color = "red") +
  labs(title = "Altura y peso", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle")

#Tambi�n puede usar labs() para reemplazar los t�tulos de los ejes y las leyendas. 
#Por lo general, es una buena idea reemplazar los nombres cortos de las variables 
#con descripciones m�s detalladas e incluir las unidades.

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(color = "black") +
  labs(title = "Relaci�n entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)")

###-------------------Anotaciones----------------------###

#Adem�s de etiquetar los componentes principales de su gr�fico, a menudo es �til 
#etiquetar observaciones individuales o grupos de observaciones.

#La primera herramienta que tienes a tu disposici�n es geom_text()
#Esto hace posible agregar etiquetas textuales a sus gr�ficos

#geom_text(aes(label = variable), data = datos_para_graficar)
#Para definir el tamano de la etiqueta, utilizamos: size = 3

#Para que sea m�s f�cil de visualizar, vamos restringir la cantidad de datos
los_mejores <- arg_bra %>% filter(overall >= 86)
los_mejores

#Ahora vamos a ver como los mejores, se ubican en nuesto grafico de altura y peso

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(color = "red") +
  labs(title = "Relaci�n entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  geom_text(aes(label = short_name), data = los_mejores, check_overlap = TRUE, size = 3)

#Podemos mejorar un poco las cosas cambiando a geom_label() que dibuja un rect�ngulo detr�s del texto
#y facilita ver las etiquetas

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(aes(color = nationality)) +
  labs(title = "Relaci�n entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  geom_label(aes(label = short_name), data = los_mejores, size = 3)

#Podemos usar el paquete ggrepel. Este �til paquete ajustar� autom�ticamente las etiquetas 
#para que no se superpongan
library(ggrepel)
#ggrepel::geom_label_repel(aes(label = variable), data = datos, size = 3)

ggplot(data = arg_bra, aes(height_cm, weight_kg, colour = nationality)) + geom_point(color = "red") +
  labs(title = "Relaci�n entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  ggrepel::geom_label_repel(aes(label = short_name), data = los_mejores, size = 3)

#### Funcion theme()

#Son una forma poderosa de personalizar los componentes que no son datos de sus gr�ficos: 
#es decir, t�tulos, etiquetas, fuentes, fondo, l�neas de cuadr�cula y leyendas. 
#Los temas se pueden usar para dar a las tramas un aspecto personalizado consistente.

#Son much�simas opciones, por eso se recomienda, consultar el manual original aqu�: 
#https://ggplot2.tidyverse.org/reference/theme.html

#Con la funci�n theme() podremos:

# Cambiar el color de fondo: theme(plot.background = element_rect(fill = "green"))
# Cambiar la linea de borde del gr�fico: theme(panel.border = element_rect(linetype = "dashed", fill = NA))
# Modificar detalles en los ejes: theme(axis.line = element_line(size = 3, colour = "grey80"))
# Ajustar la posicion de la leyenda: theme(legend.justification = "top"/ "bottom")
# Colocar la leyenda dentro del gr�fico
# Entre otras

#En caso de utilizar una leyenda para el gr�fico, podemos quitarla, utilizando el 
#argumento (theme(legend.position = "none"), por defecto, la leyenda siempre aparece activa

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(aes(color = nationality)) +
  labs(title = "Relaci�n entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  geom_label(aes(label = short_name), data = los_mejores, size = 3) +
  theme(legend.position = "none")
  
###-------------------Escalas----------------------###

#La tercera forma en que puede mejorar su gr�fico para la comunicaci�n es ajustar las escalas. 
#Las escalas controlan el mapeo de valores de datos a cosas que puedan percibirse.

#Normalmente, ggplot2 agrega escalas autom�ticamente para usted

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(aes(color = nationality)) +
  labs(title = "Relaci�n entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  geom_label(aes(label = short_name), data = los_mejores, size = 3) +
  theme(legend.position = "none")

#Es posible que desee modificar algunos de los par�metros de la escala predeterminada. 

#1. Esto le permite hacer cosas como cambiar los ejes o las etiquetas de la leyenda
#2. Es posible que desee reemplazar la escala por completo y usar un algoritmo completamente diferente. 
#A menudo, puede hacerlo mejor que el predeterminado porque sabe m�s sobre los datos.

##1. Axis ticks and legend keys

#Hay dos argumentos principales que afectan la apariencia de las marcas en los ejes y las claves en la leyenda:
#breaks and labels.

#Breaks: controla la posici�n de las marcas, o los valores asociados
#Labels: controla la etiqueta de texto asociada con cada marca
#Para aplicarlos necesitamos la funcion: scale_y_continuous o scale_x_continuous

#Cuando utilizamos "break" podemos modificar y sobrescribir la escala de los datos por defecto
#podemos definir, donde comienza y termina, la escala de valores de los ejes x e y
ggplot(data = arg_bra, aes(height_cm, weight_kg)) +
  geom_point(color = "red") +
  scale_y_continuous(breaks = seq(60, 90, by = 5)) + #El eje "y" comenzar� en 60 y terminar� en 90, dividido de 5
  scale_x_continuous(breaks = seq(170, 190, by = 5)) #El eje "x" comenzar� en 170 y terminar� en 190, dividido de 5

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5)) #El eje "y" comenzar� en 15 y terminar� en 40

#Por otra parte, podemos utilizar "labels = NULL" para ocultar los valores del gr�fico
#En ese caso, no se muestra ninguna etiqueta en los ejes

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(color = "blue") +
  scale_y_continuous(labels = NULL) +
  scale_x_continuous(labels = NULL)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)

##2. Dise�o de leyenda

#El uso m�s com�n de "breaks" y "labels" es para ajustar los ejes, pero existen
#otros argumentos, que pueden ser utilizados con el mismo fin

#Para controlar la posici�n general de la leyenda, necesita usar un "theme()"
#Los "themes()" controlan la parte sin datos del gr�fico

#El ajuste del tema legend.position controla d�nde se dibuja la leyenda

base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) #Este es el gr�fico

base + theme(legend.position = "left") #Leyenda a la izquierda
base + theme(legend.position = "top")  #Leyenda arriba
base + theme(legend.position = "bottom") #Leyenda abajo
base + theme(legend.position = "right") #Leyenda a la derecha (ubicaci�n por defecto)
#Tambi�n puede usar legend.position = "none" para suprimir la visualizaci�n de la leyenda por completo.

#Para controlar la visualizaci�n de leyendas individuales, 
#utilice guides() junto con guide_legend() o guide_colourbar().

#La funci�n guides, nos permite definir en cuantas filas podemos poner la leyenda y el tama�o de las letras
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(colour = guide_legend(nrow = 1, override.aes = list(size = 4)))

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(aes(colour = nationality)) +
  theme(legend.position = "bottom") +
  guides(colour = guide_legend(nrow = 1, override.aes = list(size = 4))) +
  labs(colour = "Nacionalidad")

#3. Escala de colores - scale_colour_brewer()

#Otra escala que se personaliza con frecuencia es la del color. 
#Las alternativas �tiles son las escalas ColorBrewer que se han ajustado a mano 
#para que funcionen mejor para las personas con tipos comunes de daltonismo.

#Gr�fico con colores por defecto
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

#Gr�fico con ColorBrewer
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_colour_brewer(palette = "Set1")

#Podemos combinar los colores, con la forma de los puntos
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_colour_brewer(palette = "Spectral")

###---------------------Zoom al gr�fico----------------------###

#Hay tres formas de controlar los l�mites de representaci�n de datos de un gr�fico:

#Ajustar qu� datos se trazan
#Estableciendo los l�mites en cada escala
#Configuraci�n de xlim y ylim en coord_cartesian()

#Para ampliar una regi�n de la gr�fica, generalmente es mejor usar coord_cartesian()
ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30))

#Tambi�n podemos hacer lo mismo con la funcion filter() de dplyr

mpg %>%
  filter(displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>%
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

###---------------------Temas----------------------###

#Puedes personalizar los elementos que no son datos del gr�fico con un tema
#Los temas son maneras r�pidas de dar estilo a los gr�ficos

#Por el momento, existen solo 7 temas

# theme_bw()
# theme_linedraw()
# theme_light()
# theme_dark()
# theme_minimal()
# theme_classic()
# theme_void()

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + 
  geom_point(aes(color = nationality)) +
  theme_bw()

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + 
  geom_point(aes(color = nationality)) +
  theme_classic()

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + 
  geom_point(aes(color = nationality)) +
  theme_dark()

###---------------------Guardando los gr�ficos-----------------###

#Hay dos formas principales de sacar sus gr�ficos de R y llevarlos a su redacci�n final: 
#ggsave() y knitr. ggsave() guardar� el gr�fico m�s reciente en el disco

ggplot(mpg, aes(displ, hwy)) + geom_point() +
  labs(title = "Este es el t�tulo del gr�fico")

#Para guardarlo
ggsave("my-plot.pdf")

#Hay cinco opciones principales que controlan el tama�o de la figura: 
#fig.width, fig.height, fig.asp, out.width y out.height.
