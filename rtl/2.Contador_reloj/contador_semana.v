//----------------------------------------------------------------
// Contador de semana.
// Codigo generado por  Mateo Amaya.
//----------------------------------------------------------------
module contador_semana (
    input wire clk,
    input wire reset,
    input wire load,
    input wire tick,

    input wire [2:0] dato_inicial,
   
    output wire [2:0] semana,
    output wire tick_out
);

    contador_calendario #(
        .WIDTH(3),
        .RESET_VALUE(1)
    ) contador_semana_inst (

        .clk(clk),
        .reset(reset),

        .load(load),
        .tick(tick),

        .d_inicial(dato_inicial),
        .valor_lim(3'd7),

        .dato(semana),
        .tick_out(tick_out)

    );

endmodule