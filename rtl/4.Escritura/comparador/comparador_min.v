// ============================================================================
// MÓDULO: comparador_min.v
// Comparador de igualdad de 8 bits para la señal de minutos
// ============================================================================
module comparador_min (
    input  wire [7:0] convermin,         // Salida del conversor de minutos (8 bits)
    input  wire [7:0] contador_angular,  // Contador angular de 8 bits
    output wire       match_min          // Salida: 1 si coinciden, 0 si no
);

    assign match_min = (convermin == contador_angular) ? 1'b1 : 1'b0;

endmodule