import java.util.LinkedList;

public class Grafo

{
    LinkedList<Nodo> nodos = new LinkedList<Nodo>();

    Grafo(){}

    void agregaNodo(String data)
    {
        nodos.addLast(new Nodo(data));
    }

    void muesraGrafo()
    {
        for(Nodo n : this.nodos)
        {
            print(n.nombre + ": ");
            n.muestraVecinos();
            print("\n");
        }
    }

    Nodo getNodo(String data)
    {
        for(Nodo n : nodos)
        {
            if(n.nombre.equals(data))
            {
                return n;
            }   
        }
        return null;
    }

    int getNodoIndex(String data)
    {
        int i = 0;
        for(Nodo n : nodos)
        {
            if(n.nombre.equals(data))
            {
                return i;
            }   
            i++;
        }
        return -1;
    }

    /*
    public static void main(String[] args) {
     prueba();   
    }*/

    void prueba()
    {
        Grafo g = new Grafo();

        g.agregaNodo("N1");
        g.agregaNodo("N2");
        g.agregaNodo("N3");
        g.agregaNodo("N4");
        g.agregaNodo("N5");
        g.agregaNodo("N6");
        g.agregaNodo("N7");
        
        g.nodos.get(0).agregaVecinoCoste(g.nodos.get(2),2);
        g.nodos.get(0).agregaVecinoCoste(g.nodos.get(3),3);

        g.nodos.get(1).agregaVecino(g.nodos.get(4));
        g.nodos.get(1).agregaVecinoCoste(g.nodos.get(5),5);
        g.nodos.get(1).agregaVecino(g.nodos.get(6));

        g.nodos.get(3).agregaVecinoCoste(g.nodos.get(1),4);

        g.muesraGrafo();
    }

}
