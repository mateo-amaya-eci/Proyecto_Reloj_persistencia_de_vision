-----------------------------------------------------------------
// Contador calendario.
// Codigo escrito por  Mateo Amaya con ayuda de la IA, esquematizado por Mateo Amaya. 
//----------------------------------------------------------------
module contador_calendario #(
    parameter WIDTH = 5,
    parameter RESET_VALUE = 1
)(
    input wire clk,
    input wire reset,

    input wire load,
    input wire tick,

    input wire [WIDTH-1:0] d_inicial,
    input wire [WIDTH-1:0] valor_lim,

    output wire [WIDTH-1:0] dato,
    output wire tick_out
);

    // -----------------------------------------
    // PARTE COMBINACIONAL
    // -----------------------------------------

    reg [WIDTH-1:0] dato_reg;

    wire [WIDTH-1:0] suma;
    wire [WIDTH-1:0] mux_limite;
    wire [WIDTH-1:0] mux_tick;
    wire [WIDTH-1:0] mux_load;

    wire fin_conteo;

    assign suma = dato_reg + 1'b1;

    assign fin_conteo = (dato_reg == valor_lim);

    // Si llegó al límite, regresar al valor inicial.
    assign mux_limite = fin_conteo ? RESET_VALUE : suma;

    // Si no hay tick, conservar el valor actual.
    assign mux_tick = tick ? mux_limite : dato_reg;

    // La carga inicial tiene prioridad.
    assign mux_load = load ? d_inicial : mux_tick;

    assign dato = dato_reg;

    // Avisar al siguiente contador cuando se completa
    // el conteo y llega un nuevo tick.
    assign tick_out = tick && !load && fin_conteo;

    // -----------------------------------------
    // PARTE SECUENCIAL
    // -----------------------------------------

    always @(posedge clk or posedge reset) begin

        if (reset)
            dato_reg <= RESET_VALUE;

        else
            dato_reg <= mux_load;

    end

endmodule
