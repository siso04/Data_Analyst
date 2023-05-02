#En esta leccion aprenderemos como crear tablas a partir de bases de datos o tablas mas grandes

#Lo primero que debemos hacer utilizar la biblioteca readxl y cargar el archivo de Excel

library(readxl)
empleados <- read_excel("employee_demographics.xlsx")

#Aplicamos View() para ver el contenido, names () para conocer el nombre de las columnas, 
#y str() para ver la estructura de la tabla

View(empleados)
names(empleados)
str(empleados)

#Para seleccionar una sola columna utilizamos corchetes
#tabla_datos [, "Nombre_Columna"]
empleados[, "Sex"]
#Tambien podemos hacerlo con el simbolo de dolar
empleados$JobLevel

#-------------------------------------------------

#Para crear una nueva tabla, la forma mas sencilla es utilizar la funcion "table()"
#Sintaxis:    table(tabla_datos$variable_1, tabla_datos$variable_2)
table(empleados$JobLevel, empleados$RaceEthnicity)
nivel_raza<- table(empleados$JobLevel, empleados$RaceEthnicity)
nivel_raza

#Podemos aplicar o ver proporciones en las tablas con funcion "prop.table()"
#Sintaxis:      prop.table(tabla_datos)
prop.table(nivel_raza)
#Para ver los porcentajes multiplicariamos por *100
prop.table(nivel_raza)*100

#Para redondear o limitar el numero de decimales, utilizamos la funcion "round()"
#El primer argumemto es la funcion con el calculo, y la segundo el numero de decimales que queremos
round(prop.table(nivel_raza)*100, 2)

#Podemos realizar tablas categoricas en base a una variables, tambien llamadas Three Way Tables
#Este tipo de tablas lleva tres variables
#Sintaxis:    table(tabla$variable_1, tabla$variable_2, tabla$variable3)
#La variable_3 va a subidvidir los datos por una categoria espeicifica
table(empleados$JobLevel, empleados$Sex, empleados$RaceEthnicity)
#Esta funcion al final nos ofrece un resumen con todos los totales

#Para simplificar el resultado de una three way table, podemos utilizar la funcion "ftable()"
ftable(table(empleados$JobLevel, empleados$Sex, empleados$RaceEthnicity))

#---------------------------------------------------------------------

#La funcion cross-tabs o "xtabs", permite realizar las mismas acciones de arriba en menos pasos
#Debemos utilizar la funcion "xtabs (~ variable_1 + variable_2, data = tabla_de_datos)"
tabla_x1<- xtabs(~ JobLevel + Sex, data = empleados)
tabla_x1

#Para una three way table, sera la misma sintaxis
tabla_x2<- xtabs(~ JobLevel + Sex + RaceEthnicity, data = empleados)
tabla_x2