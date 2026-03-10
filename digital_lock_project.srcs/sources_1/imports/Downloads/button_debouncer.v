`timescale 1ns / 1ps

module button_debouncer(
    input clk,
    input reset,
    input noisy_in,
    output reg clean_pulse
);
    
    localparam COUNT_MAX = 100000;

    reg [16:0] counter = 0;
    reg sync_0, sync_1;
    reg stable_state = 0;
    reg last_state = 0;
    
    always @(posedge clk) begin
        sync_0 <= noisy_in;
        sync_1 <= sync_0;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            stable_state <= 0;
            last_state <= 0;
            clean_pulse <= 0;
        end else begin

            if (sync_1 == stable_state) begin
                
                counter <= 0;
                clean_pulse <= 0;
            end
            else begin
                
                counter <= counter + 1;

                if (counter >= COUNT_MAX) begin
                    counter <= 0;
                    stable_state <= sync_1;

                    
                    if (stable_state == 1 && last_state == 0)
                        clean_pulse <= 1;
                    else
                        clean_pulse <= 0;

                    last_state <= stable_state;
                end else begin
                    clean_pulse <= 0;
                end
            end
        end
    end

endmodule

