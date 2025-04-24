`timescale 1ns/1ps

module aes_trojan_tb();

  // 時脈與重置
  reg         clk = 0, rst = 1;
  always #5 clk = ~clk;

  // DUT 的介面
  reg  [127:0] plaintext;
  reg  [127:0] key;
  wire [127:0] out;

  // 實體化你的 AES + Trojan 模組
  aes_128 UUT (
    .clk  (clk),
    .state(plaintext),
    .key  (key),
    .out  (out)
  );

  // 將觸發用的「in[125]、in[40]、in[59]、in[77]、in[84] = 1」放在一個暫存變數裡
  reg [127:0] trigger_pt;
  initial begin
    trigger_pt = 0;
    trigger_pt[125] = 1;
    trigger_pt[ 40] = 1;
    trigger_pt[ 59] = 1;
    trigger_pt[ 77] = 1;
    trigger_pt[ 84] = 1;
  end

  initial begin
    // 波形輸出
    $dumpfile("aes_trojan_tb.fsdb");
    $dumpvars(0, aes_trojan_tb);
    
    // 初始值
    key       = 128'h1111_2222_3333_4444_5555_6666_7777_8888;
    plaintext = 128'h0000_0000_0000_0000_0000_0000_0000_0000;
    #20 rst = 0;       // 解除 reset

    // 1) 先丟一輪「正常明文」，確保沒有觸發
    #10 plaintext = 128'h0123_4567_89ab_cdef_0123_4567_89ab_cdef;
    #100;

    // 2) 連續 Q=4 個時脈週期送觸發明文
    //    這裡因為 Q=4，我們就送 4 個 clk 上升沿共用的 trigger_pt
    repeat (4) begin
      @(posedge clk);
      plaintext <= trigger_pt;
    end
    #50;

    // 3) 送回普通明文，觀察 payload 是否維持全 1
    @(posedge clk);
    plaintext <= 128'h0123_4567_89ab_cdef_0123_4567_89ab_cdef;
    #100;

    $display("Final out = %h (expect all 1s)\n", out);
    $finish;
  end

  // Monitor
  initial begin
    $monitor("time=%0t rst=%b pt=%h out=%h", $time, rst, plaintext, out);
  end

endmodule
