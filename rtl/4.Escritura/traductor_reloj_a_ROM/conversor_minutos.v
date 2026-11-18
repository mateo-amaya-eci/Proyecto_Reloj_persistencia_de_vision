// ============================================================================
// MoDULO: conversor_minutos.v
// Traduccion de minutos (0 a 59) para direccion de ROM
// ============================================================================
module conversor_minutos (
    input  wire [5:0]  salida_m,   // Entrada de minutos del reloj (6 bits)
    output wire [13:0] rom_m       // Salida hacia ROM (14 bits segun diagrama)
);
    wire [13:0] bus_shift;
    wire [13:0] bus_sum;

    // 1. Desplazamiento a la izquierda por 8 bits (Salida_M << 8)
    assign bus_shift = {salida_m, 8'b00000000};

    // 2. Sumador de offset (+30)
    assign bus_sum   = bus_shift + 14'd30;

    // 3. Divisor entre 60
    assign rom_m     = bus_sum / 14'd60;

endmodule