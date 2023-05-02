#En esta leccion aprenderemos como trabajar con Data Frames, utilizando la libreria TidyR

#Primero debemos importar la biblioteca

library(tidyr)
library(readxl)
df1<-read_excel("df1_argentina.xlsx")
df2<-read_excel("df2_argentina.xlsx")
df3<-read_excel("df3_argentina.xlsx")
df4<-read_excel("df4_argentina.xlsx")

#Cual es la utilidad y que podemos hacer con estas funciones de tidyR

#1. Utilizar gather(), para agrupar informacion en las columnas, es igual a utilizar pivot_longer
#esta funcion alarga las tablas verticalmente
#2. Utilizar spread(), para desagrupar informacion de las columnas, es igual a utilizar pivot_wider
#esta funcion hace las tablas mas anchas horizontalmente
#3. Utilizar separate(), para dividir informacion dentro de las columnas, que este unida por un simbolo
#esto seria lo mismo, que utilizar la funcion Texto a Columna de Excel
#4. Utilizar unite(), para unir/colapsar, el contenido de varias columnas en una sola

#Hay 3 reglas que se deben cumplir para considerar que un data frame está ordenado:

#Cada variable debe tener su propia columna
#Cada observación debe tener su propia fila
#Cada valor deber tener su propia celda

#Los problemas mas comunes en el manejo de datos

#Una variable está dividida en múltiples columnas
#Una observación está dispersa en múltiples filas.
#Múltiples variables están metidas en una única celda.

#----------Funcion gather()----------------

#La función gather toma múltiples columnas y las une en pares clave-valor. 
#Esto permite resolver las situaciones en que tenemos columnas que realmente no representan variables, 
#sino valores de una variable.

#veamos la siguiente tabla
df4
#Las columnas CENSO1991, CENSo2001 y CENSO2010 representan un valor, 
#de una variable que podria llamarse sencillamente CENSO_ANO

#Asi que para ordenar este dataset necesitamos emplear la función gather.
df41 <- gather(data = df4, key = "CENSO_ANO", value = "poblacion", 2:4)
df41

#Lo que hemos hecho es decir a la función que tome el data frame df4, 
#y una las columnas que van desde 2:4 (las que tienen los valores obtenidos en cada censo), 
#y meta el resultado en nueva tabla con el par clave (CENSO_ANO) - valor (población).
#En este caso los nombres de las variables "CENSO_ANO" y "poblacion" las definimos nosotros 

#----------Funcion spread()-------------------

#La función spread es utilizada cuando tenemos una observación dispersa 
#en múltiples filas. En el siguiente ejemplo tenemos un dataset donde 
#una observación es el resultado de un censo, pero cada observación (Censo) está esparcido en dos filas 
#(una fila para la población total, y otro para la población urbana), y deberian estar separadas

#veamos la siguiente tabla
df2

#Para llevar este dataset a la forma de una observación por fila debemos usar la función spread.
df21 <- spread(data = df2, key = "Tipo", value = "Poblacion")
df21
#De esta forma evitamos que se repita el ano, y separamos urbana y total en dos columnas

#La columna que contiene los nombres de las variables (en este caso TIPO) corresponde al argumento key, 
#mientras que la columna que contiene el valor (en este caso POBLACION) es la variable para value.

#La funcion spread() es la opuesta a gather(). Mientras spread() recorta los dataframe, 
#gather los alarga.

#------------Funcion separate()--------------------

#La función separate() lo que hace es dividir una columna en múltiples columnas, 
#tomando como separador algún símbolo.

#Veamos la siguiente tabla
df3
#Supongamos que necesitamos extraer los valores de poblacion urbana y total
#que se encuentran en la columna Tasa Poblacion Urbana, para ello utilizamos separate()

df31<- separate(data =  df3, #Tabla de datos
                col  =  "Tasa.Poblacion.Urbana", #Columna original  
                into =  c("urbana", " total"), #Columnas en que sera dividido
                sep  =  "/")#Separador
df31

#Las columnas resultantes de la división son de tipo character, 
#pero dado su significado lo que deseamos es que sean tratadas 
#como numeric o integer. Para indicar esto podemos hacer la conversion del tipo de dato manualmente, 
#o se puede agregar la opcion convert = TRUE a la función separate.

df32 <- separate(data =  df3, #Tabla de datos
                 col  =  "Tasa.Poblacion.Urbana", #Columna original  
                 into =  c("urbana", " total"), #Columnas en que sera dividido
                 sep  =  "/",#Separador
                 convert = TRUE)#Para que el resultado sea directamente un numero
df32

#---------------------------------------------------

#Para separar los valores de una columna, utilizamos la funcion separate()
#La sintaxis es compleja:
#separate(tabla, campo_original, into=c("nueva_columna_1", "nueva_columna_2"), sep = " ")
#into= vector "c" con nuevas columnas       #separador (sep)
> separate(employee, name, into =c("first_name", "last_name"), sep = " ")
#Separar, de la tabla empleado, el campo nombre, en los dos campos "first_name", "last_name"
#Para separarlos utilizar el espacio en blanco " " 

#--------------Funcion unite()--------------------------

#La función unite que complementa a separate. Esta función lo que hace es tomar múltiples columnas (...) 
#y las colapsa en una única columna (col), separando los elementos mediante sep.

#--------------------------------------
#Para unir campos de una tabla utilizamos la funcion unite()
#La sintaxis es: unite(tabla, nombre_campo_nuevo, variable_1, variable_2, sep = " ")
>unite(employee, "name", primer_nombre, segundo_nombre, sep = " ")
#Son variables previamente creadas

df

ID dia mes anio
1  25   9 2015
2  30   7 2015
3   7   3 2015
4  15   8 2015

unite(data = df, 
      col = Fecha, 
      sep = "-",
      dia,mes,anio)

ID     Fecha
1 25-9-2015
2 30-7-2015
3  7-3-2015
4 15-8-2015




