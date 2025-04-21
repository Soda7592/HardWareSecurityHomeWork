`include "table.v"

module one_round (
    input  wire        clk,
    input  wire [127:0] state_in,
    input  wire [127:0] key_in,
    output reg  [127:0] state_out
);

function [7:0] x2;
    input [7:0] x;
    begin
        x2 = { x[6:0], 1'b0 } ^ (8'h1B & {8{x[7]}});
    end
endfunction

// SubBytes
wire [7:0] sb_byte[0:15];
genvar j;
generate
for (j = 0; j < 16; j = j + 1) begin
    S sb_inst (
    .clk(clk),
    .in(state_in[8*j +:8]),
    .out(sb_byte[j])
    );
end
endgenerate

wire [127:0] sb_byte_out;
genvar i;
generate
for (i = 0; i < 16; i = i + 1)
    assign sb_byte_out[8*i +:8] = sb_byte[i];
endgenerate

// ShiftRows
    wire [127:0] sr_state = {
        sb_byte_out[127:120], sb_byte_out[95:88],  sb_byte_out[63:56], sb_byte_out[31:24],
        sb_byte_out[87:80],   sb_byte_out[55:48],  sb_byte_out[23:16], sb_byte_out[119:112],
        sb_byte_out[47:40],   sb_byte_out[15:8],   sb_byte_out[111:104], sb_byte_out[79:72],
        sb_byte_out[7:0],     sb_byte_out[103:96], sb_byte_out[71:64], sb_byte_out[39:32]
    };

    wire [7:0] a0 = sr_state[127:120];
    wire [7:0] a1 = sr_state[95:88];
    wire [7:0] a2 = sr_state[63:56];
    wire [7:0] a3 = sr_state[31:24];
    wire [31:0] Col0 = {a0, a1, a2, a3};

    wire [7:0] b0 = sr_state[119:112];
    wire [7:0] b1 = sr_state[87:80];
    wire [7:0] b2 = sr_state[55:48];
    wire [7:0] b3 = sr_state[23:16];
    wire [31:0] Col1 = {b0, b1, b2, b3};

    wire [7:0] c0 = sr_state[111:104];
    wire [7:0] c1 = sr_state[79:72];
    wire [7:0] c2 = sr_state[47:40];
    wire [7:0] c3 = sr_state[15:8];
    wire [31:0] Col2 = {c0, c1, c2, c3};

    wire [7:0] d0 = sr_state[103:96];
    wire [7:0] d1 = sr_state[71:64];
    wire [7:0] d2 = sr_state[39:32];
    wire [7:0] d3 = sr_state[7:0];
    wire [31:0] Col3 = {d0, d1, d2, d3};

    wire[127:0] sr_state_out = {Col0, Col1, Col2, Col3};

    // always @(posedge clk) begin
    //     state_out <= sr_state_out;
    // end
// MixColumns

    wire [7:0] s0 = sr_state_out[127:120];
    wire [7:0] s1 = sr_state_out[119:112];    
    wire [7:0] s2 = sr_state_out[111:104];
    wire [7:0] s3 = sr_state_out[103:96];

    wire [7:0] s0_p = x2(s0) ^ (x2(s1)^s1) ^ s2 ^ s3;
    wire [7:0] s1_p = s0 ^ x2(s1) ^ (x2(s2)^s2) ^ s3;
    wire [7:0] s2_p = s0 ^ s1 ^ x2(s2) ^ (x2(s3)^s3);
    wire [7:0] s3_p = (x2(s0)^s0) ^ s1 ^ s2 ^ x2(s3);
    wire [31:0] col0 = {s0_p, s1_p, s2_p, s3_p};

    wire [7:0] s11 = sr_state_out[95:88];
    wire [7:0] s12 = sr_state_out[87:80];
    wire [7:0] s13 = sr_state_out[79:72];
    wire [7:0] s14 = sr_state_out[71:64];

    wire [7:0] s11_p = x2(s11) ^ (x2(s12)^s12) ^ s13 ^ s14;
    wire [7:0] s12_p = s11 ^ x2(s12) ^ (x2(s13)^s13) ^ s14;
    wire [7:0] s13_p = s11 ^ s12 ^ x2(s13) ^ (x2(s14)^s14);
    wire [7:0] s14_p = (x2(s11)^s11) ^ s12 ^ s13 ^ x2(s14);
    wire [31:0] col1 = {s11_p, s12_p, s13_p, s14_p};

    wire [7:0] s21 = sr_state_out[63:56];
    wire [7:0] s22 = sr_state_out[55:48];
    wire [7:0] s23 = sr_state_out[47:40];
    wire [7:0] s24 = sr_state_out[39:32];

    wire [7:0] s21_p = x2(s21) ^ (x2(s22)^s22) ^ s23 ^ s24;
    wire [7:0] s22_p = s21 ^ x2(s22) ^ (x2(s23)^s23) ^ s24;
    wire [7:0] s23_p = s21 ^ s22 ^ x2(s23) ^ (x2(s24)^s24);
    wire [7:0] s24_p = (x2(s21)^s21) ^ s22 ^ s23 ^ x2(s24);
    wire [31:0] col2 = {s21_p, s22_p, s23_p, s24_p};

    wire [7:0] s31 = sr_state_out[31:24];
    wire [7:0] s32 = sr_state_out[23:16];
    wire [7:0] s33 = sr_state_out[15:8];
    wire [7:0] s34 = sr_state_out[7:0];

    wire [7:0] s31_p = x2(s31) ^ (x2(s32)^s32) ^ s33 ^ s34;
    wire [7:0] s32_p = s31 ^ x2(s32) ^ (x2(s33)^s33) ^ s34;
    wire [7:0] s33_p = s31 ^ s32 ^ x2(s33) ^ (x2(s34)^s34);
    wire [7:0] s34_p = (x2(s31)^s31) ^ s32 ^ s33 ^ x2(s34);
    wire [31:0] col3 = {s31_p, s32_p, s33_p, s34_p};

    wire [127:0] mix_state = { col0, col1, col2, col3 };

// AddRoundKey
    always @(posedge clk) begin
        state_out <= mix_state ^ key_in;
    end

endmodule
