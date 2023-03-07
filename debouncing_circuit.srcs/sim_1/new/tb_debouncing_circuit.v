`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 28.02.2023 01:07:27
// Design Name: This design used for debouncing_circuit clock generation testbench
// Module Name: tb_debouncing_circuit
// Project Name: 
// Target Devices: BASYS 3
// Tool Versions: Vivado 2020.2
// Description: This file defined for clock generation module testing.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_debouncing_circuit;

reg  clk_tb = 1'b0, reset_tb = 1'b0, pin_in_tb = 1'b0;
wire pin_out_tb;

debouncing_circuit  tb_debouncing_circuit(	.pin_out(pin_out_tb),
										    .clk    (clk_tb    ),
										    .reset  (reset_tb  ),
										    .pin_in (pin_in_tb ));
	
always @(*)
begin
	if (clk_tb)
		#5 clk_tb <= 1'b0; 
	else
		#5 clk_tb <= 1'b1;
end
	
initial
begin
	pin_in_tb = 1'b0;
	reset_tb  = 1'b0;
	@(posedge clk_tb);
	pin_in_tb = 1'b1;
	repeat(100000000) @(posedge clk_tb);
	$stop;
end

endmodule