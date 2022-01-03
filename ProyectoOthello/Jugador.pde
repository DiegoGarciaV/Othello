import java.util.LinkedList;

class Jugador {
   
   int bifurcacion[] = new int[64]; 
   int explorados[]  = new int[64];
   int fichas[] = new int[64]; 
   int exploraciones;
   int profundidad   = 6;
  
   void setDificultad(int d)
   {
     this.profundidad = min(d,10);
   }
   
   PVector Jugar(Tablero tbl)
   {
     PVector jugada = new PVector(0,0);
     Nodo actual = tbl.mundoNodo;
     exploraciones = 0;
     println("Nodo actual: \n" + actual.imprimeEstado());
     println("Nodos hijo: \n");
     actual.vecinos = new LinkedList();
     generaHijos(actual,true);
     exploraciones += actual.vecinos.size();
     
     int maxR = -100000000,r;
     Nodo maxNodo = new Nodo("jugada", 8);
     bifurcacion[tbl.numeroDeTurno] = actual.vecinos.size();
     fichas[tbl.numeroDeTurno] = floor(tbl.cantidadFichas().x);
     println("Totales: " + actual.vecinos.size());
     if(actual.vecinos.size() > 1)
     {
       for(NodoPeso hp : actual.vecinos)
       {
         Nodo h = hp.nNodo;
         int a =  -100000;
         int b = 100000;
         int hr = heuristica(h,false);
         r= minimax(h,false,0,a,b);
         explorados[tbl.numeroDeTurno] = exploraciones;
         println(h.imprimeEstado() + " " + r + ", " + hr);
         if(r >= maxR)
         {
           if(r == maxR)
           {
             if(hr > heuristica(maxNodo,false))
             {
               maxR = r;
               maxNodo = h;
             }
           }
           else
           {
             maxR = r;
             maxNodo = h;
           }
               
         }
       }
     }
     else
     {
       Nodo h = actual.vecinos.getFirst().nNodo;
       /*println(h.imprimeEstado());
       if(nodoTerminal(h))
         println(evalFunc(h));
       else
         println(heuristica(h));*/
       maxNodo = h;
       maxR = 0;
     }
       
     println("Mejor jugada: \n" + maxNodo.imprimeEstado() + " " + maxR + ", " + heuristica(maxNodo,false));
     
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
   
   
   LinkedList<Nodo> generaHijos(Nodo n,boolean turno)
   {
     LinkedList<Nodo> hijos = new LinkedList<Nodo>();
     
     Tablero tbl = new Tablero(n);
     tbl.turno = turno;
     
     PVector[] jugadas = tbl.jugadasPosibles();
     int total = floor(jugadas[0].x);
     for(int i = 1; i < total; i++)
     {
       Nodo nNodo = new Nodo("Nodo" + i,8);
       Tablero tbl2 = new Tablero(n);
       tbl2.turno = turno;
       
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
       n.agregaVecino(nNodo);
     }
     
     return hijos;
     
   }
   
   boolean nodoTerminal(Nodo n)
   {
     Tablero tbl = new Tablero(n);
     return tbl.finPartida();
     
   }
    
    
    int heuristica(Nodo n, boolean turno)
    {
      int E,X,C,H1,H2,m,p;
      E = n.estado[0][0] + n.estado[0][7] + n.estado[7][0] + n.estado[7][7];
      X = E + n.estado[0][2] + n.estado[0][5] + n.estado[2][0] + n.estado[2][2] + n.estado[2][5] + n.estado[0][7] + n.estado[7][2] + n.estado[7][5] + n.estado[5][0] + n.estado[5][2] + n.estado[5][5] + n.estado[5][7];
      C = (n.estado[0][0] == 0 ? -4 : 1)*(n.estado[0][1] + n.estado[1][1] + n.estado[1][0]);
      C = C + (n.estado[0][7] == 0 ? -4 : 1)*(n.estado[0][6] + n.estado[1][6] + n.estado[1][7]);
      C = C + (n.estado[7][0] == 0 ? -4 : 1)*(n.estado[6][0] + n.estado[6][1] + n.estado[7][1]);
      C = C + (n.estado[7][7] == 0 ? -4 : 1)*(n.estado[7][6] + n.estado[6][6] + n.estado[6][7]);
      
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
      tbl.turno = turno;
      m = floor(tbl.jugadasPosibles()[0].x);
      p = floor(tbl.cantidadFichas().x - tbl.cantidadFichas().y);
      
      return (64*E + 16*X + 16*C + 4*H1 + 16*H2 + p - 4*m);
            
    }
    
    int evalFunc(Nodo n, boolean turno)
    {
        if(!nodoTerminal(n))
        {
            //Si no es nodo terminal retorna el valor de la heuristica
            return heuristica(n, turno);
            
        }
        else
        {
          Tablero tbl = new Tablero(n);
          int E = n.estado[0][0] + n.estado[0][7] + n.estado[7][0] + n.estado[7][7];
          int p = 10*floor(tbl.cantidadFichas().x - tbl.cantidadFichas().y + 32*E);
          p = floor(tbl.cantidadFichas().x - tbl.cantidadFichas().y)*100000;
          return p;
        }
    }
   
   int minimax(Nodo n, boolean turno, int profund, int alfa, int beta)
   {
     int alfaM = alfa,betaM = beta;
     
     if(profund >= this.profundidad || nodoTerminal(n))
        {
            int r = evalFunc(n, turno);
            //println("Nivel " + profund + ", turno de " + (turno ? 'O' : 'X') + "\n" + n.imprimeEstado() + " " + r);
            return r;
        }
        
        LinkedList<Nodo> hijos = new LinkedList<Nodo>();

        hijos = generaHijos(n,turno);
        if(hijos.size() == 0)
        {
          hijos.add(n);
        }
        exploraciones += hijos.size();
        int minimo =  100000000;
        int maximo = -minimo;
        for(Nodo h : hijos)
        {
            int r = 0;
  
            r = minimax(h, !turno,profund + 1,alfaM,betaM);
            //println("Nivel " + profund + ", turno de " + (turno ? 'O' : 'X') + "\n" + h.imprimeEstado() + " " + r);

            if(r < minimo)
                minimo = r;
            if(r> maximo)
                maximo = r;
                
            if(turno)
            {
              alfaM = maximo;
            }
            else
            {
              betaM = minimo;
            }/*
            if(alfaM >= betaM)
            {
              break;
            }*/
            
        }
        return (turno ? maximo : minimo);
   }

   
   
 }
