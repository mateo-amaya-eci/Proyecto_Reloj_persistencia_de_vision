`timescale 1ns / 1ps
// Codigo generado con inteligencia artificial ChatGPT, y esquematizado con IA
//--------------------------------------------------------------------------------
// Transmisor de datos al RTC DS1302
// Este módulo se encarga de transmitir el comando de transmisión (BF) al RTC DS1302. 
// Utiliza un registro de desplazamiento para enviar los bits del comando,
// un contador de bits para llevar un seguimiento de los bits enviados
//--------------------------------------------------------------------------------

module transmisor_rtc (
    input wire clk,
    input wire reset,
// Señal load_command para cargar el comando de transmisión (BF) al registro de desplazamiento; 
// enviado por la máquina de estados del controlador_rtc en el estado START.
    input wire load_command,
// Señal bit_enable para habilitar el desplazamiento de bits 
// en el registro de desplazamiento en cada pulso desendente del rtc_sclk;
// enviado por la máquina de estados del controlador_rtc en el estado TRANSMIT.
    input wire bit_enable,
// Señal bit_count_enable para habilitar el conteo de bits enviados en el contador de bits;
// enviado por la máquina de estados del controlador_rtc en el estado TRANSMIT.
    input wire bit_count_enable,
// Señal bit_reset para reiniciar el conteo de bits enviados en el contador de bits;
    input wire bit_reset,
//señal tx_data para enviar el bit actual del registro de desplazamiento al bus bidireccional del DS1302;
    output wire tx_data,
// Señal tx_done para indicar que se han enviado los 8 bits del comando de transmisión (BF) al DS1302;
// para indicar que se ha completado la transmisión del comando de transmisión (BF) al DS1302,
    output wire tx_done
);

    reg [7:0] shift_reg;
    reg load_command_d;

    wire load_pulse;
// Señal load_pulse para detectar el flanco ascendente de la señal 
//load_command y cargar el comando de transmisión (BF);

    assign tx_data = shift_reg[0];


    // REGISTRO DE DESPLAZAMIENTO

    always @(posedge clk) begin

        if (reset) begin
            shift_reg <= 8'h00;
            load_command_d <= 1'b0;
        end

        else begin

            load_command_d <= load_command;

            if (load_pulse) begin
                //carga 10111111, que dice que envie el burst de datos
                // de reloj _calendario.
                shift_reg <= 8'hBF;
            end

            else if (bit_enable) begin
                shift_reg <= {1'b0, shift_reg[7:1]};
            end

        end
    end
    // En la transmiccion se evnvia primero el bit menos significativo
    //------------------------------------------------
    // CONTADOR DE BITS
    //------------------------------------------------
    contador_bits contador (
        .clk(clk),
        .reset(reset),
        .reset_count(bit_reset),
        .bit_enable(bit_count_enable),
        .tx_done(tx_done)
    );

endmodule