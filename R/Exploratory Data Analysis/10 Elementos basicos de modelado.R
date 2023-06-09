#El objetivo de un modelo es proporcionar un resumen simple de baja dimensi�n de un conjunto de datos. 
#Idealmente, el modelo capturar� verdaderas "se�ales" (es decir, patrones generados por el fen�meno de inter�s) 
#e ignorar� el "ruido" (es decir, la variaci�n aleatoria que no le interesa).

#Aqu� solo cubrimos modelos "predictivos", que, como sugiere el nombre, generan predicciones.

###Generaci�n de hip�tesis vs confirmaci�n de hip�tesis###

#1. Cada observaci�n puede usarse para exploraci�n o confirmaci�n, pero no para ambas.

#2. Puede usar una observaci�n tantas veces como quiera para explorar, 
#pero solo puede usarla una vez para confirmar. 
#Tan pronto como use una observaci�n dos veces, habr� cambiado de confirmaci�n a exploraci�n.

#Esto es necesario porque para confirmar una hip�tesis debe utilizar datos independientes 
#de los datos que utiliz� para generar la hip�tesis.

###El 60-20-20###

#Un enfoque es dividir sus datos en tres partes antes de comenzar el an�lisis

#Parte 1: El 60 % de sus datos va a un conjunto de entrenamiento (o exploraci�n). 
#Puede hacer lo que quiera con estos datos: 
#visualizarlos y ajustar toneladas de modelos a ellos

#Parte 2: El 20% se destina a un conjunto de consultas. Puede usar estos datos para comparar modelos o visualizaciones a mano, 
#pero no puede usarlos como parte de un proceso automatizado.

#Parte 3: Se retiene el 20% para un conjunto de prueba. 
#Solo puede usar estos datos UNA VEZ para probar su modelo final.

###�C�mo funciona un modelo?###

#Un modelo tiene dos partes

#1. Primero Modelo Gen�rico/Familia, define una familia de modelos que expresan un patr�n preciso, pero gen�rico, 
#que desea capturar. Por ejemplo, el patr�n podr�a ser una l�nea recta o una curva cuadr�tica. 
#Expresar� la familia modelo como una ecuaci�n como y = a_1 * x + a_2 o y = a_1 * x ^ a_2. 
#Aqu�, x e y son variables conocidas de sus datos, y a_1 y a_2 son par�metros que pueden 
#variar para capturar diferentes patrones.

#2. Segundo Modelo Ajustado, A continuaci�n, genera un modelo ajustado encontrando el modelo de la familia 
#que es el m�s cercano a sus datos. Esto toma la familia de modelos gen�ricos 
#y la hace espec�fica, como y = 3 * x + 7 o y = 9 * x ^ 2.

##########################################################################

#En esta lecci�n utilizaremos las libreriras "tidyverse" y "modelr"

library(tidyverse)
library(modelr)
options(na.action = na.warn)

#Echemos un vistazo al conjunto de datos simulado sim1, incluido con el paquete modelr. 
#Contiene dos variables continuas, x e y. Grafiqu�moslos para ver c�mo se relacionan.
ggplot(sim1, aes(x, y)) + 
  geom_point()

#Puede ver un patr�n fuerte en los datos. Usemos un modelo para capturar ese patr�n y hacerlo expl�cito. 
#Nuestro trabajo es proporcionar la forma b�sica del modelo. 
#En este caso, la relaci�n parece lineal, es decir, y = a_0 + a_1 * x. 
#Comencemos por tener una idea de c�mo se ven los modelos de esa familia 
#generando algunos al azar y superponi�ndolos en los datos.

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)
models

ggplot(sim1, aes(x, y)) + 
  geom_abline(aes(intercept = a1, slope = a2), data = models, alpha = 1/4) +
  geom_point() 

#Hay 250 modelos en esta parcela, �pero muchos son realmente malos! 
#Necesitamos encontrar los buenos modelos precisando nuestra intuici�n, 
#de que un buen modelo est� "cerca" de los datos.

#Necesitamos una forma de cuantificar la distancia entre los datos y un modelo. 
#Entonces podemos ajustar el modelo encontrando el valor de a_0 y a_1 
#que generan el modelo con la distancia m�s peque�a de estos datos.

#Un lugar f�cil para comenzar es encontrar la distancia vertical entre cada punto y el modelo.
#Esta distancia es solo la diferencia entre el valor "y" dado por el modelo (la predicci�n) 
#y el valor "y" real en los datos (la respuesta).

#Para calcular esta distancia, primero convertimos nuestra familia modelo en una funci�n R. 
#Esto toma los par�metros del modelo y los datos como entradas 
#y da los valores predichos por el modelo como salida

model1 <- function(a, data) {
  a[1] + data$x * a[2]
}
model1(c(7, 1.5), sim1)

#En otras palabras, la gr�fica anterior muestra 30 distancias: �c�mo colapsamos eso en un solo n�mero?
#Una forma com�n de hacer esto en estad�stica es usar la "desviaci�n cuadr�tica media". 
#Calculamos la diferencia entre lo real y lo pronosticado, los elevamos al cuadrado, 
#los promediamos y luego sacamos la ra�z cuadrada.

measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}
measure_distance(c(7, 1.5), sim1)

#Ahora podemos usar purrr para calcular la distancia para todos los modelos definidos anteriormente. 
#Necesitamos una funci�n auxiliar porque nuestra funci�n de distancia espera que el modelo 
#sea un vector num�rico de longitud 2.

sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- models %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models

#A continuaci�n, superpongamos los 10 mejores modelos en los datos.

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(models, rank(dist) <= 10)
  )

#Tambi�n podemos pensar en estos modelos como observaciones y visualizarlos 
#con un diagrama de dispersi�n de a1 frente a a2, nuevamente coloreado por -dist.

ggplot(models, aes(a1, a2)) +
  geom_point(data = filter(models, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist))


#En lugar de probar muchos modelos aleatorios, podr�amos ser m�s sistem�ticos y generar 
#una cuadr�cula de puntos espaciados uniformemente (esto se denomina b�squeda de cuadr�cula).

grid <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
) %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>% 
  ggplot(aes(a1, a2)) +
  geom_point(data = filter(grid, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist)) 

#Cuando superpone los 10 mejores modelos en los datos originales, todos se ven bastante bien
ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(grid, rank(dist) <= 10)
  )

#Cuando realizamos un ajuste a una l�nea individual, tendremos nuestros modelo
best <- optim(c(0, 0), measure_distance, data = sim1)
best$par

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2])

###-----------------Modelos lineales------------------------###

#Hay un enfoque m�s que podemos usar para este modelo, porque es un caso especial de una familia m�s amplia: 
#modelos lineales. Un modelo lineal tiene la forma general y = a_1 + a_2 * x_1 + a_3 * x_2 + ... + a_n * x_(n - 1). 
#Entonces, este modelo simple es equivalente a un modelo lineal general donde n es 2 y x_1 es x.

#R tiene una herramienta dise�ada espec�ficamente para ajustar modelos lineales llamada "lm()". 
#lm() tiene una forma especial de especificar la familia de modelos: f�rmulas.
#Las f�rmulas se ven como y ~ x, que lm() traducir� a una funci�n como y = a_1 + a_2 * x.

sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)

#Usando algunas conexiones entre geometr�a, c�lculo y �lgebra lineal, 
#lm() encuentra el modelo m�s cercano en un solo paso, usando un algoritmo sofisticado.

###-----------------Visualizar modelos------------------------###

#1. Predicciones

#Tambi�n es �til ver lo que el modelo no captura, los llamados residuos que quedan 
#despu�s de restar las predicciones de los datos. Los residuos son poderosos porque 
#nos permiten usar modelos para eliminar patrones llamativos para que podamos estudiar 
#las tendencias m�s sutiles que quedan.

#Para visualizar las predicciones de un modelo, comenzamos generando una cuadr�cula 
#de valores espaciados uniformemente que cubre la regi�n donde se encuentran nuestros datos.

grid <- sim1 %>% 
  data_grid(x) 
grid

#A continuaci�n a�adimos predicciones. Usaremos modelr::add_predictions() que toma un data frame y un modelo. 
#Agrega las predicciones del modelo a una nueva columna en el marco de datos

grid <- grid %>% 
  add_predictions(sim1_mod) 
grid

#A continuaci�n, trazamos las predicciones. Quiz�s se pregunte acerca de todo este trabajo adicional 
#en comparaci�n con solo usar geom_abline(). Pero la ventaja de este enfoque es que funcionar� 
#con cualquier modelo en R, desde el m�s simple hasta el m�s complejo.

ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)

#2. Residuales/residuos

#La otra cara de la moneda de las predicciones son los residuos. Las predicciones le indican 
#al patr�n que ha capturado el modelo, y los residuos le indican lo que el modelo ha omitido. 
#Los residuos son solo las distancias entre los valores observados y predichos que calculamos anteriormente.

#Agregamos residuales a los datos con add_residuals(), que funciona de manera muy similar a add_predictions()

sim1 <- sim1 %>% 
  add_residuals(sim1_mod)
sim1

#Hay algunas formas diferentes de entender lo que los residuos nos dicen sobre el modelo. 
#Una forma es simplemente dibujar un pol�gono de frecuencia para ayudarnos a comprender 
#la dispersi�n de los residuos.
ggplot(sim1, aes(resid)) + 
  geom_freqpoly(binwidth = 0.5)

#A menudo querr� recrear gr�ficos utilizando los residuos en lugar del predictor original.
ggplot(sim1, aes(x, resid)) + 
  geom_ref_line(h = 0) +
  geom_point() 

###-----------------Formulas y familias de modelos------------------------###

#Si desea ver lo que R realmente hace, puede usar la funci�n model_matrix(). 
#Toma un marco de datos y una f�rmula y devuelve un tibble que define la ecuaci�n del modelo: 
#cada columna en la salida est� asociada con un coeficiente en el modelo, 
#la funci�n siempre es y = a_1 * out1 + a_2 * out_2

df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)

model_matrix(df, y ~ x1)

#La matriz del modelo crece de manera poco sorprendente cuando agrega m�s variables al modelo
model_matrix(df, y ~ x1 + x2)

#1. Variables categoricas

#Generar una funci�n a partir de una f�rmula es sencillo cuando el predictor es continuo, 
#pero las cosas se complican un poco m�s cuando el predictor es categ�rico.

#Lo que hace R es convertirlo a y = x_0 + x_1 * sex_male 
#donde sex_male es uno si sex es masculino y cero en caso contrario

df <- tribble(
  ~ sex, ~ response,
  "male", 1,
  "female", 2,
  "male", 1
)

df

model_matrix(df, response ~ sex)

#2. Interacciones (continuas y categ�ricas)

#�Qu� pasa cuando combinas variables continuas y categoricas?
ggplot(sim3, aes(x1, y)) + 
  geom_point(aes(colour = x2))

#Para visualizar estos modelos necesitamos dos nuevos trucos:
  
#Tenemos dos predictores, por lo que debemos dar a data_grid() ambas variables. 
#Encuentra todos los valores �nicos de x1 y x2 y luego genera todas las combinaciones.
#Para generar predicciones a partir de ambos modelos simult�neamente, 
#podemos usar un m�todo gather_predictions() que agrega cada predicci�n como una fila. 
#El complemento de gather_predictions() es spread_predictions() que agrega cada predicci�n a una nueva columna.

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  gather_predictions(mod1, mod2)
grid

#Podemos visualizar el modelo de la forma siguiente

ggplot(sim3, aes(x1, y, colour = x2)) + 
  geom_point() + 
  geom_line(data = grid, aes(y = pred)) + 
  facet_wrap(~ model)

#�Qu� modelo es mejor para estos datos? Podemos echar un vistazo a los residuos.

sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, colour = x2)) + 
  geom_point() + 
  facet_grid(model ~ x2)

#3. Interacciones (dos variables continuas)

#Datos

mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)

grid <- sim4 %>% 
  data_grid(
    x1 = seq_range(x1, 5), 
    x2 = seq_range(x2, 5) 
  ) %>% 
  gather_predictions(mod1, mod2)
grid

#Tenga en cuenta el uso de seq_range() dentro de data_grid().
#Hay tres argumentos clave, que podemos utilizar con "seq_range()":

#pretty = TRUE generar� una secuencia "bonita", es decir, algo que se ve bien para el ojo humano. 
#Esto es �til si desea producir tablas de salida
seq_range(c(0.0123, 0.923423), n = 5)
seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE)

#trim = 0.1 recortar� el 10% de los valores de la cola. Esto es �til si las variables tienen una 
#distribuci�n de cola larga y desea concentrarse en generar valores cerca del centro
x1 <- rcauchy(100)
seq_range(x1, n = 5)
seq_range(x1, n = 5, trim = 0.10)
seq_range(x1, n = 5, trim = 0.25)
seq_range(x1, n = 5, trim = 0.50)

#expand = 0.1 es en cierto sentido lo opuesto a trim(), expande el rango en un 10%.
x2 <- c(0, 1)
seq_range(x2, n = 5)
seq_range(x2, n = 5, expand = 0.10)
seq_range(x2, n = 5, expand = 0.25)
seq_range(x2, n = 5, expand = 0.50)

#Ahora vamos a graficar las predicciones
ggplot(grid, aes(x1, x2)) + 
  geom_tile(aes(fill = pred)) + 
  facet_wrap(~ model)

ggplot(grid, aes(x1, pred, colour = x2, group = x2)) + 
  geom_line() +
  facet_wrap(~ model)
ggplot(grid, aes(x2, pred, colour = x1, group = x1)) + 
  geom_line() +
  facet_wrap(~ model)

#4. Transformaciones

#Las transformaciones son �tiles porque puede usarlas para aproximar funciones no lineales. 
#Si ha tomado una clase de c�lculo, es posible que haya o�do hablar del teorema de Taylor, 
#que dice que puede aproximar cualquier funci�n suave con una suma infinita de polinomios.

#Eso significa que puede usar una funci�n polinomial para acercarse arbitrariamente 
#a una funci�n suave ajustando una ecuaci�n como y = a_1 + a_2 * x + a_3 * x^2 + a_4 * x ^ 3

df <- tribble(
  ~y, ~x,
  1,  1,
  2,  2, 
  3,  3
)
model_matrix(df, y ~ x^2 + x)
model_matrix(df, y ~ I(x^2) + x)
model_matrix(df, y ~ poly(x, 2))

#Sin embargo, hay un gran problema con el uso de poly(): fuera del rango de los datos, 
#los polinomios se disparan r�pidamente hacia el infinito positivo o negativo. 
#Una alternativa m�s segura es usar la spline natural, splines::ns().

library(splines)
model_matrix(df, y ~ ns(x, 2))

sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)

ggplot(sim5, aes(x, y)) +
  geom_point()

###-----------------Missing Values-----------------------###

#Las funciones de modelado eliminar�n las filas que contengan valores faltantes. 
#El comportamiento predeterminado de R es dejarlos caer silenciosamente

df <- tribble(
  ~x, ~y,
  1, 2.2,
  2, NA,
  3, 3.5,
  4, 8.3,
  NA, 10
)

mod <- lm(y ~ x, data = df)

#Para suprimir la advertencia, configure na.action = na.exclude:
mod <- lm(y ~ x, data = df, na.action = na.exclude)
mod