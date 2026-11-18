
module contador_angular_8bits (
    input wire CLK,
    input wire RESET,
    input wire PULSO,
    input wire HALL_REF,
    output reg [7:0] ANGULO
);

    always @(posedge CLK or posedge RESET) begin
        if (RESET)
            ANGULO <= 8'd0;
        else if (HALL_REF)
            ANGULO <= 8'd0;
        else if (PULSO)
            ANGULO <= ANGULO + 8'd1;
    end

endmodule
