#En R, los factores se utilizan para trabajar con variables categ�ricas, 
#variables que tienen un conjunto fijo y conocido de valores posibles.

#Por ejemplo: frio/calor, alto/medio/bajo, etc

library(tidyverse)

#Veamos un ejemplo con los meses del a�o
x1 <- c("Dec", "Apr", "Jan", "Mar")

#Y queremos ordenarlos de acuerdo a su ubicaci�n en el calendario
sort(x1)
#Pero con la funci�n b�sica "sort" no podemos hacerlo

#Para ahorrarnos todos estos problemas vamos a crear un "factor"
#Para crear un factor de forma correcta, primero debemos definir "niveles"
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

#Ahora crearemos el factor
y1 <- factor(x1, levels = month_levels)
y1
#Y cualquier valor que no est� en el conjunto se convertir� silenciosamente a NA

#Si omites el argumento de niveles "levels" el factor ser� creado en orden alfabetico
factor(x1)

#A veces, preferir� que el orden de los niveles coincida con el orden de la primera aparici�n en los datos. 
#Puede hacerlo al crear el factor estableciendo niveles en Unique(x), o despu�s del hecho, con fct_inorder()
f1 <- factor(x1, levels = unique(x1))
f1

f2 <- x1 %>% factor() %>% fct_inorder()
f2

#Para conocer los niveles, solo debe utilizar la funci�n "levels"
levels(f2)


####-----------------------General Social Survey (datos---------------------------####

#Por razones pr�cticas, utilizaremos la General Social Survey del paquete "forcats" 
gss_cat
ls(gss_cat)
str(gss_cat)

#Cuando los factores se almacenan en un tibble, no puede ver sus niveles tan f�cilmente. 
#Una forma sencilla de verlos es con count()
#Veamos los factores de la variable "race"
gss_cat %>%
  count(race)

#Tambi�n podemos verlos con un gr�fico de barras
ggplot(gss_cat, aes(race)) +
  geom_bar(fill = "blue") + labs(title = "Race") 

#Ejercicios

#1. �Cu�l es la religi�n m�s com�n en esta encuesta? �Cu�l es el partyid m�s com�n?

gss_cat %>%
  count(relig) %>%
  arrange(desc(n)) %>%
  head(1) 

gss_cat %>%
  count(partyid) %>%
  arrange(desc(n)) %>%
  head(1)

####-----------------------Modificar el orden de los factores---------------------------####

#Suele ser �til cambiar el orden de los niveles de los factores en una visualizaci�n

#Por ejemplo, queremos ver cu�l grupo religioso ve m�s televisi�n, para ellos ordenaremos la variable
#relig utilizando fct_reorder()
#Utilice fct_reorder() para factores cuyos niveles est�n ordenados arbitrariamente.

#fct_reorder() toma 3 argumentos
#f, el factor cuyos niveles desea modificar
#x, un vector num�rico que desea utilizar para reordenar los niveles
#fun, una funci�n que se usa si hay varios valores de x para cada valor de f. 
#El valor predeterminado es la mediana.

relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

#Esta ser�a otra forma de hacer el gr�fico
relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

#Otra opci�n espec�fica para los gr�ficos es "fct_reorder2()" 
#fct_reorder2() reordena el factor por los valores asociados a los valores x m�s grandes.

by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))
by_age

ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")

#Por �ltimo, para gr�ficos de barra, puede usar fct_infreq() para ordenar niveles en frecuencia creciente: 
#este es el tipo m�s simple de reordenamiento porque no necesita variables adicionales. 
#Es posible que desee combinar con fct_rev()

gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar(fill = "springgreen2")

#Ejercicios

#1. Para cada factor en gss_cat, identifique si el orden de los niveles es arbitrario u ordenado.

#Para resolver este problema, utilizaremos la funci�n "count()" en conjunto con la funci�n "names()"
keep(gss_cat, is.factor) %>% names()
levels(gss_cat[["marital"]])
levels(gss_cat$race)
levels(gss_cat$rincome)
levels(gss_cat$relig)
levels(gss_cat$denom)
levels(gss_cat$partyid)

####-----------------------Modificar el valor de los factores---------------------------####

#M�s poderoso que cambiar el orden de los niveles es cambiar sus valores. 
#Esto le permite aclarar etiquetas para publicaci�n y contraer niveles para visualizaciones de alto nivel.

#La herramienta m�s general y poderosa es fct_recode(). 
#Permite recodificar, o cambiar, el valor de cada nivel, se utiliza en conjunto con "mutate()"

#Veamos por ejemplo la variable "partyid"
gss_cat %>% count(partyid)

#Los niveles son concisos e inconsistentes. 
#Modifiqu�moslos para que sean m�s largos y usemos una construcci�n paralela.
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

#Si desea colapsar/contraer muchos niveles, fct_collapse() es una variante �til de fct_recode()
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)

#A veces, solo desea agrupar todos los grupos peque�os para simplificar un gr�fico o una tabla. 
#Ese es el trabajo de fct_lump()

gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)

#Para que el c�lculo sea m�s preciso, agregaremos el argumento "n="
gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)