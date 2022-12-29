`include "intrctrl.v"
module tb;

parameter NUM_INTR=16;
parameter WIDTH=$clog2(NUM_INTR);



reg pclk_i, prst_i, pwrite_i, psel_i, penable_i;

reg [WIDTH-1:0] paddr_i, pwdata_i;

wire [WIDTH-1:0] prdata_o;

wire pready_o;

wire [WIDTH-1:0] intr_to_service_o;

wire intr_valid_o;

reg intr_serviced_i;

reg [NUM_INTR-1:0] intr_active_i;

reg [WIDTH-1:0] prioA [NUM_INTR-1:0];

integer i,j;

reg [WIDTH-1:0] prio_t;
reg value_already_exists_in_array_f;


//registers

intr_ctrl dut(.*);

initial begin
	pclk_i=0;
	forever #5 pclk_i= ~pclk_i;
end

task apply_reset(); begin
	prst_i=1;
	paddr_i=0;
	pwdata_i=0;
	pwrite_i=0;
	psel_i=0;
	penable_i=0;
	intr_active_i=0;
	intr_serviced_i=0;

	#20;
	prst_i=0;

end
endtask

initial begin
	apply_reset();
	for(i=0;i<NUM_INTR;)begin
		prio_t=$urandom_range(0,15);
		value_already_exists_in_array_f=0;
		for(j=0;j<i;j=j+1)begin
			if(prio_t==prioA[j])begin
				value_already_exists_in_array_f=1;
				j=i;
	
			end
		end

		if(value_already_exists_in_array_f==0)begin
			prioA[i]=prio_t;
			i=i+1;
		end
	end
	for(i=0;i<NUM_INTR;i=i+1)begin
		write_reg(i,prioA[i]);
	end

	intr_active_i=$random;
	#500;

	intr_active_i=$random;
	#500;

	$finish;
end

task write_reg(input reg [WIDTH-1:0] addr, input reg [WIDTH-1:0] data);
begin
	@(posedge pclk_i);
	paddr_i=addr;
	pwdata_i=data;
	pwrite_i=1;
	psel_i=1;
	penable_i=1;
	wait(pready_o==1);

	@(posedge pclk_i);
	paddr_i=0;
	pwdata_i=0;
	pwrite_i=0;
	psel_i=0;
	penable_i=0;

end
endtask

always @(posedge pclk_i)begin
	
	if(intr_valid_o==1)begin
	#30;
	intr_serviced_i=1;
	intr_active_i[intr_to_service_o]=0;
	@(posedge pclk_i);
	intr_serviced_i=0;
	
	end
end

endmodule
