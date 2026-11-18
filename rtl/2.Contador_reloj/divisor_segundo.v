// ----------------------------------------------------------------
// Divisor de frecuencia para generar un pulso cada segundo.
// Codigo generado por  IA basado en los esquematicos diseñados por Paula Morales.
//----------------------------------------------------------------
module divisor_segundo #(
    parameter CLK_FREQ = 27000000
)(
    input wire clk,
    input wire reset,
    output reg tick_1s
);

    localparam MAX_COUNT = CLK_FREQ - 1;

    reg [31:0] contador;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            contador <= 0;
            tick_1s <= 0;
        end
        else begin
            if (contador == MAX_COUNT) begin
                contador <= 0;
                tick_1s <= 1;
            end
            else begin
                contador <= contador + 1'b1;
                tick_1s <= 0;
            end
        end
    end

endmodule