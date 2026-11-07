
module contador_generico #(
    parameter WIDTH = 6,
    parameter RESET_VAL = 0
)(
    input  wire                  clk,
    input  wire                  reset,
    input  wire                  load,
    input  wire                  enable,
    input  wire [WIDTH-1:0]      D,
    output reg  [WIDTH-1:0]      Q,
    output wire                 output_carry
);

    wire [WIDTH-1:0] carry;
    wire [WIDTH-1:0] xor_out;
    wire [WIDTH-1:0] d_ff;

    // Primer bit
    assign xor_out[0] = Q[0] ^ enable;
    assign d_ff[0]    = load ? D[0] : xor_out[0];
    assign carry[0]   = enable & Q[0];

    // Cadena de acarreo
    genvar i;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : gen_cadena_contador

            assign xor_out[i] = Q[i] ^ carry[i-1];
            assign d_ff[i]    = load ? D[i] : xor_out[i];
            assign carry[i]   = carry[i-1] & Q[i];

        end
    endgenerate

    assign output_carry = carry[WIDTH-1];

    // Registro del contador
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= RESET_VAL;
        end else begin
            Q <= d_ff;
        end
    end

endmodule
