//Alumno Marccelo Farid Tito Lezano

#include <iostream>
#include <cstdint>
using namespace std;

void desplazamiento_derecha(uint32_t& A, uint32_t& Q, uint32_t& Q_1) {
    bool bit_menos_significativo_A = A & 1;
    bool bit_menos_significativo_Q = Q & 1;

    A >>= 1; 
    Q >>= 1; 
    Q |= (bit_menos_significativo_A << 31); 
    A |= (bit_menos_significativo_A << 31);
    Q_1 = bit_menos_significativo_Q;
}

bool calcular_acarreo(bool a, bool b, bool acarreo) {
    return (a & b) | (a & acarreo) | (b & acarreo);
}


void suma_binaria(uint32_t& A, const uint32_t& M) {
    bool acarreo = false;
    for (size_t i = 0; i < 32; ++i) {
        bool b_A = (A >> i) & 1;
        bool b_M = (M >> i) & 1;

        A ^= ((b_M ^ b_A ^ acarreo) << i);
        acarreo = calcular_acarreo(b_A, b_M, acarreo);
    }
}


void resta_compDos(uint32_t& A, const uint32_t& M) {
    uint32_t neg_M = ~M;
    suma_binaria(A, neg_M); 
}

void imprimir_valores(uint32_t A, uint32_t Q) {
    cout << "A: ";
    for (int i = 31; i >= 0; --i) {
        cout << ((A >> i) & 1);
    }
    cout << endl;

    cout << "Q: ";
    for (int i = 31; i >= 0; --i) {
        cout << ((Q >> i) & 1);
    }
    cout << endl;
}


void multiplicacion_booth(uint32_t M, uint32_t Q) {
    uint32_t A = M;
    uint32_t q = Q;
    uint32_t q_1 = 0; 

    cout << "Iteracion 0:" << endl;
    imprimir_valores(A, Q);

    for (size_t i = 0; i < 32; ++i) {
        cout << "Iterar, paso " << i + 1 << ":" << endl;
        if ((q & 1) == 0 && q_1 == 1) { 
            resta_compDos(A, M);
            cout << "Restar M de A:" << endl;
        }
        else if ((q & 1) == 1 && q_1 == 0) { 
            suma_binaria(A, M);
            cout << "Sumar M a A:" << endl;
        }
        desplazamiento_derecha(A, q, q_1); 
        imprimir_valores(A, q);
    }
}

int main() {
    int32_t multiplicando, multiplicador;
    cout << "Ingresa multiplicando: ";
    cin >> multiplicando;
    cout << "Ingresa multiplicador: ";
    cin >> multiplicador;

    uint32_t M = static_cast<uint32_t>(multiplicando);
    uint32_t Q = static_cast<uint32_t>(multiplicador);

    multiplicacion_booth(M, Q);

    return 0;
}