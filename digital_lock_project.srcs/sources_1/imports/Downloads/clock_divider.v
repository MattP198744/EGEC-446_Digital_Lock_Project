`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2025 08:01:25 PM
// Design Name: 
// Module Name: clock_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_divider(
    input clk,
    input reset,
    output reg clk_scan,
    output reg clk_flash
);
    
    localparam SCAN_DIV = 100000;
    
    localparam FLASH_DIV = 50000000;

    integer scan_cnt = 0;
    integer flash_cnt = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            scan_cnt <= 0;
            flash_cnt <= 0;
            clk_scan <= 0;
            clk_flash <= 0;
        end
        
        else begin
            
            if (scan_cnt == SCAN_DIV-1) begin
                scan_cnt <= 0;
                clk_scan <= ~clk_scan;
            end else
                scan_cnt <= scan_cnt + 1;
           
            if (flash_cnt == FLASH_DIV-1) begin
                flash_cnt <= 0;
                clk_flash <= ~clk_flash;
            end else
                flash_cnt <= flash_cnt + 1;
        end
    end

endmodule
