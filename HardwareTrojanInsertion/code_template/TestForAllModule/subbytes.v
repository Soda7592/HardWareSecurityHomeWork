module SubBytes(
    input  clk,
    input [127:0] in,
    output reg [127:0] out
);

wire [7:0] sb_byte[0:15];
genvar j;
generate
  for (j = 0; j < 16; j = j + 1) begin
    S sb_inst (
      .clk(clk),
      .in(in[8*j +:8]),
      .out(sb_byte[j])
    );
  end
endgenerate

integer i;
always @(posedge clk) begin
    for (i = 0; i < 16; i = i + 1)
        out[8*i +:8] <= sb_byte[i];
end

endmodule