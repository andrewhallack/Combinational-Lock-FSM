`timescale 1 ns / 1 ps
`default_nettype wire

//behavioral description of combinational lock
module combination_lock_fsm(
    output reg [1:0] state,
    output wire [3:0] Lock, //asserted when locked
    input wire Key1, //unlock button 0
    input wire Key2, //unlock button 1
    input wire [3:0] Password, //indicate number
    input wire Reset, //reset
    input wire Clk //clock
);

    //possible states of the machine
    parameter S0 = 4'b00,
              S1 = 4'b01,
              S2 = 4'b10,
              S3 = 4'b11;
    
    //assigns lock with 1111 if the state is S4
    //and 0000 if otherwise          
    assign Lock = (state == S3) ? 4'b1111 : 4'b0000;
    reg [1:0] nextState;
    
    //describe next state logic
    always @(*)//combinational logic
        case(state)//case dependent one what state the circuit is in
            S0: begin//first possible state
                if(Key1 == 1 && Password == 4'b1101)
                    nextState = S1;//if conditions met, move on to next state
                else
                    nextState = S0;
            end
                    
            S1: begin//second possible state
                if(Key2)
                    if(Password == 4'b0111)
                        nextState = S2;//if conditions are met, move on to next state
                    else
                        nextState = S0;//wrong password resets circuit
                else
                    nextState = S1;//if Key2 is not pressed, hold state
            end
            
            S2: begin
                if(Key1)
                    if(Password == 4'b1001)
                        nextState = S3;
                    else
                        nextState = S0;
                else
                    nextState = S2;
            end
            
            S3: begin
                nextState = S3;
            end
            /*S3: begin
                if(Key2)
                    if(Password == 4'b0001)
                        nextState = S4;
                    else
                        nextState = S0;
                else
                    nextState = S3;
            end
            
            S4: begin
                nextState = S4;//final state
            end*/
        endcase
        
    always @(posedge Clk)//when clock is triggered
        if(Reset) //reset state
            state <= S0;
        else//set new state
            state <= nextState;
                
                  
endmodule