class Nave{
    var velocidad
    var direccionSol
    var combustible

    method acelerar(unValor){
        velocidad = (velocidad + unValor).min(100000)
    }
    method desacelerar(unValor){
        velocidad = (velocidad - unValor).max(0)
    } 


    method irHaciaElSol(){
        direccionSol = 10
    } 
    method escaparDelSol(){
        direccionSol = -10
    } 
    method ponerseParaleloAlSol(){
        direccionSol = 0
    }

    method acercarseUnPocoAlSol(){
        direccionSol = (direccionSol + 1).min(10)
    }
    method alejarseUnPocoDelSol(){
        direccionSol = (direccionSol - 1).max(0)
    }

    method prepararViaje()

    method cargarCombustible(unValor) {
        combustible += unValor
    }
    method descargarCombustible(unValor) {
        combustible -= unValor
    }

    method esTranquila() = combustible >= 4000 && velocidad < 12000
    method tienePocaActividad() = true

    method escapar()
    method avisar() 

    method recibirAmenaza(){
        self.escapar()
        self.avisar()
    }

    method estaRelajao() = self.esTranquila() && self.tienePocaActividad()
}

class NaveBaliza inherits Nave {
    var colorBaliza
    var cantCambiosDeBaliza = 0

    method cambiarColorBaliza(unColor) {
        colorBaliza = unColor
        cantCambiosDeBaliza += 1
    }

    override method prepararViaje() {
        self.cargarCombustible(30000)
        self.acelerar(5000)
        self.cambiarColorBaliza("verde")
        self.ponerseParaleloAlSol()
    }

    override method esTranquila() {
        return super() && colorBaliza != "rojo"
    }

    override method escapar() {
        self.irHaciaElSol()
    }
    override method avisar() {
        self.cambiarColorBaliza("rojo")
    }

    override method tienePocaActividad(){
        return cantCambiosDeBaliza == 0
    }
}

class NavePasajeros inherits Nave{
    var cantidadPasajeros
    var racionComida
    var racionBebida
    var cantidadDeRacionDeComidaDada = 0

    method cantidadPasajeros() = cantidadPasajeros
    method subirPasajeros(unaCantidad) {cantidadPasajeros += unaCantidad}
    method bajarPasajeros(unaCantidad) {cantidadPasajeros -= unaCantidad} 

    method cargarComida(unaCantidad) {
    racionComida += unaCantidad
    }
    method descargarComida(unaCantidad) {
    racionComida -= unaCantidad
    cantidadDeRacionDeComidaDada += unaCantidad
    }

    method cargarBebida(unaCantidad) {
        racionBebida += unaCantidad
    }
    method descargarBebida(unaCantidad) {
        racionBebida -= unaCantidad
    }

    override method prepararViaje() {
        self.cargarCombustible(30000)
        self.acelerar(5000)
        self.cargarComida(4*cantidadPasajeros)
        self.cargarBebida(6*cantidadPasajeros)
        self.acercarseUnPocoAlSol()
    }

    override method escapar() {
        self.acelerar(velocidad*2)
    }
    override method avisar() {
        self.descargarComida(1*cantidadPasajeros)
        self.descargarBebida(2*cantidadPasajeros)
    }

    override method tienePocaActividad(){
        return cantidadDeRacionDeComidaDada < 50
    }
}

class NaveCombate inherits Nave{
    var estaInvisible
    var misilesDesplegados
    const mensajesEmitidos = []


    method getEstaInvisible() = estaInvisible 
    method getMisilesDesplegados() = misilesDesplegados
    method getMensajesEmitidos() = mensajesEmitidos  
    
    method ponerseVisible() {
        estaInvisible = false
    }
    method ponerseInvisible() {
        estaInvisible = true
    }

    method desplegarMisiles() {
        misilesDesplegados = true
    }
    method replegarMisiles() {
        misilesDesplegados = false
    }

    method emitirMensaje(mensaje) {
        mensajesEmitidos.add(mensaje)
    }

    method primerMensajeEmitido() = mensajesEmitidos.first()
    method ultimoMensajeEmitido() = mensajesEmitidos.last()
    method esEscueta() = !mensajesEmitidos.any({e => e.length() > 30})
    method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

    override method prepararViaje() {
        self.cargarCombustible(30000)
        self.acelerar(5000)
        self.ponerseVisible()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en misión")
    }

    override method esTranquila() {
        return super() && !misilesDesplegados
    }

    override method escapar() {
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }
    override method avisar() {
        self.emitirMensaje("Amenaza recibida")
    }
}

class NaveHospital inherits NavePasajeros {
    var quirofanoPreparado

    method prepararQuirofano() {
        quirofanoPreparado = true
    }

    method desarmarQuirofano() {
        quirofanoPreparado = false
    }

    override method esTranquila() {
        return super() && !quirofanoPreparado
    }

    override method recibirAmenaza() {
        super();
        self.prepararQuirofano()
    }
}

class NaveCombateSigilosa inherits NaveCombate {
    override method esTranquila() {
        return super() && !estaInvisible
    }
    override method escapar() {
        super();
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}