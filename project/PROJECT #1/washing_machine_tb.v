`timescale 1ns/1ps

module washing_machine_tb;
    // Inputs
    reg clk;
    reg reset;
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
    reg [1:0] temp_select;     // 2'b00 = Cold, 2'b01 = Warm, 2'b10 = Hot
    reg [1:0] cloth_type;      // 2'b00 = Cotton, 2'b01 = others
    reg [1:0] cycle_duration;  // 2'b00 = 30 min, 2'b01 = 45 min, 2'b10 = 60 min

    // Outputs
    wire lock_door;
    wire fill_water;
    wire wash;
    wire rinse;
    wire spin;
    wire drain;
    wire dry;

    // Instantiate the module under test
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
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
        temp_select = 2'b00;       // Cold
        cloth_type = 2'b00;        // Cotton
        cycle_duration = 2'b01;    // 45 min

        // Reset pulse
        #10 reset = 0;
        #10 reset = 1;
        #10 reset = 0;

        // Start washing cycle
        #10 start = 1;
        #10 start = 0;

        // Door lock simulation
        #20 door_locked = 1;
        #10 door_locked = 0;

        // Filling water
        #10 fill_done = 1;
        #10 fill_done = 0;

        // Washing
        #10 wash_done = 1;
        #10 wash_done = 0;

        // Rinsing
        #10 rinse_done = 1;
        #10 rinse_done = 0;

        // Spinning
        #10 spin_done = 1;
        #10 spin_done = 0;

        // Draining
        #10 drain_done = 1;
        #10 drain_done = 0;

        // Drying
        #10 dry_done = 1;
        #10 dry_done = 0;

        // Cycle Complete
        #20;

        // Test pause and resume functionality
        #10 start = 1;
        #10 start = 0;
        #10 door_locked = 1;
        #10 fill_done = 1;
        #10 wash_done = 1;

        // Pause during rinse
        #10 pause = 1;
        #10 pause = 0;

        // Resume
        #10 resume = 1;
        #10 resume = 0;

        // Complete the cycle
        rinse_done = 1;
        #10 rinse_done = 0;
        #10 spin_done = 1;
        #10 spin_done = 0;
        #10 drain_done = 1;
        #10 drain_done = 0;
        #10 dry_done = 1;
        #10 dry_done = 0;

        #20 $stop;  // End of simulation
    end
endmodule
