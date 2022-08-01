---
title: 【Verilog学习】-11-时序逻辑-FSM
mathjax: false
date: 2022-06-01 19:42:12
tags:
  - verilog
  - FSM(有限状态机)
categories:
  - 学习
---

> 标准的一些三段式有限状态机

## Fsm1

### question

This is a Moore state machine with two states, one input, and one output. Implement this state machine. Notice that the reset state is B.

This exercise is the same as [fsm1s](https://hdlbits.01xz.net/wiki/fsm1s), but using asynchronous reset.

<!--more-->

![Fsm1.png](https://hdlbits.01xz.net/mw/images/7/70/Fsm1.png)

### Module Declaration

```
module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);
```

### Solution

```verilog
module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//  

    parameter A=1'b0, B=1'b1; 
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        // State transition logic
        case (state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
        endcase
    end

    always @(posedge clk, posedge areset) begin    // This is a sequential always block
        // State flip-flops with asynchronous reset
        if (areset) 
            state <= B;
        else 
            state <= next_state; 
    end

    // Output logic
    assign out = state ? 1'b1 : 1'b0;

endmodule
```

## Fsm1s

### question

This is a Moore state machine with two states, one input, and one output. Implement this state machine. Notice that the reset state is B.

This exercise is the same as [fsm1](https://hdlbits.01xz.net/wiki/fsm1), but using synchronous reset.

> 这道题有点怪，为什么答案是用阻塞赋值

### Module Declaration

```verilog
// Note the Verilog-1995 module declaration syntax here:
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;
```

### Answer

```verilog
// Note the Verilog-1995 module declaration syntax here:
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  
    reg out;

    // Fill in state name declarations
    parameter A = 1'b0, B = 1'b1;
    reg present_state, next_state;

    always @(posedge clk) begin
        if (reset) begin  
            // Fill in reset logic
            present_state = B;
            out = 1'b1;
        end else begin
            case (present_state)
                // Fill in state transition logic
                A : next_state = in ? A : B;
                B : next_state = in ? B : A;
            endcase

            // State flip-flops
            present_state = next_state;   

            case (present_state)
                // Fill in output logic
                A : out = 1'b0;
                B : out = 1'b1;
            endcase
        end
    end

endmodule
```

## Fsm2

### question

This is a Moore state machine with two states, two inputs, and one output. Implement this state machine.

This exercise is the same as [fsm2s](https://hdlbits.01xz.net/wiki/fsm2s), but using asynchronous reset.

![Fsmjk.png](https://hdlbits.01xz.net/mw/images/b/b8/Fsmjk.png)

### Module Declaration

```VERILOG
module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); 
```

### solution

```verilog
module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        // State transition logic
        case (state)
            OFF : next_state = j ? ON : OFF;
            ON : next_state = k ? OFF : ON;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset) 
            state <= OFF;
        else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = (state == ON);

endmodule
```

## Fsm2s

### question

This is a Moore state machine with two states, two inputs, and one output. Implement this state machine.

This exercise is the same as [fsm2](https://hdlbits.01xz.net/wiki/fsm2), but using synchronous reset.

<img src="https://hdlbits.01xz.net/mw/images/5/5d/Fsmjks.png" alt="Fsmjks.png"  />

### Module Declaration

```verilog
module top_module(
    input clk,
    input reset,    // Synchronous reset to OFF
    input j,
    input k,
    output out); 
```

### solution

```verilog
module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        // State transition logic
        case (state)
            OFF : next_state = j ? ON : OFF;
            ON : next_state = k ? OFF : ON;
        endcase
    end

    always @(posedge clk) begin
        // State flip-flops with asynchronous reset
        if (areset) 
            state <= OFF;
        else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = (state == ON);

endmodule
```

## Fsm3comb

### question

The following is the state transition table for a Moore state machine with one input, one output, and four states. Use the following state encoding: A=2'b00, B=2'b01, C=2'b10, D=2'b11.

**Implement only the state transition logic and output logic** (the combinational logic portion) for this state machine. Given the current state (`state`), compute the `next_state` and output (`out`) based on the state transition table.

| State | Next state | Next state | Output |
|:----- |:---------- |:---------- | ------ |
|       | in=0       | in=1       |        |
| A     | A          | B          | 0      |
| B     | C          | B          | 0      |
| C     | A          | D          | 0      |
| D     | C          | B          | 1      |

```verilog
Module Declaration
module top_module(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out); 
```

### solution

```verilog
module top_module(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    // State transition logic: next_state = f(state, in)
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end
    // Output logic:  out = f(state) for a Moore state machine
    assign out = (state == D);
endmodule
```

## Fsm3onehot

### question

The following is the state transition table for a Moore state machine with one input, one output, and four states. Use the following one-hot state encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000.

**Derive state transition and output logic equations by inspection** assuming a one-hot encoding. Implement only the state transition logic and output logic (the combinational logic portion) for this state machine. (The testbench will test with non-one hot inputs to make sure you're not trying to do something more complicated).

| State | Next state | Next state | Output |
|:----- |:---------- |:---------- | ------ |
|       | in=0       | in=1       |        |
| A     | A          | B          | 0      |
| B     | C          | B          | 0      |
| C     | A          | D          | 0      |
| D     | C          | B          | 1      |

> #### What does "derive equations by inspection" mean?
> 
> One-hot state machine encoding guarantees that exactly one state bit is 1. This means that it is possible to determine whether the state machine is in a particular state by examining only *one* state bit, not *all* state bits. This leads to simple logic equations for the state transitions by examining the incoming edges for each state in the state transition diagram.
> 
> For example, in the above state machine, how can the state machine can reach state A? It must use one of the two incoming edges: "Currently in state A and in=0" or "Currently in state C and in = 0". Due to the one-hot encoding, the logic equation to test for "currently in state A" is simply the state bit for state A. This leads to the final logic equation for the next state of state bit A: `next_state[0] = state[0]&(~in) | state[2]&(~in)`. The one-hot encoding guarantees that at most one clause (product term) will be "active" at a time, so the clauses can just be ORed together.
> 
> When an exercise asks for state transition equations "by inspection", use this particular method. The judge will test with non-one-hot inputs to ensure your logic equations follow this method, rather that doing something else (such as resetting the FSM) for illegal (non-one-hot) combinations of the state bits.
> 
> Although knowing this algorithm isn't necessary for RTL-level design (the logic synthesizer handles this), it is illustrative of why one-hot FSMs often have simpler logic (at the expense of more state bit storage), and this topic frequently shows up on exams in digital logic courses.

### Module Declaration

```verilog
module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out);
```

### solution

```verilog
module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    // State transition logic: Derive an equation for each state flip-flop.
    assign next_state[A] = state[A]&(~in) | state[C]&(~in);
    assign next_state[B] = state[A]&(in) | state[B]&(in) | state[D]&(in);
    assign next_state[C] = state[B]&(~in) | state[D]&(~in);
    assign next_state[D] = state[C]&in;

    // Output logic: 
    assign out = state[D];

endmodule
```

## Fsm3

### question

See also: [State transition logic for this FSM](https://hdlbits.01xz.net/wiki/Fsm3comb)

The following is the state transition table for a Moore state machine with one input, one output, and four states. Implement this state machine. Include an asynchronous reset that resets the FSM to state A.

| State | Next state | Next state | Output |
|:----- |:---------- |:---------- | ------ |
|       | in=0       | in=1       |        |
| A     | A          | B          | 0      |
| B     | C          | B          | 0      |
| C     | A          | D          | 0      |
| D     | C          | B          | 1      |

### Module Declaration

```verilog
module top_module(
    input clk,
    input in,
    input areset,
    output out); 
```

### question

```verilog
module top_module(
    input clk,
    input in,
    input areset,
    output out); //

    // State transition logic

    // State flip-flops with asynchronous reset

    // Output logic

endmodule
```

## Fsm3

### question

See also: [State transition logic for this FSM](https://hdlbits.01xz.net/wiki/Fsm3comb)

The following is the state transition table for a Moore state machine with one input, one output, and four states. Implement this state machine. Include an asynchronous reset that resets the FSM to state A.

| State | Next state | Next state | Output |
|:----- |:---------- |:---------- | ------ |
|       | in=0       | in=1       |        |
| A     | A          | B          | 0      |
| B     | C          | B          | 0      |
| C     | A          | D          | 0      |
| D     | C          | B          | 1      |

### Module Declaration

```verilog
module top_module(
    input clk,
    input in,
    input areset,
    output out);
```

### solution

```verilog
module top_module(
    input clk,
    input in,
    input areset,
    output out); //

    reg [1:0] state;
    reg [1:0] next_state;

    // State transition logic
    parameter A=0, B=1, C=2, D=3;

    // State transition logic: next_state = f(state, in)
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end
    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= A;
        else 
            state <= next_state; 
    end
    // Output logic:  out = f(state) for a Moore state machine
    assign out = (state == D);
endmodule

/* reference */
/* 

module top_module (
    input clk,
    input in,
    input areset,
    output out
);

    // Give state names and assignments. I'm lazy, so I like to use decimal numbers.
    // It doesn't really matter what assignment is used, as long as they're unique.
    parameter A=0, B=1, C=2, D=3;
    reg [1:0] state;        // Make sure state and next are big enough to hold the state encodings.
    reg [1:0] next;




    // Combinational always block for state transition logic. Given the current state and inputs,
    // what should be next state be?
    // Combinational always block: Use blocking assignments.    
    always@(*) begin
        case (state)
            A: next = in ? B : A;
            B: next = in ? B : C;
            C: next = in ? D : A;
            D: next = in ? B : C;
        endcase
    end



    // Edge-triggered always block (DFFs) for state flip-flops. Asynchronous reset.
    always @(posedge clk, posedge areset) begin
        if (areset) state <= A;
        else state <= next;
    end



    // Combinational output logic. In this problem, an assign statement is the simplest.        
    assign out = (state==D);

endmodule

*/
```

## Fsm3s

### question

See also: [State transition logic for this FSM](https://hdlbits.01xz.net/wiki/Fsm3comb)

The following is the state transition table for a Moore state machine with one input, one output, and four states. Implement this state machine. Include a synchronous reset that resets the FSM to state A. (This is the same problem as [Fsm3](https://hdlbits.01xz.net/wiki/Fsm3) but with a synchronous reset.)

| State | Next state | Next state | Output |
|:----- |:---------- |:---------- | ------ |
|       | in=0       | in=1       |        |
| A     | A          | B          | 0      |
| B     | C          | B          | 0      |
| C     | A          | D          | 0      |
| D     | C          | B          | 1      |

![Fsm3.png](https://hdlbits.01xz.net/mw/images/8/89/Fsm3.png)

### Module Declaration

```verilog
module top_module(
    input clk,
    input in,
    input reset,
    output out); 
```

### solution

```verilog
module top_module(
    input clk,
    input in,
    input reset,
    output out); //

    // State transition logic
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;
    always @(*) begin
        case (state) 
            A : next_state = in ? B : A;
            B : next_state = in ? B : C;
            C : next_state = in ? D : A;
            D : next_state = in ? B : C;
        endcase
    end
    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            state <= next_state;
        end
    end
    // Output logic
    always @(*) begin
        case (state)
            A : out = 0;
            B : out = 0;
            C : out = 0;
            D : out = 1'b1;
        endcase
    end
endmodule
```

### debug

开始设置state、next_state的位宽出现了问题：忘记写[1:0]。

## Exams/ece241 2013 q4

### question

![Ece241 2013 q4.png](https://hdlbits.01xz.net/mw/thumb.php?f=Ece241_2013_q4.png&width=740)

Also include an active-high synchronous reset that resets the state machine to a state equivalent to if the water level had been low for a long time (no sensors asserted, and all four outputs asserted).

### Module Declaration

```verilog
module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
```

### solution

```verilog
module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    parameter IDLE = 3'b001, S1_UP = 3'b010, S1_DOWN = 3'b011, S2_UP = 3'b100 , S2_DOWN = 3'b101, S3 = 3'b110; 
    reg [2:0] state, next_state;
    always @(*) begin
        case (state)
            IDLE: 
                case (s)
                    3'b001: next_state = S1_UP;
                    3'b011: next_state = S2_UP;
                    3'b111: next_state = S3;
                    default: next_state = IDLE; /*开始出现bug是所有的这个位置没加default*/
                endcase
            S1_UP: 
                case (s)
                    3'b000: next_state = IDLE;
                    3'b011: next_state = S2_UP;
                    3'b111: next_state = S3;
                    default: next_state = S1_UP;
                endcase
            S1_DOWN: 
                case (s)
                    3'b000: next_state = IDLE;
                    3'b011: next_state = S2_UP;
                    3'b111: next_state = S3;
                    default: next_state = S1_DOWN;
                endcase
            S2_UP: 
                case (s)
                    3'b000: next_state = IDLE;
                    3'b001: next_state = S1_DOWN;
                    3'b111: next_state = S3;
                    default: next_state = S2_UP;
                endcase
            S2_DOWN: 
                case (s)
                    3'b000: next_state = IDLE;
                    3'b001: next_state = S1_DOWN;
                    3'b111: next_state = S3;
                    default: next_state = S2_DOWN;
                endcase
            S3: 
                case (s)
                    3'b000: next_state = IDLE;
                    3'b001: next_state = S1_DOWN;
                    3'b011: next_state = S2_DOWN;
                    default: next_state = S3;
                endcase
            default: next_state = IDLE; /*开始出现bug是所有case这个位置没加default*/
        endcase
    end
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end
    always @(*) begin
        case (state)
            IDLE: {fr3, fr2, fr1, dfr} = 4'b1111;
            S1_UP: {fr3, fr2, fr1, dfr} = 4'b0110;
            S1_DOWN: {fr3, fr2, fr1, dfr} = 4'b0111;
            S2_UP: {fr3, fr2, fr1, dfr} = 4'b0010;
            S2_DOWN: {fr3, fr2, fr1, dfr} = 4'b0011;
            S3: {fr3, fr2, fr1, dfr} = 4'b0000;
            default:  {fr3, fr2, fr1, dfr} = 'x;
        endcase
    end
endmodule

/*reference solution*/
/*参考答案中，next_state的表达式是从状态发生顺序转变的角度考虑，每一个状态只能够转换到相临近的两个状态，上升或者下降*/
module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
);


    // Give state names and assignments. I'm lazy, so I like to use decimal numbers.
    // It doesn't really matter what assignment is used, as long as they're unique.
    // We have 6 states here.
    parameter A2=0, B1=1, B2=2, C1=3, C2=4, D1=5;
    reg [2:0] state, next;        // Make sure these are big enough to hold the state encodings.



    // Edge-triggered always block (DFFs) for state flip-flops. Synchronous reset.    
    always @(posedge clk) begin
        if (reset) state <= A2;
        else state <= next;
    end



    // Combinational always block for state transition logic. Given the current state and inputs,
    // what should be next state be?
    // Combinational always block: Use blocking assignments.    
    always@(*) begin
        case (state)
            A2: next = s[1] ? B1 : A2;
            B1: next = s[2] ? C1 : (s[1] ? B1 : A2);
            B2: next = s[2] ? C1 : (s[1] ? B2 : A2);
            C1: next = s[3] ? D1 : (s[2] ? C1 : B2);
            C2: next = s[3] ? D1 : (s[2] ? C2 : B2);
            D1: next = s[3] ? D1 : C2;
            default: next = 'x;
        endcase
    end



    // Combinational output logic. In this problem, a procedural block (combinational always block) 
    // is more convenient. Be careful not to create a latch.
    always@(*) begin
        case (state)
            A2: {fr3, fr2, fr1, dfr} = 4'b1111;
            B1: {fr3, fr2, fr1, dfr} = 4'b0110;
            B2: {fr3, fr2, fr1, dfr} = 4'b0111;
            C1: {fr3, fr2, fr1, dfr} = 4'b0010;
            C2: {fr3, fr2, fr1, dfr} = 4'b0011;
            D1: {fr3, fr2, fr1, dfr} = 4'b0000;
            default: {fr3, fr2, fr1, dfr} = 'x;
        endcase
    end

endmodule
```

### debug

- 注意case要考虑defualt的情况（特别时涉及的不确定输入有多个时，例如3位八种情况，其中3种有效，其他5种（default）也要考虑）

## Lemmings1

### question

![File:Lemmings.gif](https://hdlbits.01xz.net/mw/images/d/de/Lemmings.gif)

The game [Lemmings](https://en.wikipedia.org/wiki/Lemmings_(video_game)) involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine.

In the Lemmings' 2D world, Lemmings can be in one of two states: walking left or walking right. It will switch directions if it hits an obstacle. In particular, if a Lemming is bumped on the left, it will walk right. If it's bumped on the right, it will walk left. If it's bumped on both sides at the same time, it will still switch directions.

Implement a Moore state machine with two states, two inputs, and one output that models this behaviour.

![waveform](https://s2.loli.net/2022/06/10/NqhfVP6k8Mj7xB9.png)

### Module Declaration

```verilog
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); 
```

### solution

```verilog
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

    parameter LEFT=0, RIGHT=1;
    reg state, next_state;

    always @(*) begin
        // State transition logic
        case (state) 
            LEFT : next_state = (bump_left) ? RIGHT : LEFT;
            RIGHT : next_state = (bump_right) ? LEFT : RIGHT;
            default : next_state = LEFT;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset == 1'b1) begin
            state <= LEFT;
        end
        else begin
            state <= next_state;
        end
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule
```

## Lemmings2

### question

![Lemmings2.gif](https://hdlbits.01xz.net/mw/images/7/70/Lemmings2.gif)

See also: [Lemmings1](https://hdlbits.01xz.net/wiki/Lemmings1).

In addition to walking left and right, Lemmings will fall (and presumably go "aaah!") if the ground disappears underneath them.

In addition to walking left and right and changing direction when bumped, when `ground=0`, the Lemming will fall and say "aaah!". When the ground reappears (`ground=1`), the Lemming will resume walking in the same direction as before the fall. Being bumped while falling does not affect the walking direction, and being bumped in the same cycle as ground disappears (but not yet falling), or when the ground reappears while still falling, also does not affect the walking direction.

Build a finite state machine that models this behaviour.

![waveform](https://s2.loli.net/2022/06/10/R1vgx6LzZjTVMfA.png)

### Module Declaration

```verilog
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
```

### solution

```verilog
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

parameter LEFT = 2'b00, LEFT_FALL = 2'b01, RIGHT = 2'b10, RIGHT_FALL = 2'b11;


reg [1:0] state, next_state;
// state transition
always @(*) begin
    // State transition logic
    case (state) 
        LEFT : next_state = (!ground) ? LEFT_FALL : (bump_left ? RIGHT : LEFT);
        RIGHT : next_state = (!ground) ? RIGHT_FALL : (bump_right ? LEFT : RIGHT);
        LEFT_FALL : next_state = ground ? LEFT : LEFT_FALL;
        RIGHT_FALL : next_state = ground ? RIGHT : RIGHT_FALL;
        default : next_state = LEFT;
    endcase
end

always @(posedge clk, posedge areset) begin
    // State flip-flops with asynchronous reset
    if (areset == 1'b1) begin
        state <= LEFT;
    end
    else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);
assign aaah = (state == LEFT_FALL) || (state == RIGHT_FALL);
endmodule
```

### debug

- `reg [1:0] state`开始写成了`reg state`
- `parameter RIGHT_FALL = 2'b11`开始写成了`parameter RIGHT_FALL = 2'b10`

## Lemmings3

### question:

![Thumbnail for version as of 23:13, 17 November 2015](https://hdlbits.01xz.net/mw/images/a/a2/Lemmings3.gif)

In addition to walking and falling, Lemmings can sometimes be told to do useful things, like dig (it starts digging when `dig=1`). A Lemming can dig if it is currently walking on ground (`ground=1` and not falling), and will continue digging until it reaches the other side (`ground=0`). At that point, since there is no ground, it will fall (aaah!), then continue walking in its original direction once it hits ground again. As with falling, being bumped while digging has no effect, and being told to dig when falling or when there is no ground is ignored.

(In other words, a walking Lemming can fall, dig, or switch directions. If more than one of these conditions are satisfied, fall has higher precedence than dig, which has higher precedence than switching directions.)

Extend your finite state machine to model this behaviour.

![waveform](https://s2.loli.net/2022/07/06/98CvhMdRqoSIp6F.png)

### Module Declaration

```verilog
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
```

### solution

```verilog
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

localparam LEFT = 3'd0, RIGHT = 3'd1, DIG_R = 3'd2, FALL_R = 3'd3, FALL_L = 3'd4
            DLG_L = 3'd5;

reg [2:0] next_state;
reg [2:0] current_state;

always @(*) begin
    case (current_state)
        LEFT: 
            begin 
                if (ground == 1'b0)
                    next_state = FALL_L;
                else if (dig == 1'b1)
                    next_state = DLG_L;
                else if (bump_left == 1'b1 )
                    next_state = RIGHT;
                else
                    next_state = current_state;
            end
        RIGHT: 
            begin 
                if (ground == 1'b0)
                    next_state = FALL_R;
                else if (dig == 1'b1)
                    next_state = DLG_R;
                else if (bump_left == 1'b1 )
                    next_state = LEFT;
                else
                    next_state = current_state;
            end
        DIG_L: 
            begin 
                if (ground == 1'b0)
                    next_state = FALL_L;
                else
                    next_state = current_state;
            end
        DIG_R: 
            begin 
                if (ground == 1'b0)
                    next_state = FALL_R;
                else
                    next_state = current_state;
            end
        FALL_L:
            begin
                if (ground == 1'b1)
                    next_state = LEFT;
                else begin
                    next_state = current_state;
                end
            end
        FALL_R:
            begin
                if (ground == 1'b1) begin
                    next_state = RIGHT;
                end
                else begin
                    next_state = current_state;
                end
    endcase
end

always @(posedge clk or negedge areset) begin
    if (!areset) begin
        current_state <= LEFT;
    end
    else begin
        current_state <= next_state;
    end
end

always @(*) begin
    walk_left = (current_state == walk_left) ? 1'b1 : 1'b0;
    walk_right = (current_state == walk_right) ? 1'b1 : 1'b0;
    aaah = (current_state == FALL_L || current_state == FALL_R) ? 1'b1 : 1'b0;
    digging = (current_state == DIG_R || current_state == DIG_R) ? 1'b1 : 1'b0;
end
endmodule
```

## Fsm onehot

### question

Given the following state machine with 1 input and 2 outputs:

[![Fsmonehot.png](https://hdlbits.01xz.net/mw/images/a/a7/Fsmonehot.png)](https://hdlbits.01xz.net/wiki/File:Fsmonehot.png)

Suppose this state machine uses one-hot encoding, where `state[0]` through `state[9]` correspond to the states S0 though S9, respectively. The outputs are zero unless otherwise specified.

Implement the **state transition logic** and **output logic** portions of the state machine (but not the state flip-flops). You are given the current state in `state[9:0]` and must produce `next_state[9:0]` and the two outputs. Derive the logic equations by inspection assuming a one-hot encoding. (The testbench will test with non-one hot inputs to make sure you're not trying to do something more complicated).

### Module Declaration

```verilog
module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);
```

### Write your solution here

```verilog
module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);

always @(*) begin
    next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4]
     | state[7] | state[8] | state[9]));
    next_state[1] = (in & (state[0] | state[8] | state[9]));
    next_state[2] = (in & state[1]);
    next_state[3] = (in & state[2]);
    next_state[4] = (in & state[3]);
    next_state[5] = (in & state[4]);
    next_state[6] = (in & state[5]);
    next_state[7] = (in & (state[7] | state[6]));
    next_state[8] = (~in & state[5]);
    next_state[9] = (~in & state[6]);
    out1 = (state[8] | state[9]);
    out2 = (state[9] | state[7]);
end

endmodule
```

### debug

这一道题的本意是用独热码的原理进行状态转移，因此如果直接定有状态机进行状态转移，测试会报错。因此，应当选择独热码的转移形式。
