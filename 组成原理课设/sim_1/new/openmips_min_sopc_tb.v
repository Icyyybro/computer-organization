//openmips_min_sopc的测试文件
//////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module openmips_min_sopc_tb();

  reg     CLOCK_50;//激励信号，这是时钟信号
  reg     rst;//激励信号，这是复位信号
  //定义CLOCK_50信号，每隔10个时间单位，CLOCK_50的值翻转，由此得到一个周期信号。
  // 在仿真的时候，一个时间单位默认是1ns，所以CLOCK_50的值每10ns翻转一次，对应
  // 就是 50MHz 的时钟
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end
  // 定义rst信号，最开始为1，表示复位信号有效，过了195 个时间单位，即195ns，
  // 设置rst 信号的值为0，复位信号无效，复位结束，再运行1000ns，暂停仿真
  initial begin
    rst = `RstEnable;
    #195 rst= `RstDisable;
    #4100 $stop;
  end
  //待测试模块的例化     
  openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);

endmodule