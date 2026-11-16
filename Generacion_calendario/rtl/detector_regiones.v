// Detector de regiones para el calendario
// Codigo generado por Mateo Amaya esquematicos diseñados por Mateo  Amaya
module detector_regiones (
    input wire [7:0] an,

    output wire sel_semana,
    output wire sel_dia,
    output wire sel_mes,
    output wire sel_ano
);

assign sel_semana = (an >= 8'd85) &
                    (an <= 8'd106);

assign sel_dia = (an >= 8'd107) &
                 (an <= 8'd127);

assign sel_mes = (an >= 8'd128) &
                 (an <= 8'd148);

assign sel_ano = (an >= 8'd149) &
                 (an <= 8'd170);

endmodule
