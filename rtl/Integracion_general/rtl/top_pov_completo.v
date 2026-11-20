`timescale 1ns / 1ps
//--------------------------------------------------------------------------------
// Proyecto: Reloj con persistencia de vision
// codigo de union relizado por Mateo  Amaya  y Paula Morales, con ayuda de  herramienta de Inteligencia Artificial "ChatGPT"
//--------------------------------------------------------------------------------

module top_pov_completo #(
    parameter integer CLK_FREQ_HZ = 27_000_000,
    parameter integer START_DELAY_US = 5
)(
    input  wire clk,
    input  wire reset,       // Reset activo en alto
    input  wire sensor_eh,

    // Conexion fisica al  rtc DS1302 para la transimiccion y recepcion 
    // de datos iniciales del reloj y calendario
    
    output wire RTC_CE,// señal de habilitacion del rtc
    output wire RTC_SCLK,
    inout  wire RTC_DAT,

    // Salidas para los 10 LED RGB
    output wire [9:0] led_r,
    output wire [9:0] led_g,
    output wire [9:0] led_b,

    // Salida de los 4 LED de la caratula
    output wire [3:0] led_caratula,

    // Salidas de observacion y verificacion
    output wire       rtc_valid_out,
    output wire [7:0] angulo,
    output wire [7:0] angulo_hor,
    output wire [7:0] angulo_min,
    output wire [7:0] angulo_seg,
    output wire       match_hor,
    output wire       match_min,
    output wire       match_seg,
    output wire [4:0] led_calendario
);

    // =========================================================
    // 1. DATOS LEIDOS DEL DS1302
    // =========================================================
    //En esta etapa se transmite la señal BF ala inout data, para que empiese a enviar los datos 

    wire [7:0] rtc_seconds;
    wire [7:0] rtc_minutes;
    wire [7:0] rtc_hours;
    wire [7:0] rtc_day;
    wire [7:0] rtc_month;
    wire [7:0] rtc_weekday;
    wire [7:0] rtc_year;
    wire [7:0] debug_first_byte;

    rtc_reader #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .START_DELAY_US(START_DELAY_US)
    ) lector_rtc (
        .clk(clk),
        .reset(reset),

        .RTC_CE(RTC_CE),
        .RTC_SCLK(RTC_SCLK),
        .RTC_DAT(RTC_DAT),

        .seconds(rtc_seconds),
        .minutes(rtc_minutes),
        .hours(rtc_hours),
        .day(rtc_day),
        .month(rtc_month),
        .weekday(rtc_weekday),
        .year(rtc_year),

        .rtc_valid(rtc_valid_out),
        .debug_first_byte(debug_first_byte)
    );

    // =========================================================
    // 2. CONTADOR ANGULAR DEL SENSOR HALL
    // =========================================================

    top_angulo bloque_angular (
        .clk(clk),
        .rst(reset),
        .sensor_eh(sensor_eh),
        .angulo(angulo)
    );

    // =========================================================
    // 3. RELOJ Y CALENDARIO
    //    El reloj_top convierte los datos BCD del RTC a binario.
    // =========================================================

    wire [5:0] segundos;
    wire [5:0] minutos;
    wire [4:0] horas_visualizacion;
    wire [4:0] dia;
    wire [2:0] semana;
    wire [3:0] mes;
    wire [6:0] anio;

    reloj_top #(
        .CLK_FREQ(CLK_FREQ_HZ)
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
        .rtc_valid(rtc_valid_out),

        .segundos(segundos),
        .minutos(minutos),
        .horas_visualizacion(horas_visualizacion),

        .dia(dia),
        .semana(semana),
        .mes(mes),
        .anio(anio)
    );

    // =========================================================
    // 4. CONVERSION DE HORA A POSICIONES ANGULARES
    // =========================================================

    wire [11:0] rom_h;
    wire [13:0] rom_m;
    wire [13:0] rom_s;

    conversor_horas conversor_h (
        .salida_h(horas_visualizacion[3:0]),
        .rom_h(rom_h)
    );

    conversor_minutos conversor_m (
        .salida_m(minutos),
        .rom_m(rom_m)
    );

    conversor_segundos conversor_s (
        .salida_s(segundos),
        .rom_s(rom_s)
    );

    assign angulo_hor = rom_h[7:0];
    assign angulo_min = rom_m[7:0];
    assign angulo_seg = rom_s[7:0];

    // =========================================================
    // 5. COMPARADORES DE LAS MANECILLAS
    // =========================================================

    comparadores_top comparadores (
        .converseg(angulo_seg),
        .convermin(angulo_min),
        .converhor(angulo_hor),
        .contador_angular(angulo),

        .match_seg(match_seg),
        .match_min(match_min),
        .match_hor(match_hor)
    );

    // =========================================================
    // 6. GENERADOR DE MANECILLAS RGB
    // =========================================================

    wire [9:0] manecilla_r;
    wire [9:0] manecilla_g;
    wire [9:0] manecilla_b;

    generador_manecillas_rgb manecillas (
        .MATCH_SEG(match_seg),
        .MATCH_MIN(match_min),
        .MATCH_HORA(match_hor),

        .LED_R(manecilla_r),
        .LED_G(manecilla_g),
        .LED_B(manecilla_b)
    );

    // =========================================================
    // 7. GENERADOR DEL CALENDARIO
    // =========================================================

    generacion_calendario calendario (
        .an(angulo),
        .dia_semana(semana),
        .dia({2'b00, dia}),
        .mes({3'b000, mes}),
        .ano(anio),
        .led(led_calendario)
    );

    // =========================================================
    // 8. COMBINACION RGB + CALENDARIO
    //
    // Los 5 bits del calendario se aplican a los 5 LED RGB
    // interiores de cada canal mediante OR bit a bit.
    // Los 5 LED exteriores siguen siendo controlados solo
    // por las manecillas.
    // =========================================================

    assign led_r[4:0] = manecilla_r[4:0] | led_calendario;
    assign led_g[4:0] = manecilla_g[4:0] | led_calendario;
    assign led_b[4:0] = manecilla_b[4:0] | led_calendario;

    assign led_r[9:5] = manecilla_r[9:5];
    assign led_g[9:5] = manecilla_g[9:5];
    assign led_b[9:5] = manecilla_b[9:5];

    // =========================================================
    // 9. CARATULA ROM DE 4 LED
    // =========================================================

    rom_caratula_256x4 caratula (
        .dir_angulo(angulo),
        .caratula_out(led_caratula)
    );

endmodule
