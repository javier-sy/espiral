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

