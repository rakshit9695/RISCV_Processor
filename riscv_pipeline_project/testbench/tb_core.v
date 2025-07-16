// Simple testbench for EDA Playground
`timescale 1ns/1ps
module tb_core;
    logic clk = 0, rst = 1;

    riscv_core DUT(.clk(clk), .rst(rst));

    // clock generator
    always #5 clk = ~clk;

    // test program & stimulus
    initial begin
        // tiny program: x1=5; x2=7; x3 = x1 + x2; loop: beq x3,x3,loop
        // assembled with objdump -> hex
        $readmemh("program.hex", DUT.imem.mem);
        #12 rst = 0;      // release reset after a few cycles
        #400 $finish;
    end
endmodule
