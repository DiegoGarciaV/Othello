/**
 * Proyecto base para el juego de Othello/Reversi
 * @author Rodrigo Colín
 */

Tablero tablero;

/**
 * Método para establecet tamaño de ventana al incluir variables
 */
void settings(){
  tablero =  new Tablero();
  size(tablero.dimension * tablero.tamCasilla, (tablero.dimension + 3)* tablero.tamCasilla);
}

/**
 * Inicializaciones
 */
void setup(){
  println("Proyecto base para el juego de mesa Othello");
  tablero.muestraJugadas();
}

/**
 * Ciclo de dibujado
 */
void draw(){
  
  tablero.display();
  
}

/**
 * Evento para detectar cuando el usuario da clic
 */
void mousePressed() {
  
  int casillaX,casillaY;
  casillaX = mouseX/tablero.tamCasilla;
  casillaY = mouseY/tablero.tamCasilla;
  
  
      
  if((casillaX < 8 && casillaY < 8) && tablero.esJugable(casillaX,casillaY))
  {
      println("\nClic en la casilla " + "[" + casillaX + ", " + casillaY + "]");
      tablero.setFicha(casillaX,casillaY);
      tablero.cambiarTurno();
      println("H = " + tablero.heuristica());
      tablero.muestraJugadas();
      tablero.mensaje("Turno " + tablero.numeroDeTurno + "   "  + (tablero.turno ? " jugó ficha blanca" : "jugó ficha negra"));
      
      if(tablero.juegosPosibles == 1)
      {
        
        tablero.cambiarTurno();
        tablero.muestraJugadas();
        tablero.mensaje((tablero.juegosPosibles - 1) + " jugadas posibles, turno para el siguiente jugador.");
        if(tablero.juegosPosibles == 1)
        {
          tablero.mensajes("Fin de la partida, " + (tablero.cantidadFichas().x > tablero.cantidadFichas().y ? " ganan Negras" : (tablero.cantidadFichas().x < tablero.cantidadFichas().y ? "ganan Blancas" : "empate")),"       Volver a jugar      ");
          tablero.finPartida();
          
        }
        else
        {
          tablero.mensajes("Sin jugadas posibles","Turno para el siguiente jugador.");
        }
        
       
      }
      
      
      
  }
  else if((casillaX < 8 && casillaY < 8))
  {
     println("No es posible colocar ficha en la casilla " + "[" + casillaX + ", " + casillaY + "]");
  }
  else if(casillaY > 8 && tablero.finJuego)
  {
    tablero.nuevoJuego();
  }
  

    
}
