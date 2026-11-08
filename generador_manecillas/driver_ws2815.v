// ============================================================================
// MÓDULO: driver_ws2815.v
// Convierte el vector paralelo de 32 LEDs a protocolo serie WS2815 (800 kHz)
// diseñado para reloj de 27 MHz (Tang Nano 9K).
// ============================================================================
module driver_ws2815 #(
    parameter NUM_LEDS = 32
)(
    input  wire        clk,       // Reloj cristal de 27 MHz de la Tang Nano 9K
    input  wire        reset,     // Reset activo en alto
    input  wire [31:0] patron_s,  // Patrón activo de segundos
    input  wire [31:0] patron_m,  // Patrón activo de minutos
    input  wire [31:0] patron_h,  // Patrón activo de horas
    input  wire [31:0] rom_out,   // Patrón activo de carátula
    output reg         led_din    // Pin físico GPIO hacia la tira LED (DIN)
);

    // Tiempos del protocolo WS2815 a 27 MHz (Período de bit = 1.25 us = 34 ciclos)
    // Bit '0': T0H = 0.3 us (~8 ciclos), T0L = 0.95 us (~26 ciclos)
    // Bit '1': T1H = 0.9 us (~24 ciclos), T1L = 0.35 us (~10 ciclos)
    // Reset: > 280 us (~7600 ciclos)
    localparam CYCLES_BIT   = 34;
    localparam T0H_CYCLES   = 8;
    localparam T1H_CYCLES   = 24;
    localparam RESET_CYCLES = 8000;

    reg [13:0] timer;
    reg [5:0]  bit_index;   // 0 a 23 (24 bits por LED)
    reg [5:0]  led_index;   // 0 a 31 (32 LEDs)
    reg [23:0] current_grb; // Byte GRB del LED actual

    // Estados de la máquina de transmisión
    localparam ST_IDLE  = 2'b00;
    localparam ST_DATA  = 2'b01;
    localparam ST_RESET = 2'b10;
    reg [1:0] state;

    // Función para obtener el color GRB del LED actual según las manecillas
    always @(*) begin
        current_grb = 24'h000000; // Apagado por defecto

        // Asignación de color según qué manecilla esté encendida en la posición led_index
        if (patron_s[led_index]) begin
            current_grb = {8'h00, 8'hFF, 8'h00}; // Rojo (G=0x00, R=0xFF, B=0x00)
        end else if (patron_m[led_index]) begin
            current_grb = {8'hFF, 8'h00, 8'h00}; // Verde (G=0xFF, R=0x00, B=0x00)
        end else if (patron_h[led_index]) begin
            current_grb = {8'h00, 8'h00, 8'hFF}; // Azul (G=0x00, R=0x00, B=0x0FF)
        end else if (rom_out[led_index]) begin
            current_grb = {8'h7F, 8'h7F, 8'h7F}; // Blanco tenue para la carátula
        end
    end

    // Máquina de estados para generar el pulso serie WS2815
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= ST_RESET;
            timer     <= 0;
            bit_index <= 0;
            led_index <= 0;
            led_din   <= 0;
        end else begin
            case (state)
                ST_RESET: begin
                    led_din <= 0;
                    if (timer >= RESET_CYCLES) begin
                        timer <= 0;
                        state <= ST_DATA;
                        bit_index <= 23;
                        led_index <= 0;
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                ST_DATA: begin
                    // Generación de la forma de onda según si el bit es '1' o '0'
                    if (current_grb[bit_index]) begin
                        led_din <= (timer < T1H_CYCLES);
                    end else begin
                        led_din <= (timer < T0H_CYCLES);
                    end

                    if (timer >= CYCLES_BIT - 1) begin
                        timer <= 0;
                        if (bit_index == 0) begin
                            bit_index <= 23;
                            if (led_index == NUM_LEDS - 1) begin
                                led_index <= 0;
                                state <= ST_RESET; // Termina la trama de 32 LEDs
                            end else begin
                                led_index <= led_index + 1'b1;
                            end
                        end else begin
                            bit_index <= bit_index - 1'b1;
                        end
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                default: state <= ST_RESET;
            endcase
        end
    end

endmodule