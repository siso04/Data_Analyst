#En esta lección aprenderemos como hacer gráficos con una mayor cantidad de detalles y especificaciones
#Para una guía con todos los detalles, consultar la Cheat Sheet de ggplot2

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

#Para agregar etiquetas a nuestro gráfico, utilizamos el argumento "labs()"
#Podemos utilizar "labs", para titulo, subtitulo, y fuente

#Etiquetas más comunes de la función labs()

# Título:    title =
# Subitiulo: subtitle =
# Fuente:    caption =
# Eje x:     x =
# Eje y:     y =
# Título de la leyenda: colour =
#
#

#Ejemplo

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(color = "red") +
  labs(title = "Altura y peso", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle")

#También puede usar labs() para reemplazar los títulos de los ejes y las leyendas. 
#Por lo general, es una buena idea reemplazar los nombres cortos de las variables 
#con descripciones más detalladas e incluir las unidades.

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(color = "black") +
  labs(title = "Relación entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)")

###-------------------Anotaciones----------------------###

#Además de etiquetar los componentes principales de su gráfico, a menudo es útil 
#etiquetar observaciones individuales o grupos de observaciones.

#La primera herramienta que tienes a tu disposición es geom_text()
#Esto hace posible agregar etiquetas textuales a sus gráficos

#geom_text(aes(label = variable), data = datos_para_graficar)
#Para definir el tamano de la etiqueta, utilizamos: size = 3

#Para que sea más fácil de visualizar, vamos restringir la cantidad de datos
los_mejores <- arg_bra %>% filter(overall >= 86)
los_mejores

#Ahora vamos a ver como los mejores, se ubican en nuesto grafico de altura y peso

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(color = "red") +
  labs(title = "Relación entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  geom_text(aes(label = short_name), data = los_mejores, check_overlap = TRUE, size = 3)

#Podemos mejorar un poco las cosas cambiando a geom_label() que dibuja un rectángulo detrás del texto
#y facilita ver las etiquetas

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(aes(color = nationality)) +
  labs(title = "Relación entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  geom_label(aes(label = short_name), data = los_mejores, size = 3)

#Podemos usar el paquete ggrepel. Este útil paquete ajustará automáticamente las etiquetas 
#para que no se superpongan
library(ggrepel)
#ggrepel::geom_label_repel(aes(label = variable), data = datos, size = 3)

ggplot(data = arg_bra, aes(height_cm, weight_kg, colour = nationality)) + geom_point(color = "red") +
  labs(title = "Relación entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  ggrepel::geom_label_repel(aes(label = short_name), data = los_mejores, size = 3)

#### Funcion theme()

#Son una forma poderosa de personalizar los componentes que no son datos de sus gráficos: 
#es decir, títulos, etiquetas, fuentes, fondo, líneas de cuadrícula y leyendas. 
#Los temas se pueden usar para dar a las tramas un aspecto personalizado consistente.

#Son muchísimas opciones, por eso se recomienda, consultar el manual original aquí: 
#https://ggplot2.tidyverse.org/reference/theme.html

#Con la función theme() podremos:

# Cambiar el color de fondo: theme(plot.background = element_rect(fill = "green"))
# Cambiar la linea de borde del gráfico: theme(panel.border = element_rect(linetype = "dashed", fill = NA))
# Modificar detalles en los ejes: theme(axis.line = element_line(size = 3, colour = "grey80"))
# Ajustar la posicion de la leyenda: theme(legend.justification = "top"/ "bottom")
# Colocar la leyenda dentro del gráfico
# Entre otras

#En caso de utilizar una leyenda para el gráfico, podemos quitarla, utilizando el 
#argumento (theme(legend.position = "none"), por defecto, la leyenda siempre aparece activa

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(aes(color = nationality)) +
  labs(title = "Relación entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  geom_label(aes(label = short_name), data = los_mejores, size = 3) +
  theme(legend.position = "none")
  
###-------------------Escalas----------------------###

#La tercera forma en que puede mejorar su gráfico para la comunicación es ajustar las escalas. 
#Las escalas controlan el mapeo de valores de datos a cosas que puedan percibirse.

#Normalmente, ggplot2 agrega escalas automáticamente para usted

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(aes(color = nationality)) +
  labs(title = "Relación entre la altura y el peso de los jugadores", 
       subtitle = "Altura en cm y peso en kg", 
       caption = "Fuente: base de datos de FIFA en Kaggle",
       x = "Peso (kg)",
       y = "Altura (cm)") +
  geom_label(aes(label = short_name), data = los_mejores, size = 3) +
  theme(legend.position = "none")

#Es posible que desee modificar algunos de los parámetros de la escala predeterminada. 

#1. Esto le permite hacer cosas como cambiar los ejes o las etiquetas de la leyenda
#2. Es posible que desee reemplazar la escala por completo y usar un algoritmo completamente diferente. 
#A menudo, puede hacerlo mejor que el predeterminado porque sabe más sobre los datos.

##1. Axis ticks and legend keys

#Hay dos argumentos principales que afectan la apariencia de las marcas en los ejes y las claves en la leyenda:
#breaks and labels.

#Breaks: controla la posición de las marcas, o los valores asociados
#Labels: controla la etiqueta de texto asociada con cada marca
#Para aplicarlos necesitamos la funcion: scale_y_continuous o scale_x_continuous

#Cuando utilizamos "break" podemos modificar y sobrescribir la escala de los datos por defecto
#podemos definir, donde comienza y termina, la escala de valores de los ejes x e y
ggplot(data = arg_bra, aes(height_cm, weight_kg)) +
  geom_point(color = "red") +
  scale_y_continuous(breaks = seq(60, 90, by = 5)) + #El eje "y" comenzará en 60 y terminará en 90, dividido de 5
  scale_x_continuous(breaks = seq(170, 190, by = 5)) #El eje "x" comenzará en 170 y terminará en 190, dividido de 5

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5)) #El eje "y" comenzará en 15 y terminará en 40

#Por otra parte, podemos utilizar "labels = NULL" para ocultar los valores del gráfico
#En ese caso, no se muestra ninguna etiqueta en los ejes

ggplot(data = arg_bra, aes(height_cm, weight_kg)) + geom_point(color = "blue") +
  scale_y_continuous(labels = NULL) +
  scale_x_continuous(labels = NULL)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)

##2. Diseño de leyenda

#El uso más común de "breaks" y "labels" es para ajustar los ejes, pero existen
#otros argumentos, que pueden ser utilizados con el mismo fin

#Para controlar la posición general de la leyenda, necesita usar un "theme()"
#Los "themes()" controlan la parte sin datos del gráfico

#El ajuste del tema legend.position controla dónde se dibuja la leyenda

base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) #Este es el gráfico

base + theme(legend.position = "left") #Leyenda a la izquierda
base + theme(legend.position = "top")  #Leyenda arriba
base + theme(legend.position = "bottom") #Leyenda abajo
base + theme(legend.position = "right") #Leyenda a la derecha (ubicación por defecto)
#También puede usar legend.position = "none" para suprimir la visualización de la leyenda por completo.

#Para controlar la visualización de leyendas individuales, 
#utilice guides() junto con guide_legend() o guide_colourbar().

#La función guides, nos permite definir en cuantas filas podemos poner la leyenda y el tamaño de las letras
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
#Las alternativas útiles son las escalas ColorBrewer que se han ajustado a mano 
#para que funcionen mejor para las personas con tipos comunes de daltonismo.

#Gráfico con colores por defecto
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

#Gráfico con ColorBrewer
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_colour_brewer(palette = "Set1")

#Podemos combinar los colores, con la forma de los puntos
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_colour_brewer(palette = "Spectral")

###---------------------Zoom al gráfico----------------------###

#Hay tres formas de controlar los límites de representación de datos de un gráfico:

#Ajustar qué datos se trazan
#Estableciendo los límites en cada escala
#Configuración de xlim y ylim en coord_cartesian()

#Para ampliar una región de la gráfica, generalmente es mejor usar coord_cartesian()
ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30))

#También podemos hacer lo mismo con la funcion filter() de dplyr

mpg %>%
  filter(displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>%
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

###---------------------Temas----------------------###

#Puedes personalizar los elementos que no son datos del gráfico con un tema
#Los temas son maneras rápidas de dar estilo a los gráficos

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

###---------------------Guardando los gráficos-----------------###

#Hay dos formas principales de sacar sus gráficos de R y llevarlos a su redacción final: 
#ggsave() y knitr. ggsave() guardará el gráfico más reciente en el disco

ggplot(mpg, aes(displ, hwy)) + geom_point() +
  labs(title = "Este es el título del gráfico")

#Para guardarlo
ggsave("my-plot.pdf")

#Hay cinco opciones principales que controlan el tamaño de la figura: 
#fig.width, fig.height, fig.asp, out.width y out.height.
