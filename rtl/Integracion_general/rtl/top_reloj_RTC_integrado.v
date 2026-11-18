
module top_reloj_RTC_integrado #(
    parameter CLK_FREQ = 27_000_000,
    parameter START_DELAY_US = 5
)(
    input wire clk,
    input wire reset,
    input wire sensor_eh,

    // Conexion fisica DS1302
    output wire RTC_CE,
    output wire RTC_SCLK,
    inout wire RTC_DAT,

    // Datos para observacion y verificacion
    output wire rtc_valid_out,
    output wire [7:0] rtc_seconds_out,
    output wire [7:0] rtc_minutes_out,
    output wire [7:0] rtc_hours_out,

    // Salidas de la integracion anterior
    output wire [7:0] angulo,
    output wire [7:0] angulo_hor,
    output wire [7:0] angulo_min,
    output wire [7:0] angulo_seg,

    output wire match_hor,
    output wire match_min,
    output wire match_seg
);

    wire [7:0] rtc_day;
    wire [7:0] rtc_month;
    wire [7:0] rtc_weekday;
    wire [7:0] rtc_year;

    wire [7:0] debug_first_byte;

    // =========================================
    // 1. LECTOR DEL RTC
    // =========================================

    rtc_reader #(
        .CLK_FREQ_HZ(CLK_FREQ),
        .START_DELAY_US(START_DELAY_US)
    ) lector_rtc (
        .clk(clk),
        .reset(reset),

        .RTC_CE(RTC_CE),
        .RTC_SCLK(RTC_SCLK),
        .RTC_DAT(RTC_DAT),

        .seconds(rtc_seconds_out),
        .minutes(rtc_minutes_out),
        .hours(rtc_hours_out),
        .day(rtc_day),
        .month(rtc_month),
        .weekday(rtc_weekday),
        .year(rtc_year),

        .rtc_valid(rtc_valid_out),
        .debug_first_byte(debug_first_byte)
    );

    // =========================================
    // 2. INTEGRACION ANTERIOR:
    // RELOJ + SENSOR HALL + COMPARADORES
    // =========================================

    top_reloj_integrado #(
        .CLK_FREQ(CLK_FREQ)
    ) sistema_reloj (
        .clk(clk),
        .reset(reset),
        .sensor_eh(sensor_eh),

        .rtc_seconds(rtc_seconds_out),
        .rtc_minutes(rtc_minutes_out),
        .rtc_hours(rtc_hours_out),
        .rtc_day(rtc_day),
        .rtc_month(rtc_month),
        .rtc_weekday(rtc_weekday),
        .rtc_year(rtc_year),
        .rtc_valid(rtc_valid_out),

        .angulo(angulo),
        .angulo_hor(angulo_hor),
        .angulo_min(angulo_min),
        .angulo_seg(angulo_seg),

        .match_hor(match_hor),
        .match_min(match_min),
        .match_seg(match_seg)
    );

endmodule
