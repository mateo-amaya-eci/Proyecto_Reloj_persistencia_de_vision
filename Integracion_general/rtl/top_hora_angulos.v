
module top_hora_angulos #(
    parameter CLK_FREQ = 27000000
)(
    input wire clk,
    input wire reset,

    // Datos del RTC en formato BCD
    input wire [7:0] rtc_seconds,
    input wire [7:0] rtc_minutes,
    input wire [7:0] rtc_hours,
    input wire [7:0] rtc_day,
    input wire [7:0] rtc_month,
    input wire [7:0] rtc_weekday,
    input wire [7:0] rtc_year,
    input wire rtc_valid,

    // Posiciones angulares
    output wire [11:0] rom_h,
    output wire [13:0] rom_m,
    output wire [13:0] rom_s
);

    // Señales que conectan los módulos
    wire [4:0] horas_visualizacion;
    wire [5:0] minutos;
    wire [5:0] segundos;

    // MODULO 1: RELOJ
    reloj_top #(
        .CLK_FREQ(CLK_FREQ)
    ) reloj (
        .clk(clk),
        .reset(reset),

        .rtc_seconds(rtc_seconds),
        .rtc_minutes(rtc_minutes),
        .rtc_hours(rtc_hours),
        .rtc_day(rtc_day),
        .rtc_month(rtc_month),
        .rtc_weekday(rtc_weekday),
        .rtc_year(rtc_year),
        .rtc_valid(rtc_valid),

        .segundos(segundos),
        .minutos(minutos),
        .horas_visualizacion(horas_visualizacion),

        .dia(),
        .semana(),
        .mes(),
        .anio()
    );

    // MODULO 2: CONVERSOR DE HORAS
    conversor_horas conv_h (
        .salida_h(horas_visualizacion[3:0]),
        .rom_h(rom_h)
    );

    // MODULO 3: CONVERSOR DE MINUTOS
    conversor_minutos conv_m (
        .salida_m(minutos),
        .rom_m(rom_m)
    );

    // MODULO 4: CONVERSOR DE SEGUNDOS
    conversor_segundos conv_s (
        .salida_s(segundos),
        .rom_s(rom_s)
    );

endmodule
