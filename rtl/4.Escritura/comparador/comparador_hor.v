// ============================================================================
// MÓDULO: comparador_hor.v
// Comparador de igualdad de 8 bits para la señal de horas
// ============================================================================
module comparador_hor (
    input  wire [7:0] converhor,         // Salida del conversor de horas (8 bits)
    input  wire [7:0] contador_angular,  // Contador angular de 8 bits
    output wire       match_hor          // Salida: 1 si coinciden, 0 si no
);

    assign match_hor = (converhor == contador_angular) ? 1'b1 : 1'b0;

endmodule