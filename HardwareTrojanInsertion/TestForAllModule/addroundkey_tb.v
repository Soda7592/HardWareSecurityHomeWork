`timescale 1ns/1ps

module AddRoundKey_tb;
  reg         clk;
  reg  [127:0] mix_out;
  reg  [127:0] key;
  wire [127:0] out;


  AddRoundKey UUT (
    .clk(clk),
    .in(mix_out),
    .key(key),
    .out(out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    mix_out = 128'h5f72641557f5bc92f7be3b291db9f91a;
    key = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe;
    #20;
    $display("MixColumns out(0x%h), key (0x%h)  = 0x%h", mix_out, key, out);
    $display("Expected            = 0x89d810e8855ace682d1843d8cb128fe4");
    $finish;
  end
endmodule