`timescale 1ns/1ps

module washing_machine_tb;
    
    // Clock and reset
    reg clk;
    reg reset;
    
    // Inputs
    reg start;
    reg door_locked;
    reg fill_done;
    reg wash_done;
    reg rinse_done;
    reg spin_done;
    reg drain_done;
    reg dry_done;
    reg pause;
    reg resume;
    reg [1:0] temp_select;
    reg [1:0] cloth_type;
    reg [1:0] cycle_duration;

    // Outputs
    wire lock_door;
    wire fill_water;
    wire wash;
    wire rinse;
    wire spin;
    wire drain;
    wire dry;
    
    // Instantiate the washing_machine module
    washing_machine uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .door_locked(door_locked),
        .fill_done(fill_done),
        .wash_done(wash_done),
        .rinse_done(rinse_done),
        .spin_done(spin_done),
        .drain_done(drain_done),
        .dry_done(dry_done),
        .pause(pause),
        .resume(resume),
        .temp_select(temp_select),
        .cloth_type(cloth_type),
        .cycle_duration(cycle_duration),
        .lock_door(lock_door),
        .fill_water(fill_water),
        .wash(wash),
        .rinse(rinse),
        .spin(spin),
        .drain(drain),
        .dry(dry)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initial Conditions
        clk = 0;
        reset = 1;
        start = 0;
        door_locked = 0;
        fill_done = 0;
        wash_done = 0;
        rinse_done = 0;
        spin_done = 0;
        drain_done = 0;
        dry_done = 0;
        pause = 0;
        resume = 0;
        temp_select = 2'b00;      // Default Cold
        cloth_type = 2'b00;       // Default Cotton
        cycle_duration = 2'b00;   // Default 30 min
        
        // Reset and start the machine
        #10 reset = 0;
        #10 start = 1;
        #10 door_locked = 1;      // Lock the door
        
        // Simulate the wash cycle steps
        #20 fill_done = 1;        // Fill complete
        #20 fill_done = 0;        // Reset fill_done
        #20 wash_done = 1;        // Wash complete
        #20 wash_done = 0;        // Reset wash_done
        #20 rinse_done = 1;       // Rinse complete
        #20 rinse_done = 0;       // Reset rinse_done
        #20 spin_done = 1;        // Spin complete
        #20 spin_done = 0;        // Reset spin_done
        #20 drain_done = 1;       // Drain complete
        #20 drain_done = 0;       // Reset drain_done
        #20 dry_done = 1;         // Dry complete
        #20 dry_done = 0;         // Reset dry_done
        
        // Test Pause and Resume in between cycle
        #20 pause = 1;
        #10 pause = 0;            // Simulate pausing
        
        #10 resume = 1;           // Resume the cycle
        #10 resume = 0;           // Clear resume
        
        #20 $stop;                // End simulation
    end
endmodule
