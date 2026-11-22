// Codigo generado por Mateo Amaya esquematicos diseñados por Mateo  Amaya
module decodificador_semana (

    input wire [2:0] dia,
    input wire [5:0] col,


    output wire [4:0] led

);

    wire d2, d1, d0;

    wire [4:0] fa;
    wire [4:0] fb;
    wire [4:0] fc;
    wire [4:0] fd;
    wire [4:0] fe;

    wire valid_dia;

    assign d2 = dia[2];
    assign d1 = dia[1];
    assign d0 = dia[0];

    // 000 no es un dia valido
    assign valid_dia = (dia != 3'b000);

    // columna a

    assign fa[4] = 1'b1;
    assign fa[3] = d0 | d1;
    assign fa[2] = d0 | d1;
    assign fa[1] = ~d2 | (d0 & d1);
    assign fa[0] = d1 | ~d0 | ~d2;

    // columna b

    assign fb[4] = (d1 & d2) | (~d0 & ~d1);
    assign fb[3] = ~d0 & ~d2;
    assign fb[2] = d1 & d2 & ~d0;
    assign fb[1] = (d0 & d1 & ~d2) |
                   (d0 & d2 & ~d1);
    assign fb[0] = (d1 & d2) |
                   (~d0 & ~d1) |
                   (~d1 & ~d2);

    // columna c

    assign fc[4] = (d1 & d2) | (~d0 & ~d1);
    assign fc[3] = ~d0 & ~d1;
    assign fc[2] = ~d0 | (d1 & ~d2);
    assign fc[1] = ~d0 & ~d1;
    assign fc[0] = d0 | d2;

    // columna d

    assign fd[4] = d2 & ~d0;
    assign fd[3] = (d0 & d1 & d2) |
                   (~d0 & ~d2);
    assign fd[2] = d1 & d2;
    assign fd[1] = (d0 & d1) |
                   (d0 & d2) |
                   (d1 & d2);
    assign fd[0] = d1 & d2 & ~d0;

    // columna e

    assign fe[4] = (d1 & ~d2) |
                   (d2 & ~d1);
    assign fe[3] = (d1 & ~d2) |
                   (d0 & d2 & ~d1);
    assign fe[2] = (d1 & ~d2) |
                   (d0 & d2 & ~d1);
    assign fe[1] = d1 & ~d2;
    assign fe[0] = d1 & ~d2;

    // seleccion one-hot y punto

wire [4:0] led_interna;

assign led_interna =
    (fa & {5{col[0]}}) |
    (fb & {5{col[1]}}) |
    (fc & {5{col[2]}}) |
    (fd & {5{col[3]}}) |
    (fe & {5{col[4]}}) |
    {4'b0000, col[5]};

assign led = valid_dia ? led_interna : 5'b00000;
endmodule
