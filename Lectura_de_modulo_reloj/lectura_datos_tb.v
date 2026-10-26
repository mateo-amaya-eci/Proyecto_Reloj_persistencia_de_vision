`timescale 1ns / 1ps

module lectura_tb;

    // Entradas del UUT
    reg clk;
    reg rst;
    reg rtc_data_in;

    // Salidas binarias finales
    wire [5:0] segundos_bin;
    wire [5:0] minutos_bin;
    wire [5:0] horas_bin;
    wire [5:0] dia_sem_bin;
    wire [5:0] dia_mes_bin;
    wire [5:0] mes_bin;

    // Instancia del módulo Top
    lectura_datos_module uut (
        .clk(clk),
        .rst(rst),
        .rtc_data_in(rtc_data_in),
        .segundos_bin(segundos_bin),
        .minutos_bin(minutos_bin),
        .horas_bin(horas_bin),
        .dia_sem_bin(dia_sem_bin),
        .dia_mes_bin(dia_mes_bin),
        .mes_bin(mes_bin)
    );

    // Reloj maestro: Periodo de 10ns (100 MHz)
    always #5 clk = ~clk;

    // Tarea para transmitir 1 byte en serie alineado con los flancos de reloj
    task send_byte(input [7:0] data_bcd);
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                rtc_data_in = data_bcd[7 - i]; // O data_bcd[i] según el orden MSB/LSB de tu shift register
                @(posedge clk);
            end
        end
    endtask

    initial begin
        $dumpfile("sim_out.vcd");
        $dumpvars(0, lectura_tb);

        // Inicialización
        clk = 0;
        rst = 1;
        rtc_data_in = 0;

        #20;
        rst = 0;
        @(posedge clk);

        // Envío de bytes BCD exactos:
        send_byte(8'h40); // Segundos = 40 (Binario esperado: 101000 = 40)
        send_byte(8'h32); // Minutos  = 32 (Binario esperado: 100000 = 32)
        send_byte(8'h03); // Horas    = 3  (Binario esperado: 000011 = 3)
        send_byte(8'h01); // Día Sem  = 1  (Binario esperado: 000001 = 1)
        send_byte(8'h26); // Día Mes  = 26 (Binario esperado: 011010 = 26)
        send_byte(8'h10); // Mes      = 10 (Binario esperado: 001010 = 10)

        #100;
        $finish;
    end

endmodule