/**
 * Proyecto base para el juego de Othello/Reversi
 * @author Rodrigo Colín
 */

Tablero tablero;
Jugador jugador;
int ContadorTiempo = 250;

/**
 * Método para establecet tamaño de ventana al incluir variables
 */
void settings(){
  tablero =  new Tablero();
  jugador = new Jugador();
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
  
  
  if(tablero.turno)
    ContadorTiempo++;
  tablero.display();
  tablero.muestraJugadas();
  if(tablero.turno && !tablero.finPartida() && ContadorTiempo > 250)
    {
      PVector jugada = jugador.Jugar(tablero);
      if(tablero.esJugable(floor(jugada.x),floor(jugada.y)))
      {
        tablero.setFicha(floor(jugada.x),floor(jugada.y));
        println("\nPC jugo en  " + "[" + jugada.x + ", " + jugada.y + "]");
        tablero.cambiarTurno();
        tablero.mensaje("Turno " + tablero.numeroDeTurno + "   "  + (tablero.turno ? " jugó ficha blanca" : "jugó ficha negra"));
        ContadorTiempo = 0;
      }

      
      
      if(tablero.sinMovimientos())
      {
        
        if(tablero.finPartida())
        {
          tablero.mensajes("Fin de la partida, " + (tablero.cantidadFichas().x > tablero.cantidadFichas().y ? " ganan Negras" : (tablero.cantidadFichas().x < tablero.cantidadFichas().y ? "ganan Blancas" : "empate")),"       Volver a jugar      ");
          int i = 0;
          for(i=0;i < tablero.numeroDeTurno-1;i++)
          {
            println(jugador.bifurcacion[i] + "," + jugador.fichas[i]);
          }
          tablero.terminaPartida();
        }
        else
        {
          tablero.mensajes("Sin jugadas posibles","Turno para el siguiente jugador.");
        }
       
      }
      
    }
  
}

/**
 * Evento para detectar cuando el usuario da clic
 */
void mousePressed() {
  
  int casillaX,casillaY;
  casillaX = mouseX/tablero.tamCasilla;
  casillaY = mouseY/tablero.tamCasilla;
  
  
      
  if((casillaX < 8 && casillaY < 8) && tablero.esJugable(casillaX,casillaY) && !tablero.turno)
  {
      println("\nClic en la casilla " + "[" + casillaX + ", " + casillaY + "]");
      
      jugador.bifurcacion[tablero.numeroDeTurno] = floor(tablero.jugadasPosibles()[0].x);
      jugador.fichas[tablero.numeroDeTurno] = floor(tablero.cantidadFichas().x);
      tablero.setFicha(casillaX,casillaY);
      tablero.cambiarTurno();
      tablero.mensaje("Turno " + tablero.numeroDeTurno + "   "  + (tablero.turno ? " jugó ficha blanca" : "jugó ficha negra"));
      
      
      if(tablero.sinMovimientos())
      {
        
        if(tablero.finPartida())
        {
          tablero.mensajes("Fin de la partida, " + (tablero.cantidadFichas().x > tablero.cantidadFichas().y ? " ganan Negras" : (tablero.cantidadFichas().x < tablero.cantidadFichas().y ? "ganan Blancas" : "empate")),"       Volver a jugar      ");
          
          int i = 0;
          for(i=0;i < tablero.numeroDeTurno-1;i++)
          {
            println(jugador.bifurcacion[i] + "," + jugador.fichas[i]);
          }
          tablero.terminaPartida();
        }
        else
        {
          tablero.mensajes("Sin jugadas posibles","Turno para el siguiente jugador.");
        }
       
      }
      tablero.display();
      tablero.muestraJugadas();
      ContadorTiempo = 250;
      
      
  }
  else if((casillaX < 8 && casillaY < 8))
  {
     println("No es posible colocar ficha en la casilla " + "[" + casillaX + ", " + casillaY + "]");
  }
  else if(casillaY > 8 && tablero.finJuego)
  {
    tablero.nuevoJuego();
  }
  else if(casillaY > 8)
  {
      ContadorTiempo = 301;
  }
    
}