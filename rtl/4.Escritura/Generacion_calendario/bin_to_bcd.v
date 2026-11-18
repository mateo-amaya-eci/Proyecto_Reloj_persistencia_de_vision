
module etapa_double_dabble (

    input wire [7:0] BCD_in,
    input wire bit_in,

    output wire [7:0] BCD_out

);

    wire [3:0] unidades_corregidas;
    wire [3:0] decenas_corregidas;

    // Corrector de unidades
    mayor4_suma3 u_unidades (

        .a0(BCD_in[0]),
        .a1(BCD_in[1]),
        .a2(BCD_in[2]),
        .a3(BCD_in[3]),

        .c0(unidades_corregidas[0]),
        .c1(unidades_corregidas[1]),
        .c2(unidades_corregidas[2]),
        .c3(unidades_corregidas[3])

    );

    // Corrector de decenas
    mayor4_suma3 u_decenas (

        .a0(BCD_in[4]),
        .a1(BCD_in[5]),
        .a2(BCD_in[6]),
        .a3(BCD_in[7]),

        .c0(decenas_corregidas[0]),
        .c1(decenas_corregidas[1]),
        .c2(decenas_corregidas[2]),
        .c3(decenas_corregidas[3])

    );


    assign BCD_out = {
        decenas_corregidas[2:0],
        unidades_corregidas[3:0],
        bit_in
    };

endmodule

module mayor4_suma3 (

    input wire a0,
    input wire a1,
    input wire a2,
    input wire a3,

    output wire c0,
    output wire c1,
    output wire c2,
    output wire c3

);


    assign c3 = a3 | (a2 & (a1 | a0));

    assign c2 = (a3 & a0) |
                (a2 & ~(a1 | a0));

    
    assign c1 = (a3 & ~a0) |
                (a1 & a0) |
                (a1 & ~a2);


    assign c0 = a0 ^ c3;

endmodule

module bin_a_bcd (

    input wire [6:0] Bin,
    output wire [7:0] bcd

);

    wire [7:0] etapa0;
    wire [7:0] etapa1;
    wire [7:0] etapa2;
    wire [7:0] etapa3;
    wire [7:0] etapa4;
    wire [7:0] etapa5;
    wire [7:0] etapa6;
    wire [7:0] etapa7;


    assign etapa0 = 8'b00000000;

    etapa_double_dabble e1 (
        .BCD_in(etapa0),
        .bit_in(Bin[6]),
        .BCD_out(etapa1)
    );

    // Etapa 2: procesa Bin[5]
    etapa_double_dabble e2 (
        .BCD_in(etapa1),
        .bit_in(Bin[5]),
        .BCD_out(etapa2)
    );

    // Etapa 3: procesa Bin[4]
    etapa_double_dabble e3 (
        .BCD_in(etapa2),
        .bit_in(Bin[4]),
        .BCD_out(etapa3)
    );

    // Etapa 4: procesa Bin[3]
    etapa_double_dabble e4 (
        .BCD_in(etapa3),
        .bit_in(Bin[3]),
        .BCD_out(etapa4)
    );

    // Etapa 5: procesa Bin[2]
    etapa_double_dabble e5 (
        .BCD_in(etapa4),
        .bit_in(Bin[2]),
        .BCD_out(etapa5)
    );

    // Etapa 6: procesa Bin[1]
    etapa_double_dabble e6 (
        .BCD_in(etapa5),
        .bit_in(Bin[1]),
        .BCD_out(etapa6)
    );

    // Etapa 7: procesa Bin[0]
    etapa_double_dabble e7 (
        .BCD_in(etapa6),
        .bit_in(Bin[0]),
        .BCD_out(etapa7)
    );

    // Salida valida para el rango 0 a 99
    assign bcd = (Bin <= 7'd99) ?
                 etapa7 : 8'b00000000;

endmodule
