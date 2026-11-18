//----------------------------------------------------------------
// Contador de dia.
// Codigo generado por  IA basado en los esquematicos diseñados por Mateo Amaya.
//----------------------------------------------------------------

module contador_dia (
    input wire clk,
    input wire reset,
    input wire load,
    input wire tick,

    input wire [4:0] dato_inicial,
    input wire [3:0] mes,
    input wire [6:0] anio,

    output wire [4:0] dia,
    output wire tick_out
);

    // -----------------------------------------
    // PARTE COMBINACIONAL
    // -----------------------------------------

    wire es_bisiesto;

    reg [5:0] dias_del_mes;

    // Deteccion de año bisiesto
    // Para el intervalo 2000-2099.

    assign es_bisiesto = (anio[1:0] == 2'b00);


    // Decodificador del mes

    always @(*) begin

        case (mes)

            4'd1, 4'd3, 4'd5, 4'd7,
            4'd8, 4'd10, 4'd12:
                dias_del_mes = 6'd31;

            4'd4, 4'd6, 4'd9, 4'd11:
                dias_del_mes = 6'd30;

            4'd2: begin

                if (es_bisiesto)
                    dias_del_mes = 6'd29;
                else
                    dias_del_mes = 6'd28;

            end

            default:
                dias_del_mes = 6'd31;

        endcase

    end


    // -----------------------------------------
    // CONTADOR GENERICO
    // -----------------------------------------

    contador_calendario #(
        .WIDTH(5),
        .RESET_VALUE(1)
    ) contador_dia_inst (

        .clk(clk),
        .reset(reset),

        .load(load),
        .tick(tick),

        .d_inicial(dato_inicial),
        .valor_lim(dias_del_mes[4:0]),

        .dato(dia),
        .tick_out(tick_out)

    );

endmodule