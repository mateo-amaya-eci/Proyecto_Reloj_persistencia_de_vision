`timescale 1ns / 1ps
module contador_divisor #(
    parameter integer CLK_FREQ_HZ = 27_000_000
)(
    input wire clk,
    input wire reset,
    output reg tick_20us
);

    // 27 MHz / 50 kHz = 540 ciclos.
    // Cada 540 ciclos se genera un pulso de 20 us.
    localparam integer DIVISOR = CLK_FREQ_HZ / 50_000;

    reg [31:0] contador;

    always @(posedge clk) begin
        if (reset) begin
            contador <= 0;
            tick_20us <= 0;
        end
        else begin
            tick_20us <= 0;

            if (contador == DIVISOR - 1) begin
                contador <= 0;
                tick_20us <= 1;
            end
            else begin
                contador <= contador + 1'b1;
            end
        end
    end

endmodule

