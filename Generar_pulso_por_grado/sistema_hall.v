module medidor_periodo_efecto_hall (
    input wire clk,                    
    input wire rst,                    
    input wire sensoreh,        // Señal directa proveniente del sensor de efecto Hall
    output reg [19:0] periodo_total    // Salida con el número total de ciclos que dura la vuelta completa
);

    // Flip-flops encadenados para evitar rebotes del sensor Hall
    reg ff_eh, sync_eh;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ff_eh  <= 1'b0;
            sync_eh <= 1'b0;
        end else begin
            ff_eh  <= sensoreh;
            sync_eh <= ff_eh; 
        end
    end

    // Detección de flanco de subida del sensor Hall (inicio de nueva vuelta)
    reg anterior_eh;
    always @(posedge clk or posedge rst) begin
        if (rst)
            anterior_eh <= 1'b0;
        else
            anterior_eh <= sync_eh;
    end
    
    wire flanco_hall = sync_eh & ~anterior_eh;

    // CONTADOR DE CICLOS (Mide el tiempo entre vuelta y vuelta)
    reg [19:0] contador_maestro;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            contador_maestro <= 20'd0;
        end else if (flanco_hall) begin
            contador_maestro <= 20'd1; 
        end else begin
            contador_maestro <= contador_maestro + 1'b1; 
        end
    end

    // REGISTRO DE CAPTURA DEL PERIODO (Guarda el resultado al completar la vuelta)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            periodo_total <= 20'd0;
        end else if (flanco_hall) begin
            periodo_total <= contador_maestro;
        end
    end

endmodule


module generador_pulso_paso (
    input wire clk,                  
    input wire rst,                    
    input wire [11:0] periodo_paso,    // El valor límite (Periodo Paso)
    output reg tick_1_4                // El pulso de salida de cada 1.4°
);

    reg [11:0] contador;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            contador <= 12'd0;
            tick_1_4 <= 1'b0;
        end else begin
            // Comparador (=): ¿El contador llegó al valor del periodo de paso?
            if (contador >= periodo_paso) begin
                contador <= 12'd0;    // Se reinicia a 0 
                tick_1_4 <= 1'b1;    // Activa el pulso de salida por un ciclo de reloj
            end else begin
                contador <= contador + 1'b1; // Sigue sumando ciclos del reloj maestro
                tick_1_4 <= 1'b0;    // Mantiene el pulso apagado el resto del tiempo
            end
        end
    end

endmodule


module sistema_hall_top (
    input wire clk,
    input wire rst,
    input wire sensor_eh,
    output wire tick_1_4
);

    wire [19:0] periodo_total;

    // Instancia del módulo medidor de periodo al dar la vuelta
    medidor_periodo_efecto_hall medidor (
        .clk(clk),
        .rst(rst),
        .sensoreh(sensor_eh),
        .periodo_total(periodo_total)
    );

    // Instancia del módulo generador de pulso por paso (División por 256 mediante shift [19:8])
    generador_pulso_paso generador (
        .clk(clk),
        .rst(rst),
        .periodo_paso(periodo_total[19:8]), 
        .tick_1_4(tick_1_4)
    );

endmodule