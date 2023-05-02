#En este lección aprenderemos cómo hacer "data wrangling" o arreglos en los datos
#para poder procesarlos de forma más eficiente
#Se trata basicamente de utilizar tibbles, leer y escribir tablas

#Existen tres elementos básicos del Data Wrangling:

#Importar
#Arreglar
#Transformar

library(tidyverse)
install.packages("tibble")

#Datos

fifa <- read.csv("fifa_dplyr.csv", encoding = "UTF-8")
fifa
names(fifa)

######--------------------Tibbles----------------------------######

#Los "tibbles" son similares a los data frame, pero simplifican algunas tareas
#Los "tibbles" están directamente vinculados a la libreria "tidyverse"
#La salida de un tibble, siempre será un tibble, pero la salida de un data frame, puede ser
#otro data frame o un conjunto de vectores
#El térmimo puede llegar a utilizarse indistintamente, pudiendo ser lo mismo un tibble y un data frame

#Como la mayoria de las librerias utilizan data frame, probablemente, tendrás que transformar tus 
#tablas a un tibble con "as_tibble()"
tfifa<- as_tibble(fifa)
#La estructura de un tibble, se asemaja mas a una tabla de datos rectangular

#Los tibbles son restrictivos en algunos aspectos:

#Nunca cambia el tipo de las entradas (por ejemplo, ¡nunca convierte cadenas en factores!), 
#Nunca cambia los nombres de las variables y 
#Nunca crea nombres de fila

#Para saber si una tabla es un tibble, utilizaremos la funcion is_tibble(), el resultado es TRUE or FALSE
is_tibble(mtcars)
is_tibble(tfifa)

#------------Diferencia entre tibble y data frame-------------------

#1. Impresion

#Tibble
#Tibbles tiene un método de impresión refinado que muestra solo las primeras 10 filas y 
#todas las columnas que caben en la pantalla. Esto hace que sea mucho más fácil trabajar con grandes datos. 
#Además de su nombre, cada columna informa su tipo, una buena característica tomada de str()

tfifa
str(tfifa)

#Data Frame
#Por otra parte, en un data frame, podemos definir cuántas columnas queremos imprimir
head(fifa, 6)

#2. Subsetting/Selecciones

#En un tibble, si desea extraer una sola variable/columna, necesita algunas herramientas nuevas, $ y [[.  
#[[ puede extraer por nombre o cargo; $ solo extrae por nombre pero es un poco menos tipeo.

#Extraer por nombre o numero
head(fifa$nationality) #Con el simbolo de dolar "$" se extrae por nombre
tfifa[["weight_kg"]]    #Se puede utilizar corchetes dobles [[]] y el nombre de la variable
tfifa[[9]] %>% head()   #En este caso se extrae por el numero de la columna
tfifa[4:6]

######-------------Importar Datos (read_file)-------------------------######

#Importar datos en R se dice "leer" o readfile
#Las librerias a utilizar pueden ser "readr" o "readxl" que es más sencilla de utilizar con Excel
library(readxl)
library(readr)

#Generalmente se utilizan:

#read_csv() lee archivos delimitados por comas, 
#read_csv2() lee archivos separados por punto y coma (común en países donde coma se usa como lugar decimal), 
#read_tsv() lee archivos delimitados por tabuladores y 
#read_delim() lee archivos con cualquier delimitador

#Cuando se importan los datos, generalmente la primera columna es tomada como nombre
#En algunos casos Puedes usar skip = n (numero) para saltar las primeras n líneas; o utilice comment = "#" 
#para descartar todas las líneas que comienzan con (por ejemplo,) #.
read_csv("The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3", skip = 2)

read_csv("# A comment I want to skip
  x,y,z
  1,2,3", comment = "#")

#Es posible que los datos no tengan nombres de columna. Puede usar col_names = FALSE para decirle a read_csv() 
#que no trate la primera fila como encabezados y, en su lugar, etiquételos secuencialmente de X1 a Xn
read_csv("fifa_dplyr.csv", col_names = FALSE)

#Alternativamente, puede pasar col_names un vector de caracteres que se usará como los nombres de las columnas:
read_csv("fifa_dplyr.csv", col_names = c("id", "nombre", "nombre-completo", "edad", "nacimiento", 
                                         "altura", "peso", "nacionalidad", "equipo", "liga", "promedio",
                                         "posicion"))

#Otra opción que comúnmente necesita ajustes es na: esto especifica el valor (o valores) 
#que se utilizan para representar los valores faltantes en su archivo:
read_csv("a,b,c\n1,2,.", na = ".")

#¿Qué función usaría para leer un archivo donde los campos estuvieran separados con "|"?
read_delim(file, delim = "|")

######-------------Analizar/Parsear/Coercionar un vector-------------------------######

#Necesitamos tomar un pequeño desvío para hablar sobre las funciones parse_*(). 
#Estas funciones toman un vector de caracteres 
#y devuelven un vector más especializado como un número lógico, entero o fecha

#lógico -> entero -> numérico -> cadena de texto (logical -> integer -> numeric -> character)

#as.integer()	Entero
#as.numeric()	Numerico
#as.character()	Cadena de texto
#as.factor()	Factor
#as.logical()	Lógico
#as.null()	NULL

str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

#Las funciones parse_*() son uniformes: el primer argumento es un vector de caracteres para analizar, 
#y el argumento na especifica qué strings deben tratarse como valores perdidos
parse_integer(c("1", "231", ".", "456"), na = ".")#En este caso el punto, pasa a ser un NA

#Parsear puede ser una herramienta fundamental, para el análisis de datos
#y existen 9 tipos que son comunmente utilizados

#1 y 2 parse_logical() y parse_integer() analizan lógicos y enteros respectivamente. 
#Básicamente, no hay nada que pueda salir mal con estos parseos, 

#3 y 4 parse_double() es un analizador numérico estricto y parse_number() es un analizador numérico flexible. 
#Estos son más complicados de lo que podrías esperar, porque diferentes partes del mundo escriben números de diferentes maneras.

#5 parse_character() parece tan simple que no debería ser necesario. 
#Pero una complicación lo hace bastante importante: codificaciones de caracteres.

#6 parse_factor() crea factores, la estructura de datos 
#que R usa para representar variables categóricas con valores fijos y conocidos.

#7, 8 y 9 parse_datetime(), parse_date() y parse_time() le permiten analizar varias 
#especificaciones de fecha y hora. Estos son los más complicados, porque hay muchas 
#formas diferentes de escribir las fechas.

######-------------Exportar Datos (write_file)-------------------------######

#En R exportar una tabla de datos se dice "write a file"
#Las dos funciones principales son: write_csv() and write_tsv(), para exportar a Excel write_excel_csv()

#Los argumentos más importantes son x (el data frame para guardar) y la ruta (la ubicación para guardarlo). 
#También puede especificar cómo se escriben los valores faltantes con na 
#y si desea agregarlos a un archivo existente.

write_csv(challenge, "challenge.csv")
