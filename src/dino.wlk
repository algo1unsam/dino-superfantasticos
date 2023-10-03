import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(orjeto)
		//game.schedule(2500, {game.addVisual(orjeto0)})
		//game.schedule(5100, {game.addVisual(orjeto1)})
		game.addVisual(dino)
		game.addVisual(reloj)
		
	
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		orjeto.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		orjeto.detener()
		reloj.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo++
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

class Cactus {
	 
	var position = self.posicionInicial()

	method image() = "cactus.png"
	method position() = position
	
	method posicionInicial() = game.at(game.width()-1,suelo.position().y())

	method iniciar(){
		position = self.posicionInicial()
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
	}
	
	method chocar(){
		dino.morir()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}
const orjeto = new Cactus()
const orjeto0 = new Cactus()
const orjeto1 = new Cactus()

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}


object dino {
	var vivo = true

	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		self.subir()
		game.schedule(650, {self.bajar()})
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}