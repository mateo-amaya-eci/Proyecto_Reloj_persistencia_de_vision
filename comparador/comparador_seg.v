// ============================================================================
// MÓDULO: comparador_seg.v
// Comparador de igualdad de 8 bits para la señal de segundos
// ============================================================================
module comparador_seg (
    input  wire [7:0] converseg,         // Entrada 1: Salida del conversor de segundos (8 bits)
    input  wire [7:0] contador_angular,  // Entrada 2: Contador angular (8 bits)
    output wire       match_seg          // Salida: 1 si son iguales, 0 si son diferentes
);

    // Comparación combinacional de igualdad (==)
    assign match_seg = (converseg == contador_angular) ? 1'b1 : 1'b0;

endmodule