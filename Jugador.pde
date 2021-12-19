import java.util.LinkedList;

class Jugador {
   
   int profundidad   = 5;
   char cJugador     = 'B';
   char cOponente    = 'N';
   
   Grafo busqueda = new Grafo();
   
   void setDificultad(int d)
   {
     this.profundidad = min(d,10);
   }
   
   PVector Jugar(Tablero tbl)
   {
     PVector jugada = new PVector(0,0);
     Nodo actual = tbl.mundoNodo;
     LinkedList<Nodo> hijos;
     hijos = generaHijos(actual);
     
     int maxR = -1000000,r;
     Nodo maxNodo = new Nodo("jugada", 8);
     for(Nodo h : hijos)
     {
       r = minimax(h,cOponente,0);
       if(r > maxR)
       {
          maxR = r;
          maxNodo = h;
       }
     }
     
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
       nNodo = tbl2.mundoNodo;
       hijos.addLast(nNodo);
     }
     
     return hijos;
     
   }
   
   boolean nodoTerminal(Nodo n)
   {
     Tablero tbl = new Tablero(n);
     return tbl.finPartida();
     
   }
    
    
    int evalFunc(Nodo n)
    {
        if(!nodoTerminal(n))
        {
            //Si no es nodo terminal retorna el valor de la heuristica
            int E,X,C,H1,H2,m,p;
            E = n.estado[0][0] + n.estado[0][7] + n.estado[7][0] + n.estado[7][7];
            X = E + n.estado[0][2] + n.estado[0][5] + n.estado[2][0] + n.estado[2][2] + n.estado[2][5] + n.estado[0][7] + n.estado[7][2] + n.estado[7][5] + n.estado[5][0] + n.estado[5][2] + n.estado[5][5] + n.estado[5][7];
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
            
            return (16*E + 8*X + 4*C + 4*H1 + 2*H2 + m + p);
            
            
        }
        else
        {
          Tablero tbl = new Tablero(n);
          int p = 100*floor(tbl.cantidadFichas().x - tbl.cantidadFichas().y);
          return p;
        }
    }
   
   int minimax(Nodo n, char turno, int profund)
   {
     
     if(profund >= this.profundidad)
        {
            return evalFunc(n);
        }
        
        LinkedList<Nodo> hijos = new LinkedList<Nodo>();
        int i = 0;

        hijos = generaHijos(n);
        
        //System.out.println("");
        int minimo = 100000000;
        int maximo = -100000000;
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
