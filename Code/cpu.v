module CPU(clk);
	input clk;
	//define regs for inputs
	reg [7:0]AC =0 ; 
	reg [3:0]PC = 0;
	//auxiliary regs
	reg [2:0]SC = 0;
	reg [3:0]AR;
	reg [7:0]IR;
	reg [2:0]opcode;
	reg I; 
	reg IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7;
	reg [7:0]M[0:15]; //16 x 8bit memory
	//assignments
	initial
	begin
	M[0] = 8'b00001000;
	M[1] = 8'b00011000;
	M[2] = 8'b00101000;
	M[3] = 8'b00111000;
	M[4] = 8'b01001000;
	M[5] = 8'b01011000;
	M[6] = 8'b01101000;
	M[7] = 8'b10001001;
	M[8] = 8'b00001001;
	M[9] = 8'b00001000;
	M[10] = 8'b00001000;
	M[11] = 8'b00001001;
	M[12] = 8'b00001000;
	M[13] = 8'b00001000;
	M[14] = 8'b00001001;
	M[15] = 8'b00001000;
	end
	
	always @ (posedge clk)
	begin 
		case(SC)
		3'b000: begin
			AR[3:0] = PC[3:0];
			SC = SC + 1;
			end
		3'b001: begin
			PC = PC + 1;
		       {IR} = {M[AR]};
			SC = SC + 1;
			end
		3'b010: begin
			IR7 = IR[7];
			IR6 = IR[6];
			IR5 = IR[5];
			IR4 = IR[4];
			IR3 = IR[3];
			IR2 = IR[2];
			IR1 = IR[1];
			IR0 = IR[0];
			I = IR7;
			{opcode} = {IR6, IR5, IR4};
			{AR} = {IR3, IR2, IR1, IR0};
			SC = SC + 1;
			end
		3'b011: begin
                        if (I == 1)
				assign {AR} = {M[AR]};
                        SC = SC + 1;
                        end
		3'b100: begin
			case(opcode)
			3'b000: begin
				AC = AC + M[AR]; 
				SC = 0;
				end
			3'b001: begin
				AC = AC - M[AR];
				SC = 0;
				end
			3'b010: begin
				AC = AC ^ M[AR];
				SC = 0;
				end
			3'b011: begin
				M[AR] = M[AR] + M[AR]; 
				SC = 0;
				end
			3'b100: begin
				AC = M[AR];
				SC = 0;
				end
			3'b101: begin
				M[AR] = AC; 
				SC = 0;
				end
			3'b110: begin
				M[AR] = ~M[AR];
				SC = 0;
				end
			endcase
			end 
		endcase
	end
endmodule

module test_bench;
	reg clk;

	CPU cpu(.clk(clk));
	initial
	begin
		clk <= 0;

		#500
		$finish;
	end

	always #5 clk = ~clk;
endmodule