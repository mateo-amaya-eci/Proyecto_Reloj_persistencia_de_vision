`timescale 1ns / 1ps
// codigo generado con inteligencia artificial ChatGPT, y esquematizado con IA
// ============================================================
//  CONTADOR DE BYTES
// Cuenta los 8 bytes del burst read.
// ============================================================

module contador_bytes (
    input wire clk,
    input wire reset,
    input wire reset_count,
    // señal de avansar  a contar el siguiente byte, se activa en el estado de Receive y cuando se completa un byte
    input wire byte_enable,
    // contador de los bytes recubidos
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
                // Cuando se han recibido los 8 bytes, se reinicia el contador
                byte_count <= 3'd0;
                // indica que la recepción ha terminado y pasa al estado de finish
                rx_done    <= 1'b1;
            end
            else begin
                byte_count <= byte_count + 1'b1;
            end
        end
    end
end

endmodule
