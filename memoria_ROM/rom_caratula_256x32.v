// ============================================================================
// MÓDULO: rom_caratula_256x32.v
// Memoria ROM de 256 posiciones de 32 bits para la silueta del reloj POV.
// Resolución angular: 360° / 256 = 1.40625° por dirección.
// ============================================================================

module rom_caratula_256x32 (
    input  wire [7:0]  dir_angulo,  // Dirección de ángulo (0 a 255)
    output reg  [31:0] caratula_out // Patrón de 32 bits hacia los LEDs
);

    // Definición de máscaras radiales (posiciones de LEDs)
    localparam [31:0] LED_CENTRO       = 32'h0000_0003; // LEDs 0 y 1 (Punto central)
    localparam [31:0] ANILLO_EXTERIOR  = 32'h8000_0000; // LED 31 (Circunferencia externa)
    localparam [31:0] TICK_CORTO       = 32'hF000_0000; // LEDs 28 a 31 (Marcas de minutos)
    localparam [31:0] TICK_LARGO_HORA  = 32'hFFC0_0000; // LEDs 22 a 31 (Marcas gruesas de las 12 horas)

    always @(*) begin
        case (dir_angulo)
            // -----------------------------------------------------------------
            // MARCAS PRINCIPALES (12 HORAS) - 2 o 3 posiciones angulares de grosor
            // -----------------------------------------------------------------
            8'd0, 8'd1, 8'd255:      caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 12:00
            8'd21, 8'd22:           caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 1:00
            8'd42, 8'd43:           caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 2:00
            8'd63, 8'd64, 8'd65:    caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 3:00
            8'd85, 8'd86:           caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 4:00
            8'd106, 8'd107:         caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 5:00
            8'd127, 8'd128, 8'd129: caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 6:00
            8'd149, 8'd150:         caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 7:00
            8'd170, 8'd171:         caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 8:00
            8'd191, 8'd192, 8'd193: caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 9:00
            8'd213, 8'd214:         caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 10:00
            8'd234, 8'd235:         caratula_out = LED_CENTRO | TICK_LARGO_HORA; // 11:00

            // -----------------------------------------------------------------
            // MARCAS SECUNDARIAS (MINUTOS - Ticks Cortos)
            // -----------------------------------------------------------------
            8'd4, 8'd8, 8'd13, 8'd17, 8'd26, 8'd30, 8'd34, 8'd38,
            8'd47, 8'd51, 8'd55, 8'd60, 8'd68, 8'd73, 8'd77, 8'd81,
            8'd90, 8'd94, 8'd98, 8'd102, 8'd111, 8'd115, 8'd119, 8'd124,
            8'd132, 8'd137, 8'd141, 8'd145, 8'd154, 8'd158, 8'd162, 8'd166,
            8'd175, 8'd179, 8'd183, 8'd188, 8'd196, 8'd201, 8'd205, 8'd209,
            8'd218, 8'd222, 8'd226, 8'd230, 8'd239, 8'd243, 8'd247, 8'd251: begin
                caratula_out = LED_CENTRO | TICK_CORTO;
            end

            // -----------------------------------------------------------------
            // FONDO GENERAL (Punto central + Anillo exterior continuo)
            // -----------------------------------------------------------------
            default: begin
                caratula_out = LED_CENTRO | ANILLO_EXTERIOR;
            end
        endcase
    end

endmodule