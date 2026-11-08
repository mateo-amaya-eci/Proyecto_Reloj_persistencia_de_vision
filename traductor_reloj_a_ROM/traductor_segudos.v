// ============================================================================
// MoDULO: conversor_segundos.v
// Traduccion de segundos (0 a 59) para direccion de ROM
// ============================================================================
module conversor_segundos (
    input  wire [5:0]  salida_s,   // Entrada de segundos del reloj (6 bits)
    output wire [13:0] rom_s       // Salida hacia ROM (14 bits segon diagrama)
);
    wire [13:0] bus_shift;
    wire [13:0] bus_sum;

    // 1. Desplazamiento a la izquierda por 8 bits (Salida_s << 8)
    assign bus_shift = {salida_s, 8'b00000000};

    // 2. Sumador de offset (+30)
    assign bus_sum   = bus_shift + 14'd30;

    // 3. Divisor entre 60
    assign rom_s     = bus_sum / 14'd60;

endmodule