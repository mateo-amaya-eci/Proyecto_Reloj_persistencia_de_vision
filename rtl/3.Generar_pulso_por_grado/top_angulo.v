// codigo realizado por Mateo Felipe Amaya , con ayuda de inteligencia artificial ChatGPT
//--------------------------------------------
// codigo para generar el angulo de 0 a 255 , donde cada incremento representa 1,4 grados
//--------------------------------------------
module top_angulo (
    input wire clk,
    input wire rst,
    input wire sensor_eh,

    output wire [7:0] angulo
);

    // Señales internas de conexión
    // Señales internas
    wire tick_1_4;
    wire inicio_vuelta;
    wire rst_angular;

    // Reinicio del contador angular
    assign rst_angular = rst | inicio_vuelta;       

    // Módulo del sensor Hall
    sistema_hall_top hall (
        .clk(clk),
        .rst(rst),
        .sensor_eh(sensor_eh),
        .tick_1_4(tick_1_4),
        .inicio_vuelta(inicio_vuelta)
    );

    // Módulo contador angular
    contador_angular contador (
        .clk(clk),
        .rst(rst_angular),
        .tick_1_4(tick_1_4),
        .contador_angular(angulo)
    );

endmodule
