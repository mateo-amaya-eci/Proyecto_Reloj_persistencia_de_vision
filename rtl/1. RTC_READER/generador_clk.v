`timescale 1ns / 1ps
// Codigo generado con inteligencia artificial ChatGPT, y esquematizado con IA
// ============================================================
//  GENERADOR DE RELOJ
// Genera la señal de reloj rtc_sclk a partir de la señal tick_20us
// ============================================================
module generador_clk #(
    parameter integer CLK_FREQ_HZ = 27_000_000
)(
    input wire clk,
    input wire reset,
    input wire enable_clk,
    // sekal rtc_sclk es la señal que maneja el reloj del RTC DS1302.
    output wire rtc_sclk,
    output wire rise_pulse,//pulso de subida de la señal rtc_sclk
    output wire fall_pulse//pulso de bajada de la señal rtc_sclk
);

    wire tick_20us;

    contador_divisor #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ)
    ) divisor (
        .clk(clk),
        .reset(reset),
        .tick_20us(tick_20us)
    );

    control_fase fase (
        .clk(clk),
        .reset(reset),
        .enable(enable_clk),
        .tick_20us(tick_20us),
        .phase(rtc_sclk),
        .rise_pulse(rise_pulse),
        .fall_pulse(fall_pulse)
    );

endmodule
