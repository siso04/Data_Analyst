#En este lecci�n aprenderemos c�mo hacer "data wrangling" o arreglos en los datos
#para poder procesarlos de forma m�s eficiente
#Se trata basicamente de utilizar tibbles, leer y escribir tablas

#Existen tres elementos b�sicos del Data Wrangling:

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
#Los "tibbles" est�n directamente vinculados a la libreria "tidyverse"
#La salida de un tibble, siempre ser� un tibble, pero la salida de un data frame, puede ser
#otro data frame o un conjunto de vectores
#El t�rmimo puede llegar a utilizarse indistintamente, pudiendo ser lo mismo un tibble y un data frame

#Como la mayoria de las librerias utilizan data frame, probablemente, tendr�s que transformar tus 
#tablas a un tibble con "as_tibble()"
tfifa<- as_tibble(fifa)
#La estructura de un tibble, se asemaja mas a una tabla de datos rectangular

#Los tibbles son restrictivos en algunos aspectos:

#Nunca cambia el tipo de las entradas (por ejemplo, �nunca convierte cadenas en factores!), 
#Nunca cambia los nombres de las variables y 
#Nunca crea nombres de fila

#Para saber si una tabla es un tibble, utilizaremos la funcion is_tibble(), el resultado es TRUE or FALSE
is_tibble(mtcars)
is_tibble(tfifa)

#------------Diferencia entre tibble y data frame-------------------

#1. Impresion

#Tibble
#Tibbles tiene un m�todo de impresi�n refinado que muestra solo las primeras 10 filas y 
#todas las columnas que caben en la pantalla. Esto hace que sea mucho m�s f�cil trabajar con grandes datos. 
#Adem�s de su nombre, cada columna informa su tipo, una buena caracter�stica tomada de str()

tfifa
str(tfifa)

#Data Frame
#Por otra parte, en un data frame, podemos definir cu�ntas columnas queremos imprimir
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
#Las librerias a utilizar pueden ser "readr" o "readxl" que es m�s sencilla de utilizar con Excel
library(readxl)
library(readr)

#Generalmente se utilizan:

#read_csv() lee archivos delimitados por comas, 
#read_csv2() lee archivos separados por punto y coma (com�n en pa�ses donde coma se usa como lugar decimal), 
#read_tsv() lee archivos delimitados por tabuladores y 
#read_delim() lee archivos con cualquier delimitador

#Cuando se importan los datos, generalmente la primera columna es tomada como nombre
#En algunos casos Puedes usar skip = n (numero) para saltar las primeras n l�neas; o utilice comment = "#" 
#para descartar todas las l�neas que comienzan con (por ejemplo,) #.
read_csv("The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3", skip = 2)

read_csv("# A comment I want to skip
  x,y,z
  1,2,3", comment = "#")

#Es posible que los datos no tengan nombres de columna. Puede usar col_names = FALSE para decirle a read_csv() 
#que no trate la primera fila como encabezados y, en su lugar, etiqu�telos secuencialmente de X1 a Xn
read_csv("fifa_dplyr.csv", col_names = FALSE)

#Alternativamente, puede pasar col_names un vector de caracteres que se usar� como los nombres de las columnas:
read_csv("fifa_dplyr.csv", col_names = c("id", "nombre", "nombre-completo", "edad", "nacimiento", 
                                         "altura", "peso", "nacionalidad", "equipo", "liga", "promedio",
                                         "posicion"))

#Otra opci�n que com�nmente necesita ajustes es na: esto especifica el valor (o valores) 
#que se utilizan para representar los valores faltantes en su archivo:
read_csv("a,b,c\n1,2,.", na = ".")

#�Qu� funci�n usar�a para leer un archivo donde los campos estuvieran separados con "|"?
read_delim(file, delim = "|")

######-------------Analizar/Parsear/Coercionar un vector-------------------------######

#Necesitamos tomar un peque�o desv�o para hablar sobre las funciones parse_*(). 
#Estas funciones toman un vector de caracteres 
#y devuelven un vector m�s especializado como un n�mero l�gico, entero o fecha

#l�gico -> entero -> num�rico -> cadena de texto (logical -> integer -> numeric -> character)

#as.integer()	Entero
#as.numeric()	Numerico
#as.character()	Cadena de texto
#as.factor()	Factor
#as.logical()	L�gico
#as.null()	NULL

str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

#Las funciones parse_*() son uniformes: el primer argumento es un vector de caracteres para analizar, 
#y el argumento na especifica qu� strings deben tratarse como valores perdidos
parse_integer(c("1", "231", ".", "456"), na = ".")#En este caso el punto, pasa a ser un NA

#Parsear puede ser una herramienta fundamental, para el an�lisis de datos
#y existen 9 tipos que son comunmente utilizados

#1 y 2 parse_logical() y parse_integer() analizan l�gicos y enteros respectivamente. 
#B�sicamente, no hay nada que pueda salir mal con estos parseos, 

#3 y 4 parse_double() es un analizador num�rico estricto y parse_number() es un analizador num�rico flexible. 
#Estos son m�s complicados de lo que podr�as esperar, porque diferentes partes del mundo escriben n�meros de diferentes maneras.

#5 parse_character() parece tan simple que no deber�a ser necesario. 
#Pero una complicaci�n lo hace bastante importante: codificaciones de caracteres.

#6 parse_factor() crea factores, la estructura de datos 
#que R usa para representar variables categ�ricas con valores fijos y conocidos.

#7, 8 y 9 parse_datetime(), parse_date() y parse_time() le permiten analizar varias 
#especificaciones de fecha y hora. Estos son los m�s complicados, porque hay muchas 
#formas diferentes de escribir las fechas.

######-------------Exportar Datos (write_file)-------------------------######

#En R exportar una tabla de datos se dice "write a file"
#Las dos funciones principales son: write_csv() and write_tsv(), para exportar a Excel write_excel_csv()

#Los argumentos m�s importantes son x (el data frame para guardar) y la ruta (la ubicaci�n para guardarlo). 
#Tambi�n puede especificar c�mo se escriben los valores faltantes con na 
#y si desea agregarlos a un archivo existente.

write_csv(challenge, "challenge.csv")
