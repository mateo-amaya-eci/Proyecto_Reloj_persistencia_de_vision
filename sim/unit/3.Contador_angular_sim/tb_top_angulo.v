
`timescale 1ns/1ps

module tb_top_angulo;

    reg clk = 0;
    reg rst = 1;
    reg sensor_eh = 0;

    wire [7:0] angulo;

    integer total_ticks = 0;
    integer errores = 0;
    reg [7:0] angulo_anterior;

    // Generar reloj: periodo de 10 ns
    always #5 clk = ~clk;

    // Instanciar nuestra integracion
    top_angulo dut (
        .clk(clk),
        .rst(rst),
        .sensor_eh(sensor_eh),
        .angulo(angulo)
    );

    // Simular el paso del iman por el Hall
    task pulso_hall;
    begin
        sensor_eh = 1;
        repeat (4) @(negedge clk);
        sensor_eh = 0;
    end
    endtask

    // Comprobar el avance angular
    always @(posedge clk) begin
        if (!rst && dut.tick_1_4) begin
            angulo_anterior = angulo;
            total_ticks = total_ticks + 1;

            #1;
            if (angulo !== (angulo_anterior + 8'd1)) begin
                $display("ERROR: contador no avanzo");
                errores = errores + 1;
            end
        end
    end

    initial begin

        $dumpfile("angulo.vcd");
        $dumpvars(0, tb_top_angulo);

        // Reinicio inicial
        repeat (5) @(negedge clk);
        rst = 0;

        // Primera deteccion Hall
        pulso_hall();

        // Esperar 5120 ciclos por vuelta
        repeat (5116) @(negedge clk);

        // Segunda deteccion Hall
        pulso_hall();

        // Observar los pulsos durante otra vuelta
        repeat (5116) @(negedge clk);

        $display("Angulo antes de Hall: %d", angulo);
        $display("Total de ticks: %d", total_ticks);

        // Tercera deteccion Hall
        pulso_hall();

        repeat (5) @(negedge clk);

        $display("Angulo despues de Hall: %d", angulo);

        if (total_ticks == 0) begin
            $display("ERROR: no hubo pulsos");
            errores = errores + 1;
        end

        if (errores == 0) begin
            $display("PASS: avance y reinicio angular correctos");
        end else begin
            $fatal(1, "FAIL: %0d errores en el contador angular", errores);
        end

        $finish;
    end

endmodule
