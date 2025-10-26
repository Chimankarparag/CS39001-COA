
module mux_8(
    input [7:0] a,
    input [2:0] s,
    output out
    );
    wire [1:0] temp;
    mux_4 m1(a[3:0],s[1:0],temp[0]);
	mux_4 m2(a[7:4],s[1:0],temp[1]);
    mux_2 m3(temp,s[2],out);
endmodule