---
title: "OpenRVGPU Course"
collection: teaching
type: "Undergraduate course"
permalink: /teaching/2025-autumn-rvgpu
venue: "RIOS, TBSI, Work as Teaching Assistant"
date: 2025-10-20
location: "Shenzhen, China"
---

This course is a fast-track, hands-on journey into designing open-source GPUs that combine the royalty-free RISC-V ISA with massively parallel graphics hardware. In ten intensive weeks students will move from ISA basics to a working RTL prototype, targeting the computational bottlenecks of large-language-model workloads. Get its slides on [Github](https://github.com/chenweiphd/OpenRVGPUCourse).

Lectures and weekly labs cover: RISC-V vector/tensor extensions, GPU micro-architecture (SIMT cores, on-chip networks, HBM, Tensor/RT cores), open-source EDA flows (OpenROAD, Chisel), and compiler stacks from Triton to LLVM-VE. A Chiplet track explores 2.5/3-D integration and in-memory compute options.

The heart of the class is a team “minion-GPU” project: identify a real performance gap in an existing open-source GPU, propose a RISC-V-based extension, implement it in C-Model & RTL, verify on FPGA, and release the patch back to the community. Industry and academic mentors from the RISC-V Foundation, NVIDIA, AMD, Ventus and Tsinghua provide feedback every two weeks.

