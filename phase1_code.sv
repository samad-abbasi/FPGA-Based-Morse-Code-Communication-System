module phase1(
input logic [3:0]number,
input logic clk, btn1, rst,
output logic led
);

    logic [4:0]morse;
logic [2:0]mcount;
    
always @(*) begin //mapping the morse code 0 for dot and 1 for dash
    case(number)
        4'd0: morse = 5'b11111; // -----
        4'd1: morse = 5'b11110; // .----
        4'd2: morse = 5'b11100; // ..---
        4'd3: morse = 5'b11000; // ...--
        4'd4: morse = 5'b10000; // ....-
        4'd5: morse = 5'b00000; // .....
        4'd6: morse = 5'b00001; // -....
        4'd7: morse = 5'b00011; // --...
        4'd8: morse = 5'b00111; // ---..
        4'd9: morse = 5'b01111; // ----.
        default: morse = 5'b00000;
    endcase
end

parameter IDLE = 2'd0, //three states idle -> OFF
          ON   = 2'd1, //ON for 1s, 3s depending on dot or dash
          OFF  = 2'd2; //OFF for 0.5 seconds

	//these will changed for hardware implementation
    parameter HALF_SEC  = 5; 
    parameter ONE_SEC   = 10;
    parameter THREE_SEC = 30;



    logic [2:0] state ;
    logic [28:0] count; 


    assign led = (state == ON);

    always @(posedge clk or posedge rst) begin
	if(rst) begin
    	    state  <= IDLE;
	    count  <= 0;
	    mcount <= 0;
	end
	else begin
        case(state)

            IDLE: begin
                count <= 0;
                if(btn1)begin 
                    state <= ON;
    		    mcount <= 0;
		end
            end

            ON: begin
		    //if dot run for 1s if dash run for 3s
	if(count == (morse[mcount] ? THREE_SEC : ONE_SEC)) begin
                    count <= 0;
                    state <= OFF;

                end else
                    count <= count + 1;
            end

           
OFF: begin
    if(count == HALF_SEC) begin
        count <= 0;

        if(mcount == 5)begin
  	  state <= IDLE;
       	  mcount <= 0;
        end   
      
        else begin
          mcount <= mcount + 1;
          state <= ON;    
        end
    end

    else
        count <= count + 1;
end

            default: begin
                state <= IDLE;
                count <= 0;
		mcount <= 0;
            end

        endcase
	end

end
endmodule
