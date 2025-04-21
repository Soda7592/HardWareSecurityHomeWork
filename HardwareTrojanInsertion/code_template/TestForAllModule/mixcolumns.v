module mixcol(
    input clk,
    input [127:0] in,
    output reg [31:0] out
);

function [7:0] x2;
    input [7:0] x;
    begin
        x2 = { x[6:0], 1'b0 } ^ (8'h1B & {8{x[7]}});
    end
endfunction

wire [7:0] s0 = in[127:120];
wire [7:0] s1 = in[119:112];    
wire [7:0] s2 = in[111:104];
wire [7:0] s3 = in[103:96];

wire [7:0] s0_p = x2(s0) ^ (x2(s1)^s1) ^ s2 ^ s3;
wire [7:0] s1_p = s0 ^ x2(s1) ^ (x2(s2)^s2) ^ s3;
wire [7:0] s2_p = s0 ^ s1 ^ x2(s2) ^ (x2(s3)^s3);
wire [7:0] s3_p = (x2(s0)^s0) ^ s1 ^ s2 ^ x2(s3);
wire [31:0] col0 = {s0_p, s1_p, s2_p, s3_p};

always @(posedge clk) begin
    out <= col0;
end

endmodule