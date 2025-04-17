module uart_rx
    (
        input            i_clk,
        input            i_rst,
        input            i_rx,
        output reg [7:0] o_data;
        output reg       o_valid
    );

        reg r_rx_1 = 1'b1;
        reg r_rx_2 = 1'b1;

        parameter IDLE  = 3'b000;
        parameter START = 3'b001;
        parameter DATA  = 3'b010;
        parameter STOP  = 3'b011;
        parameter DONE  = 3'b111;

        // Double-register the incoming data. (For metastability)
        always @(posedge i_clk or negedge i_rst) begin
      
