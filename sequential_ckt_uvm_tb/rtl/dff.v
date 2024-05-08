module dff(
    input clk,rst,din,
    output reg q,q_bar
);

always@(posedge clk) begin
    if(rst) q <= 1'b0;
    else      q <= din;
end
always@(q) q_bar = ~q;
endmodule