module AddRoundKey(
    input clk,
    input [127:0] in,
    input [127:0] key,
    output reg [127:0] out
);

    always @(posedge clk) begin
        out <= in ^ key;
    end

endmodule