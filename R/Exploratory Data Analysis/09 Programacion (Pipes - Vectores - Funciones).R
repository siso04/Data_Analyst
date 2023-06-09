#En esta lecci�n haremos una recopilaci�n, de los principales elementos de programaci�n en R

library(tidyverse)

######---------Utilizaci�n de los pipes %>% --------######

#El objetivo del pipe es ayudarlo a escribir c�digo de una manera que sea m�s f�cil de leer y comprender.

#El pipe funciona mediante la realizaci�n de una "transformaci�n l�xica": 
#detr�s de escena, magrittr vuelve a ensamblar el c�digo en la tuber�a de una forma 
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

#Las funciones le permiten automatizar tareas comunes de una manera m�s poderosa y general que copiar y pegar

#Una funci�n es un conjunto de instrucciones que convierten las entradas (inputs) en resultados (outputs) 

#Escribir una funci�n tiene tres grandes ventajas sobre el uso de copiar y pegar:

#1. Puede dar a una funci�n un nombre sugerente que haga que su c�digo sea m�s f�cil de entender.
#2. A medida que cambian los requisitos, solo necesita actualizar el c�digo en un solo lugar
#3. Elimina la posibilidad de cometer errores incidentales al copiar y pegar

#Deber�a considerar escribir una funci�n siempre que haya copiado y pegado un bloque de c�digo m�s de dos veces

#Como ejemplo creemos un tibble con cuatro series de datos

df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df


#Hay tres pasos clave para crear una funci�n:

#1. Debe elegir un nombre para la funci�n. Aqu� he usado rescale01 
#porque esta funci�n cambia la escala de un vector para que est� entre 0 y 1.

#Usted enumera las entradas, o argumentos, a la funci�n dentro de la funci�n. 
#Aqu� tenemos un solo argumento. Si tuvi�ramos m�s, la llamada se ver�a como funci�n (x, y, z).

#3. Colocas el c�digo que has desarrollado en el cuerpo de la funci�n, 
#un bloque { que sigue inmediatamente a la funci�n (...).

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

#Podemos convertir un c�digo normal
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

#Pueden encadenarse m�ltiples condiciones con "elif"
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


#Los argumentos de una funci�n generalmente se dividen en dos conjuntos amplios: 
#un conjunto proporciona los datos para calcular 
#y el otro proporciona argumentos que controlan los detalles del c�lculo.

#En log(), los datos son x y el detalle es la base del logaritmo.
#En mean(), los datos son x, y los detalles son cu�ntos datos recortar de los extremos (trim) 
#y c�mo manejar los valores faltantes (na.rm).
#En t.test(), los datos son x e y, y los detalles de la prueba son 
#alternativos, mu, emparejados, var.equal y conf.level.
#En str_c() puede proporcionar cualquier cantidad de cadenas a ..., 
#y los detalles de la concatenaci�n est�n controlados por sep y collapse.

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

#Los vectores son componentes b�sicos de R, la mayor parte de las funciones y operaciones
#se realizan a trav�s de vectores/listas

library(tidyverse)

#Hay dos tipos de vectores:

#1. Vectores at�micos, de los cuales hay seis tipos: l�gicos, enteros, dobles, de car�cter, complejos y brutos. 
#Los vectores enteros y dobles se conocen colectivamente como vectores num�ricos.
#2. Listas, que a veces se denominan vectores recursivos porque las listas pueden contener otras listas.

#Los vectores at�micos, contienen solo un tipo de datos, mientras que las listas, contienen diferentes tipos

#Todos los vectores tienen dos componentes b�sicos:

#1. El tipo
typeof(letters)
typeof(1:10)

#2. La longitud (cantidad de elementos que lo componen)
x <- list("a", "b", 1:10)
length(x)

#Una �ltima condici�n es la de "vectores aumentados"

#Hay tres tipos importantes de vectores aumentados:

#Los factores se construyen sobre vectores enteros.
#Las fechas y las fechas/horas se construyen sobre vectores num�ricos.
#Los data frame y los tibbles se construyen sobre listas.

####-------------Los vectores at�micos--------------####

#1. L�gicos

#Los vectores l�gicos son el tipo m�s simple de vector at�mico porque 
#solo pueden tomar tres valores posibles: FALSE, TRUE, and NA
#Los vectores l�gicos generalmente se construyen con operadores de comparaci�n (mayor, y menor que, igual, etc).

1:10 %% 3 == 0
c(TRUE, TRUE, FALSE, NA)

#2. Num�ricos 

#Los vectores enteros y dobles se conocen colectivamente como vectores num�ricos.
typeof(1)
typeof(1L)
1.5L

#Evite usar == para verificar estos otros valores especiales. 
#En su lugar, utilice las funciones auxiliares is.finite(), is.infinite() y is.nan()

#3. Car�cteres

#Los vectores de caracteres son el tipo m�s complejo de vector at�mico, porque cada elemento de un vector 
#de caracteres es una cadena, y una cadena puede contener una cantidad arbitraria de datos (letras).

x <- "This is a reasonably long string."
x
typeof(x)
length(x)

#4. Missing Values

#Tenga en cuenta que cada tipo de vector at�mico tiene su propio valor faltante

NA            # logical
NA_integer_   # integer
NA_real_      # double
NA_character_ # character

####-------------Utilizando vectores at�micos--------------####

#Para aprender a utilizarlos, debemos responder las siguientes preguntas:

#1. C�mo convertir de un tipo a otro, y cu�ndo eso sucede autom�ticamente.
#2. C�mo saber si un objeto es un tipo espec�fico de vector.
#3. �Qu� sucede cuando trabajas con vectores de diferentes longitudes?
#4. C�mo nombrar los elementos de un vector.
#5. C�mo extraer elementos de inter�s.


###1.C�mo convertir de un tipo a otro, y cu�ndo sucede esto autom�ticamente.

#Hay dos formas de convertir, o coaccionar, un tipo de vector a otro:

#1)La coerci�n expl�cita ocurre cuando llamas a una funci�n como: as.logical(), as.integer(), as.double(), or as.character().
#2)La coerci�n impl�cita ocurre cuando usa un vector en un contexto espec�fico que espera un cierto tipo de vector

#Ya has visto el tipo m�s importante de coerci�n impl�cita: usar un vector l�gico en un contexto num�rico. 
#En este caso VERDADERO se convierte en 1 y FALSO se convierte en 0

x <- sample(20, 100, replace = TRUE)
y <- x > 10
sum(y)
mean(y)

###2. C�mo saber si un objeto es un tipo espec�fico de vector.

#A veces quieres hacer cosas diferentes seg�n el tipo de vector. Una opci�n es usar typeof()
#Pero es mejor utilizar funciones con el prefijo "is"
# is_logical(), is_integer(), is_double(), is_numeric(), is_character(), is_atomic(), is_list(), is_vector()

is.numeric(x)

#3. �Qu� sucede cuando trabajas con vectores de diferentes longitudes? Reciclaje

#Adem�s de coaccionar impl�citamente los tipos de vectores para que sean compatibles, 
#R tambi�n coaccionar� impl�citamente la longitud de los vectores. 
#Esto se denomina reciclaje de vectores, porque el vector m�s corto se repite, o se recicla, 
#con la misma longitud que el vector m�s largo.

1:10 + 1:3
#Aqu�, R expandir� el vector m�s corto a la misma longitud que el m�s largo, lo que se denomina reciclaje.

#Si desea reciclar, deber� hacerlo usted mismo con rep()
tibble(x = 1:4, y = rep(1:2, 2))
tibble(x = 1:4, y = rep(1:2, each = 2))

#4. C�mo nombrar los elementos de un vector.

#Se pueden nombrar todos los tipos de vectores. Puedes nombrarlos durante la creaci�n con c()
c(x = 1, y = 2, z = 4)

#O con "set names"
set_names(1:3, c("a", "b", "c"))

#5. C�mo extraer/seleccionar elementos de inter�s. Subsetting

#Para realizar subsetting a un vector se utilizan corchetes 
#[ es la funci�n de subconjunto, y se llama como x[a]. 
#Hay cuatro tipos de cosas con las que puede crear un subconjunto de un vector

#1)Un vector num�rico que contiene solo n�meros enteros. 
#Los n�meros enteros deben ser todos positivos, todos negativos o cero.

x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)] 
x[c(1, 1, 5, 5, 5, 2)]

#Los valores negativos colocan los elementos en las posiciones especificadas:
x[c(-1, -3, -5)]

#Es un error mezclar valores positivos y negativos:
x[c(1, -1)]

#2)El subconjunto con un vector l�gico mantiene todos los valores correspondientes a un valor VERDADERO. 
#Esto suele ser �til junto con las funciones de comparaci�n.

x <- c(10, 3, NA, 5, 8, 1, NA)

# All non-missing values of x
x[!is.na(x)]
# All even (or missing!) values of x
x[x %% 2 == 0]

#3)Si tiene un vector con nombre, puede crear subconjuntos con un vector de caracteres:

x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]

#4)El tipo m�s simple de subconjunto es nada.
#x[], que devuelve la x completa

#####-------------Vectores recursivos - Listas--------------####

#Las listas son un paso m�s en complejidad que los vectores at�micos, 
#porque las listas pueden contener otras listas. 
#Esto los hace adecuados para representar estructuras jer�rquicas o en forma de �rbol.

#1. Elementos b�sicos

#Creas una lista con "list()"

x <- list(1, 2, 3)
x
typeof(x)

#Una herramienta muy �til para trabajar con listas es "str()" porque se centra en la estructura, 
#no en el contenido.
str(x)
x_named <- list(a = 1, b = 2, c = 3)
str(x_named)

#A diferencia de los vectores at�micos, list() puede contener una combinaci�n de objetos o contener otras listas
y <- list("a", 1L, 1.5, TRUE)
str(y)

z <- list(list(1, 2), list(3, 4))
str(z)

#2. Subdividir una lista

#Hay tres formas de crear subconjuntos de una lista, que ilustrar� con una lista llamada a:

a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))

#Un corchete [ extrae una sublista. El resultado siempre ser� una lista.
#Al igual que con los vectores, puedes crear subconjuntos con un vector l�gico, entero o de caracteres.
str(a[1:2]) #Selecciona los dos primeros elementos de la lista

#Dos corchetes [[ extrae un solo componente de una lista. Elimina un nivel de jerarqu�a de la lista.
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

#Los factores est�n dise�ados para representar datos categ�ricos que pueden tomar un conjunto 
#fijo de valores posibles. Los factores se construyen sobre n�meros enteros y tienen un atributo de niveles

x <- factor(c("ab", "cd", "ab"), levels = c("uno", "dos", "tres"))
typeof(x)
attributes(x)

#2 y 3. Fechas y Fechas-Horas

#Las fechas en R son vectores num�ricos que representan el n�mero de d�as desde el 1 de enero de 1970.

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
#Todas las funciones que funcionan con tibbles imponen esta restricci�n.
