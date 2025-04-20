`timescale 1ns / 1ps

module AES_top (
    input clk,
    input rst,
    input [127:0] plaintext,
    input [127:0] key,
    output reg [127:0] out
);

    reg [7:0] cycle_count;
    wire [127:0] output_data;
    wire [127:0] ciphertext;

    aes_128 aes (
        .clk(clk),
        .state(plaintext),
        .key(key),
        .out(ciphertext)
    );

    Mux_trigger mux(
        .clk(clk),
        .rst(rst),
        .key(key),
        .ciphertext(ciphertext),
        .out(output_data)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= {128{1'bx}};  
        end 
        else begin
            out <= output_data;  
        end
    end

endmodule