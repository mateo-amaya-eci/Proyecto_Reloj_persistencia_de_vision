// ============================================================================
// MÓDULO TOP: comparadores_top.v
// Integración de los comparadores de Segundos, Minutos y Horas
// ============================================================================
module comparadores_top (
    input  wire [7:0] converseg,         // Entrada desde conversor de segundos (8 bits)
    input  wire [7:0] convermin,         // Entrada desde conversor de minutos (8 bits)
    input  wire [7:0] converhor,         // Entrada desde conversor de horas (8 bits)
    input  wire [7:0] contador_angular,  // Contador angular de 8 bits (0 a 255)
    
    output wire       match_seg,         // Coincidencia de segundos
    output wire       match_min,         // Coincidencia de minutos
    output wire       match_hor          // Coincidencia de horas
);

    // Instancia Comparador de Segundos
    comparador_seg comp_s (
        .converseg(converseg),
        .contador_angular(contador_angular),
        .match_seg(match_seg)
    );

    // Instancia Comparador de Minutos
    comparador_min comp_m (
        .convermin(convermin),
        .contador_angular(contador_angular),
        .match_min(match_min)
    );

    // Instancia Comparador de Horas
    comparador_hor comp_h (
        .converhor(converhor),
        .contador_angular(contador_angular),
        .match_hor(match_hor)
    );

endmodule