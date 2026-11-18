
module medidor_periodo_efecto_hall (
    input  wire clk,
    input  wire rst,
    input  wire sensoreh,
    output reg [31:0] periodo_total,
    output wire inicio_vuelta,
    output reg periodo_valido
);

    reg ff1, ff2, anterior;
    reg [31:0] contador;
    reg primera_vuelta;

    // Sincronizar sensor Hall
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ff1 <= 0;
            ff2 <= 0;
            anterior <= 0;
        end else begin
            ff1 <= sensoreh;
            ff2 <= ff1;
            anterior <= ff2;
        end
    end

    assign inicio_vuelta = ff2 & ~anterior;

    // Medir ciclos entre dos pulsos Hall
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            contador <= 0;
            periodo_total <= 0;
            primera_vuelta <= 0;
            periodo_valido <= 0;
        end
        else if (inicio_vuelta) begin
            contador <= 0;

            if (primera_vuelta) begin
                periodo_total <= contador + 1'b1;
                periodo_valido <= 1;
            end

            primera_vuelta <= 1;
        end
        else if (primera_vuelta) begin
            if (contador != 32'hFFFFFFFF)
                contador <= contador + 1'b1;
        end
    end

endmodule


module generador_pulso_paso (
    input wire clk,
    input wire rst,
    input wire inicio_vuelta,
    input wire periodo_valido,
    input wire [31:0] periodo_paso,
    output reg tick_1_4
);

    reg [31:0] contador;
    reg [7:0] sectores_emitidos;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            contador <= 0;
            sectores_emitidos <= 0;
            tick_1_4 <= 0;
        end
        else begin
            tick_1_4 <= 0;

            if (inicio_vuelta) begin
                contador <= 0;
                sectores_emitidos <= 0;
            end
            else if (periodo_valido &&
                     periodo_paso != 0 &&
                     sectores_emitidos < 8'd255) begin

                if (contador >= periodo_paso - 1'b1) begin
                    contador <= 0;
                    tick_1_4 <= 1;
                    sectores_emitidos <= sectores_emitidos + 1'b1;
                end
                else begin
                    contador <= contador + 1'b1;
                end
            end
        end
    end

endmodule


module sistema_hall_top (
    input wire clk,
    input wire rst,
    input wire sensor_eh,
    output wire tick_1_4,
    output wire inicio_vuelta
);

    wire [31:0] periodo_total;
    wire periodo_valido;
    wire [31:0] periodo_paso;

    medidor_periodo_efecto_hall medidor (
        .clk(clk),
        .rst(rst),
        .sensoreh(sensor_eh),
        .periodo_total(periodo_total),
        .inicio_vuelta(inicio_vuelta),
        .periodo_valido(periodo_valido)
    );

    // Dividir el periodo entre 256
    assign periodo_paso = periodo_total >> 8;

    generador_pulso_paso generador (
        .clk(clk),
        .rst(rst),
        .inicio_vuelta(inicio_vuelta),
        .periodo_valido(periodo_valido),
        .periodo_paso(periodo_paso),
        .tick_1_4(tick_1_4)
    );

endmodule
