module reloj_top #(
    parameter CLK_FREQ = 27000000
)(
    // Entradas
    input wire clk,
    input wire reset,

    // Datos provenientes del DS1302
    input wire [7:0] rtc_seconds,
    input wire [7:0] rtc_minutes,
    input wire [7:0] rtc_hours,
    input wire [7:0] rtc_day,
    input wire [7:0] rtc_month,
    input wire [7:0] rtc_weekday,
    input wire [7:0] rtc_year,
    input wire rtc_valid,

    // Salidas del reloj
    output wire [5:0] segundos,
    output wire [5:0] minutos,
    output wire [4:0] horas,
    output wire [4:0] dia,
    output wire [2:0] semana,
    output wire [3:0] mes,
    output wire [6:0] anio
);
wire tick_1s;


    // Divisor de frecuencia
    divisor_segundo #(
        .CLK_FREQ(CLK_FREQ)
    ) divisor_inst (
        .clk(clk),
        .reset(reset),
        .tick_1s(tick_1s)
    );






wire load_inicial;
// Datos iniciales provenientes del DS1302,
// después de la conversión BCD a binario
wire [5:0] dato_segundos;
wire [5:0] dato_minutos;
wire [4:0] dato_horas;

// Señales de control
wire load_segundos;
wire load_minutos;
wire load_horas;

wire tick_seg;
wire tick_min;
wire tick_dia;
reg rtc_valid_anterior;


always @(posedge clk or posedge reset) begin
    if (reset)
        rtc_valid_anterior <= 1'b0;
    else
        rtc_valid_anterior <= rtc_valid;
end

assign load_inicial = rtc_valid && !rtc_valid_anterior;



// Detectar el final de los segundos
wire fin_segundos = (segundos == 6'd59) &&
                    tick_1s &&
                    !load_inicial;

// Detectar el final de los minutos
wire fin_minutos = (minutos == 6'd59) &&
                   tick_seg &&
                   !load_inicial;

// Detectar el final de las horas
wire fin_horas = (horas == 5'd23) &&
                 tick_min &&
                 !load_inicial;


// Cargas automaticas para volver a cero
assign load_segundos = load_inicial | fin_segundos;
assign load_minutos  = load_inicial | fin_minutos;
assign load_horas    = load_inicial | fin_horas;


// Acarreos hacia la siguiente unidad
assign tick_seg = fin_segundos;
assign tick_min = fin_minutos;
assign tick_dia = fin_horas;





// ========================================
// CONTADOR DE SEGUNDOS: 0 - 59
// ========================================

contador_generico #(
    .WIDTH(6),
    .RESET_VAL(0)
) contador_segundos (
    .clk(clk),
    .reset(reset),
    .load(load_segundos),
    .enable(tick_1s),
    .D(load_inicial ? dato_segundos : 6'd0),
    .Q(segundos),
    .output_carry()
);


// ========================================
// CONTADOR DE MINUTOS: 0 - 59
// ========================================

contador_generico #(
    .WIDTH(6),
    .RESET_VAL(0)
) contador_minutos (
    .clk(clk),
    .reset(reset),
    .load(load_minutos),
    .enable(tick_seg),
    .D(load_inicial ? dato_minutos : 6'd0),
    .Q(minutos),
    .output_carry()
);


// ========================================
// CONTADOR DE HORAS: 0 - 23
// ========================================

contador_generico #(
    .WIDTH(5),
    .RESET_VAL(0)
) contador_horas (
    .clk(clk),
    .reset(reset),
    .load(load_horas),
    .enable(tick_min),
    .D(load_inicial ? dato_horas : 5'd0),
    .Q(horas),
    .output_carry()
);




// Datos iniciales convertidos a binario
wire [4:0] dato_dia;
wire [2:0] dato_semana;
wire [3:0] dato_mes;
wire [6:0] dato_anio;

control_calendario calendario_inst (
    .clk(clk),
    .reset(reset),

    .load_inicial(load_inicial),
    .tick_dia(tick_dia),

    .dato_dia(dato_dia),
    .dato_semana(dato_semana),
    .dato_mes(dato_mes),
    .dato_anio(dato_anio),

    .dia(dia),
    .semana(semana),
    .mes(mes),
    .anio(anio)
);


wire [5:0] segundos_inicial;
wire [5:0] minutos_inicial;
wire [4:0] horas_inicial;

wire [4:0] dia_inicial;
wire [2:0] semana_inicial;
wire [3:0] mes_inicial;
wire [6:0] anio_inicial;





bcd_a_binario conversor (
    .seconds_bcd(rtc_seconds),
    .minutes_bcd(rtc_minutes),
    .hours_bcd(rtc_hours),
    .day_bcd(rtc_day),
    .month_bcd(rtc_month),
    .weekday_bcd(rtc_weekday),
    .year_bcd(rtc_year),

    .seconds_bin(segundos_inicial),
    .minutes_bin(minutos_inicial),
    .hours_bin(horas_inicial),
    .day_bin(dia_inicial),
    .month_bin(mes_inicial),
    .weekday_bin(semana_inicial),
    .year_bin(anio_inicial)
);

assign dato_segundos = segundos_inicial;
assign dato_minutos  = minutos_inicial;
assign dato_horas    = horas_inicial;
assign dato_dia     = dia_inicial;
assign dato_semana  = semana_inicial;
assign dato_mes     = mes_inicial;
assign dato_anio    = anio_inicial;
endmodule