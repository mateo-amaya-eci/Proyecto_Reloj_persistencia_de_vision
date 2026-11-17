
module top_reloj_integrado #(
    parameter CLK_FREQ = 27000000
)(
    input wire clk,
    input wire reset,
    input wire sensor_eh,

    // Datos del RTC
    input wire [7:0] rtc_seconds,
    input wire [7:0] rtc_minutes,
    input wire [7:0] rtc_hours,
    input wire [7:0] rtc_day,
    input wire [7:0] rtc_month,
    input wire [7:0] rtc_weekday,
    input wire [7:0] rtc_year,
    input wire rtc_valid,

    // Salidas para comprobar la integracion
    output wire [7:0] angulo,
    output wire [7:0] angulo_hor,
    output wire [7:0] angulo_min,
    output wire [7:0] angulo_seg,

    output wire match_hor,
    output wire match_min,
    output wire match_seg
);

    // Salidas originales de los conversores
    wire [11:0] rom_h;
    wire [13:0] rom_m;
    wire [13:0] rom_s;

    // BLOQUE 1: POSICION DEL MOTOR
    top_angulo bloque_angular (
        .clk(clk),
        .rst(reset),
        .sensor_eh(sensor_eh),
        .angulo(angulo)
    );

    // BLOQUE 2: HORA Y CONVERSION ANGULAR
    top_hora_angulos #(
        .CLK_FREQ(CLK_FREQ)
    ) bloque_reloj (
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

        .rom_h(rom_h),
        .rom_m(rom_m),
        .rom_s(rom_s)
    );

    // ADAPTACION A 8 BITS
    assign angulo_hor = rom_h[7:0];
    assign angulo_min = rom_m[7:0];
    assign angulo_seg = rom_s[7:0];

    // BLOQUE 3: COMPARADORES
    comparadores_top comparadores (
        .converhor(angulo_hor),
        .convermin(angulo_min),
        .converseg(angulo_seg),

        .contador_angular(angulo),

        .match_hor(match_hor),
        .match_min(match_min),
        .match_seg(match_seg)
    );

endmodule

