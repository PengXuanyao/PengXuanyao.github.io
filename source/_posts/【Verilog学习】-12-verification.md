---
title: 【Verilog学习】-12-verification
mathjax: false
date: 2022-08-28 11:43:00
tags:
    - verilog
    - rtl verification
categories:
    - 学习
---

## Bugs mux2

### Question

This 8-bit wide 2-to-1 multiplexer doesn't work. Fix the bug(s).

### Module Declaration

```verilog
    module top_module (
        input sel,
        input [7:0] a,
        input [7:0] b,
        output [7:0] out  );
```

### Solution

```verilog
/**
module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output out  );

    assign out = (~sel & a) | (sel & b);

endmodule
**/

module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out  );

    assign out = sel ? a : b;

endmodule
```

### Referrence

```verilog
module top_module (
	input sel,
	input [7:0] a,
	input [7:0] b,
	output reg [7:0] out
);

	// 1. A mux coded as (~sel & a) | (sel & b) does not work for vectors.
	// This is because these are bitwise operators, and sel is only a 1 bit wide quantity,
	// which leaves the upper bits of a and b zeroed. It is possible to code it using
	// the replication operator, but this is somewhat difficult to read:
	//   ( {8{~sel}} & a ) | ( {8{sel}} & b )
	
	// 2. The simulation waveform shows that when sel = 1, a should be selected. This
	// is flipped in the suggested code.

    assign out = sel ? a : b;
	
endmodule
```

## Bugs nand3

### Question

This three-input NAND gate doesn't work. Fix the bug(s).

You must use the provided 5-input AND gate:

    module andgate ( output out, input a, input b, input c, input d, input e );

### Module Declaration

```verilog
    module top_module (input a, input b, input c, output out);
```

### Solution

```verilog
/**
module top_module (input a, input b, input c, output out);//

    andgate inst1 ( a, b, c, out );

endmodule
**/

/** bug exists
module top_module (input a, input b, input c, output out);//

    andgate inst1 ( .a(a), .b(b), .c(c), .out(out) );

endmodule
**/

module top_module (input a, input b, input c, output out);//
    wire out_n;
    andgate inst1 ( .a(a), .b(b), .c(c), .d(1'b1), .e(1'b1), .out(out_n) );
    
    assign out = ~out_n;

endmodule
```

## Bugs mux4

This 4-to-1 multiplexer doesn't work. Fix the bug(s).

You are provided with a bug-free 2-to-1 multiplexer:

```verilog
    module mux2 (
        input sel,
        input [7:0] a,
        input [7:0] b,
        output [7:0] out
    );
```    
### Module Declaration

```verilog
    module top_module (
        input [1:0] sel,
        input [7:0] a,
        input [7:0] b,
        input [7:0] c,
        input [7:0] d,
        output [7:0] out  );
```

### Solution

```verilog
/**
module top_module (
    input [1:0] sel,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out  ); //

    wire mux0, mux1;
    mux2 mux0 ( sel[0],    a,    b, mux0 );
    mux2 mux1 ( sel[1],    c,    d, mux1 );
    mux2 mux2 ( sel[1], mux0, mux1,  out );

endmodule
**/

module top_module (
    input [1:0] sel,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out  ); //

    wire [7:0] mux_0, mux_1;
    mux2 mux0 ( sel[0],    a,    b, mux_0 );
    mux2 mux1 ( sel[0],    c,    d, mux_1 );
    mux2 mux2 ( sel[1], mux_0, mux_1,  out );

endmodule

```

## Bugs addsubz

### Question

The following adder-subtractor with zero flag doesn't work. Fix the bug(s).

### Module Declaration

```verilog
    // synthesis verilog_input_version verilog_2001
    module top_module ( 
        input do_sub,
        input [7:0] a,
        input [7:0] b,
        output reg [7:0] out,
        output reg result_is_zero
    );
```

### Solution

```verilog
/**
// synthesis verilog_input_version verilog_2001
module top_module ( 
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);//

    always @(*) begin
        case (do_sub)
          0: out = a+b;
          1: out = a-b;
        endcase

        if (~out)
            result_is_zero = 1;
    end

endmodule
**/

// synthesis verilog_input_version verilog_2001
// synthesis verilog_input_version verilog_2001
module top_module ( 
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);//

    always @(*) begin
        case (do_sub)
          0: out = a+b;
          1: out = a-b;
        endcase

        if (!out)
            result_is_zero = 1;
        else
            result_is_zero = 0;
    end

endmodule
```

## Bugs case

### Question

This combinational circuit is supposed to recognize 8-bit keyboard scancodes for keys 0 through 9. It should indicate whether one of the 10 cases were recognized (valid), and if so, which key was detected. Fix the bug(s).

### Module Declaration

```verilog
    module top_module (
        input [7:0] code,
        output reg [3:0] out,
        output reg valid=1 );
```

### Solution

```verilog
module top_module (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid=1 );//

     always @(*)
        case (code)
            8'h45: out = 0;
            8'h16: out = 1;
            8'h1e: out = 2;
            8'd26: out = 3;
            8'h25: out = 4;
            8'h2e: out = 5;
            8'h36: out = 6;
            8'h3d: out = 7;
            8'h3e: out = 8;
            6'h46: out = 9;
            default: valid = 0;
        endcase

endmodule
```

## Bugs case

### Quesiton

This combinational circuit is supposed to recognize 8-bit keyboard scancodes for keys 0 through 9. It should indicate whether one of the 10 cases were recognized (valid), and if so, which key was detected. Fix the bug(s).

### Module Declaration

```verilog
    module top_module (
        input [7:0] code,
        output reg [3:0] out,
        output reg valid=1 );
```

### Solution

```verilog
module top_module (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid=1 );//

    always @(*) begin
        case (code)
            8'h45: out = 0;
            8'h16: out = 1;
            8'h1e: out = 2;
            8'h26: out = 3;
            8'h25: out = 4;
            8'h2e: out = 5;
            8'h36: out = 6;
            8'h3d: out = 7;
            8'h3e: out = 8;
            8'h46: out = 9;
            default: out = 0;
        endcase
    	
        case (code)
			8'h45: valid = 1'b1;
            8'h16: valid = 1'b1;
            8'h1e: valid = 1'b1;
            8'h26: valid = 1'b1;
            8'h25: valid = 1'b1;
            8'h2e: valid = 1'b1;
            8'h36: valid = 1'b1;
            8'h3d: valid = 1'b1;
            8'h3e: valid = 1'b1;
            8'h46: valid = 1'b1;
            default: valid = 1'b0;
        endcase
    end
endmodule
```

### Referrence

```verilog
module top_module (
	input [7:0] code,
	output reg [3:0] out,
	output reg valid
);

	// A combinational always block.
	always @(*) begin
		out = 0;		// To avoid latches, give the outputs a default assignment
		valid = 1;		//   then override them in the case statement. This is less
						//   code than assigning a value to every variable for every case.
		case (code)
			8'h45: out = 0;
			8'h16: out = 1;
			8'h1e: out = 2;
			8'h26: out = 3;		// 8'd26 is 8'h1a
			8'h25: out = 4;
			8'h2e: out = 5;
			8'h36: out = 6;
			8'h3d: out = 7;
			8'h3e: out = 8;
			8'h46: out = 9;
			default: valid = 0;
		endcase
	end
	
endmodule

```

### Solution

这里参考答案里面描述的更加简洁，阻塞赋值在逻辑上相当于是按顺序依次往下赋值。因此，首先是相当于给out和valid了一个默认值，然后再在case模块中进行了分别的赋值。

## Sim/circuit1

### Question

This is a combinational circuit. Read the simulation waveforms to determine what the circuit does, then implement it.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829100802.png)

### Module Declaration

```verilog
    module top_module (
        input a,
        input b,
        output q );
```

### Solution

```verilog
/**
module top_module (
    input a,
    input b,
    output q );//

    assign q = 0; // Fix me

endmodule
**/

module top_module (
    input a,
    input b,
    output q );//

    assign q = a & b; // Fix me

endmodule
```

## Sim/circuit2

### Question

This is a combinational circuit. Read the simulation waveforms to determine what the circuit does, then implement it.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829101130.png)

### Module Declaration

```verilog
    module top_module (
        input a,
        input b,
        input c,
        input d,
        output q );
```

### Solution

```verilog
/**
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = 0; // Fix me

endmodule
**/

module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = ~ (a ^ b ^ c ^ d); // Fix me

endmodule
```

## Sim/circuit3

### Question

This is a combinational circuit. Read the simulation waveforms to determine what the circuit does, then implement it.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829101424.png)

### Module Declaration

```verilog
    module top_module (
        input a,
        input b,
        input c,
        input d,
        output q );
```

### Solution

```verilog
/**
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = 0; // Fix me

endmodule 
**/

module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = (a | b) & (c | d); // Fix me, 画卡诺图得到

endmodule 

```

## Sim/circuit4

### Question

This is a combinational circuit. Read the simulation waveforms to determine what the circuit does, then implement it.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829102619.png)

### Module Declaration

```verilog
    module top_module (
        input a,
        input b,
        input c,
        input d,
        output q );
```

### Solution

```verilog
module top_module (
    input a,
    input b,
    input c,
    input d,
    output q );//

    assign q = b | c; // Fix me, 画卡诺图得到

endmodule
```
        
## Sim/circuit5

### Question

This is a combinational circuit. Read the simulation waveforms to determine what the circuit does, then implement it.

#### Simulation 1

![wf1](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829103328.png)

#### Simulation 2

![wf2](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829103352.png)

### Module Declaration

```verilog
    module top_module (
        input [3:0] a,
        input [3:0] b,
        input [3:0] c,
        input [3:0] d,
        input [3:0] e,
        output [3:0] q );
```

### Solution

```verilog
module top_module (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q );

    always @(*) begin
        q = 4'hf;
        case (c) 
            4'd0: q = b;
            4'd1: q = e;
            4'd2: q = a;
            4'd3: q = d;
        endcase
    end
endmodule
```

## Sim/circuit6

### Solution

This is a combinational circuit. Read the simulation waveforms to determine what the circuit does, then implement it.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829103804.png)

### Module Declaration

```verilog
    module top_module (
        input [2:0] a,
        output [15:0] q );
```

### Solution

```verilog
module top_module (
    input [2:0] a,
    output [15:0] q ); 
    always @(*) begin
        case (a)
            3'd0: q = 16'h1232;
            3'd1: q = 16'haee0;
            3'd2: q = 16'h27d4;
            3'd3: q = 16'h5a0e;
            3'd4: q = 16'h2066;
            3'd5: q = 16'h64ce;
            3'd6: q = 16'hc526;
            3'd7: q = 16'h2f19;
        endcase
    end
endmodule
```

## Sim/circuit7

### Question

This is a sequential circuit. Read the simulation waveforms to determine what the circuit does, then implement it.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829104236.png)

### Module Declaration

```verilog
    module top_module (
        input clk,
        input a,
        output q );
```

### Solution

```verilog
module top_module (
    input clk,
    input a,
    output q );
    
    always @(posedge clk) begin
        q <= ~a;
    end
endmodule
```

## Sim/circuit8

### Question

This is a sequential circuit. Read the simulation waveforms to determine what the circuit does, then implement it.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829104511.png)

### Module Declaration

```verilog
    module top_module (
        input clock,
        input a,
        output p,
        output q );
```

### Solution

```verilog
module top_module (
    input clock,
    input a,
    output p,
    output q);
    
    always @(*) begin
        if (clock)
            p = a;
        else
            p = p;
    end
    
    always @(negedge clock) begin
        q <= a;
    end
endmodule
```

## Sim/circuit9

### Question

This is a sequential circuit. Read the simulation waveforms to determine what the circuit does, then implement it.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829105631.png)

### Module Declaration

```verilog
    module top_module (
        input clk,
        input a,
        output [3:0] q );
```

### Solution

```verilog
module top_module (
    input clk,
    input a,
    output [3:0] q );
    
    always @(posedge clk) begin
        if (a) 
            q <= 4'd4;
        else begin
            if (q > 4'd5)
                q <= 0;
            else 
                q <= q + 1'b1;
        end 
    end
endmodule
```

## Sim/circuit10

### Question

This is a sequential circuit. The circuit consists of combinational logic and one bit of memory (i.e., one flip-flop). The output of the flip-flop has been made observable through the output state.

Read the simulation waveforms to determine what the circuit does, then implement it.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220829110342.png)

### Module Declaration

```verilog
    module top_module (
        input clk,
        input a,
        input b,
        output q,
        output state  );
```

### Solution

```verilog
module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state  );
    reg next_state;
    
    always @(*)
        case (state)
            1'b0 : next_state = (a & b) ? 1'b1 : 1'b0;
            1'b1 : next_state = ~(a | b) ? 1'b0 : 1'b1; // 这里逻辑开始写错了，写成了~(a & b);
        endcase
    
    always @(posedge clk) begin
        state <= next_state; 
    end
    
    assign q = state ? ~(a ^ b) : (a ^ b);
endmodule
```

## Tb/clock

### Question

You are provided a module with the following declaration:

    module dut (input clk)

Write a testbench that creates one instance of module dut (with any instance name), and create a clock signal to drive the module's clk input. The clock has a period of 10 ps. The clock should be initialized to zero with its first transition being 0 to 1.

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220830111529.png)

### Module Declaration

```verilog
    module top_module ( );
```

### Solution

```verilog
module top_module ( );
	reg clk;
    
    initial begin
        clk = 0;
    end
    
    always #5 clk = ~clk;
    
    dut dut_ins(clk);
endmodule
```

## Tb/tb1

### Question

Create a Verilog testbench that will produce the following waveform for outputs A and B:

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220830112049.png)

### Module Declaration

```verilog
    module top_module ( output reg A, output reg B );
```

```verilog
module top_module ( output reg A, output reg B );//

    // generate input patterns here
    initial begin
        A = 0;
        B = 0;
        #10 A = 1;
        #5 B = 1;
        #5 A = 0;
        #20 B = 0;
    end

endmodule
```

## Tb/and

### Question

You are given the following AND gate you wish to test:
```verilog
module andgate(
    input [1:0] in;
    output out
);
```

Write a testbench that instantiates this AND gate and tests all 4 input combinations, by generating the following timing diagram:
![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220830112448.png)

### Module Declaration

```verilog
    module top_module();
```

### Solution

```verilog
module top_module();
    reg [1:0] in;
    wire out;
    
    initial begin
        in = 0;
        #10 in = 2'b01;
        #10 in = 2'b10;
        #10 in = 2'b11;
    end
    
    andgate andgate_ins(in, out);
endmodule
```

## Tb/tb2

### Question

The waveform below sets clk, in, and s:

![wf](https://raw.githubusercontent.com/PengXuanyao/img-bed/main/20220830112921.png)

Module q7 has the following declaration:

```verilog
    module q7 ( 
         input clk, 
         input in, 
         input [2:0] s, 
         output out );
```


Write a testbench that instantiates module q7 and generates these input signals exactly as shown in the waveform above

### Module Declaration

```verilog
module top_module();
```

### Solution

```verilog
module top_module();
    reg clk, in;
    reg [2:0] s;
    wire out;
    
    initial begin
        clk = 0;
        in = 0;
        s = 2;
        #10 s = 6;
        #10 s = 2;
        in = 1;
        #10 s = 7;
        in = 0;
        #10 s = 0;
        in = 1;
        #30 in = 0;
    end
    
    always #5 clk = ~clk;
    
    q7 q7_inst(clk, in, s, out);
endmodule
```

### Debug

注意：clk反转是半个时钟。

## Tb/tff

### Question

You are given a T flip-flop module with the following declaration:

```verilog
module tff ( 
    input clk, 
    input reset,   // active-high synchronous reset 
    input t,       // toggle 
    output q 
);
```
Write a testbench that instantiates one tff and will reset the T flip-flop then toggle it to the "1" state.


### Module Declaration

```verilog
    module top_module ();
```

### Solution

```verilog
module top_module();
    reg clk, t;
    reg reset;
    wire q;
    
    initial begin
        clk = 0;
        t = 0;
        reset = 1;
        #10 t = 1;
        reset = 0;
        #10 t = 0;
    end
    
    always #5 clk = ~clk;
    
    tff tff_inst(clk, reset, t, q);
endmodule
```

### Debug

注意：clk反转是半个时钟。
