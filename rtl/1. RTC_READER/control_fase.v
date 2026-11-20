`timescale 1ns / 1ps
// codigo generado con inteligencia artificial ChatGPT, y esquematizado con IA
// ============================================================
// CONTROL DE FASE
// Genera la señal de reloj rtc_sclk a partir de la señal tick_20us
// ============================================================

module control_fase (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire tick_20us,

    output reg phase,
    output reg rise_pulse,
    output reg fall_pulse
);
// La señal phase es la señal de reloj rtc_sclk que se genera a partir de la señal tick_20us.
//........_______........________
//........|......|......|........
//........|......|......|........
//________........_______........
//......20us....40us.............

    always @(posedge clk) begin
        if (reset) begin
            phase <= 0;
            rise_pulse <= 0;
            fall_pulse <= 0;
        end
        else begin
            rise_pulse <= 0;
            fall_pulse <= 0;

            if (!enable) begin
                phase <= 0;
            end
            else if (tick_20us) begin

                if (phase == 0) begin
                    phase <= 1;
                    rise_pulse <= 1;
                end
                else begin
                    phase <= 0;
                    fall_pulse <= 1;
                end

            end
        end
    end

endmodule
