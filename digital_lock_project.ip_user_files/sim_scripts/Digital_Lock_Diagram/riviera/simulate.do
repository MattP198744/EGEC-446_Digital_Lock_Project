transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+Digital_Lock_Diagram  -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Digital_Lock_Diagram xil_defaultlib.glbl

do {Digital_Lock_Diagram.udo}

run 1000ns

endsim

quit -force
