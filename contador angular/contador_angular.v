
// codigo Generado por Inteligencia Artificial basado en 
// esquematicos diseñados por Mateo Felipe Amaya

module contador_angular (
    input wire clk,
    input wire rst,
    input wire tick_1_4,

    output reg [7:0] contador_angular
);

    // Sumador: incrementa el valor actual
    wire [7:0] suma;

    assign suma = contador_angular + 1'b1;
    
    wire fin_conteo;

    assign fin_conteo = (contador_angular == 8'd255);

    
    always @(posedge clk or posedge rst) begin

        if (rst) begin
            contador_angular <= 8'd0;

        end else begin

            // MUX 2: seleccion de reinicio
            if (tick_1_4 && fin_conteo) begin

                contador_angular <= 8'd0;

            end

            else if (tick_1_4) begin

                contador_angular <= suma;

            end

            else begin

                contador_angular <= contador_angular;

            end

        end
    end

endmodule
