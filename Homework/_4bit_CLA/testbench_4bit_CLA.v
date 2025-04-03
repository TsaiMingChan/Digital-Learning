`timescale 1ns / 1ps

module _4bit_CLA_testbench;
    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    
    // Outputs
    wire [3:0] S;
    wire Cout;
    
    // Instantiate the Unit Under Test (UUT)
    _4bit_CLA uut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .S(S), 
        .Cout(Cout)
    );
    
    integer i, j, k;
    integer correct_count = 0;
    integer wrong_count = 0;
    reg [4:0] expected;
    
    // Testbench process
    initial begin
        
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                for (k = 0; k < 2; k = k + 1) begin
                    A = i;
                    B = j;
                    Cin = k;
                    #10;
                    expected = A + B + Cin;
                    if ({Cout, S} !== expected) begin
                        $display("Mismatch! A=%b B=%b Cin=%b | S=%b Cout=%b (Expected: S=%b Cout=%b)", A, B, Cin, S, Cout, expected[3:0], expected[4]);
                        wrong_count = wrong_count + 1;
                    end else begin
                        correct_count = correct_count + 1;
                    end
                end
            end
        end
        
        $display("Total Correct Cases: %d", correct_count);
        $display("Total Wrong Cases: %d", wrong_count);
        
        // End simulation
        $finish;
    end
endmodule
