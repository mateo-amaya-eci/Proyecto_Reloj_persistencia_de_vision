`timescale 1ns / 1ps
//------------------------------------------------------------
//codigo generado con inteligencia artificial ChatGPT, y esquematizado con IA
//------------------------------------------------------------
//  CONTADOR DE BITS
// Cuenta los 8 bits del comando BF.
// En nuestro proyecto utilizamos el RTC DS1302, que es el circuito encargado de proporcionar la hora y la fecha.Para solicitarle información, primero debemos enviarle un comando de 8 bits
// el modulo es el encargado de conatr los 8 avances  y avisar cuando se complete 
//------------------------------------------------------------

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
                // Cuando se han enviado los 8 bits, se reinicia el contador
                // y se indica que la transmisión ha terminado
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