`timescale 1ns / 1ps

module project_car(
                input clk,reset_n,
                input entrance_sensor_input, exit_sensor_input,
                input [1:0] password_1, password_2,
                output wire GREEN_LED,RED_LED
                //output reg [6:0] STATE_1, STATE_2
                );
   
 parameter IDLE = 3'b000, WAIT_PASSWORD = 3'b001, WRONG_PASSWORD = 3'b010, RIGHT_PASSWORD = 3'b011,STOP = 3'b100;
 
 // Moore FSM : output just depends on the current state
 reg[2:0] current_state, next_state;
 reg[31:0] counter_wait;
 reg red_led_temp,green_led_temp;
 
 // Next state
 always @(posedge clk or negedge reset_n)
    begin
        if(~reset_n)
            current_state = IDLE;
        else
            current_state = next_state;
    end
   
 // counter_wait
 always @(posedge clk or negedge reset_n)
    begin
        if(~reset_n)
            counter_wait <= 0;
        else if(current_state==WAIT_PASSWORD)
            counter_wait <= counter_wait + 1;
        else
            counter_wait <= 0;
    end
   
 // change state
 always @(*)
    begin
        case(current_state)
            IDLE: begin
                    if(entrance_sensor_input == 1)
                        next_state = WAIT_PASSWORD;
                    else
                        next_state = IDLE;
                  end
            WAIT_PASSWORD: begin
                             if(counter_wait <= 3)
                                next_state = WAIT_PASSWORD;
                             else
                                begin
                                    if((password_1==2'b01)&&(password_2==2'b10))
                                        next_state = RIGHT_PASSWORD;
                                    else
                                        next_state = WRONG_PASSWORD;
                                end
                            end
            WRONG_PASSWORD: begin
                            if((password_1==2'b01)&&(password_2==2'b10))
                                next_state = RIGHT_PASSWORD;
                            else
                                next_state = WRONG_PASSWORD;
                        end
            RIGHT_PASSWORD: begin
                            if(entrance_sensor_input==1 && exit_sensor_input == 1)
                                next_state = STOP;
                            else if(exit_sensor_input == 1)
                                next_state = IDLE;
                            else
                                next_state = RIGHT_PASSWORD;
                         end
            STOP: begin
                    if((password_1==2'b01)&&(password_2==2'b10))
                        next_state = RIGHT_PASSWORD;
                    else
                        next_state = STOP;
                  end
            default: next_state = IDLE;
        endcase
     end
 
 // LEDs and output, change the period of blinking LEDs here
 always @(posedge clk) begin
    case(current_state)
        IDLE: begin
            green_led_temp = 1'b0;
            red_led_temp = 1'b0;
            //STATE_1 = 7'b1111111; // off
            //STATE_2 = 7'b1111111; // off
            end
        WAIT_PASSWORD: begin
            green_led_temp = 1'b0;
            red_led_temp = 1'b1;
            //STATE_1 = 7'b0000110; // E
            //STATE_2 = 7'b0101011; // n
            end
        WRONG_PASSWORD: begin
            green_led_temp = 1'b0;
            red_led_temp = ~red_led_temp;
            //STATE_1 = 7'b0000110; // E
            //STATE_2 = 7'b0000110; // E
            end
        RIGHT_PASSWORD: begin
             green_led_temp = ~green_led_temp;
             red_led_temp = 1'b0;
             //STATE_1 = 7'b0000010; // 6
             //STATE_2 = 7'b1000000; // 0
             end
        STOP: begin
             green_led_temp = 1'b0;
             red_led_temp = ~red_led_temp;
             //STATE_1 = 7'b0010010; // 5
             //STATE_2 = 7'b0001100; // P
             end
     endcase
 end
 
assign RED_LED = red_led_temp  ;
assign GREEN_LED = green_led_temp;

endmodule

