module phase_2(
    input  logic [3:0] number,
    input  logic       clk, btn1, btn2, rst, mode, //bt1 for write, btn2 for raed
    output logic       led
);

    logic [3:0] digits [0:5];//array of 6 elements each with lengh 4 bits
    logic [2:0] wr_index; //write index
    logic [2:0] rd_index; //read index

    logic [4:0] morse;

 
    logic [2:0] mcount; //morse count, used for bit by bit iteration of entered digit

    // these variables use to prevent the problem caused when pushbutton is kept pressed 
    logic btn1_prev;
    logic btn2_prev;

    // FSM states
    parameter IDLE = 2'd0, 
              ON   = 2'd1, //on for 1s or 3s 
              OFF  = 2'd2, //off for 0.5s
              GAP  = 2'd3; //off for 2s

	//these are temporary values, shoul be change when workikng with fpga
    parameter HALF_SEC  = 5;
    parameter ONE_SEC   = 10;
    parameter TWO_SEC   = 20;
    parameter THREE_SEC = 30;

    logic [1:0]  state;
    logic [28:0] count;

    // LED is ON only during ON state
    assign led = (state == ON);

    // Morse Coe mapping 0 -> dot and 1 -> dash
    always @(*) begin
        case (digits[rd_index])
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

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            count     <= 0;
            mcount    <= 0;
            wr_index  <= 0;
            rd_index  <= 0;
            btn1_prev <= 0;
            btn2_prev <= 0;
        end
        else begin
            btn1_prev <= btn1;
            btn2_prev <= btn2;

            case (state)

                IDLE: begin
                    count <= 0;

                    if (mode == 1'b0) begin
                        // phase 1: btn1 directly starts encoding the current number on switches
                        if (btn1 && !btn1_prev) begin
                            digits[0] <= number;
                            wr_index  <= 1;
                            rd_index  <= 0;
                            mcount    <= 0;
                            state     <= ON;
                        end
                    end
                    else begin //mode 2
                        if (btn1 && !btn1_prev && wr_index < 6) begin //btn1 && !btn1_prev makes sure data is not latched if button is kept pressed
                            digits[wr_index] <= number; //current number will saved to digits buffer upon pressing button 1 
                            wr_index         <= wr_index + 1; //goto next index after storing
                        end
                        else if (btn2 && !btn2_prev && wr_index != 0) begin //same thing for reading
                            rd_index <= 0;
                            mcount   <= 0;
                            state    <= ON;
                        end
                    end
                end

                
                ON: begin
		    //if current index of the current digit is 0 then wait one second, if 1 then wait three seconds
                    if (count == (morse[mcount] ? THREE_SEC : ONE_SEC)) begin
                        count <= 0;
                        state <= OFF;
                    end else
                        count <= count + 1;
                end

                // OFF: 0.5 s gap between Morse elements
                 OFF: begin
                    if (count == HALF_SEC) begin
                        count <= 0;

                        if (mcount == 4) begin
                            // All 5 elements (indices 0-4) transmitted
                            mcount <= 0;

                            if (rd_index == wr_index - 1) begin
                                // Last digit done → return to IDLE and clear buffer
                                state    <= IDLE;
                                rd_index <= 0;
                                wr_index <= 0;
                            end
                            else begin
                                // More digits remain → inter-digit GAP
                                rd_index <= rd_index + 1;
                                state    <= GAP;
                            end
                        end
                        else begin //value are still there to be read
                            // More elements in this digit
                            mcount <= mcount + 1;
                            state  <= ON;
                        end
                    end
                    else
                        count <= count + 1;
                end

                // for 2 seconds off gap
                GAP: begin
                    if (count == TWO_SEC) begin
                        count <= 0;
                        state <= ON;
                    end
                    else
                        count <= count + 1;
                end

                default: begin
                    state  <= IDLE;
                    count  <= 0;
                    mcount <= 0;
                end

            endcase
        end
    end

endmodule
