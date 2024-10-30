module washing_machine (
    input clk,
    input reset,
    input start,
    input door_locked,
    input fill_done,
    input wash_done,
    input rinse_done,
    input spin_done,
    input drain_done,
    input dry_done,
    input pause,
    input resume,
    input [1:0] temp_select,    // 2'b00 = Cold, 2'b01 = Warm, 2'b10 = Hot
    input [1:0] cloth_type,     // 2'b00 = Cotton, 2'b01 = others
    input [1:0] cycle_duration, // 2'b00 = 30 min, 2'b01 = 45 min, 2'b10 = 60 min

//======================================================================================

    output reg lock_door,
    output reg fill_water,
    output reg wash,
    output reg rinse,
    output reg spin,
    output reg drain,
    output reg dry

);

//states of the 4bits decalaration

    parameter IDLE        = 4'b0000;
    parameter SELECT      = 4'b0001;
    parameter LOCK_DOOR   = 4'b0010;
    parameter FILL        = 4'b0011;
    parameter WASH        = 4'b0100;
    parameter RINSE       = 4'b0101;
    parameter SPIN        = 4'b0110;
    parameter DRAIN       = 4'b0111;
    parameter DRY         = 4'b1000;
    parameter COMPLETE    = 4'b1001;
    parameter PAUSE       = 4'b1010;
    parameter CONTINUE    = 4'b1011;

    reg [3:0] current_state, next_state;
    reg [3:0] previous_state;


    always @(posedge clk or posedge reset)begin
        if (reset) begin
            current_state <= IDLE;
            end 
        else
            current_state <=next_state;
end

    always @(*) begin
        // init assignments
        next_state = current_state;
        lock_door = 0;
        fill_water = 0;
        wash = 0;
        rinse = 0;
        spin = 0;
        drain = 0;
        dry = 0;

    case (current_state)

        IDLE : begin
            if(start) 
                next_state = SELECT;
        end 

        SELECT : begin
            if(door_locked)
                next_state = LOCK_DOOR;
            lock_door = 1;
            if (pause) begin
                    previous_state = SELECT;
                    next_state = PAUSE;
                end
        end

        LOCK_DOOR : begin
            // lock_door = 1;
            if(door_locked)
                next_state = FILL;
            if (pause) begin
                previous_state = LOCK_DOOR;
                next_state = PAUSE;
            end
        end

        FILL : begin
        fill_water = 1;
            if(fill_done)
                next_state = WASH;
            if (pause) begin
                previous_state = FILL;
                next_state = PAUSE;
            end
        end

        WASH : begin
        wash = 1;
            if(wash_done)
                next_state = RINSE;
            if (pause) begin
                previous_state = WASH;
                next_state = PAUSE;
            end
        end

        RINSE : begin
        rinse = 1;
            if(rinse_done)
                next_state = SPIN;
            if (pause) begin
                previous_state = RINSE;
                next_state = PAUSE;
            end
        end

        SPIN : begin
        spin = 1;
            if(spin_done) 
                next_state = DRAIN;
            if (pause) begin
                    previous_state = SPIN;
                    next_state = PAUSE;
            end
        end

        DRAIN : begin
        drain = 1;
        if (drain_done)
            next_state = DRY;
        if (pause) begin
            previous_state = DRAIN;
            next_state = PAUSE;
            end
        end

        DRY : begin
        dry = 1;
            if(dry_done)
                next_state = COMPLETE;
            if (pause) begin
                previous_state = DRY;
                next_state = PAUSE;
            end
        end

        COMPLETE : begin
        next_state = IDLE;
        if (pause) begin
            previous_state = COMPLETE;
            next_state = PAUSE;
            end
        end

//ADDED STATES LESA NOT IMPLEMENTED

        PAUSE: begin
            if (resume) next_state = CONTINUE;
        end
        CONTINUE: begin
            next_state = previous_state; // Continue from where it left off
        end

        default: next_state = IDLE;
    endcase
end
    
endmodule