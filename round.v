/* one AES round for every two clock cycles */
`include "table.v"
module one_round (clk, state_in, key, state_out);
    input              clk;
    input      [127:0] state_in, key;
    output reg [127:0] state_out;

// SubBytes
wire [7:0] SBoxOut[15:0];
genvar i;
generate
    for (i=0;i<16;i=i+1) begin: GBox
        S u_s(
            .clk (clk),
            .in  (state_in[8*i +: 8]),
            .out (SBoxOut[i])
        );
    end
endgenerate

reg [127:0] SBoxOutReg
integer i;
always @(posedge clk) begin
    for (i=0;i<16;i=i+1)
        SBoxOutReg[8*i +: 8] <= SBoxOut[i];   // Why do this for loop : Merge the 16 wires into one
end
// ShiftRows

// 這邊的排序為甚麼是這樣排，可能還要花時間看一下 ?
wire [127:0] ShiftRowsOut = {
    SBoxOutReg[103:96], SBoxOutReg[15:8],
    SBoxOutReg[55:48],  SBoxOutReg[95:88],

    SBoxOutReg[71:64],  SBoxOutReg[79:72],
    SBoxOutReg[23:16],  SBoxOutReg[63:56],

    SBoxOutReg[39:32],  SBoxOutReg[47:40],
    SBoxOutReg[119:112],SBoxOutReg[31:24],

    SBoxOutReg[7:0],    SBoxOutReg[111:104],
    SBoxOutReg[87:80],  SBoxOutReg[127:120]
};
// MixColumns
reg [127:0] ShiftRowsOutReg;
    always @(posedge clk) 
        ShiftRowsOutReg <= ShiftRowsOut;

wire [127:0] MixColumnsOut;
genvar col;
generate
    for (col=0;col<4;col=col+1) begin: MixColumns
        wire [31:0] ColumnIn = ShiftRowsOutReg[32*col +: 32];
        wire [31:0] ColumnOut;
        
        T t0 (clk, ColumnIn[31:24], ColumnOut[31:24]);
        T t1 (clk, ColumnIn[23:16], ColumnOut[23:16]);
        T t2 (clk, ColumnIn[15:8],  ColumnOut[15:8]);
        T t3 (clk, ColumnIn[7:0],   ColumnOut[7:0]);
        
        assign MixColumnsOut[32*col +: 32] = 
            ColumnOut[31:24] ^ 
            ColumnOut[23:16] ^ 
            ColumnOut[15:8]  ^ 
            ColumnOut[7:0];
    end
endgenerate

reg [127:0] MixColumnsOutReg;
always @(posedge clk)
    MixColumnsOutReg <= MixColumnsOut;

// AddRoundKey
always @(posedge clk)
    state_out <= MixColumnsOutReg ^ key;

endmodule

/* AES final round for every two clock cycles */
module final_round (clk, state_in, key_in, state_out);
    input              clk;
    input      [127:0] state_in;
    input      [127:0] key_in;
    output reg [127:0] state_out;

// SubBytes
wire [7:0] SBoxOut[15:0];
genvar i;
generate
    for (i=0;i<16;i=i+1) begin: GBox
        S u_s(
            .clk (clk),
            .in  (state_in[8*i +: 8]),
            .out (SBoxOut[i])
        );
    end
endgenerate

reg [127:0] SBoxOutReg
integer i;
always @(posedge clk) begin
    for (i=0;i<16;i=i+1)
        SBoxOutReg[8*i +: 8] <= SBoxOut[i];   // Merge the 16 wires into one
end
// ShiftRows

wire [127:0] ShiftRowsOut = {
    SBoxOutReg[103:96], SBoxOutReg[15:8],
    SBoxOutReg[55:48],  SBoxOutReg[95:88],

    SBoxOutReg[71:64],  SBoxOutReg[79:72],
    SBoxOutReg[23:16],  SBoxOutReg[63:56],

    SBoxOutReg[39:32],  SBoxOutReg[47:40],
    SBoxOutReg[119:112],SBoxOutReg[31:24],

    SBoxOutReg[7:0],    SBoxOutReg[111:104],
    SBoxOutReg[87:80],  SBoxOutReg[127:120]
};

// AddRoundKey
always @(posedge clk)
    state_out <= sr_state ^ key_in;

endmodule