module not_gate(in, out);
  input wire in;
  output wire out;
  supply1 vdd; 
  supply0 gnd; 

  pmos pmos1(out, vdd, in);
  nmos nmos1(out, gnd, in);
endmodule

module nand_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  supply0 gnd;
  supply1 pwr;

  wire nmos1_out;

  pmos pmos1(out, pwr, in1);
  pmos pmos2(out, pwr, in2);
  nmos nmos1(nmos1_out, gnd, in1);
  nmos nmos2(out, nmos1_out, in2);
endmodule

module nor_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  supply0 gnd;
  supply1 pwr;

  wire pmos1_out;

  pmos pmos1(pmos1_out, pwr, in1);
  pmos pmos2(out, pmos1_out, in2);
  nmos nmos1(out, gnd, in1);
  nmos nmos2(out, gnd, in2);
endmodule

module and_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire nand_out;

  nand_gate nand_gate1(in1, in2, nand_out);
  not_gate not_gate1(nand_out, out);
endmodule

module and4_gate (in1, in2, in3, in4, out);
  input wire in1;
  input wire in2;
  input wire in3;
  input wire in4;
  output wire out;

  wire tmp1, tmp2;
  and_gate and1(.in1(in1), .in2(in2), .out(tmp1));
  and_gate and2(.in1(tmp1), .in2(in3), .out(tmp2));
  and_gate and3(.in1(tmp2), .in2(in4), .out(out));
endmodule

module or_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire nor_out;

  nor_gate nor_gate1(in1, in2, nor_out);
  not_gate not_gate1(nor_out, out);
endmodule

module or8_gate(
    input in1, in2, in3, in4, in5, in6, in7, in8,
    output out
);
    wire or1, or2, or3, or4, or12, or34, or56, or78;
    
    or_gate o1(.in1(in1), .in2(in2), .out(or1));
    or_gate o2(.in1(in3), .in2(in4), .out(or2));
    or_gate o3(.in1(in5), .in2(in6), .out(or3));
    or_gate o4(.in1(in7), .in2(in8), .out(or4));
    
    or_gate o12(.in1(or1), .in2(or2), .out(or12));
    or_gate o34(.in1(or3), .in2(or4), .out(or34));
    
    or_gate o_final(.in1(or12), .in2(or34), .out(out));
endmodule

module xor_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire not_in1;
  wire not_in2;

  wire and_out1;
  wire and_out2;

  wire or_out1;

  not_gate not_gate1(in1, not_in1);
  not_gate not_gate2(in2, not_in2);

  and_gate and_gate1(in1, not_in2, and_out1);
  and_gate and_gate2(not_in1, in2, and_out2);

  or_gate or_gate1(and_out1, and_out2, out);
endmodule

module half_adder(a, b, c_out, s);
  input wire a;
  input wire b;
  output wire c_out;
  output wire s;

  and_gate and_gate1(a, b, c_out);

  xor_gate xor_gate1(a, b, s);
endmodule

module adder1(
    input a, b, cin,
    output sum, cout
);
    wire s1, c1, c2;
    
    half_adder ha1(.a(a), .b(b),  .c_out(c1), .s(s1));
    half_adder ha2(.a(s1), .b(cin), .c_out(c2), .s(sum));
    or_gate or1(.in1(c1), .in2(c2), .out(cout));
endmodule

module adder8(op1, op2, sum, cout);
  input [7:0] op1, op2;
  output [7:0] sum;
  output cout;

  wire [8:0] carry;

  adder1 adder_0(.a(op1[0]), .b(op2[0]), .cin(1'b0), .sum(sum[0]), .cout(carry[1]));
  adder1 adder_1(.a(op1[1]), .b(op2[1]), .cin(carry[1]), .sum(sum[1]), .cout(carry[2]));
  adder1 adder_2(.a(op1[2]), .b(op2[2]), .cin(carry[2]), .sum(sum[2]), .cout(carry[3]));
  adder1 adder_3(.a(op1[3]), .b(op2[3]), .cin(carry[3]), .sum(sum[3]), .cout(carry[4]));
  adder1 adder_4(.a(op1[4]), .b(op2[4]), .cin(carry[4]), .sum(sum[4]), .cout(carry[5]));
  adder1 adder_5(.a(op1[5]), .b(op2[5]), .cin(carry[5]), .sum(sum[5]), .cout(carry[6]));
  adder1 adder_6(.a(op1[6]), .b(op2[6]), .cin(carry[6]), .sum(sum[6]), .cout(carry[7]));
  adder1 adder_7(.a(op1[7]), .b(op2[7]), .cin(carry[7]), .sum(sum[7]), .cout(carry[8]));

  assign cout = carry[8];
endmodule

module mux_3_8(d0, d1, d2, d3, d4, d5, d6, d7, a, out);
  input [7:0] d0, d1, d2, d3, d4, d5, d6, d7;
  input [2:0] a;    
  output [7:0] out;

  wire not0, not1, not2;
  not_gate n0(.in(a[0]), .out(not0));
  not_gate n1(.in(a[1]), .out(not1));
  not_gate n2(.in(a[2]), .out(not2));

  wire [7:0] out0, out1, out2, out3, out4, out5, out6, out7;

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : mux_bits
      and4_gate and_d0(.in1(not0), .in2(not1), .in3(not2), .in4(d0[i]), .out(out0[i]));
      and4_gate and_d1(.in1(a[0]), .in2(not1), .in3(not2), .in4(d1[i]), .out(out1[i]));
      and4_gate and_d2(.in1(not0), .in2(a[1]), .in3(not2), .in4(d2[i]), .out(out2[i]));
      and4_gate and_d3(.in1(a[0]), .in2(a[1]), .in3(not2), .in4(d3[i]), .out(out3[i]));
      and4_gate and_d4(.in1(not0), .in2(not1), .in3(a[2]), .in4(d4[i]), .out(out4[i]));
      and4_gate and_d5(.in1(a[0]), .in2(not1), .in3(a[2]), .in4(d5[i]), .out(out5[i]));
      and4_gate and_d6(.in1(not0), .in2(a[1]), .in3(a[2]), .in4(d6[i]), .out(out6[i]));
      and4_gate and_d7(.in1(a[0]), .in2(a[1]), .in3(a[2]), .in4(d7[i]), .out(out7[i]));
      
      or8_gate out_or(
        .in1(out0[i]), .in2(out1[i]), .in3(out2[i]), .in4(out3[i]),
        .in5(out4[i]), .in6(out5[i]), .in7(out6[i]), .in8(out7[i]),
        .out(out[i])
      );
    end
  endgenerate
endmodule

module alu(op1, op2, control, result);
  input [7:0] op1, op2;
  input [2:0] control;
  output [7:0] result;

  wire [7:0] and_result, nand_result, or_result, nor_result;
  wire [7:0] add_result, sub_result, slt_result;
  
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : logic_operations
      and_gate andi(.in1(op1[i]), .in2(op2[i]), .out(and_result[i]));
      nand_gate nandi(.in1(op1[i]), .in2(op2[i]), .out(nand_result[i]));
      or_gate ori(.in1(op1[i]), .in2(op2[i]), .out(or_result[i]));
      nor_gate nori(.in1(op1[i]), .in2(op2[i]), .out(nor_result[i]));
    end
  endgenerate
  
  wire cout_add;
  adder8 adder(.op1(op1), .op2(op2), .sum(add_result), .cout(cout_add));
  
  wire [7:0] not_op2;
  wire [7:0] plus_one = 8'b00000001; 
  
  generate
    for (i = 0; i < 8; i = i + 1) begin : negation
      not_gate not_b(.in(op2[i]), .out(not_op2[i]));
    end
  endgenerate
  
  wire cout_sub;
  adder8 subtractor(.op1(op1), .op2(not_op2), .sum(sub_result), .cout(cout_sub));
  
  wire [7:0] sub_corrected;
  wire cout_corrected;
  adder8 corrector(.op1(sub_result), .op2(plus_one), .sum(sub_corrected), .cout(cout_corrected));
  
  wire sign_a = op1[7];
  wire sign_b = op2[7];
  wire sign_diff = sub_corrected[7]; 
  
  wire signs_different = sign_a ^ sign_b; 
  wire a_negative_b_positive = sign_a & ~sign_b; 
  wire both_negative_diff_negative = sign_a & sign_b & sign_diff; 
  wire both_positive_diff_negative = ~sign_a & ~sign_b & sign_diff; 
  
  wire slt_value;
  or_gate slt_or1(.in1(a_negative_b_positive), .in2(both_negative_diff_negative), .out(slt_value_temp1));
  or_gate slt_or2(.in1(slt_value_temp1), .in2(both_positive_diff_negative), .out(slt_value));
  
  assign slt_result = {7'b0, slt_value};
  
  mux_3_8 output_mux(
    .d0(and_result),     // 000: a & b
    .d1(nand_result),    // 001: !(a & b)
    .d2(or_result),      // 010: a | b
    .d3(nor_result),     // 011: !(a | b)
    .d4(add_result),     // 100: a + b
    .d5(sub_corrected),  // 101: a - b
    .d6(slt_result),     // 110: slt
    .d7(8'b0),           // 111: unused
    .a(control),
    .out(result)
  );
endmodule
