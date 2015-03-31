// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
// CREATED		"Wed Apr 01 00:55:28 2015"

module tutorial(
	a,
	b,
	c,
	d,
	r,
	out
);


input wire	a;
input wire	b;
input wire	c;
input wire	d;
input wire	r;
output wire	[4:0] out;

wire	[3:0] in;





incrementer	b2v_inst(
	.in(in),
	.out(out));

assign	in[0] = a & r;

assign	in[1] = b & r;

assign	in[2] = c & r;

assign	in[3] = d & r;


endmodule
