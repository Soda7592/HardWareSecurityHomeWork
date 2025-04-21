`timescale 1ns/1ps

module Shift_tb;
  reg         clk;
  reg  [127:0] plaintext;
  wire [127:0] sf_out;

  shift UUT (
    .clk(clk),
    .in(plaintext),
    .out(sf_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    plaintext = 128'h63cab7040953d051cd60e0e7ba70e18c;
    #20;
    $display("Shiftrows(0x%h) = 0x%h", plaintext, sf_out);
    $display("Expected            = 0x6353e08c0960e104cd70b751bacad0e7");
    $finish;
  end
endmodule