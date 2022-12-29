module intr_1(

 //Processor interface

pclk_i, prst_i, paddr_i, pwdata_i, prdata_o, pwrite_i, psel_i, penable_i, pready_o, intr_to_service_o, intr_valid_o, intr_serviced_i,intr_active_i );

 //Peripheral interface 6 intr_active_i

 

 parameter NUM_INTR=16;
 parameter WIDTH=$clog2(NUM_INTR);
 parameter S_NOINTR=3'b000;
parameter S_INTR_ACT=3'b001;
parameter S_WAITING=3'b010;




input pclk_i, prst_i, pwrite_i, psel_i, penable_i;

input [WIDTH-1:0] paddr_i, pwdata_i;

output reg [WIDTH-1:0] prdata_o;

output reg pready_o;

output reg [WIDTH-1:0] intr_to_service_o;

output reg intr_valid_o;

input intr_serviced_i;

input [NUM_INTR-1:0] intr_active_i;

integer i;
//reg [2:0] ns,state;
//integer highest_prio;
//reg [3:0] intr_with_highest_prio;

//registers

reg [3:0] priority_regA [NUM_INTR-1:0];

always @(posedge pclk_i)begin
if(prst_i==1)begin
	prdata_o=0;
	pready_o=0;
	intr_to_service_o=0;
	intr_valid_o=0;
	//state=S_NOINTR;
	//ns=S_NOINTR;
	//intr_with_highest_prio=0;
	//highest_prio=-1;

	for(i=0;i<NUM_INTR;i=i+1) priority_regA[i]=0;
end

else begin
	//pready_o=0;
	if(psel_i==1 && penable_i==1)begin

	pready_o=1;
	if(pwrite_i==1)begin
		priority_regA[paddr_i]=pwdata_i;
	end

	else begin
		prdata_o=priority_regA[paddr_i];


	end
	end

	else begin
		pready_o=0;
	end
end
end



endmodule
