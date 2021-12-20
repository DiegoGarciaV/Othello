import java.util.LinkedList;

class Jugador {
   
   int profundidad   = 7;
   char cJugador     = 'N';
   char cOponente    = 'B';
   
   int a,b;
   
   Grafo busqueda = new Grafo();
   
   void setDificultad(int d)
   {
     this.profundidad = min(d,10);
   }
   
   PVector Jugar(Tablero tbl)
   {
     PVector jugada = new PVector(0,0);
     Nodo actual = tbl.mundoNodo;
     
     println("Nodo actual: \n" + actual.imprimeEstado());
     println("Nodos hijo: \n");
     LinkedList<Nodo> hijos;
     hijos = generaHijos(actual);
     
     int maxR = -1000000,r;
     Nodo maxNodo = new Nodo("jugada", 8);
     if(hijos.size() > 1)
     {
       for(Nodo h : hijos)
       {
        
         int hr = heuristica(h);
         a =  100000;
         b = -100000;
         int mx = minimax(h,cOponente,0);
         r = mx + hr;
         println(h.imprimeEstado() + " " + mx + " + " + hr + " = " + r);
         if(r > maxR)
         {
            maxR = r;
            maxNodo = h;
         }
       }
     }
     else
       maxNodo = hijos.getFirst();
       
     println("Mejor jugada: \n" + maxNodo.imprimeEstado() + " " + maxR);
     
     int i,j;
     for(i = 0; i< 8; i++)
     {
         for(j = 0; j< 8; j++)
         {
            if(actual.estado[i][j] == 0 &&  maxNodo.estado[i][j] != 0)
            {
               jugada.x = i;
               jugada.y = j;
            }
         }
     }
     
     return jugada;
   }
   
   
   LinkedList<Nodo> generaHijos(Nodo n)
   {
     LinkedList<Nodo> hijos = new LinkedList<Nodo>();
     
     Tablero tbl = new Tablero(n);
     
     PVector[] jugadas = tbl.jugadasPosibles();
     int total = floor(jugadas[0].x);
     for(int i = 1; i < total; i++)
     {
       Nodo nNodo = new Nodo("Nodo" + i,8);
       Tablero tbl2 = new Tablero(n);
       
       tbl2.setFicha(floor(jugadas[i].x),floor(jugadas[i].y));
       
       int h,k;
       for(h = 0; h < 8; h++)
       {
         for(k = 0; k < 8; k++)
         {
           nNodo.estado[h][k] = tbl2.mundo[h][k];
         }
       }
       hijos.addLast(nNodo);
     }
     
     return hijos;
     
   }
   
   boolean nodoTerminal(Nodo n)
   {
     Tablero tbl = new Tablero(n);
     return tbl.finPartida();
     
   }
    
    
    int heuristica(Nodo n)
    {
      int E,X,C,H1,H2,m,p;
      E = n.estado[0][0] + n.estado[0][7] + n.estado[7][0] + n.estado[7][7];
      X = 2*E + 2*n.estado[0][2] + 2*n.estado[0][5] + 2*n.estado[2][0] + n.estado[2][2] + n.estado[2][5] + 2*n.estado[0][7] + 2*n.estado[7][2] + 2*n.estado[7][5] + 2*n.estado[5][0] + n.estado[5][2] + n.estado[5][5] + 2*n.estado[5][7];
      C = (n.estado[0][0] == 0 ? -1 : 1)*(n.estado[0][1] + n.estado[1][1] + n.estado[1][0]);
      C = C + (n.estado[0][7] == 0 ? -1 : 1)*(n.estado[0][6] + n.estado[1][6] + n.estado[1][7]);
      C = C + (n.estado[7][0] == 0 ? -1 : 1)*(n.estado[6][0] + n.estado[6][1] + n.estado[7][1]);
      C = C + (n.estado[7][7] == 0 ? -1 : 1)*(n.estado[7][6] + n.estado[6][6] + n.estado[6][7]);
      
      int i;
      int hs = 0,hiz = 0,hd = 0,hi= 0;
      for(i=1;i<7;i++)
      {
        hs += n.estado[i][0];
        hi += n.estado[i][7];
        hiz += n.estado[0][i];
        hd += n.estado[7][i];
      }
      
      H2 = floor(hs/6) + floor(hi/6) + floor(hiz/6) + floor(hd/6);
      hs +=  n.estado[0][0] + n.estado[7][0];
      hi +=  n.estado[0][7] + n.estado[7][7];
      hiz += n.estado[0][0] + n.estado[0][7];
      hd +=  n.estado[7][0] + n.estado[7][7];
      
      H1 = floor(hs/8) + floor(hi/8) + floor(hiz/8) + floor(hd/8);
      
      Tablero tbl = new Tablero(n);
      m = floor(tbl.jugadasPosibles()[0].x);
      p = floor(tbl.cantidadFichas().x - tbl.cantidadFichas().y);
      
      return (64*E + 8*X + 16*C + 4*H1 + 2*H2 + m + p);
            
    }
    
    int evalFunc(Nodo n)
    {
        if(!nodoTerminal(n))
        {
            //Si no es nodo terminal retorna el valor de la heuristica
            return heuristica(n);
            
        }
        else
        {
          Tablero tbl = new Tablero(n);
          int E = n.estado[0][0] + n.estado[0][7] + n.estado[7][0] + n.estado[7][7];
          int p = 100*floor(tbl.cantidadFichas().x - tbl.cantidadFichas().y + 16*E);
          return p;
        }
    }
   
   int minimax(Nodo n, char turno, int profund)
   {
     
     if(profund >= this.profundidad || nodoTerminal(n))
        {
            return evalFunc(n);
        }
        
        LinkedList<Nodo> hijos = new LinkedList<Nodo>();

        hijos = generaHijos(n);
        
        if(hijos.size() == 0)
        {
          hijos.add(n);
          
        }
        int minimo = minimax(hijos.getFirst(), (turno == cJugador ? cOponente : cJugador),profund + 1);;
        int maximo = minimo;
        for(Nodo h : hijos)
        {
            int r = 0;

            r = minimax(h, (turno == cJugador ? cOponente : cJugador),profund + 1);

            if(r < minimo)
                minimo = r;
            if(r> maximo)
                maximo = r;
        }
        return (turno == cJugador ? maximo : minimo);
   }
   
   
 }
