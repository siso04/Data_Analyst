#En esta lección haremos una recopilación, de los principales elementos de programación en R

library(tidyverse)

######---------Utilización de los pipes %>% --------######

#El objetivo del pipe es ayudarlo a escribir código de una manera que sea más fácil de leer y comprender.

#El pipe funciona mediante la realización de una "transformación léxica": 
#detrás de escena, magrittr vuelve a ensamblar el código en la tubería de una forma 
#que funciona sobrescribiendo un objeto intermedio

#Permite escribir una secuencia de operaciones de izquierda a derecha
#first(x) %>% second(x) %>% third(x)

#Tabla storms
storms
names(storms)
str(storms)

#Veamos un ejemplo con "select()"
select(storms, status, pressure)

#Utilizando el pipe seria
storms %>% select(status, pressure)
storms %>% select(name, status, category) %>% filter(category >= 3) %>% arrange(desc(category)) %>% head(20)
unique(storms$category)

#Veamos lo mismo con "filter()"
filter(storms, wind >= 50)
#Ahora con el pipe
storms %>% filter(wind >= 70) %>% arrange(desc(wind)) %>% head(20) 

#Podemos combinar select y filter
storms %>% select(status, pressure, wind) %>% filter(wind >= 50)

storms %>%
  filter(wind>=50) %>%
  select(name, pressure, wind)

###############################

######---------Funciones en R--------######

#Las funciones le permiten automatizar tareas comunes de una manera más poderosa y general que copiar y pegar

#Una función es un conjunto de instrucciones que convierten las entradas (inputs) en resultados (outputs) 

#Escribir una función tiene tres grandes ventajas sobre el uso de copiar y pegar:

#1. Puede dar a una función un nombre sugerente que haga que su código sea más fácil de entender.
#2. A medida que cambian los requisitos, solo necesita actualizar el código en un solo lugar
#3. Elimina la posibilidad de cometer errores incidentales al copiar y pegar

#Debería considerar escribir una función siempre que haya copiado y pegado un bloque de código más de dos veces

#Como ejemplo creemos un tibble con cuatro series de datos

df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df


#Hay tres pasos clave para crear una función:

#1. Debe elegir un nombre para la función. Aquí he usado rescale01 
#porque esta función cambia la escala de un vector para que esté entre 0 y 1.

#Usted enumera las entradas, o argumentos, a la función dentro de la función. 
#Aquí tenemos un solo argumento. Si tuviéramos más, la llamada se vería como función (x, y, z).

#3. Colocas el código que has desarrollado en el cuerpo de la función, 
#un bloque { que sigue inmediatamente a la función (...).

nombre_de_funcion <- function(par1, par2, ...) {
  cuerpo
  cuerpo
  cuerpo
  cuerpo
  return(resultado)
}

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(c(0, 5, 10))

#Podemos convertir un código normal
mean(is.na(x))

prop_na <- function(x) {
  mean(is.na(x))
}
prop_na(c(0, 1, 2, NA, 4, NA))

###-------------------------Condicionales----------------------------###

if (condition) {
  # code executed when condition is TRUE
} else {
  # code executed when condition is FALSE
}

has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}
has_name

#Pueden encadenarse múltiples condiciones con "elif"
if (this) {
  # do that
} else if (that) {
  # do something else
} else {
  # 
}

#Estilo

if (y < 0 && debug) {
  message("Y is negative")
}

if (y == 0) {
  log(x)
} else {
  y ^ x
}

greet <- function(time = lubridate::now()) {
  hr <- lubridate::hour(time)
  if (hr < 12) {
    print("good morning")
  } else if (hr < 17) {
    print("good afternoon")
  } else {
    print("good evening")
  }
}

greet()
greet(ymd_h("2017-01-08:05"))
greet(ymd_h("2017-01-08:13"))
greet(ymd_h("2017-01-08:20"))

mean_ci <- function(x, conf = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

commas <- function(...) stringr::str_c(..., collapse = ", ")
commas(letters[1:10])

rule <- function(..., pad = "-") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}
rule("Important output")

###------------------Argumentos de una funcion------------------------###


#Los argumentos de una función generalmente se dividen en dos conjuntos amplios: 
#un conjunto proporciona los datos para calcular 
#y el otro proporciona argumentos que controlan los detalles del cálculo.

#En log(), los datos son x y el detalle es la base del logaritmo.
#En mean(), los datos son x, y los detalles son cuántos datos recortar de los extremos (trim) 
#y cómo manejar los valores faltantes (na.rm).
#En t.test(), los datos son x e y, y los detalles de la prueba son 
#alternativos, mu, emparejados, var.equal y conf.level.
#En str_c() puede proporcionar cualquier cantidad de cadenas a ..., 
#y los detalles de la concatenación están controlados por sep y collapse.

#En general, los argumentos de datos deben ser lo primero. 
#Los argumentos detallados deben ir al final y, por lo general, deben tener valores predeterminados.

# Compute confidence interval around mean using normal approximation
mean_ci <- function(x, conf = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}
x <- runif(100)
mean_ci(x)

##########################

######---------Vectores--------######

#Los vectores son componentes básicos de R, la mayor parte de las funciones y operaciones
#se realizan a través de vectores/listas

library(tidyverse)

#Hay dos tipos de vectores:

#1. Vectores atómicos, de los cuales hay seis tipos: lógicos, enteros, dobles, de carácter, complejos y brutos. 
#Los vectores enteros y dobles se conocen colectivamente como vectores numéricos.
#2. Listas, que a veces se denominan vectores recursivos porque las listas pueden contener otras listas.

#Los vectores atómicos, contienen solo un tipo de datos, mientras que las listas, contienen diferentes tipos

#Todos los vectores tienen dos componentes básicos:

#1. El tipo
typeof(letters)
typeof(1:10)

#2. La longitud (cantidad de elementos que lo componen)
x <- list("a", "b", 1:10)
length(x)

#Una última condición es la de "vectores aumentados"

#Hay tres tipos importantes de vectores aumentados:

#Los factores se construyen sobre vectores enteros.
#Las fechas y las fechas/horas se construyen sobre vectores numéricos.
#Los data frame y los tibbles se construyen sobre listas.

####-------------Los vectores atómicos--------------####

#1. Lógicos

#Los vectores lógicos son el tipo más simple de vector atómico porque 
#solo pueden tomar tres valores posibles: FALSE, TRUE, and NA
#Los vectores lógicos generalmente se construyen con operadores de comparación (mayor, y menor que, igual, etc).

1:10 %% 3 == 0
c(TRUE, TRUE, FALSE, NA)

#2. Numéricos 

#Los vectores enteros y dobles se conocen colectivamente como vectores numéricos.
typeof(1)
typeof(1L)
1.5L

#Evite usar == para verificar estos otros valores especiales. 
#En su lugar, utilice las funciones auxiliares is.finite(), is.infinite() y is.nan()

#3. Carácteres

#Los vectores de caracteres son el tipo más complejo de vector atómico, porque cada elemento de un vector 
#de caracteres es una cadena, y una cadena puede contener una cantidad arbitraria de datos (letras).

x <- "This is a reasonably long string."
x
typeof(x)
length(x)

#4. Missing Values

#Tenga en cuenta que cada tipo de vector atómico tiene su propio valor faltante

NA            # logical
NA_integer_   # integer
NA_real_      # double
NA_character_ # character

####-------------Utilizando vectores atómicos--------------####

#Para aprender a utilizarlos, debemos responder las siguientes preguntas:

#1. Cómo convertir de un tipo a otro, y cuándo eso sucede automáticamente.
#2. Cómo saber si un objeto es un tipo específico de vector.
#3. ¿Qué sucede cuando trabajas con vectores de diferentes longitudes?
#4. Cómo nombrar los elementos de un vector.
#5. Cómo extraer elementos de interés.


###1.Cómo convertir de un tipo a otro, y cuándo sucede esto automáticamente.

#Hay dos formas de convertir, o coaccionar, un tipo de vector a otro:

#1)La coerción explícita ocurre cuando llamas a una función como: as.logical(), as.integer(), as.double(), or as.character().
#2)La coerción implícita ocurre cuando usa un vector en un contexto específico que espera un cierto tipo de vector

#Ya has visto el tipo más importante de coerción implícita: usar un vector lógico en un contexto numérico. 
#En este caso VERDADERO se convierte en 1 y FALSO se convierte en 0

x <- sample(20, 100, replace = TRUE)
y <- x > 10
sum(y)
mean(y)

###2. Cómo saber si un objeto es un tipo específico de vector.

#A veces quieres hacer cosas diferentes según el tipo de vector. Una opción es usar typeof()
#Pero es mejor utilizar funciones con el prefijo "is"
# is_logical(), is_integer(), is_double(), is_numeric(), is_character(), is_atomic(), is_list(), is_vector()

is.numeric(x)

#3. ¿Qué sucede cuando trabajas con vectores de diferentes longitudes? Reciclaje

#Además de coaccionar implícitamente los tipos de vectores para que sean compatibles, 
#R también coaccionará implícitamente la longitud de los vectores. 
#Esto se denomina reciclaje de vectores, porque el vector más corto se repite, o se recicla, 
#con la misma longitud que el vector más largo.

1:10 + 1:3
#Aquí, R expandirá el vector más corto a la misma longitud que el más largo, lo que se denomina reciclaje.

#Si desea reciclar, deberá hacerlo usted mismo con rep()
tibble(x = 1:4, y = rep(1:2, 2))
tibble(x = 1:4, y = rep(1:2, each = 2))

#4. Cómo nombrar los elementos de un vector.

#Se pueden nombrar todos los tipos de vectores. Puedes nombrarlos durante la creación con c()
c(x = 1, y = 2, z = 4)

#O con "set names"
set_names(1:3, c("a", "b", "c"))

#5. Cómo extraer/seleccionar elementos de interés. Subsetting

#Para realizar subsetting a un vector se utilizan corchetes 
#[ es la función de subconjunto, y se llama como x[a]. 
#Hay cuatro tipos de cosas con las que puede crear un subconjunto de un vector

#1)Un vector numérico que contiene solo números enteros. 
#Los números enteros deben ser todos positivos, todos negativos o cero.

x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)] 
x[c(1, 1, 5, 5, 5, 2)]

#Los valores negativos colocan los elementos en las posiciones especificadas:
x[c(-1, -3, -5)]

#Es un error mezclar valores positivos y negativos:
x[c(1, -1)]

#2)El subconjunto con un vector lógico mantiene todos los valores correspondientes a un valor VERDADERO. 
#Esto suele ser útil junto con las funciones de comparación.

x <- c(10, 3, NA, 5, 8, 1, NA)

# All non-missing values of x
x[!is.na(x)]
# All even (or missing!) values of x
x[x %% 2 == 0]

#3)Si tiene un vector con nombre, puede crear subconjuntos con un vector de caracteres:

x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]

#4)El tipo más simple de subconjunto es nada.
#x[], que devuelve la x completa

#####-------------Vectores recursivos - Listas--------------####

#Las listas son un paso más en complejidad que los vectores atómicos, 
#porque las listas pueden contener otras listas. 
#Esto los hace adecuados para representar estructuras jerárquicas o en forma de árbol.

#1. Elementos básicos

#Creas una lista con "list()"

x <- list(1, 2, 3)
x
typeof(x)

#Una herramienta muy útil para trabajar con listas es "str()" porque se centra en la estructura, 
#no en el contenido.
str(x)
x_named <- list(a = 1, b = 2, c = 3)
str(x_named)

#A diferencia de los vectores atómicos, list() puede contener una combinación de objetos o contener otras listas
y <- list("a", 1L, 1.5, TRUE)
str(y)

z <- list(list(1, 2), list(3, 4))
str(z)

#2. Subdividir una lista

#Hay tres formas de crear subconjuntos de una lista, que ilustraré con una lista llamada a:

a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))

#Un corchete [ extrae una sublista. El resultado siempre será una lista.
#Al igual que con los vectores, puedes crear subconjuntos con un vector lógico, entero o de caracteres.
str(a[1:2]) #Selecciona los dos primeros elementos de la lista

#Dos corchetes [[ extrae un solo componente de una lista. Elimina un nivel de jerarquía de la lista.
str(a[[1]])
str(a[[4]])

# El simbolo de dolar "$" es una abreviatura para extraer elementos con nombre de una lista. 
#Funciona de manera similar a [[ excepto que no necesita usar comillas.
a$a
a[["a"]]

#####-------------Atributos de los vectores--------------####

#Puede obtener y establecer valores de atributos individuales con attr() 
#o verlos todos a la vez con attributes()

x <- 1:10
attr(x, "greeting")

attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Bye!"
attributes(x)

#Hay tres atributos muy importantes que se utilizan para implementar partes fundamentales de R:

#Los nombres se utilizan para nombrar los elementos de un vector.
#Las dimensiones (dims, para abreviar) hacen que un vector se comporte como una matriz o arreglo.
#La clase se utiliza para implementar el sistema orientado a objetos de S3.

#####-------------Vectores aumentados--------------####

#1. Factores
#2. Fechas
#3. Fecha-horas
#4. Tibbles

#1. Factores

#Los factores están diseñados para representar datos categóricos que pueden tomar un conjunto 
#fijo de valores posibles. Los factores se construyen sobre números enteros y tienen un atributo de niveles

x <- factor(c("ab", "cd", "ab"), levels = c("uno", "dos", "tres"))
typeof(x)
attributes(x)

#2 y 3. Fechas y Fechas-Horas

#Las fechas en R son vectores numéricos que representan el número de días desde el 1 de enero de 1970.

x <- as.Date("1971-01-01")
unclass(x)
typeof(x)
attributes(x)

#4. Tibbles

#Los Tibbles son listas aumentadas: tienen la clase "tbl_df" + "tbl" + "data.frame", 
#y los atributos names (columna) y row.names (filas)
tb <- tibble::tibble(x = 1:5, y = 5:1)
tb

typeof(tb)
attributes(tb)
names(tb)
row.names(tb)

#La diferencia entre un tibble y una lista es que todos los elementos de un data frame
#deben ser vectores con la misma longitud. 
#Todas las funciones que funcionan con tibbles imponen esta restricción.
