#Veamos cu�les son las bibliotecas, para realizar r�pidamente un Analisis Exploratorio de Datos

#Primero abrimos nuestra tabla de ejemplo
fifa <- read.csv("fifa_dplyr.csv", encoding = "UTF-8")
fifa
---------------------------------------------------
  
#Vamos a uilizar la biblioteca "skimr"
library(skimr)

#La funcion principal de esta libreria es skim()
#Que nos ofrece un resumen de la tabla, que incluye estadisticos de tendendica central y dispersion
skim(fifa)
skim_without_charts(viv_ancha)

#Si queremos, podemos ver solo un resumen de valores num�ricos
#Para ello, agregamos el argumento "yank"
fifa %>%
  skim() %>%
  yank("numeric")

#Podemos realizar selecciones, similares a las que hacemos con select()
skim(fifa, height_cm, weight_kg)
---------------------------------------------------

#Veamos ahora a la biblioteca "visdat"  
#Esta biblioteca solo funciona con data frames, no se puede utilizar con variables individuales
  
install.packages("visdat")
library(visdat)
#La libreria "visdat" funciona para realizar una exploracion grafica rapida


vis_dat(fifa)
#Muestra la distribuci�n por tipo de dato

vis_miss(fifa)
#Muestra la distribuci�n solo de los valores nulos

vis_cor(fifa)
#--------------------------------------------------
#--------------------------------------------------

#Librerias para Analisis Exploratorio Automatico

install.packages("DataExplorer")
library(DataExplorer)

# Llamada a la funci�n informe autom�tico
create_report(fifa)  
#El resultado es un archivo html con un resumen de los datos, la correlacion y un ACP

install.packages("SmartEDA")
library(SmartEDA)

data<- airquality
# Funcion que genera un informe completo
ExpReport(data,op_file='informeEDA.html')

# si queremos alguna gr�fica o tabla por separado
ExpData(data=data,type=1)
ExpData(data=data,type=2)

ExpNumStat(fifa,by="A",gp=NULL,Qnt=seq(0,1,0.1),MesofShape=2,Outlier=TRUE,round=2)
# una tabla resumen con multitud de estadisticos de las variables numericas
ExpNumStat(fifa,by="A",gp=NULL,round=2)

install.packages("dlookr")
library(dlookr)
#Para generar el informe completo se usa la funci�n diagnose_web_report() 
#o eda_web_report() seg�n el inter�s ultimo que buscamos

eda_web_report(fifa)
diagnose_web_report(fifa)

#La librer�a tiene mil opciones de an�lisis y entre las funciones disponibles, aqu� van algunos ejemplos

diagnose(fifa)
