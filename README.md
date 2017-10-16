# Patient-specific-modelling-of-intracranial-aneurysm-evolution
颅内血管瘤的建模以及对其生长状态的模拟
## Synopsis 项目大纲
此项目是关于颅内血管瘤的建模以及对其生长状态的模拟，使用Matlab, APDL, FORTRAN and Perl四种编程语言以及Anasys和Tecplot 360这两个专业软件. 

此项目主要是通过分析血管瘤表面曲率，获得其表面特征情况，然后通过Holzapfel的成长模型构建其生长模型(具体模型的数学表达可以查阅论文第26页)。对于其模拟生长的过程，针对每一个有限元需要改变的是其中的剪切模量值(c)以及k2值。

其他简要的介绍可以通过![介绍海报](https://github.com/frayds/Patient-specific-modelling-of-intracranial-aneurysm-evolution/blob/master/poster(%E6%BC%94%E7%A4%BA%E6%B5%B7%E6%8A%A5).pdf)进行了解。
## Motivation 创作动机
此项目是于University of Sheffield(谢菲尔德大学)攻读Master(硕士)的毕业项目。
## Installation 如何安装
下载此项目，在用户电脑中需安装ANASYS以及Tecplot360，同时需要配置Perl环境以便于进行程序自动化。在命令行窗口将文件目标路径定位到此文件夹，在命令行中输入"Perl FSG.pl",即可自动执行程序。结果文件会存储在当前路径下的Solid文件夹中。在Anasys中打开相关的.db文件可查阅结果。
## API Reference
计算曲率的相关文件参考了![Itzik Ben Shabat的程序](http://cn.mathworks.com/matlabcentral/fileexchange/47134-curvature-estimationl-on-triangle-mesh)
## Tests 项目运行效果
颅内血管瘤整体生长状态：
![](https://github.com/frayds/Patient-specific-modelling-of-intracranial-aneurysm-evolution/raw/master/demo_pictures/Global(%E6%95%B4%E4%BD%93%E7%94%9F%E9%95%BF).gif)

## Contributors 参与者介绍
濮一帆:advanced Computer Science, Department of Computer Science, University of Sheffield

Prof. Paul watton:毕业论文导师，老师的相关信息可以前往--![他的网站](http://www.themebio.org/paul-n-watton/)
