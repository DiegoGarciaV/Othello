/**
 * Definición de un tablero para el juego de Othello
 * @author Rodrigo Colín
 */
class Tablero {
  /**
   * Cantidad de casillas en horizontal y vertical del tablero
   */
  int dimension;

  /**
   * El tamaño en pixeles de cada casilla cuadrada del tablero
   */
  int tamCasilla;

  /**
   * Representación lógica del tablero. El valor númerico representa:
   * 0 = casilla vacia
   * 1 = casilla con ficha del primer jugador
   * 2 = casilla con ficha del segundo jugador
   */
  int[][] mundo;

  /**
   * Representa de quién es el turno bajo la siguiente convención:
   * true = turno del jugador 1
   * false = turno del jugador 2
   */
  boolean turno;
  
  /**
   * Contador de la cantidad de turnos en el tablero
   */
  int numeroDeTurno;
  
  int juegosPosibles = 4;
  
  String mensaje = "";
  String mensaje2 = "";
  boolean finJuego = false;

  /**
   * Constructor base de un tablero. 
   * @param dimension Cantidad de casillas del tablero, comúnmente ocho.
   * @param tamCasilla Tamaño en pixeles de cada casilla
   */
  Tablero(int dimension, int tamCasilla) {
    this.dimension = dimension;
    this.tamCasilla = tamCasilla;
    turno = true;
    numeroDeTurno = 0;
    mundo = new int[dimension][dimension];
    // Configuración inicial (colocar 4 fichas al centro del tablero):
    mundo[(dimension/2)-1][dimension/2] = 1;
    mundo[dimension/2][(dimension/2)-1] = 1;
    mundo[(dimension/2)-1][(dimension/2)-1] = 2;
    mundo[dimension/2][dimension/2] = 2;
  }

  /**
   * Constructor por default de un tablero con las siguientes propiedades:
   * Tablero de 8x8 casillas, cada casilla de un tamaño de 60 pixeles,
   */
  Tablero() {
    this(8, 60);
  }

  /**
   * Dibuja en pantalla el tablero, es decir, dibuja las casillas y las fichas de los jugadores
   */
  void display() {
    color fondo = color(125, 0, 0); // El color de fondo del tablero
    color linea = color(200,0,0); // El color de línea del tablero
    int grosor = 5; // Ancho de línea (en pixeles)
    color jugador1 = color(0); // Color de ficha para el primer jugador
    color jugador2 = color(255); // Color de ficha para el segundo jugador
    color jugada = color(200,200,200,100); // Color de ficha para posible jugada
    
    // Doble iteración para recorrer cada casilla del tablero
    for (int i = 0; i < dimension; i++)
      for (int j = 0; j < dimension; j++) {
        // Dibujar cada casilla del tablero:
        fill(fondo); // establecer color de fondo
        stroke(linea); // establecer color de línea
        strokeWeight(grosor); // establecer ancho de línea
        rect(i*tamCasilla, j*tamCasilla, tamCasilla, tamCasilla);

        // Dibujar las fichas de los jugadores:
        if (mundo[i][j] != 0) { // en caso de que la casilla no esté vacia
          fill(mundo[i][j] == 1 ? jugador1 : (mundo[i][j] == 2 ? jugador2 : jugada)); // establecer el color de la ficha
          noStroke(); // quitar contorno de línea
          ellipse(i*tamCasilla+(tamCasilla/2), j*tamCasilla+(tamCasilla/2), tamCasilla*4/5, tamCasilla*4/5);
        }
      }
      
      fill(fondo);
      rect(0, dimension*tamCasilla, dimension*tamCasilla, 3*tamCasilla);
      textSize(tamCasilla/2);
      fill(255);
      text("Turno: ",tamCasilla/4,(dimension+0.65)*tamCasilla);
      fill(turno ? jugador1 :  jugador2);
      noStroke();
      ellipse(tamCasilla*dimension/3, (dimension+0.55)*tamCasilla, tamCasilla*3/5, tamCasilla*3/5);
      fill(255);
      text("Score: " + int(tablero.cantidadFichas().x) + " - " + int(tablero.cantidadFichas().y),(dimension/2 + 0.25)*tamCasilla,(dimension+0.65)*tamCasilla);
      
      
      text(mensaje,tamCasilla/4,(dimension+1.65)*tamCasilla);
      text(mensaje2,tamCasilla/4,(dimension+2.65)*tamCasilla);
  }
  
  
  void mensaje(String s)
  {
      mensaje = s;
      mensaje2 = "";
  }
  
  void mensajes(String s, String t)
  {
      mensaje = s;
      mensaje2 = t;
  }

  /**
   * Coloca o establece una ficha en una casilla específica del tablero.
   * Nota: El eje vertical está invertido y el conteo empieza en cero.
   * @param posX Coordenada horizontal de la casilla para establecer la ficha
   * @param posX Coordenada vertical de la casilla para establecer la ficha
   * @param turno Representa el turno o color de ficha a establecer
   */
  void setFicha(int posX, int posY, boolean turno) {
    mundo[posX][posY] = turno ? 1 : 2;
  }
  
  void setJugada(int posX, int posY) {
    mundo[posX][posY] = 3;
  }
  
  /**
   * Coloca o establece una ficha en una casilla específica del tablero segun el turno del tablero.
   * @param posX Coordenada horizontal de la casilla para establecer la ficha
   * @param posX Coordenada vertical de la casilla para establecer la ficha
   */
  void setFicha(int posX, int posY) {
    this.setFicha(posX, posY, this.turno);
    
    
    int h,k;
    for(h = -1; h < 2; h++)
    {
      for(k = -1; k < 2; k++)
      {
        if(h == 0 && k == 0)
            continue;
        int i,d = 0;
        d = encierraEnemigo(posX,posY,h,k);
        if(d > 0)
        {
          for(i = 0; i < d; i++)
          {
              this.setFicha(posX + h*i, posY + k*i, this.turno);
          }
        }
      }
    }
  }

  /**
   * Representa el cambio de turno. Normalmente representa la última acción del turno
   */
  void cambiarTurno() {
    turno = !turno;
    numeroDeTurno += 1;
  }

  /**
   * Verifica si en la posición de una casilla dada existe una ficha (sin importar su color)
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   * @return True si hay una ficha de cualquier color en la casilla, false en otro caso
   */
  boolean estaOcupado(int posX, int posY) {
    return (mundo[posX][posY] != 0 && mundo[posX][posY] != 3);
  }
  
  boolean esJugable(int posX, int posY) {
    return mundo[posX][posY] == 3;
  }

  /**
   * Cuenta la cantidad de fichas de un jugador
   * @return La cantidad de fichas de ambos jugadores en el tablero como vector, 
   * donde x = jugador1, y = jugador2
   */
  PVector cantidadFichas() {
    PVector contador = new PVector();
    for (int i = 0; i < dimension; i++)
      for (int j = 0; j < dimension; j++){
        if(mundo[i][j] == 1)
          contador.x += 1;
        if(mundo[i][j] == 2)
          contador.y += 1;
      }
    return contador;
  }
  
  
  int encierraEnemigo(int posX, int posY, int dx, int dy)
  {
    int d = 1;
    int jugador = (turno ? 1 : 2);
    int fichaBuscar = (turno ? 2 : 1);
      
    while(posX+dx*d < 8 && posX+dx*d >= 0 && posY+dy*d < 8 && posY+dy*d >= 0 && (mundo[posX+dx*d][posY+dy*d++] == fichaBuscar))
    {
      if(posX+dx*d < 8 && posX+dx*d >= 0 && posY+dy*d < 8 && posY+dy*d >= 0 && mundo[posX+dx*d][posY+dy*d] == jugador)
      return d;
    }
    
    return 0;
  }
  
  PVector[] jugadasPosibles()
  {
      PVector jugadas[] = new PVector[60];
      int i,j,p = 1;
      int jugador = (turno ? 1 : 2);
      int fichaBuscar = (turno ? 2 : 1);
      
      //Borramos juagdas posibles anteriores
      for(i=0;i<8;i++)
      {
         for(j=0;j<8;j++)
         {
           mundo[i][j] = (mundo[i][j] == 3 ? 0 : mundo[i][j]);
         }
      }
      
      for(i=0;i<8;i++)
      {
         for(j=0;j<8;j++)
         {
            if(!estaOcupado(i,j))
            {
              int h,k;
              for(h = -1; h < 2; h++)
              {
                for(k = -1; k < 2; k++)
                {
                  if(h == 0 && k == 0)
                      continue;
                  
                  if(encierraEnemigo(i,j,h,k) > 0)
                  {
                    jugadas[p] = new PVector();
                    jugadas[p].x = i;
                    jugadas[p].y = j;
                    p++;
                  }
                }
              }
            }
           
         }
        
      }
      
      jugadas[0] = new PVector(p,0);
      return jugadas;
  }
  
  
  void muestraJugadas()
  {
    PVector jugadas[] = tablero.jugadasPosibles();
    int i = 0;
    juegosPosibles = floor(jugadas[0].x);
    for(i = 1; i < juegosPosibles; i ++)
    {
        int cx,cy;
        cx =  floor(jugadas[i].x);
        cy =  floor(jugadas[i].y);
        tablero.setJugada(cx, cy);
    }
  }
  
  void finPartida()
  {
     finJuego = true; 
    
  }
  
  
  void nuevoJuego()
  {
    
    int i,j;
    for(i=0;i<8;i++)
    {
       for(j=0;j<8;j++)
       {
         mundo[i][j] = mundo[i][j] = 0;
       }
    }
    
    mundo[(dimension/2)-1][dimension/2] = 1;
    mundo[dimension/2][(dimension/2)-1] = 1;
    mundo[(dimension/2)-1][(dimension/2)-1] = 2;
    mundo[dimension/2][dimension/2] = 2;
    
   turno = true;
   numeroDeTurno = 0;
   juegosPosibles = 4;
   mensaje = "";
   mensaje2 = "";
   finJuego = false;
   muestraJugadas();
     
  }
  
  
  
}
