#En esta leccion aprenderemos como hacer JOINS en R con la funcion merge()

#Primero llamamos a la libreria readxl para abrir los excel 
library(readxl)

#Ahora procederemos abrir/leer los dos archivos 
personal <- read_excel("Personal_Data.xlsx")
performance<- read_excel("Performance_Data.xlsx")

#Procedemos a comprobar que los datos se cargaron de forma correcta
View(personal)
View(performance)

#Con la funcion str() podemos ver las caracteristicas de cada campo
str(personal)
str(performance)

#-----------------------Funcion merge()------------------

#La funcion merge() solo sirve para combinar dos tablas de datos 
#Para aplicarla debemos crear una variable
#variable_merge <- merge(tabla_1, tabla_2)

#La funcion, basica o principal de merge() es un inner join, es decir, 
#muestra todos los registros que coincidan en ambas tablas, no incluye valores nulos
inner_join<- merge(personal, performance, by="id")
#El argumento "by=  " funciona para especificar el campo de enlace/comun entre las tablas

#Si queremos hacer un Full Join, es decir, que aparezcan todos los registros, 
#debemos agregar el argumento "all = TRUE" a nuestra variable
#El full_join permite valores nulos
full_join <- merge(personal, performance, by="id", all = TRUE)

#Tambien podemos hacer left y right join
#Para ello al  argumento "all = TRUE" debemos agregarle una .x o una .y (recordar el punto)
#de esta forma "all.x = TRUE" o "all.y = TRUE" 

#Podemos crear una variable y hacer un right join con x
right_join<-  merge(personal, performance, by="id", all.x = TRUE)

#Y hacemos lo mismos para un leff join con y 
left_join<-  merge(personal, performance, by="id", all.y = TRUE)