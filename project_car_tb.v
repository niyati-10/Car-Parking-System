`timescale 1ns / 1ps

module project_car_tb;

  // Inputs
  reg clk;
  reg reset_n;
  reg entrance_sensor_input;
  reg exit_sensor_input;
  reg [1:0] password_1;
  reg [1:0] password_2;

  // Outputs
  wire GREEN_LED;
  wire RED_LED;
 // wire [6:0] HEX_1;
  //wire [6:0] HEX_2;
// fpga4student.com FPGA projects, Verilog projects, VHDL projects
  // Instantiate the Unit Under Test (UUT)
  project_car uut (
  .clk(clk),
  .reset_n(reset_n),
  .entrance_sensor_input(entrance_sensor_input),
  .exit_sensor_input(exit_sensor_input),
  .password_1(password_1),
  .password_2(password_2),
  .GREEN_LED(GREEN_LED),
  .RED_LED(RED_LED)
  //.HEX_1(HEX_1),
 //.HEX_2(HEX_2)
 );
 initial begin
 clk = 0;
 forever #10 clk = ~clk;
 end
 initial begin
 // Initialize Inputs
 reset_n = 0;
 entrance_sensor_input = 0;
 exit_sensor_input = 0;
 password_1 = 0;
 password_2 = 0;
 // Wait 100 ns for global reset to finish
 #100;
      reset_n = 1;
 #20;
 entrance_sensor_input = 1;
 #1000;
 entrance_sensor_input = 0;
 password_1 = 1;
 password_2 = 2;
 #2000;
 exit_sensor_input =1;
 
 // Add stimulus here
// fpga4student.com FPGA projects, Verilog projects, VHDL projects
 end
     
endmodule
