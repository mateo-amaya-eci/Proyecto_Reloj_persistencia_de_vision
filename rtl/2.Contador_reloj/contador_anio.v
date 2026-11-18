//----------------------------------------------------------------
// Contador de anio.
// Codigo generado por  Mateo Amaya. 
//----------------------------------------------------------------
module contador_anio (
    input wire clk,
    input wire reset,
    input wire load,
    input wire tick,

    input wire [6:0] dato_inicial,

    output wire [6:0] anio,
    output wire tick_out
);

    contador_calendario #(
        .WIDTH(7),
        .RESET_VALUE(0)
    ) contador_anio_inst (

        .clk(clk),
        .reset(reset),

        .load(load),
        .tick(tick),

        .d_inicial(dato_inicial),
        .valor_lim(7'd99),

        .dato(anio),
        .tick_out(tick_out)

    );

endmodule