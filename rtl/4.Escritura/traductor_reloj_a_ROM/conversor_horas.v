// ============================================================================
// MoDULO: conversor_horas.v
// Traduccion de horas (1 a 12) para direccion de ROM
// ============================================================================
module conversor_horas (
    input  wire [3:0]  salida_h,   // Entrada de horas del reloj (4 bits)
    output wire [11:0] rom_h       // Salida hacia ROM (12 bits segun diagrama)
);
    wire [11:0] bus_shift;
    wire [11:0] bus_sum;

    // 1. Desplazamiento a la izquierda por 8 bits (Salida_h << 8)
    assign bus_shift = {salida_h, 8'b00000000};

    // 2. Sumador de offset (+6)
    assign bus_sum   = bus_shift + 12'd6;

    // 3. Divisor entre 12
    assign rom_h     = bus_sum / 12'd12;

endmodule