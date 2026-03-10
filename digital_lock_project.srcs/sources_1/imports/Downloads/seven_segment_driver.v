`timescale 1ns / 1ps

module seven_segment_driver(
    input clk_scan,
    input enable_digits,

    input [1:0] cursor_pos,

    input show_correct,
    input show_wrong,

    input [3:0] d1,
    input [3:0] d2,
    input [3:0] d3,
    input [3:0] d4,

    output reg [7:0] seg,
    output reg [7:0] an
);

    reg [1:0] idx = 0;
    always @(posedge clk_scan)
        idx <= idx + 1;

    reg [3:0] val;

    always @(*) begin
        if (show_correct || show_wrong) begin
            case(idx)
                2'd0: begin an = 8'b1111_0111; val = d4; end // leftmost
                2'd1: begin an = 8'b1111_1011; val = d3; end
                2'd2: begin an = 8'b1111_1101; val = d2; end
                2'd3: begin an = 8'b1111_1110; 
                       val = show_correct ? 4'd1 : 4'd0; 
                end
            endcase
        end else begin
            case(idx)
                2'd0: begin an = 8'b1111_0111; val = d4; end
                2'd1: begin an = 8'b1111_1011; val = d3; end
                2'd2: begin an = 8'b1111_1101; val = d2; end
                2'd3: begin an = 8'b1111_1110; val = d1; end
            endcase
        end
    end
    
    always @(*) begin
        case(val)
            4'd0: seg[6:0] = 7'b1000000;
            4'd1: seg[6:0] = 7'b1111001;
            4'd2: seg[6:0] = 7'b0100100;
            4'd3: seg[6:0] = 7'b0110000;
            4'd4: seg[6:0] = 7'b0011001;
            4'd5: seg[6:0] = 7'b0010010;
            4'd6: seg[6:0] = 7'b0000010;
            4'd7: seg[6:0] = 7'b1111000;
            4'd8: seg[6:0] = 7'b0000000;
            4'd9: seg[6:0] = 7'b0010000;
            default: seg[6:0] = 7'b1111111;
        endcase

        seg[7] = 1;
    end

endmodule
