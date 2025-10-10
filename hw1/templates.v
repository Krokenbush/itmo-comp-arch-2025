module adder8(op1, op2, sum, cout);
  // 8-битные операнды
  input [7:0] op1, op2;
  // 8-битная сумма
  output [7:0] sum;
  // Флаг переноса
  output cout;

  // TODO: implementation
endmodule

module mux_3_8(d0, d1, d2, d3, d4, d5, d6, d7, a, out);
  // Verilog не поддерживает массивы входов/выходов :(
  // поэтому мы явно перечисляем 8 входов
  input [7:0] d0, d1, d2, d3, d4, d5, d6, d7; // 8 входных 8-битных сигналов данных
  input [2:0] a; // 3-битный управляющий сигнал
  output [7:0] out; // 8-битный выход

  // TODO: implementation
endmodule

module alu(op1, op2, control, result);
  // 8-битные операнды
  input [7:0] op1, op2;
  // 3-битный управляющий сигнал
  input [2:0] control;
  output [7:0] result;

  // TODO: implementation
endmodule
