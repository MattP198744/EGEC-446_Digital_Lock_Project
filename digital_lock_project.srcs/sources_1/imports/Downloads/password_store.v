`timescale 1ns / 1ps

module password_store(
    input  wire clk,
    input  wire reset,
    output reg [3:0] pw1,
    output reg [3:0] pw2,
    output reg [3:0] pw3,
    output reg [3:0] pw4
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pw1 <= 9;   // Password = 9 5 2 7
            pw2 <= 5;
            pw3 <= 2;
            pw4 <= 7;
        end
    end

endmodule
