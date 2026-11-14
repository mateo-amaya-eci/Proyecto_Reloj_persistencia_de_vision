
module generador_manecillas_rgb (
    input wire MATCH_SEG,
    input wire MATCH_MIN,
    input wire MATCH_HORA,

    output wire [9:0] LED_R,
    output wire [9:0] LED_G,
    output wire [9:0] LED_B
);

    // LED 0: mas cercano al centro
    // LED 9: mas alejado del centro

    localparam [9:0] MASCARA_SEG  = 10'b1111111111;
    localparam [9:0] MASCARA_MIN  = 10'b0011111111;
    localparam [9:0] MASCARA_HORA = 10'b0000011111;

    assign LED_R = {10{MATCH_SEG}}  & MASCARA_SEG;
    assign LED_G = {10{MATCH_HORA}} & MASCARA_HORA;
    assign LED_B = {10{MATCH_MIN}}  & MASCARA_MIN;

endmodule
