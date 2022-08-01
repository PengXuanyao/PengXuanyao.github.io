---
title: 【Verilog学习】-11-时序逻辑-MoreCircuit
mathjax: false
date: 2022-05-25 21:47:46
tags:
  - verilog
  - 元胞自动机（Cellular Automata）
categories:
  - 学习
---

> 本次题目主要是对元胞自动机的仿真

<!--more-->

## Rule90

### question

[Rule 90](https://en.wikipedia.org/wiki/Rule_90) is a one-dimensional cellular automaton with interesting properties.

The rules are simple. There is a one-dimensional array of cells (on or off). At each time step, the next state of each cell is the XOR of the cell's two current neighbours. A more verbose way of expressing this rule is the following table, where a cell's next state is a function of itself and its two neighbours:

| Left | Center | Right | Center's next state |
|:---- |:------ |:----- |:------------------- |
| 1    | 1      | 1     | 0                   |
| 1    | 1      | 0     | 1                   |
| 1    | 0      | 1     | 0                   |
| 1    | 0      | 0     | 1                   |
| 0    | 1      | 1     | 1                   |
| 0    | 1      | 0     | 0                   |
| 0    | 0      | 1     | 1                   |
| 0    | 0      | 0     | 0                   |

(The name "Rule 90" comes from reading the "next state" column: 01011010 is decimal 90.)

In this circuit, create a 512-cell system (`q[511:0]`), and advance by one time step each clock cycle. The `load` input indicates the state of the system should be loaded with `data[511:0]`. Assume the boundaries (`q[-1]` and `q[512]`) are both zero (off).

### Module Declaration

```verilog
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q );
```

### solution

```verilog
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 
    always @(posedge clk) begin
        if (load) 
            q <= data;
        else begin
            for (integer i = 1 ; i < 511 ; i = i + 1)
                q[i] <= q[i+1] ^ q[i-1];
            q[0] <= q[1];
            q[511] <= q[510];
        end
    end
endmodule
```

### Debug

- end 要和 begin 对称
- 输入输出不要搞反了 data<=q(wrong)

## Rule110

### question

[Rule 110](https://en.wikipedia.org/wiki/Rule_110) is a one-dimensional cellular automaton with interesting properties (such as being [Turing-complete](https://en.wikipedia.org/wiki/Turing_completeness)).

There is a one-dimensional array of cells (on or off). At each time step, the state of each cell changes. In Rule 110, the next state of each cell depends only on itself and its two neighbours, according to the following table:

| Left | Center | Right | Center's next state |
|:---- |:------ |:----- |:------------------- |
| 1    | 1      | 1     | 0                   |
| 1    | 1      | 0     | 1                   |
| 1    | 0      | 1     | 1                   |
| 1    | 0      | 0     | 0                   |
| 0    | 1      | 1     | 1                   |
| 0    | 1      | 0     | 1                   |
| 0    | 0      | 1     | 1                   |
| 0    | 0      | 0     | 0                   |

(The name "Rule 110" comes from reading the "next state" column: 01101110 is decimal 110.)

In this circuit, create a 512-cell system (`q[511:0]`), and advance by one time step each clock cycle. The `load` input indicates the state of the system should be loaded with `data[511:0]`. Assume the boundaries (`q[-1]` and `q[512]`) are both zero (off).

### Module Declaration

```verilog
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);  
```

### solution

```verilog
module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 
    always @(posedge clk) begin
        if (load) 
            q <= data;
        else begin
            for (integer i = 1; i < 511 ; i = i + 1) begin
                q[i] <= ((~q[i+1]) & q[i-1] | (q[i] ^ q[i-1]));
            end
            q[0] <= q[0];
            q[511] <= q[510] | (q[511] ^ q[510]);
        end
    end
endmodule
```

## Conwaylife

### question

[Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) is a two-dimensional cellular automaton.

The "game" is played on a two-dimensional grid of cells, where each cell is either 1 (alive) or 0 (dead). At each time step, each cell changes state depending on how many neighbours it has:

- 0-1 neighbour: Cell becomes 0.
- 2 neighbours: Cell state does not change.
- 3 neighbours: Cell becomes 1.
- 4+ neighbours: Cell becomes 0.

The game is formulated for an infinite grid. In this circuit, we will use a 16x16 grid. To make things more interesting, we will use a 16x16 toroid, where the sides wrap around to the other side of the grid. For example, the corner cell (0,0) has 8 neighbours: `(15,1)`, `(15,0)`, `(15,15)`, `(0,1)`, `(0,15)`, `(1,1)`, `(1,0)`, and `(1,15)`. The 16x16 grid is represented by a length 256 vector, where each row of 16 cells is represented by a sub-vector: q[15:0] is row 0, q[31:16] is row 1, etc. (This tool accepts SystemVerilog, so you may use 2D vectors if you wish.)

- `load`: Loads `data` into `q` at the next clock edge, for loading initial state.
- `q`: The 16x16 current state of the game, updated every clock cycle.

The game state should advance by one timestep every clock cycle.

*[John Conway](https://en.wikipedia.org/wiki/John_Horton_Conway), mathematician and creator of the Game of Life cellular automaton, passed away from COVID-19 on April 11, 2020.*

### Module Declaration

```verilog
module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 
```

> Hint
> 
> A test case that's easily understandable and tests some boundary conditions is the blinker `256'h7`. It is 3 cells in row 0 columns 0-2. It oscillates between a row of 3 cells and a column of 3 cells (in column 1, rows 15, 0, and 1).

### solution

```verilog
module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 
    reg [5:0] res [0:255];
    always @(*) begin
        for (integer i = 0; i < 16 ; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1)
                res[i * 16 + j] = q[((i + 15) % 16) * 16 + (j + 15) % 16] + q[((i + 15) % 16) * 16 + j] + q[((i + 15) % 16) * 16 + (j + 1) % 16] + q[i * 16 + (j + 15) % 16] + q[i * 16 + (j + 1) % 16] + q[((i + 1) % 16) * 16 + (j + 15) % 16] + q[((i + 1) % 16) * 16 + j] + q[((i + 1) % 16) * 16 + (j + 1) % 16];
        end
    end
    always @(posedge clk) begin
        if (load) 
            q <= data;
        else begin
            for (integer i = 0; i < 256; i = i + 1) begin
                if (res[i] < 2'b10 || res[i] > 2'b11) 
                    q[i] <= 0;
                else if (res[i] == 2'b11)
                    q[i] <= 1'b1;
            end
        end
    end

endmodule
```

### debug

- 注意表示用一位数组表示二维数组的方法，这样同一行的数值才是正确的。
