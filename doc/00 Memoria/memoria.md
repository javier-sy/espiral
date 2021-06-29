# Sábado, 14 noviembre 2020



- Hacer una doble cuantización genera glitches interesantes

```
quantized_ts_array = m.to_p(time_dimension: 2, keep_time: true).collect do |line|
  sts = line.to_timed_serie().flatten_timed.split.collect(&:quantize)
  TIMED_UNION(*sts)
end
```

- No tener en cuenta que las timed series NO deben comenzar todas a la vez 
(falta el parámetro time_start_component: 2)

```
quantized_ts_array = m.to_p(time_dimension: 2, keep_time: true).collect do |line|
  sts = line.to_timed_serie(base_duration: 1).flatten_timed.split.collect # (&:quantize)
  TIMED_UNION(*sts)
end
```

- No separar cada línea melódica generada por las diferentes condensed_matrices 
hace que los puntos de cada línea se alternen, generando saltos que crean 
una "malla" cubriendo una sección de la vuelta de la espiral

```

quantized_ts_array = m.to_p(time_dimension: 2, keep_time: true).collect do |line|
  sts = line.to_timed_serie(time_start_component: 2, base_duration: 1).flatten_timed.split.collect # (&:quantize)
  TIMED_UNION(*sts)
end

#...

coordinates = nil
sequencer.at 1 do
  quantized_ts_array.each do |qts|

    puts "qts.peek_next_value #{qts.i.peek_next_value}"

    sequencer.play_timed qts.i do |values, next_values, duration:, quantized_duration:|
      coordinates = [values[0] || coordinates[0], values[1] || coordinates[1], sequencer.position - 1r]
      mp.render_point(:base, coordinates, color: 0x0fffff)

      violin.note 72 + values[0], duration: quantized_duration[0], velocity: 90 + 5*coordinates[1], legato: true if values[0]
      cello.note 48 + values[1], duration: quantized_duration[1], velocity: 90 + 5*coordinates[0], legato: true if values[1]
    end
  end
end
```

- Hay algunos ángulos de inclinación que hacen que pete la renderización 3D 
(parece que hay que moverse en la ventana para que falle), 
haciendo que las últimas notas queden encendidas 
(y durante unos instantes tiene sentido musicalmente). Esto se puede reproducir
parando la ejecución de notas en algún momento.

- Hay algún problema que hace que la línea de violín se interrumpa (la de cello, en cambio, no)
Aún no he identificado qué es. Es interesante que al parar el violín establece frases con pausas.
El problema era que las velocity midi > 127 no se envían y había algunas notas generadas que superaban ese valor.

# Sábado, 14 noviembre 2020

- Se podría hacer la distribución a los diferentes instrumentos también según 
la velocidad de los movimientos. Movimientos rápidos pueden ir a la flauta 
en frases cortas, p.ej.

# Jueves, 19 noviembre 2020

Ya he conseguido que genere partitura.

- Es interesante que cuanto más vueltas hacia atrás da la espiral de cada línea, más voces son necesarias
del instrumento para llevar en paralelo las armonías. Llegan a sobrepasar las 8 voces de instrumento, 
lo cual hace que sea sensato poner un límite. Ese límite conduce a una eventual eliminación de material
melódico que genera una variación sobre la dinámica de aumento de voces que va dándose. El efecto musical
es interesante.

Cada vez estoy más impresionado del resultado.

# Viernes, 20 noviembre 2020

Subido a github.

Había problemas con las series split y vueltas a TIMED_UNION a la hora de generar una partitura
a través del código que tiene en cuenta dinámicas y transición entre instrumentos. Esto me lleva a 
que será necesario rediseñar la estrategia de prototype/instance de las series.

# Lunes, 23 noviembre 2020

Hay problemas con la generación de partitura.

# Miércoles, 25 noviembre 2020

Problemas de partitura resueltos. Mayormente eran problemas de no ser coherente al usar el modelo 
basado en series con transformaciones. Las transformaciones van bien, lo que pasa es que yo le 
ponía atributos nuevos en pasos del flujo de transformaciones más avanzados y eso impedía que
las propias transformaciones los transformaran correctamente.

Aún falta añadir los legatos en las cuerdas.

Voy a empezar el curso de orquestación.

# Lunes, 3 mayo 2021

Al volver a ejecutar espiral.rb, casualmente tenía cargado en Live un sinte monofónico (Knifonium con preset Franken Lead)
que escuchaba en todos los canales midi. El principio es un poco soso pero la continuación es espectacular.
Se produce una reducción de todas las voces a 1.

Podría usarse este glitch para generar una voz alta y una baja, p.ej.

Volviendo a la intención original de renderizar sobre instrumentos de cuerda, compruebo
que se repiten notas consecutivamente en diferentes voces. Para notas basadas en el ataque es válido, pero para notas basadas en legato es 
mejor evitar los diferentes note-on y crear uno sólo con la duración total; quizás con una modulación
de intensidad según la intensidad de cada note-on. Por otro lado que la misma nota esté en varias voces es sólo una cuestión de que hay
unos unísonos eventuales que estarán ubicados en diferentes instrumentos, dando un timbre diferente.

Preguntándome cómo hacer la orquestación, factor determinante para decidir cómo "mapear" las dimensiones
de la espiral, se me ocurre emplear un "continuo tímbrico" en el que ubicar cada instrumento/ataque. Puede ser una o varias dimensiones.

A priori, selecciono un conjunto de instrumentos (cuerdas, piccolo, flauta, 
lengüeta simple: clarinete, clarinete bajo; lengüeta doble: oboe, fagot, corno inglés; 
metal: corno francés, trompeta, trombón, tuba, trombón contrabajo; 
percusión con altura: campanas tubulares, marimba, vibráfono, glockenspiel). 
Aunque supera el número inicial de 24 (condición para tener un instrumento por altavoz con una pieza para 24 altavoces) que quería usar me parece viable que sean más (hasta quizás 48?)
puesto que no sonarán todos a la vez y se puede repetir altavoz.

# Martes, 4 mayo 2021

Para estudiar la posibilidad del "continuo tímbrico" de los instrumentos realizo experimentos
haciendo el análisis espectral de los instrumentos. La intención es comprobar las diferencias espectrales y de ello deducir una o más dimensiones.
(quizás proporción de parciales armónicos vs inarmónicos, armónicos pares vs impares, cantidad de armónicos, etc)

Los resultados están en documento dentro del proyecto.

# Miércoles, 5 mayo 2021

He estado analizando las distribuciones espectrales de los instrumentos de la orquesta.
He comenzado a pautar el orden de los armónicos, y voy a poder indicar los niveles relativos de cada uno, hasta cerca del 20º armónico.
Con esto tendré la información para establecer dimensiones en base a varios parámetros.
Se me ocurren, por ahora: 
- En qué posición ordinal está la fundamental (sorprendentemente muchos instrumentos tienen una fundamental más débil que los armónicos)?
- Qué predominancia de armónicos consonantes/disonantes hay?
- Hay otros parciales significativos?

# Jueves, 6 mayo 2021

Durante la medición de los armónicos he tenido que construir una "regla" gráfica a medida de las gráficas de espectro para poder
trasladar numéricamente la intensidad relativa de los armónicos a ruby. Este instrumento ha permitido que sea una tarea relativamente fácil.
Antes de hacer la versión final me era tremendamente lento trasladar los números.

En esto se aprecia cómo una herramienta influye en la creación y cómo su influencia abre nuevas posibilidades.

# Viernes, 7 mayo 2021

Sigo pautando los datos de los armónicos.

Añado el clavicordio (harpsichord) de Pianoteq.

Sorprendente la cantidad de parciales no armónicos de los instrumentos 
percusivos "tonales". Prácticamente sólo tienen 3 o 4 armónicos reconocibles clave (el 3 y 4 entre ellos, que definen la quinta y la segunda octava)

Ahora que ya tengo los datos de sustain pautados para los instrumentos "armónicos" y para los percusivos "inarmónicos", 
¿cómo convierto los datos en dimensiones sensibles perceptualmente coherentes?

Se me ocurre:

- Diferencia de nivel entre la fundamental y el armónico más intenso
- Posición en que cae el armónico más intenso: ¿qué intérvalo juega? ¿es un intérvalo consonante/disonante?
- Proporción de parciales vs armónicos; ponderación en base al nivel y a la proximidad con la fundamental.
- Intensidad acumulada de los parciales, agrupada por nota sobre la que caen
- Regularidad del perfil armónico: 
  - intensidades decrecientes/crecientes
  - por cuántos armónicos seguidos crece/decrece la intensidad
  - nº y "volumen" (suma de intensidades? media de intensidades?) de los perfiles "campana" (subida+bajada)
  
# Sábado, 8 mayo 2021

Para analizar los datos tabulados de armónicos se me ocurre representarlos gráficamente para ir comparando variables.
En Ruby no hay buenas librerías gráficas. Opto por estudiar Jupyter Lab que, sorpresa, ahora incluye un kernel Ruby.

# Domingo, 9 mayo 2021

Estudiando Jupyter-Lab. Todo un mundo en análisis de datos y computación científica.
Parece que iruby en Jupyterlab no funciona bien, al menos con los paquetes de presentación como "daru-view".

# Lunes, 10 mayo 2021

Estudio "IPython Interactive Computing and Visualization" (Cyrille Rosant).
Compruebo que los elementos gráficos interactivos no funcionan en Safari pero sí en Chrome.
Voy a comprobar si IRuby funciona mejor con Chrome.
Los problemas eran diversos al ejecutar IRuby en Jupiterlab, entre ellos que jupyter lab, a diferencia de jupyter notebook, tiene un bug que hace que no se visualicen los gráficos con javascript en el notebook!
Tras varios pruebas compruebo que la mejor opción es tener una máquina docker con jupyter con iruby, compartiendo la carpeta del proyecto.

```sh
docker run -d -it -p 8888:8888 --name jupyter-espiral --mount type=bind,source="$(pwd)",target=/home/jovyan/work rubydata/minimal-notebook

docker logs jupyter-espiral
```

Con esta combinación sí que se dibujan gráficos:

```ruby
require 'daru/view'
Daru::View.plotting_library = :highcharts

@line_graph = Daru::View::Plot.new(
        data=[43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
)

@line_graph.show_in_iruby
```

# Martes, 11 mayo 2021

El desarrollo de herramientas para análisis científico se ha centrado en python porque se inició con IPython.
Posteriormente ha surgido la iniciativa SciRuby que ha agrupado varias herramientas en Ruby.

Estudio SciRuby, para, al menos, entender cómo funciona IRuby, daru, y daru-view, las principales que creo que necesito para analizar los datos de los parciales.

Parece ser que "daru", que sería el sustituto de "pandas" no tiene las mismas prestaciones. Concretamente no permite representar gráficamente varias líneas de datos a la vez de forma automática.

Vuelvo a instalar jupyter lab con python que, al final, pone la vida más fácil.

Continuo estudiando "Learning IPython for Interactive Computing and Data Visualization" (Cyrille Rosant).

# Miércoles, 12 mayo 2021

Continuo estudiando "Learning IPython for Interactive Computing and Data Visualization" (Cyrille Rosant).

# Jueves, 13 mayo 2021

Continuo estudiando "Learning IPython for Interactive Computing and Data Visualization" (Cyrille Rosant).
Parte gráfica interactiva.

# Viernes, 14 mayo 2021

Continuo estudiando "Learning IPython for Interactive Computing and Data Visualization" (Cyrille Rosant).
Parte gráfica interactiva.

Comienzo a pensar en cómo analizar los parciales de los instrumentos.

- Agrupar los parciales en el pitch-class:
  - contar el nº de parciales 
  - intensidad por pitch-class
  - coherencia de pitch (es decir, en parciales altos donde hay más parciales en una sola pitch class pero lo están de forma inexacta)
  - tener en cuenta el rango de frecuencias en que el oído discrimina mejor la altura como notas?
  
Esto combinaría el timbre con la armonía y daría explicación de la compatibilidad entre timbres.

- Predominancia relativa de frecuencias altas sobre bajas y medias (en escala logarítmica)

# Lunes, 17 mayo 2021

Pensando ya en las siguientes dimensiones está la articulación, ahora bien, la articulación
tiene varios aspectos diferentes (cada tipo de articulación está vinculado a un componente diferente de la ejecución):

- Ataque (ej: pizzicato, staccato, etc.)
- "Cuerpo tímbrico" (cuivré, sul ponticello, etc.)
- Modulación (vibrato, tremolo)
- Intepretación (ej: double/triple tongue, legato)

# Martes, 25 mayo 2021

Más dimensiones:

- Altura (pitch)
- Intensidad (fff-ppp)
- Timbre (a definir)
- Articulación (ver lista anterior)
- Posición vertical (cúpula)
- Posición L/R
- Posición adelante-atrás
- Tiempo: tiempo lineal (compás)
- Tiempo: duración de nota o silencio
- Repetición de la nota varias veces
- Patrón rítmico de la repetición de la nota (ej: lineal, exponencial)
- Arpegio de las N últimas notas (1 = no arpegio)
- Delay (espera respecto a otra espiral?)

Idea sobre la composición: Mientras suena una espiral proyectada sobre algunas dimensiones (delante)
que suene otra espiral sobre otras dimensiones (detrás) y con delay. P.ej. delante con legatos y detrás con ataques rápidos y notas breves

# Miércoles, 26 mayo 2021

Sigo haciendo fórmulas en Jupyter Lab para analizar las características espectrales de los instrumentos

# Jueves, 27 mayo 2021

Idem

# Viernes, 28 mayo 2021

Idem

Tengo:
- Intensidad de armónicos
- Media ponderada de los armónicos
- Distancia entre la fundamental y el armónico más intenso (dimensión)
- Intensidad de armónicos agrupados según pitch-class
- Promedio de intensidad de armónicos según pitch-class
- Pitch-class promedio ponderado (dimensión, sirve de algo?--)
- Consonancia-disonancia interna (dimensión)

Estaría bien:
- Diferenciar entre consonancia y disonancia (en lugar de sumar ambas)

Falta tener en cuenta:
- Armónicos que no caen razonablemente dentro de un pitch-class
- Parciales no armónicos

# Lunes, 31 mayo 2021

Consonancia/disonancia interna según agrupación de las intensidades de los pitch-class y su ponderación por consonancia:

De menos consonancia a más consonancia:

- French horn
- Piccolo (hay que considerarlo como una flauta aguda al no disponer de datos más allá del 12º armónico)
- Bass clarinet
- Flute
- Contrabass
- Violin
- Viola
- Oboe
- Contrabass tuba
- Trombone
- Tuba
- Contrabass trombone
- Trumpet
- English horn
- Cello
- Bassoon
- Harpsichord
- Clarinet

Otros posibles parámetros:

- Escala: cromática / diatónica / mayor / menor
- Escala según secuencia natural (C C# D D# ...), armónica (C G D ...), cadencial (1 4 5 1, 1 5 4 1, ...)
- Partir del registro medio del instrumento y tener la octava central +-1 octava
- Instrumento según consonancia/disonancia interna
- Intensidad absoluta, intensidad relativa (respecto a: nota anterior / otro instrumento / ...)
- Tipo de ataque/acción: suave-agresivo (pizzicato, staccato, ..., legato)
- Tipo de sonoridad: normal / cuivré / sul ponticello / ...
- Modulación: vibrato / tremolo
- Interpretación: legato / normal
- Contraste: rápido/fuerte - lento/sutil
- Espacialidad: adelante / atrás, l/r, arriba/abajo
- Tiempo lineal
- Duración de notas/silencios
- Repeticiones de notas
- Arpegio de las últimas N notas (1 = no arpegio)
- Selección de patrón rítmico de la repetición/arpegio (lineal-exponencial, ...)
- Tiempo: delay respecto a los eventos de la espiral
- 
# Martes, 1 junio 2021

Es importante diferenciar entre dimensión y parámetro:
- La dimensión está en el origen, en la espiral en 3D sobre 3 dimensiones.
- El parámetro es aquello a lo que se traduce el valor de la dimensión. 

Estoy visualizando la pieza como un grafo dirigido en que los nodos de origen son las dimensiones
que se conectan a los parámetros (que a su vez se conectan con otros).

La evolución de la pieza se produce porque la espiral de origen sufre transformaciones/clonaciones
y van cambiando las conexiones entre las dimensiones y los parámetros.

En esta visión me influye la lectura sobre las redes de Petri que hice el fin de semana (y el modelo procesual de los racks modulares y lenguajes gráficos como Max)

Esta visión conlleva un desbordamiento de lo que he programado hasta ahora. La conexión entre dimensiones y parámetros, que a su vez se conectan con otros, implica extender la programación, probablemente incorporando más posibilidades a MusaDSL.

El cambio de la vinculación entre dimensiones y parámetros, y entre parámetros, también puede estar sujeto al movimiento en las espirales (dimensiones)

El desbordamiento me lleva a pensar en el objeto "Composer" que articule las series y operaciones desde una perspectiva de grafo dirigido (expresando un flujo) en lugar de en forma funcional.

# Miércoles, 2 junio 2021

El objeto "Composer" es un nuevo elemento en musadsl. Se trata de un desbordamiento-formalización que es interesante incorporar a musadsl. Esto puede ocurrirle a cualquier artista usuario de MusaDSL. Es necesario que defina un mecanismo para que otros usuarios de MusaDSL puedan crear nuevas formalizaciones/estructuras/paquetes y "registrarlas" en MusaDSL para que estén accesibles para todos los demás usuarios.
Sería un sistema de repositorio de 2º nivel (el primer nivel es el de Ruby con las Gems).

¿Qué sería necesario incluir en el repo?
- Descripción
- Forma de uso
- Ejemplos
- Compatibilidad con MusaDSL
- Dependencias
- Autor
- Nombre
- Version

Varios de estos atributos son estándar en las gem, no haría falta replicarlos. ¿Los .gemspec son extensibles?

RubyGems tiene un api que permite obtener las gems que tienen determinada dependencia:
- https://guides.rubygems.org/rubygems-org-api/
- GET - /api/v1/gems/GEM NAME/reverse_dependencies.json

A partir de aquí los componentes para musa-dsl podrían tener una dependencia específica ("is-a-musadsl-component")

# Jueves, 3 junio 2021

Ayer, en el concierto para violín de Beethoven, se me ocurrieron varias cosas para Espiral.
- duración 20-25 min
- compuesta en ~60 pequeñas microsecciones
- espiral abriéndose y luego cerrándose
- usar la proyección de las dimensiones sobre los parámetros en diversas escalas temporales (macroestructura)
- empezar con una espiral "obvia" para el público
- terminar con una línea con un acorde menor
- punto de menor identificación de la espiral en phi

# Viernes, 4 junio 2021

Estoy trabajando en el nuevo objeto "Composer" para combinar operaciones de series a través de un grafo. Veo que también tiene sentido que dentro de un "Composer" se usen otros "Composer", pues al final tienen entradas y salidas.

# Lunes, 7 junio 2021

Trabajando en "Composer".

# Martes, 8 junio 2021

Trabajando en "Composer". Revisando Series para permitir cambiar los orígenes y los parámetros.

# Miércoles, 9 junio 2021

Revisando Series para permitir cambiar los orígenes y los parámetros.

# Jueves, 10 junio 2021

Refactorizando Series.

# Viernes, 11 junio 2021

Identificado bug en deep-copy que afecta a .to_a en las series.

# Lunes, 14 junio 2021

Implementando WaitingBufferSerie para que las salidas de un pipeline de Composer se puedan enviar a diversas entradas de otras pipelines.

# Martes, 15 junio 2021

Idem.

# Miércoles, 16 junio 2021

Idem.

Pensando también en la variante en que cada serie "hija" hace avanzar al principal en lugar de esperar sus valores.

# Jueves, 17 junio 2021

Implantando ParallelBufferSerie.

# Viernes, 18 junio 2021

Idem.

# Hasta el 23 de junio

Implementando y debugando "Composer".

# Lunes, 28 junio 2021

Haciendo los últimos casos de test para Composer. Faltará desasignar rutas.

Ahora toca comenzar a implementar la orquestación en Live y a programar los drivers de los parámetros.