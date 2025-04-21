`timescale 1ns / 1ps

module AES_top_tb_1();

    // Testbench signals
    reg clk;
    reg rst;
    reg [127:0] plaintext;
    reg [127:0] key;
    wire [127:0] out;
    // wire [127:0] round1;
    // Instantiate the device under test (DUT)
    AES_top dut (
        .clk(clk),
        .rst(rst),
        .plaintext(plaintext),
        .key(key),
        .out(out)
        // .round1_out(round1)
    );

    // Dump waveforms for debugging
    initial begin
        $dumpfile("AES_top_tb.fsdb");    // Waveform output file
        $dumpvars(0, AES_top_tb_1);       // Dump all signals in this testbench
    end
    
    // Generate a clock with 10 ns period (toggle every 5 ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Apply stimulus
    initial begin
        // Initially assert reset and set default inputs
        rst   = 1;
        // plaintext = 128'h00112233445566778899aabbccddeeff;
        // key= 128'h000102030405060708090a0b0c0d0e0f;
        // expected = 69c4e0d86a7b0430d8cdb78070b4c55a

        plaintext = 128'h0123_4567_89ab_cdef_0123_4567_89ab_cdef;
        key   = 128'h1111_2222_3333_4444_5555_6666_7777_C0DE;
        // expected = f5faab4f8f660658658dbaa45146e768
        #20;
        rst = 0;

        #4000; 

        // End simulation
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("rst=%b, key[15:0]=%h, out=%h\n", rst, key[15:0], out);
        // $monitor("rst=%b, key[15:0]=%h, round1=%h\n",
        //         rst, key[15:0], round1);
    end



endmodule
