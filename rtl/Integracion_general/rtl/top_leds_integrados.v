
module top_leds_integrados #(
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

    // Salidas de los 10 LED RGB
    output wire [9:0] led_r,
    output wire [9:0] led_g,
    output wire [9:0] led_b,

    // Salidas de los 4 LED normales
    output wire [3:0] led_caratula,

    // Señales de prueba
    output wire [7:0] angulo,
    output wire match_hor,
    output wire match_min,
    output wire match_seg
);

    wire [7:0] angulo_hor;
    wire [7:0] angulo_min;
    wire [7:0] angulo_seg;

    // BLOQUE 1: INTEGRACION DEL RELOJ
    top_reloj_integrado #(
        .CLK_FREQ(CLK_FREQ)
    ) reloj (
        .clk(clk),
        .reset(reset),
        .sensor_eh(sensor_eh),

        .rtc_seconds(rtc_seconds),
        .rtc_minutes(rtc_minutes),
        .rtc_hours(rtc_hours),
        .rtc_day(rtc_day),
        .rtc_month(rtc_month),
        .rtc_weekday(rtc_weekday),
        .rtc_year(rtc_year),
        .rtc_valid(rtc_valid),

        .angulo(angulo),
        .angulo_hor(angulo_hor),
        .angulo_min(angulo_min),
        .angulo_seg(angulo_seg),

        .match_hor(match_hor),
        .match_min(match_min),
        .match_seg(match_seg)
    );

    // BLOQUE 2: MANECILLAS RGB
    generador_manecillas_rgb manecillas (
        .MATCH_SEG(match_seg),
        .MATCH_MIN(match_min),
        .MATCH_HORA(match_hor),

        .LED_R(led_r),
        .LED_G(led_g),
        .LED_B(led_b)
    );

    // BLOQUE 3: CARATULA
    rom_caratula_256x4 caratula (
        .dir_angulo(angulo),
        .caratula_out(led_caratula)
    );

endmodule

