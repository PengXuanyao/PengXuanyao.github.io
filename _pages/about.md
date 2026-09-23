---
permalink: /
title: "About Me"
author_profile: true
redirect_from:
  - /about/
  - /about.html
---

Xuanyao Peng is a first-year Ph.D. student at the [School of Computing](https://www.comp.nus.edu.sg/), [National University of Singapore (NUS)](https://nus.edu.sg/), advised by Prof. [Flavien Solt](https://flaviens.github.io/). His research interests span computer architecture, hardware security, confidential computing, and secure and efficient LLM inference. Before joining NUS, he received his M.E. in Computer Technology from the [State Key Lab of Processors](https://sklp.ict.ac.cn/), Institute of Computing Technology (ICT), Chinese Academy of Sciences (CAS), under the supervision of Prof. [Hang Lu](https://luhang-hpu.github.io/), and was a visiting student at the [COMPASS lab](https://compass.sustech.edu.cn/) supervised by Prof. [Fengwei Zhang](https://fengweiz.github.io/). He received his B.E. in Automation from Xi’an Jiaotong University.

You can find my CV [here](/files/cv-english.pdf).

Education
------
Ph.D. Student, [School of Computing, National University of Singapore](https://www.comp.nus.edu.sg/), 2026 - Present
* Advisor: Prof. [Flavien Solt](https://flaviens.github.io/)

M.Eng. [Institute of Computing Technology, Chinese Academy of Sciences](https://www.ict.ac.cn/), 2023 - 2026
* Major in Computer Technology
* National Scholarship 2025

B.Eng. [School of Automation Science and Engineering, Xi'an Jiao Tong University](https://automation.xjtu.edu.cn/), 2019 - 2023
* Major in Automation
* National Scholarship 2022

Research Interests
------
* Computer Architecture
* Hardware Security
* Confidential Computing
* Secure and Efficient LLM Inference

News
------
* 2026.8, I started my Ph.D. at the National University of Singapore 🇸🇬, advised by Prof. [Flavien Solt](https://flaviens.github.io/)!
* 2025.9, Our team won second prize in the SecretFlow Cup Data Challenge Competition[[news😆]](https://www.isc.org.cn/article/26347674537553920.html) [[news📰]](https://sklp.ict.ac.cn/xwzx/202510/t20251021_785152.html)! We developed an efficient and secure LLM inference system on Intel TDX (Confidential Virtual Machine).
* 2025.7, Our paper on securing LLM inference on NPU was accepted by the $$43^{rd}$$ International Conference on Computer Design([ICCD](https://www.iccd-conf.com/home.html) 2025). See you at Dallas🌇, Texas!

Selected publications
------
{% assign pubs = site.publications | sort: 'date' | reverse %}
{% for post in pubs limit:5 %}
* [{{ post.title }}]({{ post.url }}) — {{ post.date | date: "%Y" }}{% if post.venue %}, _{{ post.venue }}_{% endif %}
{% endfor %}

[See all publications](/publications/)

Honors and Awards
------
* 2025: National Scholarship / 硕士生国家奖学金
* 2022: National Scholarship / 本科生国家奖学金
<!--
For more info
------
More info about configuring Academic Pages can be found in [the guide](https://academicpages.github.io/markdown/), the [growing wiki](https://github.com/academicpages/academicpages.github.io/wiki), and you can always [ask a question on GitHub](https://github.com/academicpages/academicpages.github.io/discussions). The [guides for the Minimal Mistakes theme](https://mmistakes.github.io/minimal-mistakes/docs/configuration/) (which this theme was forked from) might also be helpful.
-->
