`include "table.v"

module mixcol_T (
    input  wire        clk,
    input  wire [31:0] col_in,
    output wire [31:0] col_out
);
    wire [31:0] p0,p1,p2,p3;
    T t0(clk,col_in[31:24],p0);
    T t1(clk,col_in[23:16],p1);
    T t2(clk,col_in[15:8] ,p2);
    T t3(clk,col_in[7:0]  ,p3);

    assign col_out = p0 ^
                     {p1[23:0],p1[31:24]} ^
                     {p2[15:0],p2[31:16]} ^
                     {p3[7:0] ,p3[31:8 ]};
endmodule



module one_round (
    input  wire        clk,
    input  wire [127:0] state_in,
    input  wire [127:0] key_in,
    output reg  [127:0] state_out
);
    wire [7:0] sb_byte [0:15];
    genvar i;
    generate
        for(i=0;i<16;i=i+1)
            S u_s(.clk(clk),
                  .in (state_in[8*i +:8]),
                  .out(sb_byte[i]));
    endgenerate

    reg [127:0] sb_state;
    integer k;
    always @(posedge clk)
        for(k=0;k<16;k=k+1)
            sb_state[8*k +:8] <= sb_byte[k];

    wire [127:0] sr_state = {
        sb_state[103:96],sb_state[15:8], sb_state[55:48], sb_state[95:88],
        sb_state[71:64], sb_state[79:72],sb_state[23:16], sb_state[63:56],
        sb_state[39:32], sb_state[47:40],sb_state[119:112],sb_state[31:24],
        sb_state[7:0],   sb_state[111:104],sb_state[87:80], sb_state[127:120]
    };

    wire [7:0] r0c0 = sr_state[7:0];
    wire [7:0] r1c0 = sr_state[111:104];
    wire [7:0] r2c0 = sr_state[87:80];
    wire [7:0] r3c0 = sr_state[127:120];
    wire [7:0] r0c1 = sr_state[39:32];
    wire [7:0] r1c1 = sr_state[47:40];
    wire [7:0] r2c1 = sr_state[119:112];
    wire [7:0] r3c1 = sr_state[31:24];
    wire [7:0] r0c2 = sr_state[71:64];
    wire [7:0] r1c2 = sr_state[79:72];
    wire [7:0] r2c2 = sr_state[23:16];
    wire [7:0] r3c2 = sr_state[63:56];
    wire [7:0] r0c3 = sr_state[103:96];
    wire [7:0] r1c3 = sr_state[15:8];
    wire [7:0] r2c3 = sr_state[55:48];
    wire [7:0] r3c3 = sr_state[95:88];

    wire [31:0] col0_in = {r3c0, r2c0, r1c0, r0c0};
    wire [31:0] col1_in = {r3c1, r2c1, r1c1, r0c1};
    wire [31:0] col2_in = {r3c2, r2c2, r1c2, r0c2};
    wire [31:0] col3_in = {r3c3, r2c3, r1c3, r0c3};

    wire [31:0] mc0,mc1,mc2,mc3;
    mixcol_T mc_u0(clk,col0_in,mc0);
    mixcol_T mc_u1(clk,col1_in,mc1);
    mixcol_T mc_u2(clk,col2_in,mc2);
    mixcol_T mc_u3(clk,col3_in,mc3);

    reg [127:0] mc_state;
    always @(posedge clk)
        mc_state <= {mc3,mc2,mc1,mc0};

    always @(posedge clk)
        state_out <= mc_state ^ key_in;
endmodule



module final_round (
    input  wire        clk,
    input  wire [127:0] state_in,
    input  wire [127:0] key_in,
    output reg  [127:0] state_out
);
    wire [7:0] sb_byte [0:15];
    genvar j;
    generate
        for(j=0;j<16;j=j+1)
            S u_s(.clk(clk),
                  .in (state_in[8*j +:8]),
                  .out(sb_byte[j]));
    endgenerate

    reg [127:0] sb_state;
    integer t;
    always @(posedge clk)
        for(t=0;t<16;t=t+1)
            sb_state[8*t +:8] <= sb_byte[t];

    wire [127:0] sr_state = {
        sb_state[103:96],sb_state[15:8], sb_state[55:48], sb_state[95:88],
        sb_state[71:64], sb_state[79:72],sb_state[23:16], sb_state[63:56],
        sb_state[39:32], sb_state[47:40],sb_state[119:112],sb_state[31:24],
        sb_state[7:0],   sb_state[111:104],sb_state[87:80], sb_state[127:120]
    };

    always @(posedge clk)
        state_out <= sr_state ^ key_in;
endmodule
