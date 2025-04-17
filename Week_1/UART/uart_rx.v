module uart_rx
(
    input            clk,
    input            rst,
    input            rx,
    output reg [7:0] data,
    output reg       valid
);

    parameter CLK_PER_BIT = 16;
    
    reg       rx_1;
    reg       rx_2;
    reg [3:0] bit_cnt;
    reg [7:0] data_buf;
    reg [7:0] clk_cnt;
    reg [2:0] state;

    parameter IDLE  = 3'b000;
    parameter START = 3'b001;
    parameter DATA  = 3'b010;
    parameter STOP  = 3'b011;
    parameter DONE  = 3'b111;

    // Double-register the incoming data. (For metastability)
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rx_1 <= 1;
            rx_2 <= 1;
        end
        else begin
            rx_1 <= rx;
            rx_2 <= rx_1;
        end
    end

    // Finite State Machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state    <= IDLE;
            clk_cnt  <= 0;
            bit_cnt  <= 0;
            data_buf <= 0;
            data     <= 0;
            valid    <= 0;
        end 
        else begin
            case (state)
                IDLE: begin
                    valid <= 0;
                    clk_cnt <= 0;
                    bit_cnt <= 0;
                    if (rx_2 == 0)  // Detect start bit
                        state <= START;
                end

                START: begin
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == (CLK_PER_BIT >> 1)) begin
                        clk_cnt <= 0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        data_buf[bit_cnt] <= rx_2;
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 7)
                            state <= STOP;
                    end
                end

                STOP: begin
                    clk_cnt <= clk_cnt + 1;
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        state <= DONE;
                    end
                end

                DONE: begin
                    data <= data_buf;
                    valid <= 1;
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule
      
