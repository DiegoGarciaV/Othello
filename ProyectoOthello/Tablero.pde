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
   * 1 = casilla con ficha del agente
   * -1 = casilla con ficha del oponente
   */
  int[][] mundo;
  Nodo mundoNodo = new Nodo("mundo",8);
  /**
   * Representa de quién es el turno bajo la siguiente convención:
   * true = turno del agente 1
   * false = turno del oponente -1
   */
  boolean turno;
  
  /**
   * Contador de la cantidad de turnos en el tablero
   */
  int numeroDeTurno;
  
  // Cantidad de posibles movimientos en el turno actual
  int juegosPosibles = 4;
  
  
  //Cadenas de texto que se muestran en la parte inferior del tablero
  String mensaje = "";
  String mensaje2 = "";
  
  //Bandera de juego terminado
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
    mundo[(dimension/2)-1][(dimension/2)-1] = -1;
    mundo[dimension/2][dimension/2] = -1;
    
    mundoNodo.estado[(dimension/2)-1][dimension/2] = 1;
    mundoNodo.estado[dimension/2][(dimension/2)-1] = 1;
    mundoNodo.estado[(dimension/2)-1][(dimension/2)-1] = -1;
    mundoNodo.estado[dimension/2][dimension/2] = -1;
  }

  /**
   * Constructor por default de un tablero con las siguientes propiedades:
   * Tablero de 8x8 casillas, cada casilla de un tamaño de 60 pixeles,
   */
  Tablero() {
    this(8, 60);
  }
  
    Tablero(Nodo n) {
    this(8, 60);
    this.mundoNodo = new Nodo("nodo juego",8);
    int i,j;
    //Volcamos la información del nodo al mundo del tablero.
     for(i=0;i<8;i++)
     {
        for(j=0;j<8;j++)
        {
          this.mundo[i][j] = n.estado[i][j];
          this.mundoNodo.estado[i][j] = n.estado[i][j];
          
        }
     }
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
    
    
    for (int i = 0; i < dimension; i++)
      for (int j = 0; j < dimension; j++) {
        // Dibujar cada casilla del tablero:
        fill(fondo); // establecer color de fondo
        stroke(linea); // establecer color de línea
        strokeWeight(grosor); // establecer ancho de línea
        rect(i*tamCasilla, j*tamCasilla, tamCasilla, tamCasilla);

        // Dibujar las fichas de los jugadores:
        if (mundo[i][j] != 0) { // en caso de que la casilla no esté vacia
          fill(mundo[i][j] == 1 ? jugador1 : jugador2); // establecer el color de la ficha
          noStroke(); // quitar contorno de línea
          ellipse(i*tamCasilla+(tamCasilla/2), j*tamCasilla+(tamCasilla/2), tamCasilla*4/5, tamCasilla*4/5);
        }
      }
      
      //Mostrar consola de datos en la parte inferior del tablero
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
  
  
  //Escribir mensajes en la consola del juego
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
    return (mundo[posX][posY] != 0);
  }
  
    /**
   * Verifica si en la posición de una casilla dada se puede hacer un movimiento legal 
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   * @return True si es un movimiento legal, false en otro caso
   */
  boolean esJugable(int posX, int posY) {
    
    //buscar en la lista de jugadas
    PVector jugadas[] = tablero.jugadasPosibles();
    int i = 0;
    juegosPosibles = floor(jugadas[0].x);
    for(i = 1; i < juegosPosibles; i ++)
    {
       if(jugadas[i].x == posX && jugadas[i].y == posY)
         return true;
    }
    return false;
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
        if(mundo[i][j] == -1)
          contador.y += 1;
      }
    return contador;
  }
  
  
  
  /**
   * Coloca o establece una ficha en una casilla específica del tablero.
   * Nota: El eje vertical está invertido y el conteo empieza en cero.
   * @param posX Coordenada horizontal de la casilla para establecer la ficha
   * @param posX Coordenada vertical de la casilla para establecer la ficha
   * @param turno Representa el turno o color de ficha a establecer
   */
  void setFicha(int posX, int posY, boolean turno) {
    mundo[posX][posY] = turno ? 1 : -1;
    mundoNodo.estado[posX][posY] = turno ? 1 : -1;
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
   * Verifica si en la posición de una casilla dada encierra a alguna hilera del oponente en una dirección dada
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   * @param dx dirección horizontal de busqueda
   * @param dy dirección vertical de busqueda
   * @return Cantidad de fichas encerradas
   */
  int encierraEnemigo(int posX, int posY, int dx, int dy)
  {
    int d = 1;
    int jugador = (this.turno ? 1 : -1);
    int fichaBuscar = -jugador;
      
    while(posX+dx*d < 8 && posX+dx*d >= 0 && posY+dy*d < 8 && posY+dy*d >= 0 && (mundo[posX+dx*d][posY+dy*d++] == fichaBuscar))
    {
      if(posX+dx*d < 8 && posX+dx*d >= 0 && posY+dy*d < 8 && posY+dy*d >= 0 && mundo[posX+dx*d][posY+dy*d] == jugador)
      return d;
    }
    
    return 0;
  }
  
  
   /**
   * Verifica si un movimiento legar ya se ha considerado y agregado a la lista de movimientos legales
   * @param J Lista de movimientos legales
   * @param j jugada por verificar
   * @param p cantidad de jugadas posibles
   * @return True si ya se consideró esa jugada
   */
   
  boolean jugadaConsiderada(PVector[] J, PVector j,int p)
  {
    int i = 0;
    for(i  = 1; i < p; i++)
    {
      if(J[i].x == j.x && J[i].y == j.y)
        return true;
    }
    return false;
  }
  
  
  
  /**
   * Función que devuelve una lista de todas las jugadas posibles dado el turno actual
   * @return Lista de jugadas posibles
   */
   
  PVector[] jugadasPosibles()
  {
      PVector jugadas[] = new PVector[60];
      jugadas[0] = new PVector(1,0);
      int i,j,p = 1;
      
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
                  
                  if(encierraEnemigo(i,j,h,k) > 0 && !jugadaConsiderada(jugadas,new PVector(i,j),p))
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
  
  //Método que imprime las ubicaciones de las jugadas posibles del turno actual
  void muestraJugadas()
  {
    PVector jugadas[] = jugadasPosibles();
    int i = 0;
    juegosPosibles = floor(jugadas[0].x);
    for(i = 1; i < juegosPosibles; i ++)
    {
        int cx,cy;
        cx =  floor(jugadas[i].x);
        cy =  floor(jugadas[i].y);
        fill(color(200,200,200,100));
        noStroke(); // quitar contorno de línea
        ellipse(cx*tamCasilla+(tamCasilla/2), cy*tamCasilla+(tamCasilla/2), tamCasilla*4/5, tamCasilla*4/5);
    }
  }
  
  /**
   * Verifica si el jugador el turno actual tiene movmientos legales posibles
   * @return True si no iene movimientos, False en otro caso
   */
   
  boolean sinMovimientos()
  {
    if(jugadasPosibles()[0].x == 1)
    {
      return true;
    }
    return false;
  }
  
   /**
   * Verifica si ambos jugadores tienen movimientos posibles y la partida puede continuar
   * @return True si la partida ha concluido, false en otro caso
   */
   
  boolean finPartida()
  {
    if(sinMovimientos())
    {
      cambiarTurno();
      return sinMovimientos();
    }
    return false;
  }
  
  
  
  void terminaPartida()
  {
     finJuego = true; 
    
  }
  
  //Método que coloca el tablero en el estado inicial de un partidas
  void nuevoJuego()
  {
    
    int i,j;
    for(i=0;i<8;i++)
    {
       for(j=0;j<8;j++)
       {  
         mundo[i][j] = 0;
         mundoNodo.estado[i][j] = 0;
       }
    }
    
    mundo[(dimension/2)-1][dimension/2] = 1;
    mundo[dimension/2][(dimension/2)-1] = 1;
    mundo[(dimension/2)-1][(dimension/2)-1] = -1;
    mundo[dimension/2][dimension/2] = -1;
    
    
    mundoNodo.estado[(dimension/2)-1][dimension/2] = 1;
    mundoNodo.estado[dimension/2][(dimension/2)-1] = 1;
    mundoNodo.estado[(dimension/2)-1][(dimension/2)-1] = -1;
    mundoNodo.estado[dimension/2][dimension/2] = -1;
    
   turno = true;
   numeroDeTurno = 0;
   juegosPosibles = 4;
   mensaje = "";
   mensaje2 = "";
   finJuego = false;
   muestraJugadas();
     
  }
  
  
  
}
