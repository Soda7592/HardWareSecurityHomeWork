`timescale 1ns/1ps

module TB_Single;
  reg         clk;
  reg  [127:0] state_in;
  reg [127:0] key_in;
  wire [127:0] out;

  one_round UUT (
    .clk(clk),
    .state_in(state_in),
    .key_in(key_in),
    .state_out(out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    state_in = 128'h00102030405060708090a0b0c0d0e0f0;
    key_in = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe;
    #20;
    $display("SingleRound State_in(0x%h) key_in(0x%h) = 0x%h", state_in, key_in, out);
    $display("Expected            = 0x89d810e8855ace682d1843d8cb128fe4");
    $finish;
  end
endmodule