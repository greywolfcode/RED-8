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

;----Program Data----

ram: vector! 4096       ;4kb of ram
pc: 0                   ;program counter
I: make integer! 0        ;index register
delay-timer: make integer! 0
sound-timer: make integer! 0

;----Variables----
V0: make integer! 0
V1: make integer! 0
V2: make integer! 0
V3: make integer! 0
V4: make integer! 0
V5: make integer! 0
V6: make integer! 0
V7: make integer! 0
V8: make integer! 0
V9: make integer! 0
VA: make integer! 0
VB: make integer! 0
VC: make integer! 0
VD: make integer! 0
VE: make integer! 0
VF: make integer! 0

view [
    title "RED-8"
    below
    base 64x32
]