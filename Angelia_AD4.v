//  David Fainitski N7DDC
//  for Odyssey-2 project
//  MCP3202 control
// modified eu1sw for MCP3204 control
// CS/ --|_____________________________________________________________________________________________________|--------
// CLK --|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--
// DIN      1     1     CH    1  ---------------------------------
// DOUT  ---------------------------0     B11   B10    B9   B8    B7    B6    B5    B4    B3    B2    B1    B0

module Angelia_AD4(clock, SCLK, nCS, MISO, MOSI, AIN1, AIN2);

input  wire       clock;
output reg        SCLK;
output reg        nCS;
input  wire       MISO;
output reg        MOSI;
output reg [11:0] AIN1; // 
output reg [11:0] AIN2; // 


reg   [5:0] ADC_state = 1'd0;
reg   [3:0] bit_cnt;
reg  [12:0] temp_1;	
reg  [12:0] temp_2;
reg CH = 0;


// NOTE: this code generates the SCLK clock for the ADC
always @ (posedge clock)
begin
  case (ADC_state)
  0:
	begin
    nCS <= 1;          // set nCS high
    bit_cnt <= 4'd12;         // set bit counter
	 CH <= ~CH;
    ADC_state <= ADC_state + 1'd1;
	end
	
  1:
	begin
    nCS  <= 0;             		// select ADC
	 SCLK <= 0;
    MOSI      <= 1; // START bit
    ADC_state <= ADC_state + 1'd1;
	end
	
  2:
	begin
    SCLK      <= 1;          // SCLK high
    ADC_state <= ADC_state + 1'd1;
	end
	
  3:
	begin
    SCLK      <= 0;          // SCLK low
	 MOSI      <= 1; // SGL/DIFF bit
    ADC_state <= ADC_state + 1'd1;
	end

   4:
	begin
    SCLK      <= 1;          // SCLK high
    ADC_state <= ADC_state + 1'd1;
	end

		5:
			begin
		    SCLK      <= 0;          // SCLK low
			 MOSI      <= 1; // D2 bit
		    ADC_state <= ADC_state + 1'd1;
			end
		
		   6:
			begin
		    SCLK      <= 1;          // SCLK high
		    ADC_state <= ADC_state + 1'd1;
			end
		7:
			begin
		    SCLK      <= 0;          // SCLK low
			 MOSI      <= 1; // D1 bit
		    ADC_state <= ADC_state + 1'd1;
			end
		
		   8:
			begin
		    SCLK      <= 1;          // SCLK high
		    ADC_state <= ADC_state + 1'd1;
			end
	
		  9:
			begin
		    SCLK      <= 0;          // SCLK low
			 MOSI <= CH; // Channel select
		    ADC_state <= ADC_state + 1'd1;
			end
			
			10:
			begin
		    SCLK      <= 1;          // SCLK high
		    ADC_state <= ADC_state + 1'd1;
			end
		
			11:
			begin
		    SCLK      <= 0;          // SCLK low
		    ADC_state <= ADC_state + 1'd1;
			end
			
			12:
			begin
		    SCLK      <= 1;          // SCLK high
		    ADC_state <= ADC_state + 1'd1;
			end
			13:
			begin
		    SCLK      <= 0;          // SCLK low
		    ADC_state <= ADC_state + 1'd1;
			end
			
			14:
			begin
		    SCLK      <= 1;          // SCLK high
		    ADC_state <= ADC_state + 1'd1;
			end
	
	
  15:
	begin
    SCLK      <= 0;          // SCLK low
    ADC_state <= ADC_state + 1'd1;
	end
	
	16:
	begin
    SCLK      <= 1;          // SCLK high
    ADC_state <= ADC_state + 1'd1;
	end
	
	17:
	begin
	 if(CH) temp_1[bit_cnt] <= MISO; else temp_2[bit_cnt] <= MISO;
    SCLK      <= 0;          // SCLK low
	 ADC_state <= ADC_state + 1'd1;
	end 
	
  18:
    if(bit_cnt == 0) 
	 begin 
	   if(CH) AIN1 <= temp_1[11:0]; else AIN2 <= temp_2[11:0];
		ADC_state <= 1'd0;
	 end	
	 else
	 begin 
	   bit_cnt <= bit_cnt - 1'd1;
      ADC_state <= 6'd16;
	 end

  default:
    ADC_state <= 0;
  endcase
end 



endmodule 

