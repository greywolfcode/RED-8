Red [
    Title: "RED-8"
    Author: "greywolfcode"
    File: "%main.red"
    Tabs: 4
    Rights:  "Copyright (C) 2026 greywolfcode. All rights reserved."
	License: {
		Distributed under the MIT License.
		See ./LICENSE
	}
    Needs: ["View"]
]

#include %config-handler.red

#include %lib\fixed-ints.red
#include %lib\stack.red

;----Load Data----
config: config-handler/read-config

;----Program Data----

ram: make block! 4096      ;4kb of ram
insert/dup ram 0 4096

pc: 513 ;program counter - set to first byte of code
I: make int16! [val: 0]        ;index register
delay-timer: make int8! [val: 0] 
sound-timer: make int8! [val: 0] 
stack: make stack! []
screen: make image! [64x32 0.0.0]

;----Variables----
V0: make int8! [val: 0] 
V1: make int8! [val: 0] 
V2: make int8! [val: 0] 
V3: make int8! [val: 0] 
V4: make int8! [val: 0] 
V5: make int8! [val: 0] 
V6: make int8! [val: 0] 
V7: make int8! [val: 0] 
V8: make int8! [val: 0] 
V9: make int8! [val: 0] 
VA: make int8! [val: 0] 
VB: make int8! [val: 0] 
VC: make int8! [val: 0] 
VD: make int8! [val: 0] 
VE: make int8! [val: 0] 
VF: make int8! [val: 0] 

;----Load Program----
if (config/program-data/path <> "") and (exists? to file! config/program-data/path) [
    program-source: read/binary to file! config/program-data/path
    insert at ram 513 program-source ;--at index 512 (1 base indexing)
]

view [
    title "RED-8"
    below
    image screen
]