`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 27.02.2023 23:55:23
// Design Name: 
// Module Name: debouncing_circuit
// Project Name: Debouncing Circuit
// Target Devices: 
// Tool Versions: Vivado 2020.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncing_circuit
#(parameter freq     = 100000000,
			delay_ms = 1000      )
(
	input  wire clk, reset,
	input  wire pin_in,
	output reg  pin_out
);

localparam 	counter  = ((freq/delay_ms) * 1000 - 1),
			wait_to_1  = 2'b00,
			count_to_1 = 2'b01,
			wait_to_0  = 2'b10,
			count_to_0 = 2'b11;


/* Bu projede mealy model FSM uygulanacaktir. */

reg [31:0] counter_reg, counter_next;
reg [1 :0] state_reg  , state_next  ;
reg        tick_ok                  ;

/* Next state lojik begin */
always @(posedge clk, posedge reset)
begin
	if (reset)
		state_reg <= wait_to_1;
	else
		state_reg <= state_next;
end
/* Next state lojik end   */


always @(posedge clk)
begin
	counter_reg <= counter_next;
end

always @(*)
begin
	
	/* Default assigments */ 
	counter_next = 32'd0;
	pin_out      = 1'b0 ;
	tick_ok      = 1'b0 ;
	state_next   = 2'b00;
	/**********************/

	case (state_reg)
	
	wait_to_1:
	begin /* wait to 1 */
		counter_next = 32'd0;
		pin_out      = 1'b0 ;
		tick_ok      = 1'b0 ;
		
		if (pin_in)
			state_next = count_to_1;
		else
			state_next = wait_to_1;
			
	end /* wait to 1 */
	
	count_to_1:
	begin /* count_to_1 */
		counter_next = counter_reg + 1;
		
		if (counter_reg == counter)
			tick_ok = 1'b1;
		else
			tick_ok = 1'b0;
		
		if (tick_ok & pin_in)
			state_next = wait_to_0;
		else if((~tick_ok) & pin_in)
			state_next = count_to_1;
		else
			state_next = wait_to_1;
		
	end /* count_to_1 */
	
	wait_to_0:
	begin /* wait_to_0 */
	
		counter_next = 32'd0;
		pin_out      = 1'b1 ;
		tick_ok      = 1'b0 ;
		
		if (pin_in)
			state_next = wait_to_0;
		else
			state_next = count_to_0;
		
	end /* wait_to_0 */
	
	count_to_0:
	begin /* count_to_0 */
	
	
		counter_next = counter_reg + 1;
		
		if (counter_reg == counter)
			tick_ok = 1'b1;
		else
			tick_ok = 1'b0;
		
		if (tick_ok & (~pin_in))
			state_next = wait_to_1;
		else if((~tick_ok) & (~pin_in))
			state_next = count_to_0;
		else
			state_next = wait_to_0;
	
	end /* count_to_0 */
	
	endcase
end


endmodule
