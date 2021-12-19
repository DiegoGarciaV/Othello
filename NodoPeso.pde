public class NodoPeso{

    double peso = 1;
    Nodo nNodo;

    NodoPeso(String data) {
        nNodo = new Nodo(data);
        this.peso = 1;
    }

    NodoPeso(String data, double w) {
        nNodo = new Nodo(data);
        this.peso = w;
    }

    NodoPeso(Nodo data) {
        nNodo = data;
        this.peso = 1;
    }

    NodoPeso(Nodo data, double w) {
        nNodo = data;
        this.peso = w;
    }
    
}
