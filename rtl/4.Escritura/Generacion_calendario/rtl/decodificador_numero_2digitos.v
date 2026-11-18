
module decodificador_numero_2digitos (

    input wire [3:0] bcd_dec,
    input wire [3:0] bcd_uni,

    input wire [5:0] col,



    output wire [4:0] led

);

    wire [4:0] led_dec;
    wire [4:0] led_uni;

    // decodificador de decenas

    decodificador_bcd_3col decenas (

        .bcd(bcd_dec),
        .col(col[2:0]),
        .led(led_dec)

    );

    // decodificador de unidades

    decodificador_bcd_3col unidades (

        .bcd(bcd_uni),
        .col(col[5:3]),
        .led(led_uni)

    );

    // habilitacion de la region

    assign led = led_dec | led_uni;

endmodule
