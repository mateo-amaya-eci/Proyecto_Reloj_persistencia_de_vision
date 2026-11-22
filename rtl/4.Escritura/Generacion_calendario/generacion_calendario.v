// Codigo generado por Mateo Amaya esquematicos diseñados por Mateo  Amaya

module generacion_calendario (

    // CONTADOR ANGULAR
    input wire [7:0] an,

    // DATOS DEL CALENDARIO
    input wire [2:0] dia_semana,
    input wire [6:0] dia,
    input wire [6:0] mes,
    input wire [6:0] ano,

    // SALIDA FINAL
    output wire [4:0] led

);

    // =====================================
    // 1. DETECTOR DE REGIONES
    // =====================================

    wire sel_semana;
    wire sel_dia;
    wire sel_mes;
    wire sel_ano;

    detector_regiones REGIONES (
        .an(an),
        .sel_semana(sel_semana),
        .sel_dia(sel_dia),
        .sel_mes(sel_mes),
        .sel_ano(sel_ano)
    );


    // =====================================
    // 2. SELECTOR DE COLUMNAS
    // =====================================

    wire [5:0] col;

    selector_columnas COLUMNAS (
        .an(an),
        .co(col)
    );


    // =====================================
    // 3. CONVERSORES BINARIO A BCD
    // =====================================

    wire [7:0] bcd_dia;
    wire [7:0] bcd_mes;
    wire [7:0] bcd_ano;

    bin_a_bcd conv_dia (
    .Bin(dia),
    .bcd(bcd_dia)
    );

    bin_a_bcd conv_mes (
        .Bin(mes),
        .bcd(bcd_mes)
    );

    bin_a_bcd conv_ano (
        .Bin(ano),
        .bcd(bcd_ano)
    );





    // =====================================
    // 5. SALIDAS DE LOS DECODIFICADORES
    // =====================================

    wire [4:0] led_semana;
    wire [4:0] led_dia;
    wire [4:0] led_mes;
    wire [4:0] led_ano;



    // =====================================
    // 6. DECODIFICADOR SEMANAL
    // =====================================

        decodificador_semana semana (
        .dia(dia_semana),
        .col(col),
        .led(led_semana)
    );


    // =====================================
    // 7. DECODIFICADOR DEL dia
    // =====================================

    decodificador_numero_2digitos decod_dia (
        .bcd_dec(bcd_dia[7:4]),
        .bcd_uni(bcd_dia[3:0]),
        .col(col),
        .led(led_dia)
    );



    // =====================================
    // 8. DECODIFICADOR DEL mes
    // =====================================

    decodificador_numero_2digitos decod_mes (
        .bcd_dec(bcd_mes[7:4]),
        .bcd_uni(bcd_mes[3:0]),
        .col(col),
        .led(led_mes)
    );
    

    // =====================================
    // 9. DECODIFICADOR DEL ano
    // =====================================

    decodificador_numero_2digitos decod_ano (
        .bcd_dec(bcd_ano[7:4]),
        .bcd_uni(bcd_ano[3:0]),
        .col(col),
        .led(led_ano)
    );  




    // =====================================
    // 10. MULTIPLEXOR ONE-HOT
    // =====================================

    mux_onehot_regiones mux_regiones (

        .led_semana(led_semana),
        .led_dia(led_dia),
        .led_mes(led_mes),
        .led_ano(led_ano),

        .sel_semana(sel_semana),
        .sel_dia(sel_dia),
        .sel_mes(sel_mes),
        .sel_ano(sel_ano),

        .led(led)

    );

endmodule



