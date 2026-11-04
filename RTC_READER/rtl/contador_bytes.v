// ============================================================
// 3. CONTADOR DE BYTES
// Cuenta los 8 bytes del burst read.
// ============================================================

module contador_bytes (
    input wire clk,
    input wire reset,
    input wire reset_count,
    input wire byte_enable,

    output reg [2:0] byte_count,
    output reg rx_done
);

always @(posedge clk) begin
    if (reset || reset_count) begin
        byte_count <= 3'd0;
        rx_done    <= 1'b0;
    end
    else begin
        rx_done <= 1'b0;

        if (byte_enable) begin
            if (byte_count == 3'd7) begin
                byte_count <= 3'd0;
                rx_done    <= 1'b1;
            end
            else begin
                byte_count <= byte_count + 1'b1;
            end
        end
    end
end

endmodule
