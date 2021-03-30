module cd(input wire clk, reset, s_inc, we3, wez, popsignal, pushsignal, s_stack, we4, we_out,
          input wire [1:0] s_inm, s_in, s_out,
          input wire [2:0] op_alu, 
          input wire [7:0] in1, in2,
          output wire z, output wire [15:0] opcode,
          output wire[7:0] out1, out2, out3, out4);

// Camino de datos de instrucciones de un solo ciclo
wire [15:0] salida_memoria_programa;
wire [9:0] salida_sumador, salida_mux_inc, entrada_sumador_a, salida_contador_programa;
wire [7:0] rd1, rd2, salida_alu, salida_mux_inm, salida_memoria_datos, entrada_io, salida_mux_out;
wire entrada_ffz, d0, d1, d2, d3, rege1, rege2, rege3, rege4;

// Pila
wire [9:0] salida_pila, salida_mux_stack;


// module mux2 #(parameter WIDTH = 8) 
//              (input  wire [WIDTH-1:0] d0, d1, 
//               input  wire s, 
//               output wire [WIDTH-1:0] y);
mux2 #(10) inc (salida_memoria_programa[9:0], salida_sumador,
                s_inc,
                salida_mux_inc);

// module sum(input  wire [9:0] a, b, 
//            output wire [9:0] y);
sum sumador ( 10'b0000000001, salida_contador_programa,
             salida_sumador);


// module registro #(parameter WIDTH = 8)
//              (input wire clk, reset,
//               input wire [WIDTH-1:0] d, 
//               output reg [WIDTH-1:0] q);          
registro #(10) contador_programa (clk, reset,
                                  salida_mux_stack,
                                  salida_contador_programa);

// module memprog(input  wire clk,
//                input  wire [9:0]  a,
//                output wire [15:0] rd);
memprog memoria_programa (clk,
                          salida_contador_programa,
                          salida_memoria_programa);

assign opcode = salida_memoria_programa[15:10];

//  module regfile(input  wire clk, 
//                 input  wire we3,                  //se�al de habilitaci�n de escritura
//                 input  wire [3:0]  ra1, ra2, wa3, //direcciones de regs leidos y reg a escribir
//                 input  wire [7:0]  wd3, 			     //dato a escribir
//                 output wire [7:0]  rd1, rd2); 
regfile banco_registros (clk, we3,
                         salida_memoria_programa[11:8],salida_memoria_programa[7:4],salida_memoria_programa[3:0],
                         salida_mux_inm,
                         rd1, rd2);

// module alu(input wire [7:0] a, b,
//            input wire [2:0] op_alu,
//            output wire [7:0] y,
//            output wire zero);
alu unidad_alu (rd1, rd2,
                op_alu,
                salida_alu,
                entrada_ffz);

// module ffd(input wire clk, reset, d, carga, output reg q);
ffd ffz(clk, reset, entrada_ffz, wez , z);

// module mux4 #(parameter WIDTH = 8)
//              (input  wire [WIDTH-1:0] d0, d1, d2, d3,
//               input  wire [1:0]            s, 
//               output reg [WIDTH-1:0] y);
mux4 inm(salida_alu, salida_memoria_programa[11:4], salida_memoria_datos, entrada_io,
          s_inm,
          salida_mux_inm);

// adicion de un registro interno en la cpu como pila, antes del pc
// module mux2 #(parameter WIDTH = 8) 
//              (input  wire [WIDTH-1:0] d0, d1, 
//               input  wire s, 
//               output wire [WIDTH-1:0] y);  
mux2 #(10) mux_stack(salida_mux_inc, salida_pila,
                     s_stack,
                     salida_mux_stack);

// module stack(input wire clk, reset, popsignal, pushsignal,
//              output reg [9:0] pop,
//              input wire [9:0] push);                     
stack pila(clk, reset, popsignal, pushsignal,
           salida_pila,
           salida_mux_stack);

// module memory_data(input  wire        clk, 
//                   input  wire        we4,     
//                   input  wire [9:0]  ra,       
//                   input  wire [7:0]  wd4, 	
//                   output wire [7:0]  rd1);
memory_data memoria_datos(clk,
                    we4,
                    salida_memoria_programa[11:0],
                    rd1,
                    salida_memoria_datos);           

// entrada datos
mux4 in(in1, in2, , ,
          s_in,
          entrada_io);
// salida datos  
mux4 out(rd1,salida_memoria_programa[11:4], , ,
        s_out,
        salida_mux_out);

decoder24 deco_out(salida_memoria_programa[1:0], 
          d0,d1,d2,d3);

// module registro #(parameter WIDTH = 8)
//              (input wire clk, reset,
//               input wire [WIDTH-1:0] d, 
//               output reg [WIDTH-1:0] q);          
registro reg1_out (rege1, reset,
                   salida_mux_out,
                   out1);

registro reg2_out (rege2, reset,
                   salida_mux_out,
                   out2);

registro reg3_out (rege3, reset,
                   salida_mux_out,
                   out3);

registro reg4_out (rege4, reset,
                   salida_mux_out,
                   out4);                                                         

assign rege1 = d0 & we_out;
assign rege2 = d1 & we_out;
assign rege3 = d2 & we_out;
assign rege4 = d3 & we_out;

endmodule





