// ============================================================================
// MÓDULO TOP LEVEL PARA LA TANG NANO 9K
// ============================================================================
module top_reloj_pov (
    input  wire clk_27mhz,   // Pin 52 de la Tang Nano 9K
    input  wire rst_n,       // Pin 4 (Reset activo en bajo)
    
    // Conexión física hacia la tira LED WS2815
    output wire led_din      // Pin GPIO asignado en el archivo .cst
);

    wire rst = ~rst_n; // Inversión para reset activo en alto

    // ------------------------------------------------------------------------
    // Señales internas provenientes de otros módulos del proyecto
    // ------------------------------------------------------------------------
    wire match_seg;   // Desde los comparadores de ángulo
    wire match_min;   // Desde los comparadores de ángulo
    wire match_hora;  // Desde los comparadores de ángulo
    wire [31:0] rom_out; // Desde la Memoria ROM de la carátula

    wire [31:0] patron_seg;
    wire [31:0] patron_min;
    wire [31:0] patron_hora;
    wire [31:0] patron_manecillas;
    wire [31:0] led_out;

    // 1. INSTANCIA DEL GENERADOR DE MANECILLAS (Lógica combinacional)
    generador_manecillas gen_manecillas_inst (
        .MATCH_SEG(match_seg),
        .MATCH_MIN(match_min),
        .MATCH_HORA(match_hora),
        .ROM_OUT(rom_out),
        .PATRON_SEG(patron_seg),
        .PATRON_MIN(patron_min),
        .PATRON_HORA(patron_hora),
        .PATRON_MANECILLAS(patron_manecillas),
        .LED_OUT(led_out)
    );

    // 2. INSTANCIA DEL DRIVER SERIALIZADOR WS2815 (32 LEDs @ 27 MHz)
    driver_ws2815 #(
        .NUM_LEDS(32)
    ) driver_led_inst (
        .clk(clk_27mhz),
        .reset(rst),
        .patron_s(patron_seg),
        .patron_m(patron_min),
        .patron_h(patron_hora),
        .rom_out(rom_out),
        .led_din(led_din)
    );

endmodule