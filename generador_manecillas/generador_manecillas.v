// ============================================================================
// MÓDULO: generador_manecillas.v
// Genera los patrones de 32 bits para Horas, Minutos y Segundos
// y los combina con la carátula proveniente de la ROM.
// ============================================================================
module generador_manecillas (
    // Entradas de coincidencia (1 bit cada una desde el comparador)
    input  wire        MATCH_SEG,   // Coincidencia de posición de segundos
    input  wire        MATCH_MIN,   // Coincidencia de posición de minutos
    input  wire        MATCH_HORA,  // Coincidencia de posición de horas

    // Entrada de carátula desde la ROM (32 bits)
    input  wire [31:0] ROM_OUT,     // Patrón de carátula en el ángulo actual

    // Salidas de patrones individuales (32 bits cada uno)
    output wire [31:0] PATRON_SEG,
    output wire [31:0] PATRON_MIN,
    output wire [31:0] PATRON_HORA,

    // Salida combinada de las 3 manecillas (32 bits)
    output wire [31:0] PATRON_MANECILLAS,

    // Salida final hacia la tira de LEDs (32 bits encendido/apagado)
    output wire [31:0] LED_OUT
);

    // Máscaras fijas según la longitud de cada manecilla
    localparam [31:0] MASCARA_SEG  = 32'h01FFFFFF; // 25 LEDs (bits 0 a 24)
    localparam [31:0] MASCARA_MIN  = 32'h001FFFFF; // 21 LEDs (bits 0 a 20)
    localparam [31:0] MASCARA_HORA = 32'h00007FFF; // 15 LEDs (bits 0 a 14)

    // 1. Generador de segundos (25 LEDs)
    assign PATRON_SEG = {32{MATCH_SEG}} & MASCARA_SEG;

    // 2. Generador de minutos (21 LEDs)
    assign PATRON_MIN = {32{MATCH_MIN}} & MASCARA_MIN;

    // 3. Generador de horas (15 LEDs)
    assign PATRON_HORA = {32{MATCH_HORA}} & MASCARA_HORA;

    // 4. Combinación de manecillas con compuerta OR de 32 bits
    assign PATRON_MANECILLAS = PATRON_SEG | PATRON_MIN | PATRON_HORA;

    // 5. Combinación final con la carátula ROM usando compuerta OR de 32 bits
    assign LED_OUT = ROM_OUT | PATRON_MANECILLAS;

endmodule