//=================================INSTRUMENTOS====================================

//===================================PUNTO 1=======================================
//la guitarra Fender Stratocaster, de color negra, ni hay que afinarla porque siempre 
//suena bien. Su costo es de 15 chelines cuando es negra o 10 en caso contrario. 
//La Fender es valiosa.

object guitarraFenderStratocaster {
  var property color = "negro"

  method esValioso() = true
  method estaAfinado() = true 
  method costo() = if (color == "negro") 15 else 10  
}

//===================================PUNTO 2=======================================
//la trompeta Jupiter al igual que todas las trompetas necesita afinarse en base a 
//la temperatura ambiente. Si la temperatura está de 20 a 25 grados no hace falta afinarla,
// en caso contrario el músico debe hacer el calentamiento (que consiste en soplar la 
//trompeta para calentar el metal hasta lograr la afinación deseada). A los fines prácticos 
//podemos considerar que simplemente “hizo el calentamiento”. Sabemos si tiene puesta la 
//sordina, que es un elemento que atenúa o cambia la calidad del sonido que se propaga por 
//la trompeta. Su costo es 30 chelines al que hay que agregarle 5 si tiene puesta la sordina.
// La trompeta Jupiter no es considerada valiosa.

object generadorTemperatura {
  method temperaturaRandom() = 20.randomUpTo(25).truncate(0)
}

object trompetaJupiter {
  var property temperatura = 20
  var property sordina = true 
  var property generadorRandom = generadorTemperatura.temperaturaRandom()

  method estaAfinado() = temperatura.between(20, 25) 
  method hacerCalentamiento() {temperatura = generadorRandom}

  method costo() = 30 + self.costoAgregado()
  method costoAgregado() = if(sordina) 5 else 0

  method esValioso() = false
}


//===================================PUNTO 3=======================================
//el piano Bechstein, que por el momento está ubicado en una habitación de 5x5, 
//suena afinado mientras se mantenga en una habitación de más de 20 metros cuadrados. 
//También sabemos la última fecha en que lo revisó un técnico afinador (el piano sale de 
//fábrica revisado por primera vez). Su costo es 2 chelines por el ancho de la habitación 
//en donde está. El piano Bechstein es valioso si está afinado.

object pianoBechstein {
  var property largoHabitacion = 5
  var property anchoHabitacion = 5
  var property ultimaRevision = new Date() 

  method estaAfinado() = (largoHabitacion * anchoHabitacion) > 20
  method costo() = 2 * anchoHabitacion
  method esValioso() = self.estaAfinado()  
}

//===================================PUNTO 4=======================================
//el violín Stagg, que comienza afinado pero cada vez que se hace un trémolo 
//(implica mover el arco arriba y abajo muy rápido) comienza a perder algo de afinación: 
//cuando se llega al décimo trémolo el violín queda desafinado. Sabemos el tipo de pintura 
//con el que está laqueado. Su costo es 20 chelines al que le restamos los trémolos que 
//tenga en el momento, pero nunca baja de 15. El violín es valioso si está pintado con 
//laca acrílica.

object violinStagg {
  var property cantidadTremolos = 0
  var property pintura = "laca acrilica" 

  method hacerTremolo() {cantidadTremolos+=1} 
  method estaAfinado() = cantidadTremolos < 10 

  method costo() =15.max(20-cantidadTremolos) 
  
  method esValioso() = (pintura == "laca acrilica") 
}

//=================================MUSICOS=========================================

//===================================PUNTO 1=======================================
//Johann es feliz si tiene un instrumento caro (que cueste 
//más de 20 chelines). Inicialmente Johann tiene una trompeta Jupiter.

object johann {
  var property instrumento = trompetaJupiter 

  method esFeliz() = instrumento.costo() > 20 
}

//===================================PUNTO 2=======================================
//Wolfgang es feliz si Johann es feliz
object wolfgang {
  method esFeliz() = johann.esFeliz()
}

//===================================PUNTO 3=======================================
//Antonio es feliz si su instrumento es valioso. Inicialmente tiene un piano Bechstein.
object antonio {
  var property instrumento = pianoBechstein

  method esFeliz() = instrumento.esValioso()  
}

//===================================PUNTO 4=======================================
//Giuseppe es feliz si su instrumento está afinado. Inicialmente tiene una guitarra Fender
object giuseppe {
    var property instrumento = guitarraFenderStratocaster

    method esFeliz() = instrumento.estaAfinado() 
}

//===================================PUNTO 5=======================================
//Maddalena es feliz si su instrumento tiene un costo par. Inicialmente tiene un violín Stagg.
object maddalena {
    var property instrumento = violinStagg

    method esFeliz() = instrumento.costo().even() 
}

//===================================PUNTO 6=======================================
//Dada una lista de músicos de una asociación musical, queremos saber quiénes son felices.

object asociacionMusical {
  const property miembros = #{} 

  method agregarMiembro(miembro) {
    miembros.add(miembro)
  }

  method musicosFelices() = miembros.filter({miembro => miembro.esFeliz()}) 
}