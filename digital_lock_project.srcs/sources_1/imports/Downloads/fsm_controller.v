`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2025 08:04:26 PM
// Design Name: 
// Module Name: fsm_controller
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

module fsm_controller(
    input clk,
    input reset,

    input check_mode,
    input clear_sw,
    input ok_pulse,
    input match,

    input clk_flash,      

    output reg correct_led,
    output reg wrong_led,

    output reg blinking,
    output reg clear_digits
);

    localparam S_IDLE  = 0;
    localparam S_BLINK = 1;

    reg state = S_IDLE;

    reg [4:0] blink_target = 0;
    reg [4:0] blink_step   = 0;
    reg led_state = 0;

    reg blink_is_correct;
    reg clk_flash_d;
    reg match_latched;
    
    always @(posedge clk or posedge reset) begin
    if (reset)
        clk_flash_d <= 0;
    else
        clk_flash_d <= clk_flash;
end

wire flash_tick = clk_flash & ~clk_flash_d;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
    state <= S_IDLE;
    blinking <= 0;
    clear_digits <= 0;
    correct_led <= 0;
    wrong_led <= 0;
    blink_step <= 0;
    led_state <= 0;
    blink_is_correct <= 0;
end 
        
        else begin

            
            if (clear_sw) begin
                state <= S_IDLE;
                blinking <= 0;
                clear_digits <= 1;
                correct_led <= 0;
                wrong_led <= 0;
            end else begin
                clear_digits <= 0;
            end

            case (state)
            
            S_IDLE: begin
                blinking <= 0;
                correct_led <= 0;
                wrong_led <= 0;
                blink_step <= 0;

                if (check_mode && ok_pulse) begin
                    state <= S_BLINK;
                    blinking <= 1;

                    blink_step <= 0;
                    led_state <= 1;
                    
                    match_latched <= match;
    
                    if (match) begin
                        correct_led <= 1;
                        wrong_led <= 0;
                        blink_target <= 2;
                        blink_is_correct <= 1;
                    end else begin
                        correct_led <= 0;
                        wrong_led <= 1;
                        blink_target <= 2;
                        blink_is_correct <= 0;
                        match_latched <= 0;
                    end
                end
            end
            
            S_BLINK: begin
                if (flash_tick) begin
                    led_state <= ~led_state;
                    blink_step <= blink_step + 1;

                    correct_led <= blink_is_correct ? led_state : 0;
                    wrong_led   <= blink_is_correct ? 0 : led_state;

                    if (blink_step == blink_target || led_state == 0) begin
                        blinking <= 0;

                        correct_led <= 0;
                        wrong_led <= 0;

                        if (blink_is_correct)
                            clear_digits <= 1;

                        state <= S_IDLE;
                    end
                end
            end
            endcase
        end
    end

endmodule
