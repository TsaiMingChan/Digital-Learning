module _4bit_CLA(A, B, Cin, S, Cout);

  // Declare the output
  output [3:0] S;
  output       Cout;
  
  // Declare the input
  input [3:0] A;
  input [3:0] B;
  input       Cin;

  // Declare the wire
  wire [3:0] G;   // Generate
  wire [3:0] P;   // Propagate
  wire [3:0] P_s; // P for S
  wire [3:1] C;   // Intermediate carries

  assign G = A & B;   // Generate
  assign P = A | B;   // Propagate

  assign P_s = A ^ B;
  
  assign C[1] = G[0] | (P[0] & Cin);
  assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
  assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
  assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

  assign S = P_s ^ {C[3], C[2], C[1], Cin}; 

endmodule
