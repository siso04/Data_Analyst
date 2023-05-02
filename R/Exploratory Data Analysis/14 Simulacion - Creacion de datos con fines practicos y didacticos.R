#Simulaciones

#Las simulaciones permiten realizar calculos o plantear escenarios de prueba para los datos
#Tambien permiten aplicar funciones estadisticas, para ver como se comportan

#La primera funcion para crear datos es sample()
sample(1:6, 4, replace = TRUE)

#sample(1:6, 4, replace = TRUE) indica a R que seleccione aleatoriamente cuatro números entre 1 y 6, CON
#reemplazo. El muestreo con reemplazo simplemente significa que cada número se "reemplaza" después de seleccionarlo,
#para que el mismo número pueda aparecer más de una vez. Esto es lo que queremos aquí, ya que lo que tiras 
#en un dado en uno no debera afectar lo que tiras en otro.

#Para crear una muestra sin reemplazo, sencillamente dejamos por fuera el argumento replace
sample(1:20, 20)
[1]  1  7  8  5  6 15  9  4 11 20
#Sin reemplazo cada uno de los numeros aparece una sola vez

#Cada distribucion de probabilidad en R tiene una funcion r*** (para random "aleatoria"), 
#una función d*** (para density "densidad"), una funcion p***
#(para probability "probabilidad"), y q*** (para quantile "cuantil")

#En R podemos simular muestras de datos de distintas distribuciones estadisticas
#Para una distribucion binominal utilizarmos rbinom()
#Por ejemplo rbinom(100, size = 1, prob = 0.7)

#Sin embargo, la disribucion mas utilizada para pruebas es la DISTRIBUCION NORMAL (media 0, desviacion 1)
#La funcion es rnorm(). Dentro de los parentesis, metemos la cantidad de datos que queremos simular
rnorm(10) #Genera diez numeros de una distribucion normal
rnorm(100, 25) #Genera 100 numeros, y el segundo argumento es opcional, en este caso la desviacion de 25