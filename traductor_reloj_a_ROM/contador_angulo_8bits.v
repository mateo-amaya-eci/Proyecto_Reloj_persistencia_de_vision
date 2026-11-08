// ============================================================================
// MÓDULO: contador_angular_8bits.v
// Contador angular síncrono de 8 bits (rango 0 a 255)
// ============================================================================
module contador_angular_8bits (
    input  wire       CLK,       // Reloj principal del sistema
    input  wire       RESET,     // Reset activo en alto (reinicia a 0)
    input  wire       PULSO,     // Pulso de avance angular por grado/sector
    output reg  [7:0] ANGULO     // Ángulo actual (0 a 255 bits)
);

    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            ANGULO <= 8'd0;
        end else if (PULSO) begin
            ANGULO <= ANGULO + 1'b1; // Incrementa 1 grado; al pasar de 255 vuelve a 0
        end
    end

endmodule