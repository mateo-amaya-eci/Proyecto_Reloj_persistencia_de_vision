//----------------------------------------------------------------
// Testbench para el contador angular.
// Testbench generado por  IA 
//----------------------------------------------------------------

`timescale 1ns / 1ps

module tb_contador_angular;

    // Entradas
    reg clk;
    reg rst;
    reg tick_1_4;

    // Salida
    wire [7:0] contador_angular;

    // Contador de pulsos del testbench
    integer numero_ticks;

    // Instancia del modulo
    contador_angular uut (
        .clk(clk),
        .rst(rst),
        .tick_1_4(tick_1_4),
        .contador_angular(contador_angular)
    );

    // Generador de reloj: periodo de 10 ns
    always #5 clk = ~clk;

    initial begin

        // Inicializacion
        clk = 0;
        rst = 1;
        tick_1_4 = 0;
        numero_ticks = 0;

        // Archivo de ondas
        $dumpfile("contador_angular.vcd");
        $dumpvars(0, tb_contador_angular);

        // Aplicar reset
        #20;
        rst = 0;

        $display("--------------------------------");
        $display(" INICIO DE LA SIMULACION");
        $display("--------------------------------");

        // Generar 1000 pulsos
        repeat (1000) begin

            @(negedge clk);
            tick_1_4 = 1;

            @(posedge clk);
            #1;
            numero_ticks = numero_ticks + 1;

            $display("Tick=%0d | Contador angular=%0d",
                     numero_ticks, contador_angular);

            @(negedge clk);
            tick_1_4 = 0;

        end

        // Resultado final
        $display("--------------------------------");
        $display(" RESULTADO FINAL");
        $display("--------------------------------");

        $display("Numero de ticks: %0d", numero_ticks);
        $display("Contador angular: %0d", contador_angular);

        // Después de 1000 incrementos:
        // 1000 mod 256 = 232

        if (contador_angular == 8'd232) begin
            $display("PRUEBA SUPERADA");
        end
        else begin
            $display("ERROR EN LA SIMULACION");
        end

        #20;
        $finish;

    end

endmodule
