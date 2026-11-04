// ============================================================
// 2. CONTADOR DE BITS
// Cuenta los 8 bits del comando BF.
// ============================================================

module contador_bits (
    input wire clk,
    input wire reset,
    input wire reset_count,
    input wire bit_enable,

    output reg [2:0] bit_count,
    output reg tx_done
);

always @(posedge clk) begin
    if (reset || reset_count) begin
        bit_count <= 3'd0;
        tx_done   <= 1'b0;
    end
    else begin
        tx_done <= 1'b0;

        if (bit_enable) begin
            if (bit_count == 3'd7) begin
                bit_count <= 3'd0;
                tx_done   <= 1'b1;
            end
            else begin
                bit_count <= bit_count + 1'b1;
            end
        end
    end
end

endmodule