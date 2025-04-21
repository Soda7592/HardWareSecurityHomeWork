module shift(
    input clk,
    input [127:0] in,
    output reg [127:0] out
);
    // reg [127:0] PreSrRows = {
    //     in[127:120], in[95:88], in[63:56], in[31:24],
    //     in[119:112], in[87:80], in[55:48], in[23:16],
    //     in[111:104], in[79:72], in[47:40], in[15:8],
    //     in[103:96],  in[71:64], in[39:32], in[7:0],
    // };

    wire [127:0] sr_state = {
        in[127:120], in[95:88], in[63:56], in[31:24],
        in[87:80],   in[55:48], in[23:16], in[119:112],
        in[47:40],   in[15:8],  in[111:104], in[79:72],
        in[7:0],    in[103:96], in[71:64], in[39:32]
    };

    // reg [127:0] sr_state = {
    //     63, 09, cd, ba,
    //     53, 60, 70, ca,
    //     e0, el, b7, d0,
    //     8c, 04, 51, e7
    // };

        // reg [127:0] sr_state = {
    //     in[127:120], in[119:112], in[111:104], in[103:96],
    //     in[95:88],   in[87:80],   in[79:72],   in[71:64],
    //     in[63:56],  in[55:48],   in[47:40],   in[39:32],
    //     in[31:24],  in[23:16],   in[15:8],    in[7:0]
    // };


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


    always @(posedge clk) begin
        out <= sr_state_out;
    end

    // in = 0x63cab7040953d051cd60e0e7ba70e18c
    // out = 0x6353e08c0960e104cd70b751bacad0e7
    // expected = 0x6353e08c0960e104cd70b751bacad0e7

endmodule