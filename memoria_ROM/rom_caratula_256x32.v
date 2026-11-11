
module rom_caratula_256x4 (
    input  wire [7:0] dir_angulo,
    output reg  [3:0] caratula_out
);

    // LED 0: normal mas cercano a los RGB
    // LED 3: normal mas externo

    localparam [3:0] ANILLO     = 4'b1000;
    localparam [3:0] MINUTOS    = 4'b1100;
    localparam [3:0] HORAS      = 4'b1111;

    always @(*) begin
        case (dir_angulo)

            // Marcas principales: 12 horas
            8'd0, 8'd1, 8'd255,
            8'd21, 8'd22,
            8'd42, 8'd43,
            8'd63, 8'd64, 8'd65,
            8'd85, 8'd86,
            8'd106, 8'd107,
            8'd127, 8'd128, 8'd129,
            8'd149, 8'd150,
            8'd170, 8'd171,
            8'd191, 8'd192, 8'd193,
            8'd213, 8'd214,
            8'd234, 8'd235:
                caratula_out = HORAS;

            // Marcas secundarias: minutos
            8'd4, 8'd8, 8'd13, 8'd17,
            8'd26, 8'd30, 8'd34, 8'd38,
            8'd47, 8'd51, 8'd55, 8'd60,
            8'd68, 8'd73, 8'd77, 8'd81,
            8'd90, 8'd94, 8'd98, 8'd102,
            8'd111, 8'd115, 8'd119, 8'd124,
            8'd132, 8'd137, 8'd141, 8'd145,
            8'd154, 8'd158, 8'd162, 8'd166,
            8'd175, 8'd179, 8'd183, 8'd188,
            8'd196, 8'd201, 8'd205, 8'd209,
            8'd218, 8'd222, 8'd226, 8'd230,
            8'd239, 8'd243, 8'd247, 8'd251:
                caratula_out = MINUTOS;

            // Fondo: anillo exterior continuo
            default:
                caratula_out = ANILLO;

        endcase
    end

endmodule
