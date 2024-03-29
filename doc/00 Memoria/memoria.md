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

Preparando el proyecto nuevo en Live, guardando versiones de lo hecho hasta ahora, etc.

# Martes, 29 junio 2021

Preparando los drivers para instrumentos.

# Miércoles, 30 junio 2021

Preparando los drivers para los instrumentos. Surge la problemática de que la librería BBC SO Pro
tiene un único nivel jerárquico para identificar las articulaciones (el nº de keyswitch) mientras
que lógicamente hay una jerarquía: 1r nivel legato/long/short, 2º nivel con sordina/flautando/... 3r nivel (trill) 2M/2m

# Jueves, 1 julio 2021

Preparando los drivers para instrumentos.

# Viernes, 2 julio 2021

Preparando los drivers para instrumentos.
Siguiente: Seguir con vientos.

# Lunes, 5 julio 2021

He completado viento madera y viento metal. He comenzado percusión afinada.
Siguiente: seguir con percusión afinada.

# Martes, 6 julio 2021

He completado los drivers de percusión afinada.
He implementado todos los instrumentos de la orquesta en VEP y en Live y he conectado los nuevos puertos MIDI a Live.
He comenzado a crear los midi_voices en espiral2.rb

# Miércoles, 7 julio 2021

Completados midi_voices y escala de instrumentos. Corregidos pequeños bugs.

Conseguido generar una secuencia de una nota por cada instrumento.
Se encalla el note-off de glockenspiel y tubular bells... Por qué??

# Jueves, 8 julio 2021

El note-off que se encallaba era porque en la última nota paraba el clock y no se llegaban a emitir los últimos note-off.

He estado trasladando una primera prueba de la espiral a multinstrumento.

# Viernes, 9 julio 2021

Estoy intentando entender cómo introducir el mecanismo para generar diferentes transformaciones mediante Composer.

Hay varios problemas:
- La matriz no es unitaria (todas las dimensiones deberían ser valores entre 0 y 1) sino que tiene valores para x, y, z con una escala más próxima a alturas y tiempo. Esto impide que los valores transformados puedan tener una escala arbitraria.  
- En las transformaciones básicas de Matrix a TIMED_UNION cuantizadas se separa en varias partes el proceso: primero m.to_p, que extrae la dimensión temporal (y ya no se puede transformar, o sí?); luego la timed_union (que se ejecuta con play) tiene el tiempo sin transformar porque se excluye con tap { delete_at(2) }

Vamos, es un lío (resoluble).

Parece que la cuestión es que en...

```
matrix_p_array = m.to_p(time_dimension: 2, keep_time: true)

midi_quantized_timed_series =
  matrix_p_array.collect do |line|
    TIMED_UNION(
      *line.to_timed_serie(time_start_component: 2, base_duration: 1)
           .flatten_timed
           .split
           .to_a
           .tap { |_| _.delete_at(2) } # we don't want time dimension itself to be quantized
           .collect { |_|
             _.quantize(predictive: true, stops: false)
              .anticipate { |_, c, n|
                n ? c.clone.tap { |_| _[:next_value] = (c[:value].nil? || c[:value] == n[:value]) ? nil : n[:value] } :
                  c } }
    )
  end
```

... hay que pasar por Composer desde .split (incluido).

Esto implica que Composer debe permitir no sólo operaciones de series sino operaciones de arrays (sólo en medio del pipeline, de modo que el pipeline comienze y acabe con una serie).

# Lunes, 12 julio 2021

Implementando operaciones no-series en los pipelines de Composer.

# Martes, 13 julio 2021

Detectado un fallo en los buffers.

# Jueves, 15 julio 2021

Sigo con el fallo en los buffers. Es un problema de .split al instanciar las series spliteadas. (se clonan los proxis cuando deberían tener el mismo proxy)

# Viernes, 16 julio 2021

Idem.

# Lunes, 19 julio 2021

Sigo con Composer.

# Martes, 20 julio 2021

Sigo con Composer, para añadir posibilidad de ejecución lazy que permita combinar non-series operations y inputs asignadas a posteriori.

# Miercoles, 21 julio 2021

Idem.

# Jueves, 22 julio 2021

Al final estoy rehaciendo el Composer para que utilice encadenamiento de Proc's con la finalidad
de hacer que todo el enlazamiento sea 'lazy'. Con eso evito que se ejecuten las pipelines antes de 
tener inputs asignados, lo cual, si hay non-series operations, rompe el paso de los datos a través de la pipeline.

# Viernes, 23 julio 2021

Sigo con Composer.

# Lunes, 26 julio 2021

Sigo con Composer.

# Martes, 27 julio 2021

Sigo con Composer.

# Miércoles, 28 julio 2021

Terminado Composer. En principio ya funciona bien. Genero versión 0.23.5.
Problemas con RubyMine al debugar espiral2.rb. Solucionados descargando el repo de nuevo...

# Jueves, 29 julio 2021.

Ajustes en Composer.

# Viernes, 30 julio 2021.

# Sábado, 31 julio 2021.

# Lunes, 2 agosto 2021.

Estos últimos días he estado haciendo que las series tengan un estado "undefined" 
que corresponde a que aún no tienen su source/sources asignadas y no pueden decidir si 
son prototype o instance.

# Martes, 3 agosto 2021.

Completadas las pruebas del estado "undefined" en las series y completado el composer teniendo en cuenta el nuevo estado y 
su lógica. Subido a versión 0.23.9.

# Miércoles, 4 agosto 2021.

Estoy peleándome sobre cómo organizar la generación de la pieza.
Hay problemas...
- porque hay muchos parámetros que controlar (en cada parte de la pieza son diferentes),
- porque cada parámetro implica una forma de generación diferente, 
- porque quiero varios niveles organizativos
estructurados por las espirales de los niveles superiores (con 3 niveles es suficiente, pero me atrae la idea 
de una jerárquía con diferentes niveles de profundidad). 

Esto me lleva a olvidar por el momento todo lo construído hasta ahora, pensar en el problema y luego volver a las herramientas 
construídas. Espero que no me lleve a tener que crear más herramientas.

También me doy cuenta que en cuanto haya repliegues de las espirales se multiplican las líneas (voces en el último nivel jerárquico) y 
probablemente acabarán faltando instrumentos. Tendré que aplicar algún criterio y mecanismo de selección. Habrá un % de notas perdidas cuya 
medición me ayudará a valorar el funcionamiento de las opciones que vaya eligiendo.

# Jueves, 5 agosto 2021.

He comenzado a plantear la solución a través de varios niveles de play, every, etc. en el sequencer.
He comenzado a montar el render de la espiral basada en aumento hasta phi y reducción hasta el final.


# Viernes, 6 agosto 2021.

He implementado el nivel 0 y funciona bien. Habían surgido algunos problemas porque la espiral hacía 
un retroceso temporal en el paso de la subida a la bajada pero no era de Musa sino de la función 
generadora de espiral, que generaba un punto más de los necesarios al final.

Al estar tan centrado en la perspectiva de intentar hacerlo todo desde una única p_serie no estaba
viendo los recursos que ya tengo para implementar múltiples niveles. Ayer vi que tenía que simplificar.

# Lunes, 30 agosto 2021.

Volvemos a la espiral. A ver si la termino ya...
He refactorizado el código de espiral3 para comenzar a tenerlo más estructurado.
Ha surgido un error rarísimo de que dentro del método _next_value de TimedUnionOfArrayOfTimedSeries no se ve el método Ha surgido un error rarísimo de que dentro del método _next_value de TimedUnionOfArrayOfTimedSeries no se ve el método infer_components de la misma clase
  
# Martes, 31 agosto 2021.

Sigo con el error rarísimo. Alucinante. Parece un error relacionado con el private def _next_value, que NO ocurre en el contexto de las pruebas rspec.

# Miércoles, 1 septiembre 2021.

El error era porque en TimedUnionOfArrayOfTimedSeries el método infer_components estaba FUERA de la clase.
Lo raro es que funcionara en otras ocasiones, lo cual era debido al uso generalizado de includes en la raíz de las pruebas rspec,
que hacía que no se hubiera detectado.

Estoy quitando todos los include en la raíz de las pruebas rspec, lo cual lleva a añadir el módulo en todos los usos de clases porque
los "include" sólo importan clases cuando se está en el contexto de una clase.
Podría funcionar extend? Comprobado que no.

# Jueves, 2 septiembre 2021.

He seguido quitando los include en los tests (y en el código principal de musa-dsl). También he reformateado y refactorizado algo de código.

# Viernes, 3 septiembre 2021.

Ya funciona de nuevo lo que funcionaba antes del refactor. También he resuelto un pequeño problema con musa::extension::with.
Ahora ya toca volver a Espiral.
El nivel 2 creo que sí que va a permitir dobleces temporales (aunque tendrán que ser pocas) para hacer más interesante la generación.

# Lunes, 6 septiembre 2021.

Preparando los niveles de forma agregada: el nivel 3 define el tamaño de los ciclos del nivel 2 y éste del nivel 1.
Ha surgido un problema menor con la función Serie.map que me ha llevado a tener que cambiar algunas cosas en MusaDSL.

# Martes, 7 septiembre 2021.

Corrigiendo en musa los problemas derivados del cambio en Serie.map. Generada versión 0.23.15.

# Miércoles, 8 septiembre 2021.

He conseguido visualizar las matrices de nivel 1 nivel 2. En las de nivel 2
se pueden aplicar transformaciones y las encadena correctamente. Lo que pasa es que las transformacione aplicadas
cambian la posición del eje temporal original y no respeta la duración necesaria, con lo que no se coinciden con las duraciones esperadas.

Para resolver esto creo que hay que aplicar una normalización de la espiral, de modo que [0,0,0] quede en el centro geométrico de la espiral y que el "cubo" que la contiene tenga lados unitarios,
luego aplicar la transformación, que creo que mantendrá el cubo unitario, y finalmente extender la transformación para que ocupe el tiempo y dimensiones necesarias.

También se podría extender la espiral no en base al cubo unitario sino en base a los puntos de inicio y finalización de la espiral,
lo cual podría hacer que otros puntos de la espiral cayeran fuera del cubo y ocuparan tiempos fuera de los asignados.

# Jueves, 9 septiembre 2021.

He implementado que la espiral sea unitaria, luego se rote, y luego se estire en z para que ocupe todo el tiempo que le toca y
que se escale en x, y para que tenga la altura y anchura que le toca según el radio correspondiente.

La idea es que las espirales de nivel 2 roten haciendo que el vector z roten hacia un vector v que se corresponda con un
punto de otra espiral que va desarrollándose en el tiempo. Así las espirales de nivel 2 son como unas "peonzas" que se están desestabilizando y caen.

Esto ha requerido investigar un poco de geometría y trigonometría.

https://www.euclideanspace.com/maths/algebra/vectors/angleBetween/

# Viernes, 10 septiembre 2021.

He construido la espiral de nivel 2 con rotaciones orientadas según un vector también representado por otra espiral.
He tenido que ir ajustando para que no haya un exceso de voces ni vueltas al pasado antes de que empiece la pieza!
También he ajustado para tomar en cuenta phi como centro de interés donde pasan más cosas.

# Lunes, 13 septiembre 2021.

El nivel 2 ya está cuantizado correctamente. Tiene 23 curvas. La densidad máxima de curvas simultáneas es de 7.
Ahora toca hacer las espirales de nivel 3: una espiral por curva, con varias vueltas (proporcional a la zona en que se encuentra) 
y con giro con vector perpendicular al plano de la espiral de nivel 2?

# Martes, 14 septiembre 2021.

He programado parte del nivel 3, que se basa en las curvas generadas desde el nivel 2. Las espirales de nivel 3 siguen a las curvas del nivel 2.

# Miércoles, 15 septiembre 2021.

Estoy haciendo que las espirales de nivel 3 tengan como eje los segmentos de nivel 2. Hay varias cosillas a tener en cuenta que afectan.

# Jueves, 16 septiembre 2021.

Sigo con ello.
Ya renderiza hasta el nivel 3 con las cuantizaciones por defecto.

# Lunes, 20 septiembre 2021.

He comenzado a renderizar a MIDI (wip).
No tengo claro que el level 3 dé lugar a pliegos que generen armonías.
Las espirales en nivel 3 son muy dirigidas sobre el eje Z porque se basan en las curvas de nivel 2 que se segmentan sobre los pliegues sobre Z.

# Martes, 21 septiembre 2021.

He conseguido que comience a sonar con este método de renderización MIDI:

```ruby
protected def render_to_midi(level2:, level3:, values:, duration:)
super

    if values[0]
      # interpretamos los valores como [pitch/velocity, velocity/pitch, time]
      quantized_duration =
        duration.collect { |d| @sequencer.quantize_position(@sequencer.position + d) - @sequencer.position if d }

      note = { grade: (84 + values[0]).to_i,
               duration: quantized_duration[0],
               velocity: (@level3_z[level2][level3] / 6r).to_i - 3,
               voice: "#{level2}-#{level3}" }.extend(GDV)

      instrument = @pool.find_free

      technique = instrument.find_techniques(:legato).first
      technique ||= instrument.find_techniques(:long).first
      technique ||= instrument.find_techniques(:short).first

      raise "Cannot find a technique for #{instrument.name}!!!!" unless technique

      note[technique.id] = true

      instrument.note **note.to_pdv(@chromatic_scale).tap { |_| _[:pitch] = put_in_pitch_range(instrument, _[:pitch]) }
    end
end
```

Suena lento y pone notas en el límite inferior del rango del instrumento porque se salen del mismo pero es interesante.

Voy a comenzar a añadir transformaciones de las dimensiones de las espirales a parámetros musicales.
Quizás haya que cambiar 

# Miércoles, 22 septiembre 2021.

Depurando las transformación a sonido. Entre otras cosas ajustando el mapeo a instrumentos basado en level2_x y en el pitch.
Arreglando problemillas de nils perdidos.

# Jueves, 23 septiembre 2021.

Arreglados los problemas de nils perdidos. Era porque la rotación de las espirales hacia atrás
hacía que el nivel 3 comenzara antes que el nivel 2. La solución es usar los datos del nivel 2 anterior.

Hay algunos fragmentos que suenan interesantes, sobre todo cuando hay más densidad 
de curvas. ([tag v1](https://github.com/javier-sy/2020-10-05-Espiral/tree/v1))

Continúo complejizando la selección instrumental, eligiendo alternativamente entre
instrumentos de cuerdas, viento madera y viento metal, por un lado, y percusivos tonales por otro.
Además empiezo a renderizar el nivel 2 sólo con el clave.
En esta versión hay varios momentos en que se producen errores porque no encuentra timbres que resuelvan los requisitos (a investigar).
Pero es interesante incluso el silencio que produce. Es un buen mecanismo... faltan instrumentos para cubrir el timbre esperado? Pues silencio.
([tag v2](https://github.com/javier-sy/2020-10-05-Espiral/tree/v2))

# Viernes, 24 septiembre 2021.

Arreglando pequeños errores de nils y revisando algoritmo de búsqueda de instrumentos que fallaba.
([tag v3](https://github.com/javier-sy/2020-10-05-Espiral/tree/v3))

Otra cosa que también se puede parametrizar es el tempo. Los diferentes niveles 2 pueden tener diferente tempo...

# Lunes, 27 septiembre 2021.

Y otra cosa que se puede parametrizar es la escala.
También el nº de vueltas de las espirales de nivel 3.

Voy a intentar parametrizar el tempo y a cambiar la orientación de las espirales.

Con el tempo parametrizado: ([tag v4](https://github.com/javier-sy/2020-10-05-Espiral/tree/v4))

Estoy modificando la orientación de las espirales de nivel 3, pero parece que la primera no se genera correctamente.

# Martes, 28 septiembre 2021.

El problema con la primera espiral que no comenzaba era que comenzaba antes de tiempo (en tiempo negativo) y no se procesaba bien. He ajustado la generación de las espirales para que no se puedan producir en tiempo negativo.

Es importante añadir un criterio para añadir silencio. Cuando falla una espiral, p.ej., y no se genera salida resulta interesante.

He detectado otro fallo: al iniciar tarda 300 ticks en pasar de la position 1 a la siguiente. Hay demasiado procesamiento en ese inicio.
Hay que investigar qué ocurre.
No parece ser el motor de renderización 3d.

# Miércoles, 29 septiembre 2021.

El problema es que al comenzar el compás 1 se lanzan todos los comandos play que,
al final, son muchos. Eso hace que la inicialización sea lenta.

Creo que la solución pasa por hacer que Sequencer permita programar anticipadamente (al menos con play_timed).
He añadido el parámetro at: a play_timed (musa-dsl v0.24.20)

Otro error: a veces se salta una nota. Creo que es porque considera que la nota anterior aún no ha terminado. Hay que revisarlo.

# Jueves, 30 septiembre 2021.

Se saltaba una nota porque el valor de x no había cambiado (aunque el de y, sí). 
Lo he modificado para que genere una nota cuando cambia cualquiera de los dos valores. El valor que no cambia se mantiene con el valor anterior.

Esta versión suena interesante. ([tag v5](https://github.com/javier-sy/2020-10-05-Espiral/tree/v5))

Siguiente cosa: aumentar el tamaño x-y del nivel 2 de modo que haya más variación de los registros al generar el nivel 3.

He multiplicado la dimensión x-y del level 2 por 4. Es espectacular. 
Sobre todo cuando entra el contrabass grave. ([tag v6](https://github.com/javier-sy/2020-10-05-Espiral/tree/v6))

"El sueño de la razón produce monstruos" (aguafuerte de Goya).
Como subtítulo de Espiral: "El despertar de la razón produce monstruos". Alusión a la capacidad autogenerativa de Espiral,
cambiando los macroparámetros.

# Viernes, 1 octubre 2021.

He añadido que el radio de las espirales de nivel 3 sea proporcional (entre 3 y 8) a la y del level 2 en que se encuentre.

Versión ([tag v7](https://github.com/javier-sy/2020-10-05-Espiral/tree/v7))

Veo que la instrumentación tiene algunos problemas: los violines no se usan nunca y a menudo falta percusión.

En el harpsichord tb falta a veces rango. Quizás mejor un piano.

Cuando el harpsichord se sale de rango elige mal las notas, les cambia el grado (método put_in_pitch_range).

Añadir un plato de percusión???? con redoble largo...????

Se me ocurre hacer grupos instrumentales más marcados, no sólo armónicos vs percusivos.

# Miércoles, 6 octubre 2021.

He puesto el piano como instrumento del level 2.
He modificado el pitch_in_range para que cambie la octava sin cambiar el grado.
Falla algo, no emite notas para el piano.

# Jueves, 7 octubre 2021.

El piano en live no tenía el canal de entrada MIDI correcto.

Versión con piano: ([tag v8](https://github.com/javier-sy/2020-10-05-Espiral/tree/v8))

# Viernes, 8 octubre 2021.

He creado 4 grupos de instrumentos (viento madera, metal, cuerdas, percusión) y he creado
conjuntos de instrumentos que combinan los 4 grupos de forma proporcional a la manitud del level 1.
Así al principio suenan menos familias simultáneamente y al acercarse al punto máximo de level 1 
van sonando más familias de instrumentos.

También he subido una octava el conjunto para que llegue a los registros agudos de violines y piccolo.

Versión ([tag v9](https://github.com/javier-sy/2020-10-05-Espiral/tree/v9))

# Lunes, 11 octubre 2021.

Subo una quinta más porque faltan notas en los registros inferiores. Aún así
el problema no se resuelve. 

También ocurre que en viento metal se pierden muchas notas por quedar fuera del registro.

Hay que considerar:
- el rango de cada familia de instrumentos
- si trasladar el rango de entrada al rango accesible de un instrumento cambiando de octava
- contemplar el uso del rango central y de los armónicos de los instrumentos (lo cual interacciona con las articulaciones, aún por asignar)
- los criterios de compatibilidad con el instrumento (es interpretable la nota con la duración y articulación que se pide?)
- cómo introducir silencios

Por otro lado, ahora mismo la percusión es excesiva (con redoble continuo). 
Quizás usarla sólo como contraste cuando no hay instrumentos? o en secciones alternativas?

# Jueves, 21 octubre 2021.

Comienzo a analizar la estructura sonora de las articulaciones de cada instrumento para establecer
dos niveles: un primer nivel de grupos de articulaciones contrastantes (ej. strings legato vs pulsada vs staccatos) y un segundo nivel de niveles de diferenciación dentro 
del primero (ej. en strings longs legato vs long harmonics).

He añadido un atributo techniques_groups en los instrumentos para representar esos dos niveles.

# Viernes, 22 octubre 2021.

He añadido la renderización de las articulaciones pero hay algún error en el nivel2 de articulaciones.

# Lunes, 25 octubre 2021.

Resuelto el problema de selección de la articulación Y ajustando la dinámica de las articulaciones al máximo sale algo bastante interesante.
Versión ([tag v10](https://github.com/javier-sy/2020-10-05-Espiral/tree/v10))

Hay un problema con notas sonando a la vez en algunos instrumentos monofónicos. No sé si vendrá de 
la cuantización de las curvas o de los instrumentos adimitiendo más notas de las posibles en alguna condición.

# Martes, 26 octubre 2021.

Resuelto el problema de instrumentos con más notas que las que permite su polifonía.
He bajado una 5ª las alturas para que no brille tanto. Versión ([tag v11](https://github.com/javier-sy/2020-10-05-Espiral/tree/v11))


# Lunes, 22 noviembre 2021.

Retomo espiral tras estar un mes preparando musa lce for live.
Comienzo a añadir dinámicas, primero a la línea de piano, que da algunos problemas técnicos (aparentes, que luego no eran)

# Martes, 23 noviembre 2021.

Sigo con la línea de piano y comienzo a añadir la dinámica al resto de instrumentos.

# Miércoles, 24 noviembre 2021.

Se me ocurre que en lugar de elegir la instrumentación en base al continuo tímbrico, seleccionarla
además en base predominancia de notas long vs notas short; con contraste entre espirales de nivel 3.
También sería interesante seleccionarlas en base a incluir los registros más intensos o no (p.ej. cuivré en brass)

He resuelto que envíe los midi cc1 y cc11 para las notas long y legato. 
Falta confirmar que la intensidad es correcta (mapear bien los niveles).

# Jueves, 25 noviembre 2021.

He cambiado la selección de instrumento para que si no encuentra el instrumento en el pool inicial
vaya a buscar el complementario en el pool (i + 0.5) % 1.0, en lugar de en 1-i 
(que era una fórmula incorrecta para buscar el complementario).

También he cambiado la selección del grupo de articulaciones en el nivel 3: ahora va rotando 
según estamos en espirales más avanzadas (módulo 5).

```
articulation1 = ((level2 % 5.0) / 5.0).round(2)
```

Revisar cuántas articulaciones e instrumentos quedan sin usar.
Ajustar los niveles para asegurar que suenan mínimamente las primeras articulaciones suaves.

# Viernes, 26 noviembre 2021.

He ajustado los niveles para que las notas cortas y de nivel bajo suenen mínimamente.
He añadido un log para ver el uso de los instrumentos.

Versión ([tag v12](https://github.com/javier-sy/2020-10-05-Espiral/tree/v12))

Sería interesante generar un fichero csv con la información simbólica de lo que suena para analizarlo y comprobar qué ocurre.

# Lunes, 29 noviembre 2021.

He añadido la generación de un fichero json que registra la salida de notas para analizar en jupyterlab.
He pasado a constantes todas las apariciones de valores fijos.

La idea es hacer fácil la generación de alternativas.

Versión ([tag v13](https://github.com/javier-sy/2020-10-05-Espiral/tree/v13))

# Martes, 30 noviembre 2021.

He comenzado a investigar la espacialización 3D con ambisonics y el plugin NX de Waves. 
Parece que podré hacerlo para auriculares sin problemas a través de MaxMSP. 

# Miércoles, 1 diciembre 2021.

He seguido probando la generación de audio espacializado con ambisonics usando Envelope for Live.
He añadido una salida en el dispositivo master de Envelope for Live para Waves NX, de modo
que se pueda escuchar espacializado con tracking de los movimientos de la cabeza.

# Jueves, 2 diciembre 2021.

He tenido que arreglar el dispositivo m4l de control de los micrófonos de la BBC SO Pro porque no 
controlaba los dispositivos secundarios.

He generado el dispositivo m4l de Envelope Master para NX.

He añadido los dispositivos de control de micrófonos en live.

# Jueves, 9 diciembre 2021.

He modificado los rangos de los instrumentos para que usen sus mejores rangos, no el rango completo.
Además de facilitar la interpretación y mejorar el sonido hará que se usen más instrumentos.

También he ajustado la duración de las notas cortas entre 1/4 y 1/16 entre todos los instrumentos.

Y he añadido la posibilidad de respirar para las notas largas en los instrumentos que lo requieran.
Lo he hecho añadiendo una propiedad _max_duration_ aunque si fuera necesario lap podría cambiar
por "volumen de aire" disponible que se consumiría en función de la duración,
la intensidad de la nota y un "factor de consumo de aire en función de la intensidad" que dependería
de cada instrumento.

# Viernes, 10 diciembre 2021.

Tras resolver problemas de falta de memoria 
(debido a que las librerías en VEP estaban configuradas para aprovechar mucha memoria antes de usar múltiples micrófonos)
he comprobado que la forma de limitar la duración de las notas para que el intérprete respire no resulta natural.
Paso al modelo "medio complejo" del consumo de aire según la intensidad.

Lo he implementado pero tiene algún fallo que genera notas ultracortas. A ver mañana.

# Lunes, 13 diciembre 2021.

La fórmula para calcular la respiración en notas largas estaba mal. Corregida. 
Versión ([tag v14](https://github.com/javier-sy/2020-10-05-Espiral/tree/v14)) que corresponde a [Variante 0](https://github.com/javier-sy/espiral/tree/master/musa.variant0). 

El resultado es interesante. El final un poco pobre.

Primer cambio de parámetros (en composition-3-spirals.rb): [Variante 1](https://github.com/javier-sy/espiral/tree/master/musa.variant1).

Segundo cambio de parámetros (en composition-3-spirals.rb): [Variante 2](https://github.com/javier-sy/espiral/tree/master/musa.variant2).

He quitado la espacialización con ambisonics porque se oye mejor con la mezcla "nativa".

OJO: Parece que hay repeticiones de notas que no tienen sentido y no se deben a la respiración.

OJO: También hay notas sobrepuestas cuando en teoría sólo tendría que estar habiendo una línea.

¿Puede estar habiendo un problema con la cuantización?

# Martes, 14 diciembre 2021.

¿Puede estar habiendo un problema con la cuantización? -> NO. El problema es que la dimensión Y 
no se estaba utilizando en el piano (en el resto de instrumentos se usa para la articulación).

He incluído la dimensión Y como parte de la velocidad (no creo que se note mucho porque el rango de Y puede ser muy grande y el salto entre valores de Y del orden de la unidad).

Tercer cambio de parámetros (en composition-3-spirals.rb): [Variante 3](https://github.com/javier-sy/espiral/tree/master/musa.variant3).

Cuarto cambio de parámetros (en composition-3-spirals.rb): [Variante 4](https://github.com/javier-sy/espiral/tree/master/musa.variant4).

Sería interesante hacer análisis estadístico de las obras (incluyendo registro de notas perdidas).

Y sería interesante explorar una pieza que algunos de los macroparámetros cambien durante la pieza (en cada espiral de nivel 3, p.ej.)

# Miércoles, 15 diciembre 2021.

Generando [Variante 5](https://github.com/javier-sy/espiral/tree/master/musa.variant5).

# Jueves, 16 diciembre 2021.

He añadido que algunos de los parámetros que eran fijos sean dependientes de la espiral de nivel 3 en que se encuentran.

He regenerado la versión _v14_, que era _variant0_, como [Variante 6](https://github.com/javier-sy/espiral/tree/master/musa.variant6). Suena diferente y tiene una duración diferente... ¿Qué ha cambiado?

El problema era que la variant0 no estaba bien copiada. Copié otra variante incorrectamente!!! La he restaurado.

# Viernes, 17 diciembre 2021.

La [Variante 6](https://github.com/javier-sy/espiral/tree/master/musa.variant6) es muy interesante. Creo que tiene algunas pequeñas diferencias con la _v14_ supongo que por los cambios en el modelo de asignación de instrumentos.

Nueva [Variante 7](https://github.com/javier-sy/espiral/tree/master/musa.variant7) con parámetros con pequeñas variaciones a través de series.

# Lunes, 20 diciembre 2021.

Hoy he enviado a Mikel, Josep Cerdà y a Berenguer las variantes 6 y 7. Creo que lo doy por cerrado por ahora.

# Febrero 2022.

Durante este mes, de manera informal y tras la reunión con Mikel, he estado pensando en el espacio.
Algo que está de fondo en la construcción de obra: cómo el sonido informa del espacio y cómo hacer un sonido creativo de ello.
El sonido habla del espacio a través de la reverberación (además de a través de la posición de la fuente del sonido, que en realidad habla más del espacio "emulado").

Me planteo, hablado con Mikel y Josep, usar el sonido del espacio en sí (a través de reverbs de convolución con IR adhoc realizadas con "petardos").

# Jueves, 24 febrero 2022.

Llevo estos dos meses entre pausa para refrescar ideas e implementando MusaDSL for Live/Bitwig.
En concreto estos últimos días estoy con el problema de que MusaLCE no hace bien los "imports" de los paquetes de Musa
y no deja utilizar las clases directamente, obliga a ponerles el namespace completo.

(Finalmente el problema de los imports lo resolví y dejé una versión de MusaLCEforBitwig bastante aceptable, aunque 
le falta persistir bien la asignación de pistas dentro de bitwig)

# Domingo, 1 de mayo 2022.

Tras el accidente estos últimos días he estado migrando la renderización de la orquesta de Ableton Live 11 + VEP7 en local a
Bitwig Studio 4.2 + VEP7 en servidor + procesamiento de audio en local. Entre otras cosas he podido mejorar la asignación de
canales midi para comenzar por el 1 (en lugar de por el 2) y de los canales de audio (comenzar por par 1/2 en lugar de 3/4). Por
otro lado me he visto obligado a duplicar las pistas en bitwig: para cada instrumento, una de midi y otra de audio, cosa que 
en Live se podía hacer en una única pista por instrumento. Nada grave de todos modos.

Por otro lado, la renderización de OpenGL de las espirales ha dejado de funcionar con el nuevo Macbook Pro M1. No sé si es 
consecuencia del cambio de CPU o si hice algún cambio en la librería mittsu para hacer que funcionase (veo que tengo una versión
local del repo de mittsu). Aún no lo he comprobado. No es prioritario de momento.

Los siguientes pasos son: implementar la gestión de micrófonos de la orquesta y comenzar a trabajar las reverbs expresivas. Quizás
también cree un sistema para añadir expresividad según el instrumento en notas largas.


# Lunes, 24 octubre 2022.

He retomando Espiral, para prepararla para el concierto de noviembre en Barcelona. Ajustando micrófonos y pensando cómo hacer la modulación de 
la reverb.

# Martes, 25 octubre 2022.

He estado pensando cómo realizar la reverb. Cada instrumento va a un canal y por cada tipo se distribuyen ocupando los altavoces disponibles.
Con sends modulados desde el código se envía la señal a canales de retorno con las reverbs que, a su vez, están vinculadas a pares de altavoces.

# Miércoles, 26 octubre 2022.

Creando la matriz de redirección de envíos en BW para la versión de 8 altavoces: nivel 1 (entrada), sends/returns de reverbs, nivel 2 (), nivel físico.
Probando con el midifighter y el nakedcontrols mc8 el tipo de reverb y el nivel de send respectivamente.

Faltan parámetros. Falta que tenga sentido el uso de los parámetros. Falta automatizarlo desde musadsl.

# Lunes, 31 octubre 2022.

He montado en BW un dispositivo que mezcla la señal de 2 reverbs y he decidido para cada una de ellas los parámetros básicos.
Las he integrado en los sends/returns.
Tengo que controlarlas desde musa a través de unos CC.

Cada sección de la pieza debería tener unos parámetros de reverb sustancialmente diferentes, contrastantes. Con variaciones dentro
de las secciones.

# Miércoles, 2 novimebre 2022.

Me he planteado que la modulación de la reverb sea manual en lugar de automática. La intervención humana directa con una 
interpretación del concepto de espiral como un sistema más que procesa el "input" conceptual sección a sección. Donde las 
secciones son las percibidas subjetivamente.

# Jueves, 3 noviembre 2022.

He estado mezclando la pieza para la versión de 8 altavoces. Añadiendo EQ, TEOTE, saturación, etc.

# Sábado, 5 noviembre 2022.

He generado una versión con las reverbs moduladas a mano. Parece que queda bien. Falta renderizar por separado reverbs y audios
para generar el player para el concierto.

# Lunes, 7 noviembre 2022.

Preparando la renderización para 8 altavoces con Max/MSP.

# Lunes, 13 noviembre 2022.

Preparando la renderización para 16 altavoces con Max/MSP (pero haciendo la reverb en Max, no en BW).

# Martes, 14 noviembre 2022.

Idem.

# Miércoles, 15 noviembre 2022.

Idem.

# Jueves, 16 noviembre 2022.

Idem.

Poniendo plugins mínimos de mezcla y mastering (teote + hg-2) ya ocupa el >80% de CPU a 44.1 khz. Podría dar
problemas en el contexto final. Veremos.

El problema que hay ahora es cómo controlar la reverb de cada canal. Al final hay un montón de reverbs que tienen, cada una,
2 parámetros y que deben mantener una cierta coherencia.

Haciéndolo manual no sé si se puede hacer bien. ¿Simplificar para controlar desde unos pocos parámetros vinculados a las 
zonas (delante, detrás, izda, derecha, arriba, abajo, etc.)?

¿Permitir discrepancias extremas dentro de esa lógica más o menos uniformizadora (tipo: un instrumento se salta la homogeneidad de su zona?

