
`timescale 1ns/1ps

module tb_sistema_hall;

    reg clk = 0;
    reg rst = 1;
    reg sensor_eh = 0;

    wire tick_angular;
    wire inicio_vuelta;
    wire [7:0] angulo_actual;

    integer total_ticks = 0;
    integer errores = 0;

    // Reloj de simulacion: periodo 10 ns
    always #5 clk = ~clk;

    sistema_hall_top dut_hall (
        .clk(clk),
        .rst(rst),
        .sensor_eh(sensor_eh),
        .tick_1_4(tick_angular),
        .inicio_vuelta(inicio_vuelta)
    );

    contador_angular_8bits dut_contador (
        .CLK(clk),
        .RESET(rst),
        .PULSO(tick_angular),
        .HALL_REF(inicio_vuelta),
        .ANGULO(angulo_actual)
    );

    // Generar un pulso Hall
    task pulso_hall;
    begin
        @(negedge clk);
        sensor_eh = 1;
        repeat (4) @(negedge clk);
        sensor_eh = 0;
    end
    endtask

    // Contar pulsos y comprobar limites
    always @(posedge clk) begin
        if (!rst) begin
            if (tick_angular) begin
                total_ticks = total_ticks + 1;
                if (angulo_actual == 8'd255) begin
                    $display("ERROR: pulso extra en angulo 255");
                    errores = errores + 1;
                end
            end
        end
    end

    initial begin
        $dumpfile("sim_hall.vcd");
        $dumpvars(0, tb_sistema_hall);

        repeat (5) @(negedge clk);
        rst = 0;

        // Primera referencia Hall
        pulso_hall();

        // Primera vuelta: 5120 ciclos
        repeat (5116) @(negedge clk);
        pulso_hall();

        // Segunda vuelta: genera pulsos angulares
        repeat (5116) @(negedge clk);

        // Comprobar estado antes de nueva vuelta
        $display("Angulo antes de Hall: %d", angulo_actual);
        $display("Ticks acumulados: %d", total_ticks);

        // Tercera referencia
        pulso_hall();
        repeat (5) @(negedge clk);

        $display("Angulo despues de Hall: %d", angulo_actual);

        if (angulo_actual !== 8'd0) begin
            $display("ERROR: no se reinicio el angulo");
            errores = errores + 1;
        end

        if (errores == 0)
            $display("SIMULACION SIN ERRORES DETECTADOS");
        else
            $display("ERRORES: %d", errores);

        $finish;
    end

endmodule
