//----------------------------------------------------------------
 // Contador de mes.
 // Codigo generado por Mateo Amaya.
 //----------------------------------------------------------------
module contador_mes (
    input wire clk,
    input wire reset,
    input wire load,
    input wire tick,

    input wire [3:0] dato_inicial,

    output wire [3:0] mes,
    output wire tick_out
);

    contador_calendario #(
        .WIDTH(4),
        .RESET_VALUE(1)
    ) contador_mes_inst (

        .clk(clk),
        .reset(reset),

        .load(load),
        .tick(tick),

        .d_inicial(dato_inicial),
        .valor_lim(4'd12),

        .dato(mes),
        .tick_out(tick_out)

    );

endmodule