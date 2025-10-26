
module mux_16(
    input [15:0] a,
    input [3:0] s,
    output out
    );
    wire [1:0] temp;
    mux_8 m1(a[7:0],s[2:0],temp[0]);
	mux_8 m2(a[15:8],s[2:0],temp[1]);
    mux_2 m3(temp,s[3],out);
endmodule