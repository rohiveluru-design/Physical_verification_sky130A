v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -50 -20 -30 -20 {lab=vin}
N -50 -20 -50 60 {lab=vin}
N -50 60 -30 60 {lab=vin}
N -60 -0 -50 -0 {lab=vin}
N 10 -40 10 -20 {lab=#net1}
N 10 10 10 30 {lab=vout}
N 10 20 60 20 {lab=vout}
N 10 60 10 80 {lab=#net2}
C {sky130_fd_pr/pfet_01v8.sym} -10 -20 0 0 {name=M1
W=1
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -10 60 0 0 {name=M2
W=1
L=0.15
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {gnd.sym} 10 90 0 0 {name=l1 lab=0}
C {vdd.sym} 10 -50 0 0 {name=l2 lab=VDD=1.8}
C {ipin.sym} -60 0 0 0 {name=p1 lab=vin}
C {opin.sym} 60 20 0 0 {name=p2 lab=vout
}
C {code_shown.sym} 200 200 0 0 {name=MODEL_LIB only_toplevel=true value="
.lib \"/foss/pdks/ciel/sky130/versions/1689ac3f2dc763876eaf967227c7dfe831b031ae/sky130A/libs.tech/ngspice/sky130.lib.spice\" tt
"}
