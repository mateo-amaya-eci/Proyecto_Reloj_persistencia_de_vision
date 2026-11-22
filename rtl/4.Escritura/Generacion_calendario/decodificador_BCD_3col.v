// Codigo generado por Mateo Amaya esquematicos diseñados por Mateo  Amaya
module decodificador_bcd_3col (

    input wire [3:0] bcd,
    input wire [2:0] col,

    output wire [4:0] led

);

    wire b3, b2, b1, b0;

    wire [4:0] fa;
    wire [4:0] fb;
    wire [4:0] fc;

    wire valid_bcd;

    assign b3 = bcd[3];
    assign b2 = bcd[2];
    assign b1 = bcd[1];
    assign b0 = bcd[0];

    assign valid_bcd = (bcd <= 4'd9);

    // columna a

    assign fa[4] = b1 | b2 | b3 | ~b0;

    assign fa[3] = ~b1 | (b2 & ~b0);

    assign fa[2] = b3 | ~b0 |
                   (b1 & ~b2) |
                   (b2 & ~b1);

    assign fa[1] = (b1 & ~b0) |
                   (~b0 & ~b2);

    assign fa[0] = ~b2 |
                   (b0 & ~b1) |
                   (b1 & ~b0);

    // columna b

    assign fb[4] = b0 | b1 | ~b2;

    assign fb[3] = ~b3 & ~b2 & ~b1 & b0;

    assign fb[2] = b0 | b1 | b2 | b3;

    assign fb[1] = (b0 & b1 & b2) |
                   (b0 & ~b1 & ~b2 & ~b3);

    assign fb[0] = b0 | b1 | ~b2;

    // columna c

    assign fc[4] = b1 | b2 | b3 | ~b0;

    assign fc[3] = b3 |
                   (b0 & b1) |
                   (~b0 & ~b1) |
                   (~b0 & ~b2);

    assign fc[2] = b3 | ~b0 |
                   (b1 & ~b2) |
                   (b2 & ~b1);

    assign fc[1] = b3 |
                   (b2 & ~b0) |
                   (b2 & ~b1) |
                   (~b0 & ~b1) |
                   (b0 & b1 & ~b2);

    assign fc[0] = ~b0 | ~b1 | ~b2;

    // selector one-hot

    assign led = valid_bcd ?
        ((fa & {5{col[0]}}) |
         (fb & {5{col[1]}}) |
         (fc & {5{col[2]}}))
        : 5'b00000;

endmodule
