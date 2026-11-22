`timescale 1ns / 1ps
//--------------------------------------------------------------------------------
// Proyecto: Reloj con persistencia de vision
// Integracion realizada por Mateo Amaya y Paula Morales.con ayuda de herramientas de IA
//--------------------------------------------------------------------------------

module top_pov_completo #(
    parameter integer CLK_FREQ_HZ = 27_000_000,
    parameter integer START_DELAY_US = 5
)(
    // Entradas fisicas
    input  wire clk,
    input  wire reset,       // Reset activo en alto
    input  wire sensor_eh,

    // Interfaz fisica del RTC DS1302
    output wire RTC_CE,
    output wire RTC_SCLK,
    inout  wire RTC_DAT,

    // Salidas para los 10 LED RGB
    output wire [9:0] led_r,
    output wire [9:0] led_g,
    output wire [9:0] led_b,

    // Salidas para los 4 LED independientes de la caratula
    output wire [3:0] led_caratula
);

    // =========================================================
    // 1. DATOS DEL RTC DS1302 (SENALES INTERNAS)
    // =========================================================

    wire [7:0] rtc_seconds;
    wire [7:0] rtc_minutes;
    wire [7:0] rtc_hours;
    wire [7:0] rtc_day;
    wire [7:0] rtc_month;
    wire [7:0] rtc_weekday;
    wire [7:0] rtc_year;
    wire [7:0] debug_first_byte;
    wire rtc_valid;
    // se genera una comunicaion serial con el rtc ds1302 para tener los valores iniciales 
    // de segundos, minutos, horas, dia, dia semana, mes , año
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
        .rtc_valid(rtc_valid),
        .debug_first_byte(debug_first_byte)
    );

    // =========================================================
    // 2. CONTADOR ANGULAR DEL SENSOR HALL
    // =========================================================
    // por cada 2 activos del sensor hall se toma el numero de clk del periodo, se divide entre 255
    // y se suman los pulsos de clk para conocer el numero del angulo del sistema POV

    wire [7:0] angulo;

    top_angulo bloque_angular (
        .clk(clk),
        .rst(reset),
        .sensor_eh(sensor_eh),
        .angulo(angulo)
    );

    // =========================================================
    // 3. RELOJ Y CALENDARIO
    // =========================================================
    // al tomar los valores iniciales del ds1302 , empiesa un conteo de
    // segundo , minuto , hora , mes ,año, dia , dia_semana

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
        .rtc_valid(rtc_valid),
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
    // se toma el valor del reloj y genera la sigiente funcion para minutos y segundos (min|seg*256+30)/60
    // para hora (hora*256+6)/12

    wire [11:0] rom_h;
    wire [13:0] rom_m;
    wire [13:0] rom_s;
    wire [7:0] angulo_hor;
    wire [7:0] angulo_min;
    wire [7:0] angulo_seg;

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
    // se compara el angulo ancutual con el angulo hora , minuto y segundo, y cuando son iguales genera en alto el match correspondiente

    wire match_hor;
    wire match_min;
    wire match_seg;

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
    // cuando el match es 1 toma en alto la manecilla correpondiente con el color correpondiente
    // con segundos en rojo, minutos en verde y horas en azul

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
    // se toman los valores del calendario del reloj top, y se toma como un sistema polar, donde cada 
    // numero y letra entran en una matriz de 5*6 que de forma combinacional, dependiendo del angulo genera 
    // el numero correspondiente segun la matriz

    wire [4:0] led_calendario;

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
    // =========================================================
    // se mescla en led rojo o azul o verde la combinacion con la del calendario , para generar la tira de los 10 leds rgb
    

    assign led_r[4:0] = manecilla_r[4:0] | led_calendario;
    assign led_g[4:0] = manecilla_g[4:0] | led_calendario;
    assign led_b[4:0] = manecilla_b[4:0] | led_calendario;

    assign led_r[9:5] = manecilla_r[9:5];
    assign led_g[9:5] = manecilla_g[9:5];
    assign led_b[9:5] = manecilla_b[9:5];

    // =========================================================
    // 9. CARATULA ROM DE 4 LED
    // =========================================================
    // se genera el alrededor del reloj top . 

    rom_caratula_256x4 caratula (
        .dir_angulo(angulo),
        .caratula_out(led_caratula)
    );

endmodule
