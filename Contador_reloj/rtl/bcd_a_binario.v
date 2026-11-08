
module bcd_a_binario (
    input wire [7:0] seconds_bcd,
    input wire [7:0] minutes_bcd,
    input wire [7:0] hours_bcd,
    input wire [7:0] day_bcd,
    input wire [7:0] month_bcd,
    input wire [7:0] weekday_bcd,
    input wire [7:0] year_bcd,

    output wire [5:0] seconds_bin,
    output wire [5:0] minutes_bin,
    output wire [4:0] hours_bin,
    output wire [4:0] day_bin,
    output wire [3:0] month_bin,
    output wire [2:0] weekday_bin,
    output wire [6:0] year_bin
);

    // Convierte dos dígitos BCD a un número binario.
    function [6:0] convertir_bcd;
    input [7:0] bcd;
    begin
        convertir_bcd =
            (bcd[7:4] * 7'd10) + bcd[3:0];
    end
endfunction

    // Segundos: bit 7 es CH.
    assign seconds_bin =
        convertir_bcd({1'b0, seconds_bcd[6:0]});

    // Minutos: se utilizan los 7 bits inferiores.
    assign minutes_bin =
        convertir_bcd({1'b0, minutes_bcd[6:0]});

    // Día del mes: se utilizan los 6 bits inferiores.
    assign day_bin =
        convertir_bcd({2'b00, day_bcd[5:0]});

    // Mes: se utilizan los 5 bits inferiores.
    assign month_bin =
        convertir_bcd({3'b000, month_bcd[4:0]});

    // Año: los 8 bits completos están en BCD.
    assign year_bin = convertir_bcd(year_bcd);

    // El día de la semana ya es un valor binario de 1 a 7.
    assign weekday_bin = weekday_bcd[2:0];


    // Bit 6 = 0: formato de 24 horas.
    // Bit 6 = 1: formato de 12 horas.
    // Bit 5 = indicador PM en formato de 12 horas.
    // Conversión de horas en formato de 24 horas.
assign hours_bin =
    (hours_bcd[5] ? 5'd20 : 5'd0) +
    (hours_bcd[4] ? 5'd10 : 5'd0) +
    {1'b0, hours_bcd[3:0]};

endmodule
