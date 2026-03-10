`timescale 1ns / 1ps

module digit_selector(
    input clk,
    input reset,
    input clear,
    input lock_mode,
    input blinking,

    input up_pulse,
    input down_pulse,
    input left_pulse,
    input right_pulse,

    output reg [1:0] cursor_pos,  
    output reg [3:0] d1, d2, d3, d4
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            d1 <= 0; d2 <= 0; d3 <= 0; d4 <= 0;
            cursor_pos <= 0;  
        end
        else if (clear) begin
            d1 <= 0; d2 <= 0; d3 <= 0; d4 <= 0;
            cursor_pos <= 0;
        end
        else if (!lock_mode && !blinking) begin
        
            
            if (right_pulse && cursor_pos < 3) cursor_pos <= cursor_pos + 1;
            if (left_pulse  && cursor_pos > 0) cursor_pos <= cursor_pos - 1;

            case (cursor_pos)
                2'd0: begin
                    if (up_pulse   && d4 < 9) d4 <= d4 + 1;
                    if (down_pulse && d4 > 0) d4 <= d4 - 1;
                end
                2'd1: begin
                    if (up_pulse   && d3 < 9) d3 <= d3 + 1;
                    if (down_pulse && d3 > 0) d3 <= d3 - 1;
                end
                2'd2: begin
                    if (up_pulse   && d2 < 9) d2 <= d2 + 1;
                    if (down_pulse && d2 > 0) d2 <= d2 - 1;
                end
                2'd3: begin
                    if (up_pulse   && d1 < 9) d1 <= d1 + 1;
                    if (down_pulse && d1 > 0) d1 <= d1 - 1;
                end
            endcase
        end
    end

endmodule
