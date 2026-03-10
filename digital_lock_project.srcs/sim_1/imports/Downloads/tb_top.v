`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2025 08:12:12 PM
// Design Name: 
// Module Name: tb_top
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

module tb_top;

    reg clk;
    reg btnU, btnL, btnD, btnR, btnC;
    reg [3:0] sw;

    wire [7:0] seg;
    wire [7:0] an;
    wire [15:0] led;
    
    top DUT (
        .clk(clk),
        .sw(sw),
        .btnU(btnU),
        .btnL(btnL),
        .btnD(btnD),
        .btnR(btnR),
        .btnC(btnC),
        .seg(seg),
        .an(an),
        .led(led)
    );
    
    defparam DUT.div.FLASH_DIV = 5000;
    
    always #5 clk = ~clk;

    task do_pulse(input integer btn_code);
    begin
        
        btnU=0; btnD=0; btnL=0; btnR=0; btnC=0;

        case(btn_code)
            0: btnU = 1;
            1: btnD = 1;
            2: btnL = 1;
            3: btnR = 1;
            4: btnC = 1;
        endcase

        #2_000_000;
        
        btnU=0; btnD=0; btnL=0; btnR=0; btnC=0;

        #2_000_000;
    end
    endtask
   
    initial begin

        clk = 0;
        btnU = 0; btnD = 0; btnL = 0; btnR = 0; btnC = 0;
        sw = 4'b0000;
        
        sw[0] = 1; #100;
        sw[0] = 0; #200;
        
        
        do_pulse(0);
        do_pulse(3);
        do_pulse(0);
        do_pulse(3);
        do_pulse(0);
        do_pulse(3);
        do_pulse(0);
        
        do_pulse(4);

        #20000;
        
        repeat(9) do_pulse(0);

        do_pulse(3);
        repeat(5) do_pulse(0);

        do_pulse(3);
        repeat(2) do_pulse(0);

        do_pulse(3);
        repeat(7) do_pulse(0);

        do_pulse(4);

        #20000;

        $stop;
    end

endmodule
