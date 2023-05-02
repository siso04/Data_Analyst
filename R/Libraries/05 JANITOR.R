#Vamos a utilizar el paquete JANITOR
#El paquete Janitor, tiene la función de simplificar algunas funciones de dplyr

#Para que es útil el paquete janitor()

#1. Asignar nombres o encabezados a la tabla con: row_to_names()
#2. Limpiar los nombres/encabezados de la tabla: clean_names()
#3. Obtener un resumen rápido de los datos de una columna: tabyl(tabla$columna)
#4. Utilizar funciones con el prefijo adorn():
# adorn_totals(): permite obtener los totales de los campos por fila
# adorn_totals(where = "col"): permite obtener los totales de los campos por columna
# adorn_totals(c("col", "row")): permite obtener los totales de los campos por fila y columna al mismo tiempo
# adorn_percentages("row"): permite obtener resultados en décimales
# adorn_pct_formatting(): permite obtener resultados en décimales en porcentaje
# adorn_ns(): indica las veces que se repite un valor en una columna (útil para variables cualitativas)
#5. Eliminar filas o columnas vacías con: remove_empty()
# Eliminar todo en filas y columnas: remove_empty(c("rows", "cols"))
# Eliminar fila vacía: remove_empty(tabla, which = "rows") 
# Eliminar columna vacía: remove_empty(tabla, which = "cols") 
#6. Comparar el contenido de dos tablas con: compare_df_cols(tabla1, tabla2)
#7. Identificar y examinar registros duplicados con: get_dupes()
#8. Convertir datos a fecha con: convert_to_date()


#Utilizaremos como ejemplo un excel: dirty_data

#Primero llamamos a las librerias
library(janitor)
library(readxl)

#Luego abrimos el archivo de excel

sucios<- read_excel("dirty_data.xlsx")
sucios
#Y comenzamos....

#--------------------ASIGNAR LA FILA CORRECTA DE NOMBRES A LA TABLA-----------------

#Lo primero que vamos hacer es asignar la fila de nombres correcta a la tabla
#Los titulos de cada columna, no tienen nombres, solo informacion irrelevante
#Los verdaderos titulos estan en la fila 1 de la tabla
#Para arreglar este problema utilizamos la funcion row_to_names()
datoslimpios <-    sucios %>% row_to_names(row_number = 1)
datoslimpios
# Variable nueva <- Tabla %>% funcion     (fila_con_los_nombres = 1)

#--------------------LIMPIAR LOS NOMBRES DE LA TABLA-----------------


#Ahora los nombres de la tabla tienen errores con simbolos ? % o espacios en blanco
#Para arreglar esto utilizamos la funcion clean_names()
#Aplicamos la funciona a la tabla que creamos mas arriba "datoslimpios"
limpios <- clean_names(sucios)
limpios

#En una sola linia de codigo
tablalimpia <- dirty_data %>% clean_names()

#--------------------RESUMEN RÁPIDO DE DATOS DE UNA COLUMNA--------------

#Para obtener un resumen rapido de los datos de una columna, utilizamos la funcion tabyl()
#Solo debemos indicar la tabla, luego $ y nombre del campo
tabyl(limpios$certification_9)
#Para utilizarlo con dos o mas variables, aplicamos un chain %>% 
limpios %>% tabyl(employee_status, certification_9)
fifa %>% tabyl(league_name)

fifa <- read.csv("fifa_dplyr.csv", encoding = "UTF-8")
names(fifa)

#--------------------FUNCIONES CON EL PREFIJO adorn()--------------

#El paquete JANITOR incluye varias funciones con el prefijo adorn()

#adorn_totals()
#adorn_totals(where = "col")
#adorn_totals(c("col", "row"))
#adorn_percentages("row") - Resultado en décimales
#adorn_pct_formatting() - Resultado en porcentaje
#adorn_ns - Indica las veces que se repite un valor

#La funcion adorn_totals(), nos arroja el total de las variables seleccionadas, sumando los valores de la fila
tabla %>% tabyl(variable1, variable2) %>% adorn_totals() 
limpios %>% tabyl(percent_allocated, certification_9) %>%  adorn_totals()

#Tambien podemos sumar los totales, y obtener el resultado por columnas
tabla %>% tabyl(variable1, variable2) %>% adorn_totals(where = "col")
limpios %>% tabyl(percent_allocated, certification_9) %>% adorn_totals(where = "col")

#Y por ambas (filas y columnas)
tabla %>% tabyl(variable1, variable2) %>% adorn_totals(where = c("row", "col" ))
limpios %>% tabyl(employee_status, full_time) %>% adorn_totals(c("col", "row"))

#Si queremos los resultados en porcentajes, utilizamos la funcion adorn_percentages()
tabla %>% tabyl(variable1, variable2) %>% adorn_percentages("row") #Este resultado sale en decimales
limpios %>% tabyl(percent_allocated, certification_9) %>% adorn_percentages("row")

#Si queremos los valores multiplicados por 100, debemos agregar adorn_pct_formatting()
tabla %>% tabyl(variable1, variable2) %>% adorn_percentages("row") %>% adorn_pct_formatting()
limpios %>% tabyl(percent_allocated, certification_9) %>% adorn_pct_formatting()

#Por ultimo, la funcion adorn_ns() coloca la cantidad o numero de veces que aparece un valor
tabla %>% tabyl(variable1, variable2) %>% adorn_percentages("row") %>% adorn_ns()/adorn_ns("front")
limpios %>%
  tabyl(employee_status, full_time) %>%
  adorn_ns() %>%
  adorn_title("combined")

#------------------REMOVER FILAS Y COLUMNAS VACÍAS---------------------

#Para remover filas y columnas que esten completamente vacias, utilizamos la funcion remove_empty()
#Eliminar todo: remove_empty(c("rows", "cols"))
#Eliminar fila: remove_empty(tabla, which = "rows") 
#Eliminar columna: remove_empty(tabla, which = "cols") 

#La sintaxis para eliminar todo lo vacio es: tabla %>% remove_empty(c("rows", "cols"))
todolimpio<- limpios %>% remove_empty(c("rows", "cols"))#Elimina filas y columnas
todolimpio

#Si queremos eliminar filas vacias
#La sintaxis es: remove_empty(tabla, which = "rows") 
paralimpiar_fila <- remove_empty(limpios, which = "rows")
paralimpiar_fila

#Si queremos eliminar columnas vacias
#La sintaxis es: remove_empty(tabla, which = "cols") 
paralimpiar_columna <- remove_empty(datoslimpios, which = "cols")
paralimpiar_columna

#-----------------COMPARAR TABLAS--------------

#La funcion compare_df_cols(), funciona para comparar las columas de varias tablas
#Puede ser util en momentos que manipulemos la tabla, y podamos ver los cambios
#La sintaxis es: compare_df_cols(tabla_1, tabla_2)
compare_df_cols(paralimpiar_fila, paralimpiar_columna)

#-----------------EXAMINAR/UBICAR REGISTROS DUPLICADOS-------------

#Para eliminar duplicados, se utiliza la funcion get_dupes()
duplicados <- limpios %>% get_dupes(first_name, last_name)
duplicados
#El resultado son las filas que tiene duplicados

#-----------------CONVERTIR DATOS A FECHA-----------------

#La funcion convert_to_date(), permite convertir los numeros de R en una fecha comun
limpios$hire_date
convert_to_date(limpios$hire_date)

#Ejemplo aplicando múltiples funciones 

limpios %>%
  tabyl(employee_status, full_time) %>%
  adorn_totals("row") %>%
  adorn_percentages("row") %>%
  adorn_pct_formatting() %>%
  adorn_ns() %>%
  adorn_title("combined")

