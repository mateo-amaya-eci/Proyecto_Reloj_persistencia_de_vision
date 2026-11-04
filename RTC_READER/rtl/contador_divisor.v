module contador_divisor #(
    parameter integer CLK_FREQ_HZ = 100_000_000
)(
    input wire clk,
    input wire reset,
    output reg tick_5us
);

    localparam integer DIVISOR = CLK_FREQ_HZ / 200_000;

    reg [31:0] contador;

    always @(posedge clk) begin
        if (reset) begin
            contador <= 0;
            tick_5us <= 0;
        end
        else begin
            tick_5us <= 0;

            if (contador == DIVISOR - 1) begin
                contador <= 0;
                tick_5us <= 1;
            end
            else begin
                contador <= contador + 1'b1;
            end
        end
    end

endmodule