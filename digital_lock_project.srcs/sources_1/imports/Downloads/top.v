`timescale 1ns / 1ps

module top(
    input clk,
    input [3:0] sw,
    input btnU, btnL, btnD, btnR, btnC,

    output [7:0] seg,
    output [7:0] an,
    output [15:0] led
);

    wire reset      = sw[0];
    wire check_mode = sw[1];
    wire clear_sw   = sw[2];
    wire lock_mode  = ~sw[1];
    
    wire up_pulse, left_pulse, down_pulse, right_pulse, ok_pulse;
    button_debouncer dbU(.clk(clk), .reset(reset), .noisy_in(btnU), .clean_pulse(up_pulse));
    button_debouncer dbL(.clk(clk), .reset(reset), .noisy_in(btnL), .clean_pulse(left_pulse));
    button_debouncer dbD(.clk(clk), .reset(reset), .noisy_in(btnD), .clean_pulse(down_pulse));
    button_debouncer dbR(.clk(clk), .reset(reset), .noisy_in(btnR), .clean_pulse(right_pulse));
    button_debouncer dbC(.clk(clk), .reset(reset), .noisy_in(btnC), .clean_pulse(ok_pulse));
    
    wire clk_scan, clk_flash;
    clock_divider div(
        .clk(clk),
        .reset(reset),
        .clk_scan(clk_scan),
        .clk_flash(clk_flash)
    );
    
    wire [3:0] d1, d2, d3, d4;
    wire [1:0] cursor_pos;
    wire blinking, clear_digits;

    digit_selector sel(
        .clk(clk),
        .reset(reset),
        .clear(clear_digits),
        .lock_mode(lock_mode),
        .blinking(blinking),

        .up_pulse(up_pulse),
        .down_pulse(down_pulse),
        .left_pulse(left_pulse),
        .right_pulse(right_pulse),

        .cursor_pos(cursor_pos),
        .d1(d1), .d2(d2), .d3(d3), .d4(d4)
    );
    
    wire match = (d4 == 9 && d3 == 5 && d2 == 2 && d1 == 7);
    
    wire correct_led, wrong_led;
    fsm_controller fsm(
        .clk(clk),
        .reset(reset),
        .check_mode(check_mode),
        .clear_sw(clear_sw),
        .ok_pulse(ok_pulse),
        .match(match),
        .clk_flash(clk_flash),

        .correct_led(correct_led),
        .wrong_led(wrong_led),
        .blinking(blinking),
        .clear_digits(clear_digits)
    );
    
    seven_segment_driver disp(
        .clk_scan(clk_scan),
        .d1(d1), .d2(d2), .d3(d3), .d4(d4),
        .seg(seg),
        .an(an)
    );
    
    assign led[0] = reset;
    assign led[1] = check_mode;
    assign led[2] = clear_sw;
    assign led[3] = correct_led;
    assign led[4] = wrong_led;
    assign led[15:5] = 0;

endmodule