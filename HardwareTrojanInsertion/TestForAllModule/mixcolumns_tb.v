`timescale 1ns/1ps

module Mix_tb;
  reg         clk;
  reg  [127:0] plaintext;
  wire [127:0] mix_out;

  mixcol UUT (
    .clk(clk),
    .in(plaintext),
    .out(mix_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    plaintext = 128'h6353e08c0960e104cd70b751bacad0e7;
    #20;
    $display("MixColumns(0x%h) = 0x%h", plaintext, mix_out);
    $display("Expected            = 0x5f72641557f5bc92f7be3b291db9f91a");
    $finish;
  end
endmodule