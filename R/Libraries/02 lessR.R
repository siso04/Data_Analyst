#En esta lección aprenderemos a utilizar las principales herramientes de lessR

#La biblioteca lessR es útil para:

#1. Seleccionar filas y columnas de una forma particular: utilizando la la función corchete - punto - parentesis"[.()]"
#2. Seleccionar filas y columnas especificas con: tabla[1:10, .(columnas)], tabla[.(filas), 1:5]
#3. Realizar selecciones aleatorias, utilizamos la funcion random(): tabla[.(random(10)), .(columnas)]
#4. Ordenar filas con Sort(): Sort(tabla, columna)/ direction con un signo mas "+" (ascedente) o un signo menos "-" (descendente)
#fifa %>% Sort(overall, direction = "-")
#5. Renombrar una variable de una tabla funcion rename(): tabla <- rename(tabla, nombre_viejo, nombre_nuevo)
#ADVERTENCIA: no utilizar esta funcion, con dplyr, porque crea conflicto, ambas bibliotecas, tienen una
#funcion "rename"
#6. Reshape data (remodelar datos), tablas largas y anchas: reshape_long() y reshape_wide()
#7. Trabajar con tablas dinámicas: pivot(). Tablas dinamicas, tablas de frecuencia, dividir los datos en
#cuartiles, ordenar los datos (sort), y hacer tablas de dos/tres dimensiones (una verdadera tabla dinámica)
#8. Hacer gráficos: BarChart(), PieChart(), BarChart() con dos o más variables (by=variable), gráficos de barras
#comparativas con Barchart(by1 =), histogramas Histogram(), diagramas de dispersión con Plot(requiere dos variables),
#gráfico de Violin Plot(requiere una sola variable), gráfico de Cleveland Plot(row_names), gráficos solo de variables
#cualitativas

#Primero necesitamos las bibliotecas
library(lessR)
library(tidyverse)

#Utilizaremos la tabla de fifa como ejemplo
fifa <- read.csv("fifa_dplyr.csv", encoding = "UTF-8")
fifa
str(fifa)
glimpse(fifa)

d <- Read("Employee") #Tabla del paquete lessR
storms #Tabla del paquete tidyverse

#---------------Seleccion de filas y columnas----------------------------

#La libreria lessR proporciona la función corchete - punto - parentesis"[.()]" 
#para obtener filas y columnas con condiciones especificas, y si es necesario sus indices

#La sintaxis de la funcion es: tabla[.(rows), .(columns)]
#A las columnas y filas seleccionadas, podemos aplicarle operadores logicos: igual, mayor que, menor que, etc
fifa[.(nationality == "Brazil" & overall > 85 ), .(short_name:overall, nationality)]
fifa[.(nationality == "Argentina"), .(short_name, age, dob)] %>% head(10)
storms[.(name == "Amy"), .(day:status, name)]
d[.(Gender=="M" & Post>90), .(Years:Salary, Post)]

#Es como un filtro doble, es decir, filtramos por fila y por columna al mismo tiempo
#De la fila quiero a los jugadores de Brasil con overall mayor a 85, 
#y de la columna, quiero ver las columnas de short_name:overall y nationality

#Si queremos negar la expresion, utilizamos exclamacion "!", para deseleccionar columnas
#utilizamos el signo de menos "-"
#tabla[.(!(rows)), -.(columns)]
d[.(!(Gender=="M" & Post>90)), -.(Dept:Plan, Pre)]
fifa[.(!(nationality == "Brazil" & overall > 85 )), .(short_name:overall, nationality)]
fifa[.(!(age == 27)), .(age, dob)]

###Seleccionar filas y columnas por numero (no por nombre)

#Si queremos definir un numero de filas especifico, utilizamos dos puntos ":"
#Esto seria lo mismo que utilizar la funcion "head()"
#Por ejemplo: fifa[1:10], seria igual a fifa %>% head(10)

d[1:3, .(Years:Salary, Post)]
fifa[1:10, .(short_name:weight_kg)]
fifa[1:5, .(age, dob)]
#Nos muestra las primeras diez filas, con esas variables

#Si queremos definir un numero de columnnas especifico, utilizamos dos puntos ":"
d[.(Gender=="M" & Post>90), 1:3]
fifa[.(nationality == "Brazil" & overall > 85), 2:7]

###Selecciones aleatorias

#Para realizar selecciones aleatorias, utilizamos la funcion random()
tabla[.(random(numero)), .(columnas)]
d[.(random(5)), .(Years:Salary)]
fifa[.(random(10)), .(short_name, club_name, overall)]
#El numero entre parentesis, indica la cantidad de filas de salida, seria como el "head"

#Tambien podemos definir un porcentaje de filas del total, utilizando numeros desde 0.1 hasta 1
d[.(random(0.3)), .(Years:Salary)]
fifa[.(random(0.001)), .(short_name, club_name, overall)]

#---------------Ordenar filas con Sort()------------------------

#Para ordenar las filas con lessR, debemos utilizar la funcion Sort()
d <- Sort(d, Gender)
fifa %>% Sort(overall) 
fifa[.(nationality == 'Brazil'), .( short_name:weight_kg)] %>% head(20) %>%  Sort(height_cm)

#Para ordenarlos en forma ascendente o descendente utilizamos el argumento direction
# con un signo mas "+" (ascedente) o un signo menos "-" (descendente)
d <- Sort(d, Gender, direction = "-")
fifa %>% Sort(overall, direction = "-")
fifa[.(nationality == 'Brazil'), .( short_name:weight_kg)] %>% head(20) %>%  Sort(height_cm, direction = "-")

#Si utilizamos dos variables, podemos indicarle la direction de cada una 
d <- Sort(d, c(Gender, Salary), direction=c("+", "-"))
fifa %>% Sort(c(overall, height_cm), direction = c("-", "+"))


#---------------Renombrar una variable de una tabla funcion rename()---------------

#Para renombrar una variable, debemos utilizar la funcion rename()

#Nombres originales
names(d)
names(fifa)

#Para renombrar debemos seleccionar la tabla "d", nombre viejo "Salary" y nombre nuevo "AnnualSalary"
d <- rename(d, Salary, AnnualSalary)
d

fifa <- rename(fifa, short_name, nombre)
names(fifa)

#--------------Reshape data (remodelar datos), tablas largas y anchas---------------

#Una tabla de datos de formato ancho tiene múltiples mediciones de la misma unidad de análisis (p. ej., persona) 
#a lo largo de la fila de datos que generalmente estan repetidos de forma innecesaria. 
#La conversión a formato largo, ofrece la forma de tres columnas nuevas a partir del formato ancho de entrada: 
#el nombre de la variable de agrupación, el nombre de los valores de respuesta y el nombre del campo ID.

#Tabla original
d <- Read("Anova_rb")
d

#Ahora aplicamos reshape() para alargar la tabla
reshape_long(d, c("sup1", "sup2", "sup3", "sup4"))
#Este tipo de operacion puede ser util, por ejemplo, si necesitamos hacer queries en SQL

#Tabla ancha con reshape_wide()
#Tambien podemos aplicar la estrategia inversa, convertir una tabla larga, a una tabla corta
#Esta la opcion mas comun para el analisis de datos, y se utiliza la funcion reshape_wide()

#Tabla larga
dl <- reshape_long(d, sup1:sup4) 
dl

#Ahora la pasamos a tabla corta con reshape_wide()
reshape_wide(dl, group="Group", response="Value", ID="Person")
#Los valores de cada variable provienen de la tabla anterior

CountAll(dl)

#---------------Estadistica Descriptiva con tablas Dinamicas pivot()-----------------

#La función pivot() de lessR sirve como fuente única para una amplia variedad y tipos 
#de estadísticas descriptivas para una o más variables. 
#Las estadísticas se calculan para todo el conjunto de datos a la vez 
#o por separado para diferentes grupos de datos.

#Los estadisticos que podemos utilizar en las tablas dinamicas, son los siguientes:
# Statistic	Meaning
# sum	        sum
# mean	      arithmetic mean
# median	    median
# min	        minimum
# max	        maximum
# sd	        standard deviation
# var	        variance
# skew	      skew
# kurtosis	  kurtosis
# IQR	        inter-quartile range
# mad	        mean absolute deviation
# quantile	  min, quartiles, max
# table	cell  counts or proportions

#La construccion de tablas dinamicas con lessR, incluye 5 parametros

#1. data: el data frame que incluye las variables de interés.
#2. compute: una o más funciones que especifican los estadísticos correspondientes a calcular.
#3. variable: una o más variables numéricas para resumir, ya sea por agregación
#sobre grupos o toda la muestra como un solo grupo.
#4. by: especificar la opción de agregado según la(s) variable(s) categórica(s) que define(n) los grupos.
#5. by_cols: las variables categóricas opcionales que definen los grupos o celdas
#para calcular los valores agregados, enumerados como columnas en una tabla bidimensional.

#Veamos un ejemplo
d <- Read("Employee")
d
fifa
names(fifa)

#Vamos a reducir la dimension de la tabla fifa a solo 50 registros
fa <- fifa[1:50, .(short_name:club_name)]
fa

#Crearemos una tabla pivot() con la tabla "d", el computo "mean", la variable "Years", 
#y la agruparemos por "Dept" y "Gender" 
a <- pivot(data=d, compute=mean, variable=Years, by=c(Dept, Gender))
a

f <- pivot(data = fa, compute = mean, height_cm, by=c(nationality))
f

#Ahora hagamos una tabla nueva con un conjunto de estadisticos particulares
pivot(d, c(mean, median, sd, IQR), Salary, Dept)
pivot(d, c(mean,sd,skew,kurtosis), Salary, Dept, digits_d=3)
pivot(fa, c(mean,sd,skew,kurtosis), weight_kg, nationality)

#Podemos cambiar el nombre de salida de las variables utilizando el argumento "out_names"
pivot(d, c(mean, median), Salary, c(Gender,Dept), out_names=c("MeanSalary", "MedianSalary"))

#Tambien podemos hacer agrupaciones/agregaciones con multiples variables
#Agruparemos por Years y Salary, y tambien por Dept y Gender
pivot(d, mean, c(Years, Salary), c(Dept, Gender), digits_d=0)

#Para poder realizar calculos mas precisos y eliminar los nulos, utilizamos show_n=FALSE
pivot(d, mean, c(Years, Salary), Dept, digits_d=2, show_n=FALSE)

#Para resumenes mas sencillos podemos analizar toda la tabla
pivot(d, mean, Years)
pivot(fa, c(mean, sd), age)

#Tambien utilizar estadisticos y nombres particulares
pivot(d, mean, c(Years, Salary), digits_d=2, out_names=c("MeanYear", "MeanSalary"))

#-----------------Tablas de frecuencia (veces que se repite un valor)------------------

#La tabla de frecuencia, permite ver cuántas veces se repite un valor
#Para realizar una tabla de frecuencia, al argumento "compute" de pìvot(), debemos colocarle
#el argumento "table"

d <- Read("Mach4", quiet=TRUE)
d

pivot(fifa, table, age)
pivot(d, table, m06)
pivot(fa, table, height_cm)
#Nos muestra la frecuencia, que se repite para los valores de "m06"

pivot(d, table, m06, m07)
#En este segundo caso vemos la frecuencia de "m06" y las agrupamos por "m07"

#También puede agregar otras estadísticas simultáneamente además de la tabla de frecuencia, 
#aunque, por supuesto, solo tiene sentido si la variable agregada es numérica
pivot(d, c(mean,sd,table), m06, c(m07, m10))

#------Division de los datos en cuartiles----------------------

#Para realizar el calculo de los cuartiles, al argumento "compute" de pìvot(), debemos colocarle
#el argumento "quantile"
#La division que ofrece la libreria por defecto es de cuatro clases de 25% cada una

d <- Read("Employee", quiet=TRUE)
pivot(d, quantile, Years, c(Dept, Gender))

pivot(fifa, quantile, age)
pivot(fifa, quantile, height_cm)
pivot(fifa, quantile, age, c(club_name, league_name))


#Si queremos dividir de acuerdo a otros valores que no sean cuartiles, o cuatro partes
#debemos utilizar el argumento "q_num", y colocar un número para dividir los datos
pivot(d, c(mean,sd,quantile), c(Years,Salary), q_num=5, digits_d=2)
pivot(fifa, quantile, height_cm, q_num = 3)

#--------------- Ordenar los datos--------------------------

#Podemos ordenar la tabla pivot() en base a una o varias variables, utilizando al final
#el argumento "sort=". Establézcalo en "-" para una ordenación descendente. 
#Establézcalo en "+" para una ordenación ascendente.
pivot(d, mean, Salary, c(Dept, Gender), sort="-")
pivot(fifa, mean, age, c(nationality), sort = "-")

#Especifique el parámetro "sort_var" para especificar el nombre o el número de columna de la variable a ordenar.
pivot(d, c(mean, median), Salary, c(Gender,Dept), out_names=c("MeanSalary", "MedianSalary"),
      sort="-", sort_var="MeanSalary")

#-----------Tablas de dos dimensiones-----------------------

#Para calcular tablas de dos dimensiones agregamos al argumento "by_cols" una variable 
pivot(d, mean, Salary, Dept, Gender)
pivot(fa, mean, age, height_cm, nationality)
pivot(fa, mean, age, height_cm, by_cols = nationality)

#Podemos aplicar lo mismo, para varias variables
pivot(d, mean, Salary, Dept, c(Gender, Plan))

##########---------------Gráficos con lessR-----------------------------#############

#A diferencia de ggplot() con la biblioteca lessR los gráficos se hacen de manera
#más rápida y automatizada. La sintaxis es mucho más sencilla y directa.
library("lessR")
d <- Read("Employee")
d

#Vamos a reducir la dimension de la tabla fifa a solo 100 registros
fa <- fifa[1:100, .(short_name:club_name)]
fa

####---Gráfico de barras

#Para crear un grafico de barras, utilizamos la funcion "BarChart()"
#Sintaxis: BarChart(campo_tabla, data=tabla_de_datos)

#A un gráfico de barra podemos agregarle muchas caracteristicas:

#fill=relleno
#fill=colores en plural para degradado ("reds", "rusts", "browns", "olives", "greens"...)
#color=color de linea de borde de las barras
#trans= transparencia va de 0.1 a 1
#values_color= color de los datos
#sort= ordenar los datos de mayor a menor (signo menos - ) o viceversa (signo más + )
#values_size = color de los números dentro de las barras
#rotate_x= para rotar las etiquetas del eje x va de 0.1 a 1

#Grafico de una sola variable
BarChart(JobSat, data = d)
BarChart(Dept)
BarChart(Gender)
BarChart(nationality, data = fa)
BarChart(height_cm, data = fa)
BarChart(age, data = fa)

#Si queremos podemos ajustar los colores del grafico
BarChart(Dept, fill="darkred", color="black", trans=.8, values_color="black")
BarChart(age, data = fa, fill = "cornsilk3", color = "gray", trans = .2, values_color = "black")

#Si queremos las barras en direccion horizontal, agregamos el argumento "horiz=TRUE"
BarChart(Dept, theme="gray", values="off", horiz=TRUE)
BarChart(age, data = fa, theme = "gray", horiz = TRUE, sort = "-")

#Para realizar un degradado, utilizamos el argumento "fill=" y un color en plural
BarChart(Dept, fill="browns")
BarChart(height_cm, data = fa, fill = "olives", horiz = TRUE, sort = "-")
# "reds", "rusts", "browns", "olives", "greens", "emeralds", "turquoises", 
#"aquas", "blues", "purples", "violets", "magentas", and "grays"

#Existe una paleta de colores similar que se llama "color-blind family"
#Opciones:  "viridis", "cividis", "magma", "inferno", "plasma"
BarChart(Dept, fill="viridis")
BarChart(age, data = fa, fill = "magma", sort = "-")

#Para rotar/inclinar las etiquetas, utilizamos el argumento "rotate_x="
BarChart(Dept, rotate_x=45, offset=1, sort="-")

#Si utilizamos el argumento "count", la intensidad del color se dirige directamente al valor mas alto
BarChart(Dept, fill=(count))
BarChart(nationality, data = fa, fill = (count), sort="-")

#--------------Grafico de barra con variables especificas y pivot()-----------------

#Tambien podemos crear graficos a partir de tablas y variables particulares,
#para ello podemos utilizar la funcion pivot()
a <- pivot(d, mean, Salary, Dept)
a
a <- na.omit(a)#Eliminamos u omitimos los valores nulos para poder hacer el grafico

altura <- pivot(fa, mean, height_cm, nationality) 
altura

#Ahora podemos utilizar las valores resultantes en la tabla, luego de aplicar esa función pivot()
#para hacer nuestro gráfico. En este caso utilizaremos: Salary_mean y height_cm_mean
#La salida es un grafico con Salary en el eje "y" y Dept en el eje "x"
BarChart(Dept, Salary_mean, data=a)
BarChart(nationality, height_cm_mean, data = altura)

#Podemos crear un grafico con una anotacion, agregando el argumento "style"
style(add_fill="aliceblue")
BarChart(Dept, add=c("rect", "Employees by\nDepartment"),
         x1=c(1.75,3), y1=c(11, 10), x2=4.25, y2=9)
#Las x y las y, indican la ubicacion del recuadro dentro del grafico

#----------------Grafico de barra de dos o mas variables-----------------------

#Para realizar un grafico de barra con mas de una variable o de variables apiladas
#debemos utilizar el argumento "by=variable"
BarChart(Dept, by=Gender)
BarChart(JobSat, data = d, by = Gender)
BarChart(age, data = fa, by = nationality)

#Podemos hacer que el grafico cubra el 100% de la altura, agregando el documento "stack100=TRUE"
BarChart(Dept, by=Gender, stack100=TRUE)
BarChart(age, data = fa, by = nationality, stack100 = TRUE)

#Podemos especificar los colores con un vector "c"
BarChart(Dept, by=Gender, fill=c("deepskyblue", "black"))

#Podemos mostrar las barras de forma horizontal, utilizando el parametro "horiz=TRUE"
BarChart(Gender, by=Dept, horiz=TRUE)
BarChart(age, data = fa, by = nationality, horiz = TRUE, sort = "-")


#Si queremos que una barra aparezca al lado de la otra, debemos utilizar los argumentos:
# "beside=TRUE" y "values_pòsition=¨out¨"
BarChart(Dept, by=Gender, beside=TRUE, values_position="out")
BarChart(age, data = fa, by = nationality, beside = TRUE, values_position = "out")

#Por ultimo, si tenemos multiples varibles, y condiciones, podemos hacer un grafico
#de barras con variables multiples
#Este tipo de gráficos es útil, para manejar múltiples variables númericas
d <- rd("Mach4", quiet=TRUE)
BarChart(m01:m20, sort = "-")
#El argumento para el grafico en este es caso es ir desde la variable "m01" hasta "m20"

#--------------Grafico de Malla o Trellis-------------------------

#Es un tipo de gráfico de barras comparativo, muestras ambas variables de forma simúltanea
#una al lado o debajo de la otra. Es útil cuando tenemos pocas variables cuantitativas

#Podemos realizar estos graficos, agregando la instruccion "by1="
BarChart(JobSat, data = d, by1 = Gender)
BarChart(Dept, by1=Gender)
#Ese codigo crea 2 graficos, uno por cada genero Men and Women

#Podemos apilar uno sobre otro, utlizando el parametro "n_col"
BarChart(Dept, by1=Gender, n_col=1)

#--------Grafico de barra interactivo------------------------

#En caso que sea muy complicado realizar un grafico, podemos utilizar esta funcion
#que nos abre una ventana, desde la cual podremos visualizar, las diferentes opciones que tenemos 
#para hacer un gráfico de barra con lessR
interact("BarChart1")
Valid names:
  'BarChart1', 'BarChart2', 'Histogram', 'PieChart', 'ScatterPlot', 'Trellis'

#------------------Grafico de torta-----------------------------------

#Para crear un grafico de torta, utilizamos la funcion "PieChart()"
#Sintaxis: PieChart(variable, data = tabla_de_datos)
PieChart(Dept)
PieChart(Gender, data = d)
PieChart(height_cm, data = fa)
PieChart(nationality, data = fa)

#Grafico de torta sin el circulo en el medio
PieChart(Dept, hole=0, quiet=TRUE)

#-----------------------Histogramas-------------------------------

d <- Read("Employee")
l <- rd("Employee_lbl")
l

#Para realizar un histograma, solo debemos utilizar la funcion "Histogram(nombre_variable)"
Histogram(Salary)
Histogram(height_cm, data = fa)

#Para personalizar el histograma, podemos utilizar los parámetros "bin_start" (inicio), "bin_width" (ancho)
#y "bin_end" (final) 
Histogram(Salary, bin_start=35000, bin_width=14000)
Histogram(height_cm, data = fa, bin_start = 163, bin_width = 10)

#Tambien podemos modificar los colores
Histogram(Salary, fill="reds", color="transparent")
Histogram(age, data = fa, fill = "blues", bin_width = 5)

#Para entender mejor la distribucion, podemos agregar un grafico de densidad al histograma
#Gráfica de densidad: es una curva suave que estima la distribución subyacente en los datos.
Histogram(Salary, density=TRUE)
Histogram(age, data = fa, density = TRUE)

#Por ultimo, podemos hacer Histogramas interactivos con la funcion "interact("Histogram")"
#lo que nos ayudará a determinar, cuáles son las variables que queremos agregar a nuestro gráfico
interact("Histogram")

#------------------Diagrama de Dispersion - Scatterplot----------------------

d <- Read("Employee")
l <- rd("Employee_lbl")
l

#Para realizar un digrama de dispersiones, debemos utilizar la funcion "Plot()" con dos variables
Plot(Years, Salary)
Plot(data = fa, height_cm, weight_kg, fill="skyblue")

#Podemos tener un grafico mas completo, utilizando el argumento "enhance=TRUE"
Plot(Years, Salary, enhance=TRUE)
Plot(data = fa, height_cm, weight_kg, fill="skyblue", enhance = TRUE)
#La visualización incluye la media de cada variable indicada por la línea negra respectiva a través del diagrama 
#de dispersión, el elipse con una confianza del 95 %, los valores atípicos etiquetados, 
#la línea de regresión de mínimos cuadrados con un intervalo de confianza del 95 % y 
#la línea de regresión correspondiente con los valores atípicos eliminados

#El diagrama de dispersion tiene multiples opciones de representacion
#Los valores disponibles: "loess" para ajuste general no lineal, "lm" para mínimos cuadrados lineales, 
#"null" para modelo nulo (línea plana), "exp" para crecimiento y decaimiento exponencial, 
#"quad" para modelo cuadrático modelo y potencia para la potencia general más allá de 2. 
#Si se ajusta a TRUE, se traza la línea "loess".
#Con el valor de la potencia, especifique el valor de la raíz con el parámetro fit_power.
Plot(Years, Salary, fit="loess", plot_errors=TRUE)
Plot(Years, Salary, fit="exp", plot_errors=TRUE)
Plot(data = fa, height_cm, weight_kg, fit = "loess", plot_errors = TRUE)
Plot(data = fa, height_cm, weight_kg, fit = "exp", plot_errors = TRUE)
Plot(data = fa, height_cm, weight_kg, fit = "lm", plot_errors = TRUE)

#Podemos hacer un diagrama de dispersion con tres variables
#La tercera variable se agrega con el argumento "size=" y sirve para indicar el tamano del circulo
Plot(Years, Salary, size=Pre)
Plot(data = fa, height_cm, weight_kg, size = age)

#Podemos realizar combinaciones mas complejas, como utilizar tres variables
#y realizar ajustes lineales con "lm"
Plot(c(Pre, Post), Salary, fit="lm", fit_se=0)

#Otra opcion para multiples variables, es una matriz de diagramas de dispersion
#Para construirla debemos utilizar un vector "c"
#Super util para comparar la correlacion entre multiples variables de forma rápida

Plot(c(Salary, Years, Pre, Post), fit="lm")
Plot(data = fa, c(height_cm, weight_kg, age))
Plot(data = fa, c(height_cm, weight_kg, age), fit = "lm")

#Podemos hacer graficos con variables continuas y categoricas
#Para agregar una variable categorica, utilizamos el argumento "by="
Plot(Years, Salary, by=Gender)
Plot(data = fa, age, weight_kg, by = nationality)

#Tambien podemos utilizar la misma combinacion, y aplicar un ajuste lineal "lm"
Plot(Years, Salary, by1=Gender, fit="lm")
Plot(data = fa, age, weight_kg, by = nationality, fit = "lm")

#--------------------Grafico VBS Violin, Boxplot y Scatterplot-----------------------

#Para realizar un grafico VBS solo debemos utilizar la funcion Plot()
Plot(Salary)
Plot(data = fa, height_cm)
#Ademas del grafico, el resultado arroja un resumen muy bueno de los principales estadisticos

#Podemos controlar cada uno de los elementos representados con el argumento "vbs_plot= v, b s"
Plot(Salary, vbs_plot="b")
#En este caso solo veriamos el boxplot

#-----------------Grafico de puntos de Cleveland------------------------

#Es una representación grafica como un grafico de barra horizontal, pero en lugar de la barra
#esta representado por una linea, con un punto al final que indica el valor mas alto de la categoria
Plot(Salary, row_names)
Plot(data = fa, height_cm, row_names)

#La version cruda del grafico no es muy util, por eso arriba utilizamos el argumento "row_names"
Plot(Salary, row_names, sort_yx="0", segments_y=FALSE)

#Podemos utilizar este tipo de grafico con dos variables, en ese caso la linea indica un rango,
#y los puntos los limites minimo y maximo del rango
Plot(c(Pre, Post), row_names, sort_yx = "-")

#------------------Graficos solo con variables categoricas-----------------------

#Podemos realizar cualquier tipo de grafico, solo utilizando variables categoricas
#Debemos pensar si alguno de estos graficos, puede ser util para nuestro analisis

d <- Read("Employee", quiet=TRUE)
Plot(Dept, Gender)

#En este caso podemos agregar argumentos, para ver los circulos mas grandes de acuerdo a su valor
Plot(Dept, Gender, radius=.6, power=0.8, pad_x=0.05, pad_y=0.05)

#Grafico de Cleveland
Plot(Dept, by1=Gender)

#Solo una variable
Plot(Dept)

#Diagramas de dispersion interactivos
interact("ScatterPlot")

#################################FIN##################################################