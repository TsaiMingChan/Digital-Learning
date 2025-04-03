module _4bit_CLA(A, B, Cin, S, Cout);

  // declare the output
  output [3:0] S;
  output       Cout;
  
  // declare the input
  input [3:0] A;
  input [3:0] B;
  input       Cin;

  // declare the wire
  wire [3:0] G;
  wire [3:0] P;
  wire [3:0] Cinterval;

  assign G = A & B;
  assign P = A ^ B;
  
  assign Cinterval[0] = G[0] | (P[0] & Cin);
  assign Cinterval[1] = G[1] | (P[1] & Cinterval);
  assign Cinterval[2] = G[2] | (P[2] & Cinterval);
  assign Cinterval[3] = G[3] | (P[3] & Cinterval);
    
