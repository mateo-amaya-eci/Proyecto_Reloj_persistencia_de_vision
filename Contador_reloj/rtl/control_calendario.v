//----------------------------------------------------------------
 // Controlador del calendario.
 // Codigo generado por  Mateo Amaya con ayudas de la IA, esquematizado por Mateo Amaya.
 //----------------------------------------------------------------

module control_calendario (
    input wire clk,
    input wire reset,

    input wire load_inicial,
    input wire tick_dia,

    input wire [4:0] dato_dia,
    input wire [2:0] dato_semana,
    input wire [3:0] dato_mes,
    input wire [6:0] dato_anio,

    output wire [4:0] dia,
    output wire [2:0] semana,
    output wire [3:0] mes,
    output wire [6:0] anio
);



    wire tick_mes;
    wire tick_anio;


    // -----------------------------------------
    // CONTADOR DEL DIA
    // -----------------------------------------

    contador_dia U_DIA (

        .clk(clk),
        .reset(reset),

        .load(load_inicial),
        .tick(tick_dia),

        .dato_inicial(dato_dia),
        .mes(mes),
        .anio(anio),

        .dia(dia),
        .tick_out(tick_mes)

    );


    // -----------------------------------------
    // CONTADOR DE SEMANA
    // -----------------------------------------

    contador_semana U_SEMANA (

        .clk(clk),
        .reset(reset),

        .load(load_inicial),
        .tick(tick_dia),

        .dato_inicial(dato_semana),

        .semana(semana),
        .tick_out()

    );


    // -----------------------------------------
    // CONTADOR DEL MES
    // -----------------------------------------

    contador_mes U_MES (

        .clk(clk),
        .reset(reset),

        .load(load_inicial),
        .tick(tick_mes),

        .dato_inicial(dato_mes),

        .mes(mes),
        .tick_out(tick_anio)

    );


    // -----------------------------------------
    // CONTADOR DEL AÑO
    // -----------------------------------------

    contador_anio U_ANIO (

        .clk(clk),
        .reset(reset),

        .load(load_inicial),
        .tick(tick_anio),

        .dato_inicial(dato_anio),

        .anio(anio),
        .tick_out()

    );

endmodule
