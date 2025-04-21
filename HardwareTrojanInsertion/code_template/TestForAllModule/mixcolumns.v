module mixcol(
    input clk,
    input [127:0] in,
    output reg [127:0] out
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

wire [7:0] s11 = in[95:88];
wire [7:0] s12 = in[87:80];
wire [7:0] s13 = in[79:72];
wire [7:0] s14 = in[71:64];

wire [7:0] s11_p = x2(s11) ^ (x2(s12)^s12) ^ s13 ^ s14;
wire [7:0] s12_p = s11 ^ x2(s12) ^ (x2(s13)^s13) ^ s14;
wire [7:0] s13_p = s11 ^ s12 ^ x2(s13) ^ (x2(s14)^s14);
wire [7:0] s14_p = (x2(s11)^s11) ^ s12 ^ s13 ^ x2(s14);
wire [31:0] col1 = {s11_p, s12_p, s13_p, s14_p};

wire [7:0] s21 = in[63:56];
wire [7:0] s22 = in[55:48];
wire [7:0] s23 = in[47:40];
wire [7:0] s24 = in[39:32];

wire [7:0] s21_p = x2(s21) ^ (x2(s22)^s22) ^ s23 ^ s24;
wire [7:0] s22_p = s21 ^ x2(s22) ^ (x2(s23)^s23) ^ s24;
wire [7:0] s23_p = s21 ^ s22 ^ x2(s23) ^ (x2(s24)^s24);
wire [7:0] s24_p = (x2(s21)^s21) ^ s22 ^ s23 ^ x2(s24);
wire [31:0] col2 = {s21_p, s22_p, s23_p, s24_p};

wire [7:0] s31 = in[31:24];
wire [7:0] s32 = in[23:16];
wire [7:0] s33 = in[15:8];
wire [7:0] s34 = in[7:0];

wire [7:0] s31_p = x2(s31) ^ (x2(s32)^s32) ^ s33 ^ s34;
wire [7:0] s32_p = s31 ^ x2(s32) ^ (x2(s33)^s33) ^ s34;
wire [7:0] s33_p = s31 ^ s32 ^ x2(s33) ^ (x2(s34)^s34);
wire [7:0] s34_p = (x2(s31)^s31) ^ s32 ^ s33 ^ x2(s34);
wire [31:0] col3 = {s31_p, s32_p, s33_p, s34_p};

always @(posedge clk) begin
    out <= { col0, col1, col2, col3 };
end

endmodule