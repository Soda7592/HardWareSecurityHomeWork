`timescale 1ns/1ps

module tb_subbytes;
  reg         clk;
  reg  [127:0] plaintext;
  wire [127:0] sb_out;

  SubBytes UUT (
    .clk(clk),
    .in(plaintext),
    .out(sb_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    plaintext = 128'h00102030405060708090a0b0c0d0e0f0;
    #20;
    $display("SubBytes(0x%h) = 0x%h", plaintext, sb_out);
    $display("Expected            = 0x63cab7040953d051cd60e0e7ba70e18c");
    $finish;
  end
endmodule