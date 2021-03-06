module box_computeAABB(
	input clk, rst,
	input[31:0] x, y, z,
	input[31:0] side0, side1, side2,
	input[31:0] r0, r1, r2, r4, r5, r6, r8, r9, r10,
	output[31:0] aabb0, aabb1, aabb2, aabb3, aabb4, aabb5,
	output done
);

///////////////////////////////////////////////////////////
//calculating xrange, used in aabb[0] and aabb[1] calculation

//xrange = (abs(r0 * side0)/2) + (abs(r1 * side1)/2) + (abs(r2 * side2)/2)
wire[31:0] xrange;
	//R[0] * side0
	wire[31:0] r0side0;
	wire done_r0side0;
	wire output_z_ack_r0side0;
	wire input_a_ack_r0side0;
	wire input_b_ack_r0side0;
	multiplier mult_r0side0(
		.input_a(r0),
		.input_b(side0),
		.input_a_stb(1'b1),
		.input_b_stb(1'b1),
		.output_z_ack(output_z_ack_r0side0),
		.clk(clk),
		.rst(rst),
		.output_z(r0side0),
		.output_z_stb(done_r0side0),
		.input_a_ack(input_a_ack_r0side0),
		.input_b_ack(input_b_ack_r0side0)
	);
	
	//R[1] * side1
	wire[31:0] r1side1;
	wire done_r1side1;
	wire output_z_ack_r1side1;
	wire input_a_ack_r1side1;
	wire input_b_ack_r1side1;
	multiplier mult_r1side1(
		.input_a(r1),
		.input_b(side1),
		.input_a_stb(1'b1),
		.input_b_stb(1'b1),
		.output_z_ack(output_z_ack_r1side1),
		.clk(clk),
		.rst(rst),
		.output_z(r1side1),
		.output_z_stb(done_r1side1),
		.input_a_ack(input_a_ack_r1side1),
		.input_b_ack(input_b_ack_r1side1)
	);
	
	//R[2] * side2
	wire[31:0] r2side2;
	wire done_r2side2;
	wire output_z_ack_r2side2;
	wire input_a_ack_r2side2;
	wire input_b_ack_r2side2;
	multiplier mult_r2side2(
		.input_a(r2),
		.input_b(side2),
		.input_a_stb(1'b1),
		.input_b_stb(1'b1),
		.output_z_ack(output_z_ack_r2side2),
		.clk(clk),
		.rst(rst),
		.output_z(r2side2),
		.output_z_stb(done_r2side2),
		.input_a_ack(input_a_ack_r2side2),
		.input_b_ack(input_b_ack_r2side2)
	);
	
		//abs(R[0] * side0)
		wire[31:0] r0side0_abs;
		assign r0side0_abs = (r0side0[31] == 1'b1) ? {~r0side0[31], r0side0[30:0]}:r0side0;
		
		//abs(R[1] * side1)
		wire[31:0] r1side1_abs;
		assign r1side1_abs = (r1side1[31] == 1'b1) ? {~r1side1[31], r1side1[30:0]}:r1side1;
		
		//abs(R[2] * side2)
		wire[31:0] r2side2_abs;
		assign r2side2_abs = (r2side2[31] == 1'b1) ? {~r2side2[31], r2side2[30:0]}:r2side2;
		
		wire[31:0] temp0;
		wire done_temp0;
		wire add_z_ack0;
		wire a_ack0;
		wire b_ack0;
		adder add_r01side01_abs(
			.input_a(r0side0_abs), 
			.input_b(r1side1_abs), 
			.input_a_stb(done_r0side0),
			.input_b_stb(done_r1side1),
			.output_z_ack(add_z_ack0),
			.clk(clk),
			.rst((done_r0side0 && done_r1side1)),
			.output_z(temp0),
			.output_z_stb(done_temp0),
			.input_a_ack(a_ack0),
			.input_b_ack(b_ack0)
		);
		
			wire[31:0] xsum_rside;
			wire done_xsum_rside;
			wire add_z_xsum_rside;
			wire a_ack_xsum_rside;
			wire b_ack_xsum_rside;
			adder add_xsum_rside(
				.input_a(temp0), 
				.input_b(r2side2_abs), 
				.input_a_stb(done_temp0),
				.input_b_stb(done_r2side2),
				.output_z_ack(add_z__xsum_rside),
				.clk(clk),
				.rst(done_temp0),
				.output_z(xsum_rside),
				.output_z_stb(done_xsum_rside),
				.input_a_ack(a_ack_xsum_rside),
				.input_b_ack(b_ack_xsum_rside)
			);
		
				//xrange = xsum_rside/2
				wire done_xrange;
				wire mult_z_xrange;
				wire a_ack_xrange;
				wire b_ack_xrange;
				divider divide_xsum_rside_2(
					.input_a(xsum_rside), 
					.input_b(32'b01000000000000000000000000000000),
					.input_a_stb(done_xsum_rside),
					.input_b_stb(1'b1),
					.output_z_ack(mult_z_xrange),
					.clk(clk),
					.rst(done_xsum_rside),
					.output_z(xrange),
					//.output_z(aabb0),
					.output_z_stb(done_xrange),
					.input_a_ack(a_ack_xrange),
					.input_b_ack(b_ack_xrange)
				);
	
///////////////////////////////////////////////////////////
//calculating yrange, used in aabb[2] and aabb[3] calculation

//yrange = (abs(r4 * side0)/2) + (abs(r5 * side1)/2) + (abs(r6 * side2)/2)
wire[31:0] yrange;
	//R[4] * side0
	wire[31:0] r4side0;
	wire done_r4side0;
	wire output_z_ack_r4side0;
	wire input_a_ack_r4side0;
	wire input_b_ack_r4side0;
	multiplier mult_r4side0(
		.input_a(r4),
		.input_b(side0),
		.input_a_stb(1'b1),
		.input_b_stb(1'b1),
		.output_z_ack(output_z_ack_r4side0),
		.clk(clk),
		.rst(rst),
		.output_z(r4side0),
		.output_z_stb(done_r4side0),
		.input_a_ack(input_a_ack_r4side0),
		.input_b_ack(input_b_ack_r4side0)
	);
	
	//R[5] * side1
	wire[31:0] r5side1;
	wire done_r5side1;
	wire output_z_ack_r5side1;
	wire input_a_ack_r5side1;
	wire input_b_ack_r5side1;
	multiplier mult_r5side1(
		.input_a(r5),
		.input_b(side1),
		.input_a_stb(1'b1),
		.input_b_stb(1'b1),
		.output_z_ack(output_z_ack_r5side1),
		.clk(clk),
		.rst(rst),
		.output_z(r5side1),
		.output_z_stb(done_r5side1),
		.input_a_ack(input_a_ack_r5side1),
		.input_b_ack(input_b_ack_r5side1)
	);
	
	//R[6] * side2
	wire[31:0] r6side2;
	wire done_r6side2;
	wire output_z_ack_r6side2;
	wire input_a_ack_r6side2;
	wire input_b_ack_r6side2;
	multiplier mult_r6side2(
		.input_a(r6),
		.input_b(side2),
		.input_a_stb(1'b1),
		.input_b_stb(1'b1),
		.output_z_ack(output_z_ack_r6side2),
		.clk(clk),
		.rst(rst),
		.output_z(r6side2),
		.output_z_stb(done_r6side2),
		.input_a_ack(input_a_ack_r6side2),
		.input_b_ack(input_b_ack_r6side2)
	);
	
		//abs(R[4] * side0)
		wire[31:0] r4side0_abs;
		assign r4side0_abs = (r4side0[31] == 1'b1) ? {~r4side0[31], r4side0[30:0]}:r4side0;
		
		//abs(R[5] * side1)
		wire[31:0] r5side1_abs;
		assign r5side1_abs = (r5side1[31] == 1'b1) ? {~r5side1[31], r5side1[30:0]}:r5side1;
		
		//abs(R[6] * side2)
		wire[31:0] r6side2_abs;
		assign r6side2_abs = (r6side2[31] == 1'b1) ? {~r6side2[31], r6side2[30:0]}:r6side2;
		
		wire[31:0] temp1;
		wire done_temp1;
		wire add_z_ack1;
		wire a_ack1;
		wire b_ack1;
		adder add_r41side41_abs(
			.input_a(r4side0_abs), 
			.input_b(r5side1_abs), 
			.input_a_stb(done_r4side0),
			.input_b_stb(done_r5side1),
			.output_z_ack(add_z_ack1),
			.clk(clk),
			.rst(done_r4side0 && done_r5side1),
			.output_z(temp1),
			.output_z_stb(done_temp1),
			.input_a_ack(a_ack1),
			.input_b_ack(b_ack1)
		);
		
			wire[31:0] ysum_rside;
			wire done_ysum_rside;
			wire add_z_ysum_rside;
			wire a_ack_ysum_rside;
			wire b_ack_ysum_rside;
			adder add_ysum_rside(
				.input_a(temp1), 
				.input_b(r6side2_abs), 
				.input_a_stb(done_temp1),
				.input_b_stb(done_r6side2),
				.output_z_ack(add_z_ysum_rside),
				.clk(clk),
				.rst(done_temp1 && done_r6side2),
				.output_z(ysum_rside),
				.output_z_stb(done_ysum_rside),
				.input_a_ack(a_ack_ysum_rside),
				.input_b_ack(b_ack_ysum_rside)
			);
		
				//yrange = ysum_rside/2
				wire done_yrange;
				wire mult_z_yrange;
				wire a_ack_yrange;
				wire b_ack_yrange;
				divider divide_ysum_rside_2(
					.input_a(ysum_rside), 
					.input_b(32'b01000000000000000000000000000000),
					.input_a_stb(done_ysum_rside),
					.input_b_stb(1'b1),
					.output_z_ack(mult_z_yrange),
					.clk(clk),
					.rst(done_ysum_rside),
					.output_z(yrange),
					.output_z_stb(done_yrange),
					.input_a_ack(a_ack_yrange),
					.input_b_ack(b_ack_yrange)
				);
	
	
///////////////////////////////////////////////////////////
//calculating zrange, used in aabb[4] and aabb[5] calculation

//zrange = (abs(r8 * side0)/2) + (abs(r9 * side1)/2) + (abs(r10 * side2)/2)
wire[31:0] zrange;
	//R[8] * side0
	wire[31:0] r8side0;
	wire done_r8side0;
	wire output_z_ack_r8side0;
	wire input_a_ack_r8side0;
	wire input_b_ack_r8side0;
	multiplier mult_r8side0(
		.input_a(r8),
		.input_b(side0),
		.input_a_stb(1'b1),
		.input_b_stb(1'b1),
		.output_z_ack(output_z_ack_r8side0),
		.clk(clk),
		.rst(rst),
		.output_z(r8side0),
		.output_z_stb(done_r8side0),
		.input_a_ack(input_a_ack_r8side0),
		.input_b_ack(input_b_ack_r8side0)
	);
	
	//R[9] * side1
	wire[31:0] r9side1;
	wire done_r9side1;
	wire output_z_ack_r9side1;
	wire input_a_ack_r9side1;
	wire input_b_ack_r9side1;
	multiplier mult_r9side1(
		.input_a(r9),
		.input_b(side1),
		.input_a_stb(1'b1),
		.input_b_stb(1'b1),
		.output_z_ack(output_z_ack_r9side1),
		.clk(clk),
		.rst(rst),
		.output_z(r9side1),
		.output_z_stb(done_r9side1),
		.input_a_ack(input_a_ack_r9side1),
		.input_b_ack(input_b_ack_r9side1)
	);
	
	//R[10] * side2
	wire[31:0] r10side2;
	wire done_r10side2;
	wire output_z_ack_r10side2;
	wire input_a_ack_r10side2;
	wire input_b_ack_r10side2;
	multiplier mult_r10side2(
		.input_a(r10),
		.input_b(side2),
		.input_a_stb(1'b1),
		.input_b_stb(1'b1),
		.output_z_ack(output_z_ack_r10side2),
		.clk(clk),
		.rst(rst),
		.output_z(r10side2),
		.output_z_stb(done_r10side2),
		.input_a_ack(input_a_ack_r10side2),
		.input_b_ack(input_b_ack_r10side2)
	);
	
		//abs(R[8] * side0)
		wire[31:0] r8side0_abs;
		assign r8side0_abs = (r8side0[31] == 1'b1) ? {~r8side0[31], r8side0[30:0]}:r8side0;
		
		//abs(R[9] * side1)
		wire[31:0] r9side1_abs;
		assign r9side1_abs = (r9side1[31] == 1'b1) ? {~r9side1[31], r9side1[30:0]}:r9side1;
		
		//abs(R[10] * side2)
		wire[31:0] r10side2_abs;
		assign r10side2_abs = (r10side2[31] == 1'b1) ? {~r10side2[31], r10side2[30:0]}:r10side2;
		
		wire[31:0] temp2;
		wire done_temp2;
		wire add_z_ack2;
		wire a_ack2;
		wire b_ack2;
		adder add_r81side81_abs(
			.input_a(r8side0_abs), 
			.input_b(r9side1_abs), 
			.input_a_stb(done_r8side0),
			.input_b_stb(done_r9side1),
			.output_z_ack(add_z_ack1),
			.clk(clk),
			.rst(done_r8side0 && done_r9side1),
			.output_z(temp2),
			.output_z_stb(done_temp2),
			.input_a_ack(a_ack2),
			.input_b_ack(b_ack2)
		);
		
			wire[31:0] zsum_rside;
			wire done_zsum_rside;
			wire add_z_zsum_rside;
			wire a_ack_zsum_rside;
			wire b_ack_zsum_rside;
			adder add_zsum_rside(
				.input_a(temp2), 
				.input_b(r10side2_abs), 
				.input_a_stb(done_temp2),
				.input_b_stb(done_r10side2),
				.output_z_ack(add_z_zsum_rside),
				.clk(clk),
				.rst(done_temp2 && done_r10side2),
				.output_z(zsum_rside),
				.output_z_stb(done_zsum_rside),
				.input_a_ack(a_ack_zsum_rside),
				.input_b_ack(b_ack_zsum_rside)
			);
		
				//zrange = zsum_rside/2
				wire done_zrange;
				wire mult_z_zrange;
				wire a_ack_zrange;
				wire b_ack_zrange;
				divider divide_zsum_rside_2(
					.input_a(zsum_rside), 
					.input_b(32'b01000000000000000000000000000000),
					.input_a_stb(done_zsum_rside),
					.input_b_stb(1'b1),
					.output_z_ack(mult_z_zrange),
					.clk(clk),
					.rst(done_zsum_rside),
					.output_z(zrange),
					.output_z_stb(done_zrange),
					.input_a_ack(a_ack_zrange),
					.input_b_ack(b_ack_zrange)
				);
	
///////////////////////////////////////////////////////////		
//compute AABBs after dependencies are calculated
					
					wire[31:0] xrange_neg;
					assign xrange_neg = {~xrange[31], xrange[30:0]};
					
					wire[31:0] yrange_neg;
					assign yrange_neg = {~yrange[31], yrange[30:0]};
					
					wire[31:0] zrange_neg;
					assign zrange_neg = {~zrange[31], zrange[30:0]};
					
					//aabb0 = x - xrange
					wire done_a0;
					wire add_z_a0;
					wire a_ack_a0;
					wire b_ack_a0;
					adder add_a0(
						.input_a(x), 
						.input_b(xrange_neg), 
						.input_a_stb(done_xrange),
						.input_b_stb(1'b1),
						.output_z_ack(add_z_a0),
						.clk(clk),
						.rst(done_xrange),
						.output_z(aabb0),
						.output_z_stb(done_a0),
						.input_a_ack(a_ack_a0),
						.input_b_ack(b_ack_a0)
					);
				
					//aabb1 = x + xrange
					wire done_a1;
					wire add_z_a1;
					wire a_ack_a1;
					wire b_ack_a1;
					adder add_a1(
						.input_a(x), 
						.input_b(xrange), 
						.input_a_stb(done_xrange),
						.input_b_stb(1'b1),
						.output_z_ack(add_z_a0),
						.clk(clk),
						.rst(done_xrange),
						.output_z(aabb1),
						.output_z_stb(done_a1),
						.input_a_ack(a_ack_a1),
						.input_b_ack(b_ack_a1)
					);
					
					//aabb2 = y - yrange
					wire done_a2;
					wire add_z_a2;
					wire a_ack_a2;
					wire b_ack_a2;
					adder add_a2(
						.input_a(y), 
						.input_b(yrange_neg), 
						.input_a_stb(done_yrange),
						.input_b_stb(1'b1),
						.output_z_ack(add_z_a2),
						.clk(clk),
						.rst(done_yrange),
						.output_z(aabb2),
						.output_z_stb(done_a2),
						.input_a_ack(a_ack_a2),
						.input_b_ack(b_ack_a2)
					);
					
					//aabb3 = y + yrange
					wire done_a3;
					wire add_z_a3;
					wire a_ack_a3;
					wire b_ack_a3;
					adder add_a3(
						.input_a(y), 
						.input_b(yrange), 
						.input_a_stb(done_yrange),
						.input_b_stb(1'b1),
						.output_z_ack(add_z_a3),
						.clk(clk),
						.rst(done_yrange),
						.output_z(aabb3),
						.output_z_stb(done_a3),
						.input_a_ack(a_ack_a3),
						.input_b_ack(b_ack_a3)
					);
					
					
					//aabb4 = z - zrange
					wire done_a4;
					wire add_z_a4;
					wire a_ack_a4;
					wire b_ack_a4;
					adder add_a4(
						.input_a(z), 
						.input_b(zrange_neg), 
						.input_a_stb(done_zrange),
						.input_b_stb(1'b1),
						.output_z_ack(add_z_a4),
						.clk(clk),
						.rst(done_zrange),
						.output_z(aabb4),
						.output_z_stb(done_a4),
						.input_a_ack(a_ack_a4),
						.input_b_ack(b_ack_a4)
					);
					
					//aabb5 = z + zrange
					wire done_a5;
					wire add_z_a5;
					wire a_ack_a5;
					wire b_ack_a5;
					adder add_a5(
						.input_a(z), 
						.input_b(zrange), 
						.input_a_stb(done_zrange),
						.input_b_stb(1'b1),
						.output_z_ack(add_z_a5),
						.clk(clk),
						.rst(done_zrange),
						.output_z(aabb5),
						.output_z_stb(done_a5),
						.input_a_ack(a_ack_a5),
						.input_b_ack(b_ack_a5)
					);
					
					//done signal
					assign done = done_a0 && done_a1 && done_a2 && done_a3 && done_a4 && done_a5;

endmodule