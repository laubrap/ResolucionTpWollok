//===================================ENTREGA 2=====================================
//=================================INSTRUMENTOS====================================

//===================================PUNTO 1=======================================
//la guitarra Fender Stratocaster, de color negra, ni hay que afinarla porque siempre 
//suena bien. Su costo es de 15 chelines cuando es negra o 10 en caso contrario. 
//La Fender es valiosa.

object guitarraFenderStratocaster inherits Instrumento(familia = "cuerda") {
  var property color = "negro"

  method esValioso() = true
  override method estaAfinado() = true 
  override method costo() = if (color == "negro") 15 else 10  
  override method esSensitivo() = super() && self.costo()> 12
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

object trompetaJupiter inherits Instrumento(familia = "viento"){
  var property temperatura = 20
  var property sordina = true 
  var property generadorRandom = generadorTemperatura.temperaturaRandom()

  override method estaAfinado() = temperatura.between(20, 25) 

  method hacerCalentamiento() {temperatura = generadorRandom}

  override method costo() = 30 + self.costoAgregado()
  method costoAgregado() = if(sordina) 5 else 0

  override method esCopado() = sordina

  method esValioso() = false

  override method afinar(tecnico) { 
    self.hacerCalentamiento()
    super(tecnico)
  } 
}


//===================================PUNTO 3=======================================
//el piano Bechstein, que por el momento está ubicado en una habitación de 5x5, 
//suena afinado mientras se mantenga en una habitación de más de 20 metros cuadrados. 
//También sabemos la última fecha en que lo revisó un técnico afinador (el piano sale de 
//fábrica revisado por primera vez). Su costo es 2 chelines por el ancho de la habitación 
//en donde está. El piano Bechstein es valioso si está afinado.

object pianoBechstein inherits Instrumento(familia = "percusion"){
  var property largoHabitacion = 5
  var property anchoHabitacion = 5

  override method estaAfinado() = (largoHabitacion * anchoHabitacion) > 20
  override method costo() = super() + 2 * anchoHabitacion
  override method esCopado() = largoHabitacion > 6 || anchoHabitacion > 6
  method esValioso() = self.estaAfinado()  

  override method afinar(tecnico) { 
    largoHabitacion = 8 
    anchoHabitacion = 4
    super(tecnico)
  } 
}

//===================================PUNTO 4=======================================
//el violín Stagg, que comienza afinado pero cada vez que se hace un trémolo 
//(implica mover el arco arriba y abajo muy rápido) comienza a perder algo de afinación: 
//cuando se llega al décimo trémolo el violín queda desafinado. Sabemos el tipo de pintura 
//con el que está laqueado. Su costo es 20 chelines al que le restamos los trémolos que 
//tenga en el momento, pero nunca baja de 15. El violín es valioso si está pintado con 
//laca acrílica.

object violinStagg inherits Instrumento(familia = "cuerda") {
  var property cantidadTremolos = 0
  var property pintura = "laca acrilica" 

  method hacerTremolo() {cantidadTremolos+=1} 
  override method estaAfinado() = cantidadTremolos < 10 

  override method costo() =15.max(20-cantidadTremolos) 
  
  method esValioso() = (pintura == "laca acrilica") 

  override method afinar(tecnico) { 
    cantidadTremolos = 0
    super(tecnico)
  } 
}

//=================================MUSICOS=========================================

//===================================PUNTO 1=======================================
//Johann es feliz si tiene un instrumento caro (que cueste 
//más de 20 chelines). Inicialmente Johann tiene una trompeta Jupiter.

object johann inherits Musico (instrumento = trompetaJupiter) {

  override method esFeliz() = instrumento.costo() > 20 

}

//===================================PUNTO 2=======================================
//Wolfgang es feliz si Johann es feliz
object wolfgang inherits Musico (instrumento = violinStagg) {

  override method esFeliz() = johann.esFeliz()

}

//===================================PUNTO 3=======================================
//Antonio es feliz si su instrumento es valioso. Inicialmente tiene un piano Bechstein.
object antonio inherits Musico (instrumento = pianoBechstein)  {

  override method esFeliz() = instrumento.esValioso()  
}

//===================================PUNTO 4=======================================
//Giuseppe es feliz si su instrumento está afinado. Inicialmente tiene una guitarra Fender
object giuseppe inherits Musico (instrumento = guitarraFenderStratocaster)  {

  override method esFeliz() = instrumento.estaAfinado() 

}

//===================================PUNTO 5=======================================
//Maddalena es feliz si su instrumento tiene un costo par. Inicialmente tiene un violín Stagg.
object maddalena inherits Musico (instrumento = violinStagg)  {
    
  override method esFeliz() = instrumento.costo().even() 

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

//===================================ENTREGA 2=======================================

//===================================PUNTO 1=========================================
//Queremos agregar estos músicos que se comportan todos de la misma manera:
//~tienen una preferencia de la familia de instrumentos que tocan: cuerdas, vientos, percusión, etc.
//son expertos si su instrumento es de la familia que ellos prefieren
//y son felices si el instrumento que tocan es copado, esto vale para la trompeta Júpiter con 
//Sordina y para el piano Bechstein en una habitación con un ancho o un largo > 6 metros
//los músicos anteriores (Johann, Wolfgang, etc.) siguen conservando su propia lógica pero también 
//tienen que poder responder si son expertos igual que los músicos genéricos. Considerar que la 
//preferencia inicial de la familia de instrumentos es indistinta.

class Musico {
  var property prefiereFamilia = "indistinta"
  var property instrumento 
  
  method esExperto() = instrumento.familia() == prefiereFamilia
  method esFeliz() = instrumento.esCopado() 
}


//Necesitamos además conformar una orquesta con varios músicos, para lo cual
//inicialmente definimos la cantidad de músicos máxima que estarán en la orquesta
//al agregar un músico, tenemos que evitar agregar al mismo músico dos veces
//tampoco está permitido que la orquesta tenga más músicos que la cantidad permitida

class Orquesta {
  const property miembros = [] 
  var property maximoMiembros

  method agregarMusico(musico) {
    self.validarCantidadMusicos()
    self.validarMusico(musico)
    miembros.add(musico)
  }

  method validarCantidadMusicos(){
    if(miembros.length() >= maximoMiembros) {
      throw new Exception(message = "Ya se alcanzo la cantidad maxima de miembros")
    }
  }

  method validarMusico(musico){
    if(miembros.contains(musico)) {
      throw new Exception(message = "El musico ya pertenece a la orquesta")
    }
  }

  method estaBienConformada() = miembros.all({musico => musico.esFeliz()})

  method instrumentosEnOrquesta() = miembros.map({musico => musico.instrumento()}).asSet()

  method orquestaEsDiversa() = self.instrumentosEnOrquesta().length() == miembros.length()
}

//===================================PUNTO 2=========================================
//Luego de un análisis nos dimos cuenta de lo siguiente:
//queremos agregar un instrumento genérico del cual conocemos la familia de instrumentos a la 
//que pertenece, el costo que está en función de la longitud de la familia * 2 ó 3 en base a un
//número al azar del 1 al 10: si ese número es par multiplica por 2 o en caso contrario multiplica 
//por 3. Estará afinado si la última afinación fue hace menos de un mes (ver punto 3).
//los otros instrumentos también deben poder responder la familia a la que pertenecen
//el piano Bechstein ahora calcula como costo el mismo cálculo que el instrumento genérico + el 
//cálculo original por último queremos saber si el instrumento es sensitivo, ésto implica que la 
//familia a la que pertenece tiene exactamente 7 letras. Para el caso de la guitarra Fender además 
//debe tener un costo > 12.

object generadorRandom {
  method randomNumberGenerator() = 1.randomUpTo(10).truncate(0)  
}

object generadorEaxactoPar {
  method randomNumberGenerator() = 2 
}

object generadorEaxactoImpar {
  method randomNumberGenerator() = 3 
}

class Instrumento {
  const property familia
  const property afinaciones = [] 

  var property numeroRandom = generadorRandom
  method multiplicadorPrecio() = if (numeroRandom.randomNumberGenerator().even()) 2 else 3

  method costo() = familia.length() * self.multiplicadorPrecio()

  method esCopado() = false

  method ultimaRevision() = afinaciones.last()

  method estaAfinado() = (new Date() - self.ultimaRevision()) < 30

  method esSensitivo() = familia.length() == 7 

  method verificarTecnico(tecnico){
    if(!tecnico.sabeAfinar()){
      throw new Exception(message = "El tecnico no sabe afinar este instrumento")
    }
  }

  method verificarTiempoRevision(){
    if(!self.cumpleTiempVerificacion()){
      throw new Exception(message = "El instrumento fue revisado recientemente")
    }
  }

  method cumpleTiempVerificacion() = afinaciones.isEmpty() || self.ultimaRevision()-new Date() < 7

  method revisar(tecnico) {
    self.verificarTecnico(tecnico)
    self.verificarTiempoRevision()
    self.afinar(tecnico)
  }

  method afinar(tecnico) {
    const verificacion = new Verificacion(nombreTecnico = tecnico, fecha = new Date())
    afinaciones.add(verificacion)
  }

  method revisionesRecientes() = afinaciones.filter({afinacion => afinacion.esReciente()})
}

class Verificacion {
  const property nombreTecnico
  const property fecha

  method esReciente() = fecha.between(new Date().minusMonths(2), new Date()) 
}

//===================================PUNTO 3=========================================

class Tecnico {
  var property nombreTecnico 
  var property familiaQueAfina 

  method sabeAfinar() = familiaQueAfina == Instrumento.familia()
}