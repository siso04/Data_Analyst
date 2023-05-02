#En este capítulo, aprenderá tres ideas poderosas que lo ayudarán a trabajar 
#con una gran cantidad de modelos con facilidad

#1. Uso de muchos modelos simples para comprender mejor los conjuntos de datos complejos.

#2. Uso de columnas de lista para almacenar estructuras de datos arbitrarias en un marco de datos. 
#Por ejemplo, esto le permitirá tener una columna que contenga modelos lineales.

#3. Usando el paquete "broom", de David Robinson, para convertir modelos en datos ordenados. 
#Esta es una técnica poderosa para trabajar con una gran cantidad de modelos 
#porque una vez que tiene datos ordenados, puede aplicar todas las técnicas que aprendió anteriormente en el libro.

library(modelr)
library(tidyverse)

#Los datos de gapminder resumen la progresión de los países a lo largo del tiempo, 
#analizando estadísticas como la esperanza de vida y el PIB.

library(gapminder)
ls(gapminder)
str(gapminder)
gapminder
unique(gapminder$country)

#¿Cómo cambia la esperanza de vida (lifeExp) con el tiempo (año) para cada país (país)?

gapminder %>% 
  ggplot(aes(year, lifeExp, group = country)) +
  geom_line(alpha = 1/3)

#Separaremos estos factores ajustando un modelo con una tendencia lineal. 
#El modelo captura un crecimiento constante a lo largo del tiempo y los residuos mostrarán lo que queda

nz <- filter(gapminder, country == "New Zealand")
nz %>% 
  ggplot(aes(year, lifeExp)) + 
  geom_line() + 
  ggtitle("Full data = ")

#Modelo lineal

nz_mod <- lm(lifeExp ~ year, data = nz)
nz %>% 
  add_predictions(nz_mod) %>%
  ggplot(aes(year, pred)) + 
  geom_line() + 
  ggtitle("Linear trend + ")

#Residuales

nz %>% 
  add_residuals(nz_mod) %>% 
  ggplot(aes(year, resid)) + 
  geom_hline(yintercept = 0, colour = "white", size = 3) + 
  geom_line() + 
  ggtitle("Remaining pattern")

####-----------------Datos anidados-----------------------####

#Este problema está estructurado de manera un poco diferente a lo que has visto antes. 
#En lugar de repetir una acción para cada variable, queremos repetir una acción para cada país, 
#un subconjunto de filas. Para hacer eso, necesitamos una nueva estructura de datos: 
#el marco de datos anidado. Para crear un marco de datos anidado, 
#comenzamos con un marco de datos agrupados y lo "anidamos"

by_country <- gapminder %>% #Seleccionamos la tabla
  group_by(country, continent) %>%#Agrupamos por las variables
  nest()#Anidamos la tabla

by_country #Tiene cuatro variables adentro cada registro

#Esto crea un marco de datos que tiene una fila por grupo (por país) y una columna bastante inusual: datos. 
#data es una lista de marcos de datos (o tibbles, para ser precisos). 
#Esto parece una idea loca: tenemos un marco de datos con una columna que es una lista de otros marcos de datos

View(by_country)
by_country$data[[3]]

####-----------------Listas-Columnas-----------------------####

#Ahora que tenemos nuestro marco de datos anidado, estamos en una buena posición para ajustar algunos modelos.

country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}
country_model

#Y queremos aplicarlo a cada marco de datos. Los marcos de datos están en una lista, 
#por lo que podemos usar purrr::map() para aplicar country_model a cada elemento

models <- map(by_country$data, country_model)
models

#Sin embargo, en lugar de dejar la lista de modelos como un objeto flotante, 
#creo que es mejor almacenarlo como una columna en el marco de datos por_país. 
#Almacenar objetos relacionados en columnas es una parte clave del valor de los marcos de datos, 
#y por eso creo que las "columnas de lista" son una buena idea

#En otras palabras, en lugar de crear un nuevo objeto en el entorno global, 
#vamos a crear una nueva variable en el marco de datos por_país. Ese es un trabajo para dplyr::mutate()

by_country <- by_country %>% 
  mutate(model = map(data, country_model))
by_country #Cada registro tiene el modelo asociado y las cuatro variables
View(by_country)

#Esto tiene una gran ventaja: debido a que todos los objetos relacionados 
#se almacenan juntos, no necesita mantenerlos sincronizados manualmente cuando filtra u organiza
by_country %>% 
  filter(continent == "Europe")

by_country %>% 
  arrange(continent, country)

####-----------------Desanidar los datos-----------------------####

by_country <- by_country %>% 
  mutate(
    resids = map2(data, model, add_residuals)
  )
by_country

#Anteriormente usamos nest() para convertir un marco de datos regular en un marco de datos anidado, 
#y ahora hacemos lo contrario con unnest()
#Esto debemos hacerlo, para calcular los residuales de los individuos

resids <- unnest(by_country, resids)
resids

#Ahora que tenemos un marco de datos regular, podemos trazar los residuos

resids %>% 
  ggplot(aes(year, resid)) +
  geom_line(aes(group = country), alpha = 1 / 3) + 
  geom_smooth(se = FALSE)

#Veamos el mismo gráfico por continente
resids %>% 
  ggplot(aes(year, resid, group = country)) +
  geom_line(alpha = 1 / 3) + 
  facet_wrap(~continent)

####-----------------Calidad del modelo-----------------------####

#El paquete "broom()" proporciona un conjunto general de funciones para convertir modelos 
#en datos ordenados. Aquí usaremos broom::glance() para extraer algunas métricas de calidad 
#del modelo. Si lo aplicamos a un modelo, obtenemos un marco de datos con una sola fila

broom::glance(nz_mod)

#Podemos usar mutate() y unnest() para crear un marco de datos con una fila para cada país:

by_country %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance)

#Para simplificar la salida, utilizamos ".drop = TRUE"

glance <- by_country %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance, .drop = TRUE)
glance

#Con este marco de datos en la mano, podemos empezar a buscar modelos que no encajen bien:

glance %>% 
  arrange(r.squared)

glance %>% 
  ggplot(aes(continent, r.squared)) + 
  geom_jitter(width = 0.5)

bad_fit <- filter(glance, r.squared < 0.25)

gapminder %>% 
  semi_join(bad_fit, by = "country") %>% 
  ggplot(aes(year, lifeExp, colour = country)) +
  geom_line()

####-----------------Lista-Columna-----------------------####

#Las columnas de lista suelen ser más útiles como estructura de datos intermedia.

#En general, hay tres partes de un pipe de columna de lista efectiva:
  
#1. La columna de lista se crea con una de nest(), summarise() + list() o mutate() + una función map, 
#como se describe en Creación de columnas de lista.

#2.Usted crea otras columnas de lista intermedias transformando las columnas de lista existentes 
#con map(), map2() o pmap(). Por ejemplo, en el estudio de caso anterior, 
#creamos una columna de lista de modelos transformando una columna de lista de un data frame.

#3. Simplificas la columna de lista de nuevo a un marco de datos o vector atómico, 
#como se describe en Simplificación de columnas de lista.

###-----------------Creación de columnas de lista--------------------------###

#Las creará a partir de columnas regulares, utilizando uno de estos tres métodos:

#Con tidyr::nest() para convertir un marco de datos agrupados en un marco de datos 
#anidado donde tiene una columna de lista de marcos de datos.

#Con mutate() y funciones vectorizadas que devuelven una lista.

#Con summarise() y funciones de resumen que devuelven múltiples resultados.

#1. Con elementos anidados 

#nest() crea un marco de datos anidado, que es un marco de datos con una columna de lista de marcos de datos

gapminder %>% 
  group_by(country, continent) %>% 
  nest()

gapminder %>% 
  nest(data = c(year:gdpPercap))

#2. Con funciones de vectores 

df <- tribble(
  ~x1,
  "a,b,c", 
  "d,e,f,g"
) 

df %>% 
  mutate(x2 = stringr::str_split(x1, ","))

df %>% 
  mutate(x2 = stringr::str_split(x1, ",")) %>% 
  unnest(x2)

#3. De resúmenes multivaluados

mtcars %>% 
  group_by(cyl) %>% 
  summarise(q = list(quantile(mpg)))

#4. De una lista nombrada

x <- list(
  a = 1:5,
  b = 3:4, 
  c = 5:6
) 

df <- enframe(x)
df

#Otras formas de crear listas

str_split(sentences[1:3], " ")
str_match_all(c("abc", "aa", "aabaa", "abbbc"), "a+")
map(1:3, runif)

###-----------------Simplificar las lista-columna (volver al original)--------------------------###

#Lista a vector

df <- tribble(
  ~x,
  letters[1:5],
  1:3,
  runif(5)
)

df %>% mutate(
  type = map_chr(x, typeof),
  length = map_int(x, length)

df <- tribble(
    ~x,
    list(a = 1, b = 2),
    list(a = 2, c = 4)
  )

df %>% mutate(
    a = map_dbl(x, "a"),
    b = map_dbl(x, "b", .null = NA_real_)
  )  
  
#Desanidar - Unnesting  

tibble(x = 1:2, y = list(1:4, 1)) %>% unnest(y)

df1 <- tribble(
  ~x, ~y,           ~z,
  1, c("a", "b"), 1:2,
  2, "c",           3
)
df1

df1 %>% unnest(c(y, z))
  