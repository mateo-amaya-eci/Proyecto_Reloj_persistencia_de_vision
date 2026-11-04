
// ============================================================
// 4. RECEPTOR SIPO
// Recibe los bits seriales y reconstruye un byte.
// DS1302 transmite LSB primero.
// ============================================================

module receptor_sipo (
    input wire clk,
    input wire reset,
    input wire capture_enable,
    input wire dat_in,

    output reg [7:0] rx_byte,
    output reg byte_complete
);

reg [2:0] bit_count;

always @(posedge clk) begin
    if (reset) begin
        rx_byte       <= 8'd0;
        bit_count     <= 3'd0;
        byte_complete <= 1'b0;
    end
    else begin
        byte_complete <= 1'b0;

        if (capture_enable) begin

            rx_byte <= {dat_in, rx_byte[7:1]};

            if (bit_count == 3'd7) begin
                bit_count     <= 3'd0;
                byte_complete <= 1'b1;
            end
            else begin
                bit_count <= bit_count + 1'b1;
            end
        end
    end
end

endmodule