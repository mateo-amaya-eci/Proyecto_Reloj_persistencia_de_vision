
module control_calendario (
    input wire clk,
    input wire reset,

    input wire load_inicial,
    input wire tick_dia,

    input wire [4:0] dato_dia,
    input wire [2:0] dato_semana,
    input wire [3:0] dato_mes,
    input wire [6:0] dato_anio,

    output reg [4:0] dia,
    output reg [2:0] semana,
    output reg [3:0] mes,
    output reg [6:0] anio
);

    // Para el intervalo 2000-2099,
    // un año es bisiesto si es divisible entre 4.
    wire es_bisiesto;
    assign es_bisiesto = (anio[1:0] == 2'b00);

    // Cantidad de días del mes actual.
    reg [5:0] dias_del_mes;

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

    // Actualización de la fecha.
    always @(posedge clk or posedge reset) begin

        if (reset) begin
            dia     <= 5'd1;
            semana  <= 3'd1;
            mes     <= 4'd1;
            anio    <= 7'd0;
        end

        else if (load_inicial) begin
            dia     <= dato_dia;
            semana  <= dato_semana;
            mes     <= dato_mes;
            anio    <= dato_anio;
        end

        else if (tick_dia) begin

            // Actualización del día de la semana.
            if (semana == 3'd7)
                semana <= 3'd1;
            else
                semana <= semana + 1'b1;

            // Actualización del día del mes.
            if (dia < dias_del_mes) begin
                dia <= dia + 1'b1;
            end

            else begin
                dia <= 5'd1;

                // Cambio de mes.
                if (mes < 4'd12) begin
                    mes <= mes + 1'b1;
                end

                else begin
                    mes <= 4'd1;

                    // Cambio de año.
                    if (anio < 7'd99)
                        anio <= anio + 1'b1;
                    else
                        anio <= 7'd0;
                end
            end
        end
    end

endmodule
