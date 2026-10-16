# Physical_Verification_SKY130A

This repository contains the documentation of the work done during a five-day physical verification workshop carried out by VSD.

The workshop describes the physical verification process that takes place during an RTL to GDSII flow using Skywater 130nm Technology, including DRC and LVS tests. This helps the participants get ready for the tape out and is particularly helpful for chip fabrication. The workshop assists in locating and fixing violations made during the physical verification stage.

More information about the workshop can be found at 


A special thanks to Tim, Kunal, and Sumanto for creating and helping out during this fantastic workshop

## Index
* [Chapter 0 - Getting the tools](#Chapter-0---Getting-the-tools)
* [Chapter 1 - Understanding the design flow](#Chapter-1---Understanding-the-design-flow)
* [Chapter 2 - DRC and LVS Fundamentals](#Chapter-2---DRC-and-LVS-Fundamentals)
* [Chapter 3 - DRC Issues](#Chapter-3---DRC-Issues)
* [Chapter 4 - LVS](#Chapter-4---LVS)
* [Additional Content - OpenLANE Design Flow](#Additional-Content---OpenLANE-Design-Flow)
* [Workshop Certificate](#Workshop-Certificate)

## Chapter 0 - Getting the tools

To adequately utilize the open source skywater130 pdk and understand the design flow, we first require to install all the tools, which are
- open_pdk
- magic
- ngspice
- xschem
- netgen


*Note: open_pdk has to be installed last so it can correctly associate the xschem and magic directories.*
*Note: if the configure step fails during any process, its most likely due to missing additional packages, and they need to be installed (preferably from source) to complete the installation*

### Magic
Magic is an open-source VLSI layout tool.<br /><br />
Install steps:
```
$  git clone git://opencircuitdesign.com/magic
$  cd magic
$	 ./configure
$  make
$  sudo make install
```
More info can be found at 
### Netgen
Netgen is a tool for comparing netlists, a process known as LVS, which stands for "Layout vs. Schematic" <br /><br />
Install steps:
```
$  git clone git://opencircuitdesign.com/netgen
$  cd netgen
$	./configure
$  make
$  sudo make install
```


### Xschem
Xschem is a schematic capture program <br /><br />
Install steps:
```
$  git clone https://github.com/StefanSchippers/xschem.git xschem_git
$	./configure
$  make
$  sudo make install
```

### Ngspice
ngspice is the open-source spice simulator for electric and electronic circuits.<br /><br />
Install steps:<br />

After downloading the tarball from  to a local directory, unpack it using:
```
 $ tar -zxvf ngspice-37.tar.gz
 $ cd ngspice-37
 $ mkdir release
 $ cd release
 $ ../configure  --with-x --with-readline=yes --disable-debug
 $ make
 $ sudo make install
```
More info can be found at 

Please note that to view the simulation graphs of ngspice, xterm is required and can be installed using.
```
$ sudo apt-get update
$ sudo apt-get install xterm
```

### open_pdk

Open_PDKs is distributed with files that support the Google/SkyWater sky130 open process description . Open_PDKs will set up an environment for using the SkyWater sky130 process with open-source EDA tools and tool flows such as magic, qflow, openlane, netgen, klayout, etc.<br /><br />
Install steps:
```
$  git clone git://opencircuitdesign.com/open_pdks
$  open_pdks
$	./configure --enable-sky130-pdk
$  make
$  sudo make install
```

Now that we have all the necessary tools installed let's understand the design flow!
## Chapter 1 - Understanding the design flow

### Verifiying the open_pdk installation
An initial working directory can be made by copying the required files as follows:
```
$ mkdir Lab1_and
$ cd Lab1_and
$ mkdir mag
$ mkdir netgen
$ mkdir xschem
$ cd xschem
$ cp /usr/local/share/pdk/sky130A/libs.tech/xschem/xschemrc .
$ cp /usr/local/share/pdk/sky130A/libs.tech/ngspice/spinit .spiceinit
$ cd ../mag
$ cp /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc .magicrc
$ cd ../netgen
$ cp /usr/local/share/pdk/sky130A/libs.tech/netgen//sky130A_setup.tcl .
```
Checking if magic works
![mag_test](Resources/Lab1/mag_test.png)<br /><br />
Checking if xschem works
![xschem_test](Resources/Lab1/xschem_test.png)<br /><br />
Checking if netgen works
![netgen_test](Resources/Lab1/netgen_test.png)<br /><br />
Checking if ngspice works
![spice_test](Resources/Lab1/spice_test.png)<br /><br />
### Creating inverter schematic using xschem
An initial schematic is made by placing components from the open_pdk library<br />
The required changes to the properties of the device can be made here and will automatically reflect in the layout

Convert the schematic to a symbol
<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/16ba31ff-4c0c-4f0f-93a2-4cb87718e3b0" />


Using the symbol, we can create an independent test bench to simulate the circuit
<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/927ebabc-c99b-4ca9-9565-a2da353fa100" />

### Creating and simulating testbench Schematic
The circuit can be simulated in ngspice. *make sure to disable .subckt in the simulation tab for the netlist generated for the sim*
![xschem_sim](Resources/Lab1/xschem_sim.png)
### Creating inverter layout in Magic and exporting its netlist
The original schematic can be used to export a netlist, which can be imported into magic to create the layout. <br /><br />

Set the appropriate device properties and route the layout.

### Performing LVS checks on testbench and layout netlists
The netlist of the layout can be extracted using
```
% extract do local
% extract all
% ext2spice lvs
% ext2spice
```

ext files are intermidiate files and can be cleaned using
```
rm *.ext
/usr/local/share/pdk/scripts/cleanup_unref.py -remove
```
The schematic netlist and layout netlist can be compared using LVS by netgen
```
$ netgen -batch lvs "../mag/inverter.spice inverter" "../xschem/inverter.spice inverter"
```

## Chapter 2 - DRC and LVS Fundamentals

### Design Rule Checking (DRC)
Make sure the design layout meets all silicon foundry rules for masks.

### Layout vs. Schematic (LVS)
Make sure the design layout matches a simulatable netlist by electrical connectivity and devices.



### Reading GDS files

```
$ cp /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc ./.magicrc
```

```
% gds read /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds
% load sky130_fd_sc_hd__and2_1
```


```
% cif istyle sky130(vendor)
% gds read /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds
```




### Matching ports to spice netlists

```
% port first
% port 1 name
% port 1 class
% port 1 use
```


```
% lef read /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
```


```
% readspice /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
% load sky130_fd_sc_hd__and2_1
```



### Abstract views

Note: the difference between load and getcell

The difference is between a cell and an instance of that cell.
If you do load inverter, then you will be editing the cell called inverter.
If you do getcell inverter, then you will place an instance of the cell inverter inside the cell you're currently editing.

```
% lef read /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
% load sky130_fd_sc_hd__and2_1
% readspice /usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
% load test
% getcell sky130_fd_sc_hd__and2_1
% gds write test     
```
!


Restart magic and the cell fails to be adequately loaded because the changes were not saved.
```
%gds read test
%save test
```


When the test is reloaded after saving, we get the original layout.
```
% load test
% gds write test
```
We can edit the cell by making it editable.
```
% property
% cellname writeable sky130_fd_sc_hd__and2_1 true
% gds write test
```


And after restarting magic and reloading it, we still get an unchanged cell
```
% gds read test
```




### Extraction
```
% extract all
% ext2spice lvs
% ext2spice
```

```
% ext2spice cthresh 0.01
% ext2spice
```


```
% ext2sim labels on
% ext2sim

% extresist tolerance 10
% extresist

% ext2spice lvs
% ext2spice cthresh 0.01
% ext2spice extresist on
% ext2spice
```
![spice_rc](Resources/Lab2/spice_rc.png)


### DRC
```
$ /usr/local/share/pdk/sky130A/libs.tech/magic/run_standard_drc.py /usr/local/share/pdk sky130A/libs.ref/sky130_fd_sc_hd/mag/sky130_fd_sc_hd__and2_1.mag
```
```
% drc liastall style
% drc style drc(full)
% drc check
% drc why
% drc find
```
```
% getcell sky130_fd_sc_hd__tapvpwrvgnd_1
```


### LVS
)

```
netgen -batch lvs "../mag/sky130_fd_sc_hd__and2_1.spice sky130_fd_sc_hd__and2_1" "/usr/local/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice sky130_fd_sc_hd__and2_1"
```




## Chapter 3 - DRC Issues

Each foundry has its own manufacturing rules and we have to make sure that the layout abides by these. The stackup for the skywater130 process is as folows:

The detailed explaination of all the rules can be found at:
[https://skywater-pdk.readthedocs.io/en/main/rules.html](https://skywater-pdk.readthedocs.io/en/main/rules.html)

### Useful Magic commands
- b
- s
- ?
- : box width 0.14um
- : stret u 0.14um
- : move e 0.14um
- : box grow c 0.01um
- : paint m1
- drc find
- see no *
- see m1




