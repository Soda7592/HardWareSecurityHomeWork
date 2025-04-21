`timescale 1ns / 1ps

module AES_top (
    input clk,
    input rst,
    input [127:0] plaintext,
    input [127:0] key,
    output reg [127:0] out
    // output reg [127:0] round1_out
);

    reg [7:0] cycle_count;
    wire [127:0] output_data;
    wire [127:0] ciphertext;
    // wire [127:0] round1;

    aes_128 aes (
        .clk(clk),
        .state(plaintext),
        .key(key),
        .out(ciphertext)
        // .round1_out(round1)
    );

    // Mux_trigger mux(
    //     .clk(clk),
    //     .rst(rst),
    //     .key(key),
    //     .ciphertext(ciphertext),
    //     .out(output_data)
    // );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= {128{1'bx}};  
        end 
        else begin
            out <= ciphertext;  
            // round1_out <= round1;
        end
    end

endmodule