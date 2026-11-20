`timescale 1ns / 1ps
// codigo generado con inteligencia artificial ChatGPT, y esquematizado con IA
// ============================================================
// RECEPTOR SIPO
// Recibe los bits seriales y reconstruye un byte.
// DS1302 transmite LSB primero.
// ============================================================

module receptor_sipo (
    input wire clk,
    input wire reset,
    // Señal que indica que se debe capturar el bit de datos entrante, 
    // en el estado de Receive , solo en el pulso de subida.
    input wire capture_enable,
    // Señal de datos entrante desde el I/O del DS1302
    input wire dat_in,

    output reg [7:0] rx_byte,
    // Señal que indica que se ha recibido un byte completo
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
            // coloca el bit  nuevo bit en la posicion mas significativa
            rx_byte <= {dat_in, rx_byte[7:1]};
            // informa que se completo el byte de el SIPO
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