#En esta lección aprenderemos como manipular "strings" con "regular expressions" en R

library(tidyverse)
#Utilizaremos específicamente la libreria "sringr"


####----------Elementos básicos de los strings-----------------####

#En R los strings pueden ser creados con comillas dobles o simples
string1 <- "Esto es un texto"
string1
string2 <- 'Si quieres incluir "comillas" en el texto, utiliza simples afuera y dobles adentro'
string2

#En algunos casos será necesario incluir una comilla " como parte del texto
#en ese caso debemos utilizar una barra invertida "\" para "escaparlo" (para que quede representado en el texto)
comilla_doble <- "\"" # or '"'
writeLines(comilla_doble)
comilla_simple <- '\'' # or "'"
writeLines(comilla_simple)

#Ahora si quieres incluir una barra invertida, tendras que colocarla doble \\
x <- c("\"", "\\")
x

#Para poder observar el verdadero contenido de un string, debemos utilizar la función "writeLines()"
#porque coloca los elementos de forma real
writeLines(x)


#Otros elementos comunes son new_line "\n" y tabular "\t"

#Cuando queremos utilizar múltiples strings, debemos almacenarlos en un vector
c("one", "two", "three")

###Longitud de un string - str_length()

#Para conocer la longitud de un string, podemos utilizar la función str_length()
#Nos dice cuantas letras tiene la palabra, pero no nos dice cuántas hay
str_length(c("a", "R for data science", NA))
str_length(c("Cesar", "Kobe", "Michael"))


###############----Funciones---------#########################

#Combinar strings:           "str_c()" 
#Subdividr strings:          "str_sub()"
#Ordenar strings:            "str_sort()" para el contenido y "str_order()" para el posicionamiento númerico
#Quitar espacios en blanco:  "str_trim()"
#Agregar espacios en blanco: "str_pad()"


####-------------Combinar strings------------------------####

#Para combinar uno o más strings se utiliza "str_c()"
str_c("c", "a", "s", "a")
str_c("a", "z", "u", "l")

#Utilizando str_c() y el argumento "sep", podemos definir el tipo de separador
str_c("A", "B", sep = ", ")

#Para poder ver un valor NA, debemos utilizar str_replace_na()
x <- c("abc", NA)
str_c("|-", str_replace_na(x), "-|")

#Para colapsar (unir/combinar) elementos en un solo vector, debemos utilizar el argumento "collapse"
str_c(c("c", "a", "s", "a"), collapse = "")
str_c(c("x", "y", "z"), collapse = ", ")

####-------------Subdividr (subsetting) strings------------------------####

#Puedes extraer partes de un string utilizando la funcion "str_sub()"
#debemos definir el inicio "start" y el final "end" de la selección
x <- c("Manzana", "Banana", "Pera")
str_sub(x, 1, 3) #Del vector x, toma las letras de cada elemento, desde la posición 1 hasta la posición 3

# Numero negativos cuenta los caracteres del final al principio 
str_sub(x, -3, -1)

#La función "str_sub()" también aplica, para realizar modificaciones
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))#Volvemos la primera letra mínuscula 
x

####-------------Ordenar strings------------------------####

#Para ordenar los strings podemos utilizar dos funciones: str_sort() para el contenido
#y str_order() para el posicionamiento númerico
x <- c("manzana", "aguacate", "banana")

str_sort(x, locale = "en")
str_order(x)

str_sort(texto, locale = "es")
str_order(texto)
####-------------Quitar o agregar espacios en blanco------------------------####

#La función str_trim() quita los espacios en blanco de un string
str_trim(" abc ")
str_trim(" abc ", side = "left")
str_trim(" abc ", side = "right")

#Por el contrario str_pad() agrega espacios
str_pad("abc", 5, side = "both")
str_pad("abc", 4, side = "right")
str_pad("abc", 4, side = "left")

####-----------Coincidencia de patrones con expresiones regulares-------------------####

#Para poder trabajar con Expresiones Regulares debemos utilizar str_view() y str_view_all()
#Estas funciones toman un vector de caracteres y una expresión regular, y muestran cómo coinciden

#Hay un conjunto significativo de elementos, que pueden ser utilizados con expresiones regulares

# ^      para que coincida con el inicio de la cadena (fija un punto de inicio)
# $      para que coincida con el final de la cadena (fija un punto de finalización)
# "."    funciona para acceder o coincidir cualquier caracter, menos un salto de linea
# \d     coincide con cualquier dígito
# \s     coincide con cualquier espacio en blanco (por ejemplo, espacio, tabulador, nueva línea).
#[abc]:  coincide a, b, o c.
#[^abc]: coincide con cualquier cosa excepto a, b o c.
# ?:     repeteción 0 o 1
# +:     repeteción 1 o más veces
# *:     repeteción 0 o más veces
#\d - Representa un dígito del 0 al 9.
#\w - Representa cualquier carácter alfanumérico.
#\s - Representa un espacio en blanco.
#\D - Representa cualquier carácter que no sea un dígito del 0 al 9.
#\W - Representa cualquier carácter no alfanumérico.
#\S - Representa cualquier carácter que no sea un espacio en blanco.
#\A - Representa el inicio de la cadena. No un carácter sino una posición.
#\Z - Representa el final de la cadena. No un carácter sino una posición.
#\b - Marca la posición de una palabra limitada por espacios en blanco, puntuación o el inicio/final de una cadena.
#\B - Marca la posición entre dos caracteres alfanuméricos o dos no-alfanuméricos.
# {n}:   la letra aparece el número de veces que indiquemos
# {,m}:  como mucho m
# {n,m}: entre n y m. La letra solo aparecerá en el rango que indíquemos
# (.)\1\1:        El mismo carácter que aparece tres veces seguidas. P.ej. "aaa"
# "(.)(.)\\2\\1": un par de caracteres seguidos del mismo par de caracteres en orden inverso. P.ej. "abba".
#(..)\1:          Dos caracteres cualesquiera repetidos. P.ej. "a1a1".
#"(.).\\1.\\1":   Un carácter seguido de cualquier carácter, el carácter original, 
#cualquier otro carácter, el carácter original nuevamente. P.ej. "ábaca", "b8b.b".
#"(.)(.)(.).*\\3\\2\\1" Tres caracteres seguidos de cero o más caracteres de cualquier tipo 
#seguidos de los mismos tres caracteres pero en orden inverso. P.ej. "abcsgasgddsadgsdgcba" o "abccba" o "abc1cba"


#1. Coincidencias básicas

#Se trata de hacer coincidir letras o caracteres dentro de un texto
x <- c("pera", "manzana", "banana")
str_view(x, "an")

# To create the regular expression, we need \\
dot <- "\\."
dot

# But the expression itself only contains one:
writeLines(dot)
#> \.

# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

#2. Anclas

#Por defecto, una expresión regular hará coincidir cualquier parte del texto
#por eso es necesario utilizar "anclas" para que fijen un punto de inicio y fin específico en el texto
#Básicamente tenemos dos tipos de anclas:
#   ^ para que coincida con el inicio de la cadena.
#   $ para que coincida con el final de la cadena.

#Tenemos la variable x
x <- c("aguacate", "banana", "pera")

#Si queremos ver las palabras que comienza con a utilizamos ^
str_view(x, "^a")

#Pero si queremos ver las palabras que terminan con a utilizamos $
str_view(x, "a$")

#Si queremos que el resultado sea una coincidencia exacta de la palabra
#debemos combinar ^ y $ junto con la palabra
x <- c("torta de zanahoria", "zanahoria", "sopa de zanahoria")
str_view(x, "^zanahoria$")

#Ejercicios

#Utilizando datos precargados de stringr::words, determine lo siguiente:

#Palabras que comienzan con "y".
str_view(stringr::words, "^y", match = TRUE)

#Palabras que terminan con "x"
str_view(stringr::words, "x$", match = TRUE)

#Palabras que solo tienen 3 letras
str_view(stringr::words, "^...$", match = TRUE)

#Palabras que tienen 7 letras o más
str_view(stringr::words, ".......", match = TRUE)

#3. Otras clases de caracteres y alternativas

#Hay un conjunto significativo de elementos, que pueden ser utilizados con expresiones regulares

# "."    funciona para acceder o coincidir cualquier caracter, menos un salto de linea
# \d     coincide con cualquier dígito
# \s     coincide con cualquier espacio en blanco (por ejemplo, espacio, tabulador, nueva línea).
#[abc]:  coincide a, b, o c.
#[^abc]: coincide con cualquier cosa excepto a, b o c.
# ?:     repeteción 0 o 1
# +:     repeteción 1 o más veces
# *:     repeteción 0 o más veces

#Ejemplos

str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")

#Recuerde, para crear una expresión regular que contenga \d o \s, deberá escapar de \ para la cadena, 
#por lo que deberá escribir "\\d" o "\\s".

#Un elemento adicional que podemos utilizar es un pipeline |, que tienen la funcion de OR
str_view(c("grey", "gray"), "gr(e|a)y")

#4. Repeticiones de caracteres 

#El siguiente paso es conocer cuántas veces se repite un patron o caracter, para ello utilizaremos

# ?: 0 o 1
# +: 1 o más veces
# *: 0 o más veces

#Veamos la siguiente variable
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"

#veamos si la combinación "CC" aparece 0 o una vez con "?"
str_view(x, "CC?")

#Pero sabemos que en el string hay tres letras C, para poder verlas tenemos que utilizar "+"
str_view(x, "CC+")

#También puede especificar el número de coincidencias con precisión:

# {n}: la letra aparece el número de veces que indiquemos
str_view(x, "C{2}")

# {n,}: n o más. La letra aparece el número de veces que indiquemos y otras más
str_view(x, "C{2,}")

# {,m}: como mucho m
# {n,m}: entre n y m. La letra solo aparecerá en el rango que indíquemos
str_view(x, "C{2,3}")
str_view(x, "C{2}")

#Ejercicios 

#Crea expresiones regulares para encontrar todas las palabras que:

#Comiencen con tres consonantes.
str_view(words, "^[^aeiou]{3}", match = TRUE)

#Tengan tres o más vocales seguidas.
str_view(words, "[aeiou]{3,}", match = TRUE)

#Tengan dos o más pares de vocales y consonantes seguidos.
str_view(words, "([aeiou][^aeiou]){2,}", match = TRUE)

#Ejercicios

#Comienza y termina con el mismo caracter
str_subset(words, "^(.)((.*\\1$)|\\1?$)")

#Contiene un par repetido de letras (por ejemplo, church'' containsch'' repetido dos veces).
str_subset(words, "([A-Za-z][A-Za-z]).*\\1")

#Contiene una letra repetida en al menos tres lugares (por ejemplo, once'' contiene trese's).
str_subset(words, "([a-z]).*\\1.*\\1")

####----------Ejercicios con todo lo aprendido-----------------#### 

#En esta serie de ejercicios aprenderás: 

# ¿Cuáles strings coinciden con un patrón?
# Encontrar las posiciones de las coincidencias
# Extraer el contenido de las coincidencias
# Reemplazar las coincidencias con nuevos valores
# Dividir un string basado en una coincidencia


#Para detectar una coincidencia se utliza "str_detect()"
#Para obtener coincidencias exactas, utilizaremos la función "str_extract()"
#str_replace() y str_replace_all() le permiten reemplazar coincidencias con nuevas cadenas.
#Para la coincidencia de un elemento individual: str_match()
#str_split() para dividir una cadena en partes. Por ejemplo, podríamos dividir oraciones en palabras
#str_locate() y str_locate_all() le brindan las posiciones inicial y final de cada coincidencia

#Si te quedas atascado tratando de crear una única expresión regular que resuelva tu problema, 
#da un paso atrás y piensa, si podrías dividir el problema en partes más pequeñas, 
#resolviendo cada desafío de forma individual antes de pasar al siguiente.

###---------------1. Detectar patrones/coincidencias-------------------------###

#Para detectar una coincidencia se utliza "str_detect()"
#La salida es un boolean: True or False
x <- c("aguacate", "banana", "pera")
str_detect(x, "e")

#Recuerda que cuando utiliza un vector lógico en un contexto numérico, 
#FALSO se convierte en 0 y VERDADERO se convierte en 1
#Esto facilita la realización de cálculos como sum() y mean() u otros conteos

#¿Cuántas palabras comienzan con la letra t?
sum(str_detect(words, "^t"))
#¿Cuántas palabras comienzan con la letra w?
sum(str_detect(words, "^w"))

#¿Qué proporción de palabras comunes terminan en vocal?
mean(str_detect(words, "[aeiou]$"))
mean(str_detect(words, "[ou]$"))

# Encuentra todas las palabras que contienen al menos una vocal 
no_vowels_1 <- !str_detect(words, "[aeiou]")
no_vowels_1

#Un uso común de str_detect() es seleccionar los elementos que coinciden con un patrón. 
#Puede hacer esto con subconjuntos lógicos, o el conveniente str_subset()
words[str_detect(words, "x$")]
words[str_count(words, "o$")]
str_subset(words, "x$")
str_subset(words, "o$")

#Una variación de str_detect() es "str_count()": 
#en lugar de un simple sí o no, te dice cuántas coincidencias hay en una cadena.
x <- c("aguacate", "banana", "pera")
str_count(x, "p")

# En promedio, ¿cuántas vocales por palabra?
mean(str_count(words, "[aeiou]"))

#Es común utilizar "str_count()" con mutate()
df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]"))

#Ejercicios

#1) ¿Palabras que empiezan o terminan con x?
words[str_detect(words, "^x|x$")]

#Por partes
start_with_x <- str_detect(words, "^x")
end_with_x <- str_detect(words, "x$")
words[start_with_x | end_with_x]

#2) Palabras que comienzan con vocal y terminan con consonante
str_subset(words, "^[aeiou].*[^aeiou]$") %>% head()

#Por partes
start_with_vowel <- str_detect(words, "^[aeiou]")
end_with_consonant <- str_detect(words, "[^aeiou]$")
words[start_with_vowel & end_with_consonant] %>% head()

#3) ¿Hay palabras que contengan al menos una de cada vocal diferente?

#Utilizamos cinco expresiones diferentes y el & para indicar coincidencia exacta en el resultado
words[str_detect(words, "a") &
        str_detect(words, "e") &
        str_detect(words, "i") &
        str_detect(words, "o") &
        str_detect(words, "u")]

###---------------2. Extraer patrones/coincidencias-------------------------###

#Para obtener coincidencias exactas, utilizaremos la función "str_extract()"
length(sentences)
head(sentences, 10)

#Imagina que queremos encontrar todas las oraciones que contienen un color. 
#Primero creamos un vector de nombres de colores y luego lo convertimos en una sola expresión regular

#Vector
colours <- c("red", "orange", "yellow", "green", "blue", "purple")

#Regex
colour_match <- str_c(colours, collapse = "|")
colour_match

#Ahora podemos seleccionar las oraciones que contienen un color 
#y luego extraer el color para averiguar cuál es.
has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)

#Tenga en cuenta que str_extract() solo extrae la primera coincidencia. 
#Podemos ver eso más fácilmente seleccionando primero todas las oraciones que tienen más de 1 coincidencia:
more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)

#Para obtener todas las coincidencias, use str_extract_all(). Devuelve una lista:
str_extract_all(more, colour_match)
str_extract_all(more, colour_match, simplify = TRUE)

#Ejercicios

#1. La primera palabra de cada oración.
str_extract(sentences, "[A-ZAa-z]+") %>% head()

#2. Todas las palabras que terminen con "ing"
pattern <- "\\b[A-Za-z]+ing\\b"
sentences_with_ing <- str_detect(sentences, pattern)
unique(unlist(str_extract_all(sentences[sentences_with_ing], pattern))) %>%
  head()

#3. Todos los plurales
unique(unlist(str_extract_all(sentences, "\\b[A-Za-z]{3,}s\\b"))) %>%
  head()

###---------------3. Coincidencias agrupadas-------------------------###

#Hablamos sobre el uso de paréntesis () para aclarar la precedencia y 
#para referencias inversas "//" al hacer coincidir. 
#También puede usar paréntesis para extraer partes de una coincidencia compleja.

noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)
has_noun %>% 
  str_extract(noun)

#str_extract() nos da la coincidencia completa; pero str_match() da cada componente individual. 
#En lugar de un vector de caracteres, devuelve una matriz, 
#con una columna para la coincidencia completa seguida de una columna para cada grupo:

has_noun %>% 
  str_match(noun)

#Si la tabla es un "tibble" es recomendable utilizar "tidyr::extract()", pero esto requiere
#colocar los nombres que queremos encontrar

tibble(sentence = sentences) %>% 
  tidyr::extract(sentence, c("article", "noun"), "(a|the) ([^ ]+)", 
                 remove = FALSE)
                 
#Ejercicios
                 
#1. Encuentra todas las palabras que vienen después de un "número" como "uno", "dos", "tres", etc. 
#Saca tanto el número como la palabra.
                 
numword <- "\\b(one|two|three|four|five|six|seven|eight|nine|ten) +(\\w+)"
sentences[str_detect(sentences, numword)] %>%
str_extract(numword)
                 
#2. Encuentra todas las contracciones. Separe las piezas antes y después del apóstrofe.
                 
contraction <- "([A-Za-z]+)'([A-Za-z]+)"
sentences[str_detect(sentences, contraction)] %>%
                   str_extract(contraction) %>%
                   str_split("'")

###---------------4. Reemplazar coincidencias-------------------------###

#str_replace() y str_replace_all() le permiten reemplazar coincidencias con nuevas cadenas. 
#El uso más simple es reemplazar un patrón con una cadena fija:

x <- c("aguante", "pera", "cambur")
str_replace(x, "[aeiou]", "-") #Reemplaza solo la primera coincidencia
str_replace_all(x, "[aeiou]", "-") #Reemplaza todas las coincidencias

#Con str_replace_all() puede realizar múltiples reemplazos proporcionando un vector con nombre:

x <- c("1 casa", "2 carros", "3 personas")
str_replace_all(x, c("1" = "una", "2" = "dos", "3" = "tres"))

#Ejercicios

#1. Implemente una versión simple de str_to_lower() usando replace_all()

replacements <- c("A" = "a", "B" = "b", "C" = "c", "D" = "d", "E" = "e",
                  "F" = "f", "G" = "g", "H" = "h", "I" = "i", "J" = "j", 
                  "K" = "k", "L" = "l", "M" = "m", "N" = "n", "O" = "o", 
                  "P" = "p", "Q" = "q", "R" = "r", "S" = "s", "T" = "t", 
                  "U" = "u", "V" = "v", "W" = "w", "X" = "x", "Y" = "y", 
                  "Z" = "z")
lower_words <- str_replace_all(words, pattern = replacements)
head(lower_words)

#2. Cambia la primera y la última letra de las palabras. ¿Cuáles de esas cadenas siguen siendo palabras?

swapped <- str_replace_all(words, "^([A-Za-z])(.*)([A-Za-z])$", "\\3\\2\\1")
intersect(swapped, words)

###---------------5. Dividir coincidencias-------------------------###

#Use str_split() para dividir una cadena en partes. Por ejemplo, podríamos dividir oraciones en palabras:

sentences %>%
  head(5) %>% 
  str_split(" ")

#Puedes utilizar simplify = TRUE para devolver una matriz

sentences %>%
  head(5) %>% 
  str_split(" ", simplify = TRUE)

#También puede solicitar un número máximo de palabras, agrengando el argumento "n=":

fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% str_split(": ", n = 2, simplify = TRUE)

#En lugar de dividir cadenas por patrones, también puede dividirlas por carácter, 
#línea, y palabra utilizando boundary()
x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))
str_split(x, " ")[[1]]
str_split(x, boundary("word"))[[1]]

#Ejercicios

#1. Divide una cadena como "manzanas, peras y plátanos" en componentes individuales.
x <- c("apples, pears, and bananas")
str_split(x, ", +(and +)?")[[1]]

###---------------6. Encontrar coincidencias/patrones-------------------------###

#str_locate() y str_locate_all() le brindan las posiciones inicial y final de cada coincidencia. 
#Estos son particularmente útiles cuando ninguna de las otras funciones hace exactamente lo que desea. 
#Puede usar str_locate() para encontrar el patrón coincidente, str_sub() para extraerlo y/o modificarlo.

fruit <- c("aguacate", "banana", "pera", "piña")
str_locate(fruit, "$")
str_locate(fruit, "a")
str_locate(fruit, "e")
str_locate(fruit, c("a", "b", "p", "p"))

str_locate_all(fruit, "a")
str_locate_all(fruit, "e")
str_locate_all(fruit, c("a", "b", "p", "p"))