
module mux_onehot_regiones (

    // salidas de los decodificadores

    input wire [4:0] led_semana,
    input wire [4:0] led_dia,
    input wire [4:0] led_mes,
    input wire [4:0] led_ano,

    // selectores one-hot

    input wire sel_semana,
    input wire sel_dia,
    input wire sel_mes,
    input wire sel_ano,

    // salida final

    output wire [4:0] led

);

    assign led =
          (led_semana & {5{sel_semana}})
        | (led_dia    & {5{sel_dia}})
        | (led_mes    & {5{sel_mes}})
        | (led_ano    & {5{sel_ano}});

endmodule
