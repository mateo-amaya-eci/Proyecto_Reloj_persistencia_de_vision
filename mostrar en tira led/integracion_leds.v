
module integracion_leds (
    input wire [7:0] angulo_actual,
    input wire [7:0] angulo_seg,
    input wire [7:0] angulo_min,
    input wire [7:0] angulo_hora,

    output wire [9:0] led_r,
    output wire [9:0] led_g,
    output wire [9:0] led_b,
    output wire [3:0] led_caratula
);

    wire match_seg;
    wire match_min;
    wire match_hor;

    // Comparar posiciones de las manecillas
    comparadores_top comparadores (
        .converseg(angulo_seg),
        .convermin(angulo_min),
        .converhor(angulo_hora),
        .contador_angular(angulo_actual),

        .match_seg(match_seg),
        .match_min(match_min),
        .match_hor(match_hor)
    );

    // Generar las manecillas RGB
    generador_manecillas_rgb manecillas (
        .MATCH_SEG(match_seg),
        .MATCH_MIN(match_min),
        .MATCH_HORA(match_hor),

        .LED_R(led_r),
        .LED_G(led_g),
        .LED_B(led_b)
    );

    // Generar la caratula con 4 LED normales
    rom_caratula_256x4 caratula (
        .dir_angulo(angulo_actual),
        .caratula_out(led_caratula)
    );

endmodule
