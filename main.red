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
debug: true

;----Program Data----

ram: make block! 4096      ;4kb of ram
insert/dup ram 0 4096

pc: 512 ;program counter - set to first byte of code
I: make int16! [val: 0]        ;index register
delay-timer: make int8! [val: 0] 
sound-timer: make int8! [val: 0] 
stack: make stack! []
screen: make image! [64x32 0.0.0]

;----Variables----

registers: make reactor! [
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
]

;----Interpreter Functions----

get-register-name: func [
    num [integer!]
][
    hex-chars: "0123456789ABCDEF"

    ;--create register name as word
    register-num: pick hex-chars (num + 1)
    register-name: to-word rejoin ["V" register-num] 
    register: registers/(register-name) ;--return value
]

process-instruction: func [] [
    ;--step 1: fetch instruction
    byte-one: to-integer pick ram pc 
    byte-two: to-integer pick ram (pc + 1)
    pc: pc + 2

    ;--step 2: decode instruction data
    X: byte-one and 0Fh
    Y: (byte-two and F0h) >> 4
    N: (byte-two and 0Fh)
    NN: byte-two
    NNN: ((byte-one and 0Fh) << 8) or byte-two
    ;--step 2: decode and execute
    switch (byte-one and F0h) >> 4 [
        00h [
            switch NNN [
                0E0h [ ;--clear screen - 00E0
                    screen/rgb: 0.0.0
                ]
            ]
        ]
        01h [ ;--jump - 1NNN
            pc: NNN
        ]
        06h [ ;--set - 6XNN
            register-name: get-register-name X
            set register-name make int8! [val: NN] 
        ]
        07h [ ;--add - 7XNN
            register-name: get-register-name X
            register: get register-name
            register/add NN
        ]
        0Ah [ ;--set index - ANNN
            I: make int16! [val: NNN]
        ]
        0Dh [ ;--display - DXYN
            x-reg-val: get get-register-name X
            y-reg-val: get get-register-name Y
            x-coord: x-reg-val/val and 3Fh ;--mod 64 wrap around
            y-coord: y-reg-val/val and 20h ;--mod 32 wrap around
            registers/VF: make int8! [val: 0] 

            repeat y-count N [
                current-y-coord: y-coord + y-count
                if (current-y-coord) > 32 [ ;--check if out of bounds
                        break
                ]

                byte: pick ram (I/val + y-count - 1) ;--handle 1 based indexing

                repeat x-count 8 [
                    current-x-coord: x-coord + x-count

                    if (current-x-coord) > 64 [ ;--check if out of bounds
                        break
                    ]

                    index: (((y-coord + y-count) * 64) + ((x-coord + x-count) + 1)) ;--calculate index into image (1 based index)
                    bit: (byte >> x-count) and 1 ;--get current bit
                    either (pick screen index) = white [
                        poke screen index black
                        registers/VF: make int8! [val: 1] 
                    ][
                        poke screen index white
                    ]
                ]
            ]
        ]
    ]
]

;----Load Program----
if (config/program-data/path <> "") and (exists? to file! config/program-data/path) [
    program-source: read/binary to file! config/program-data/path
    forall program-source [
        index: index? program-source
        insert at ram (513 + index) first program-source ;--at index 512 (1 base indexing)
    ]
]


;----Setup UI----
either debug [
    ;--extrea debug variables
    current-ram-display-index: 0

    window: layout [
        title "RED-8"
        below
        panel [
            across
            panel [
                below
                text "" react [face/text: rejoin["V0: " to-string registers/V0/val]]
                text "" react [face/text: rejoin["V1: " to-string registers/V1/val]]
                text "" react [face/text: rejoin["V2: " to-string registers/V2/val]]
                text "" react [face/text: rejoin["V3: " to-string registers/V3/val]]
                text "" react [face/text: rejoin["V4: " to-string registers/V4/val]]
                text "" react [face/text: rejoin["V5: " to-string registers/V5/val]]
                text "" react [face/text: rejoin["V6: " to-string registers/V6/val]]
                text "" react [face/text: rejoin["V7: " to-string registers/V7/val]]
                text "" react [face/text: rejoin["V8: " to-string registers/V8/val]]
                text "" react [face/text: rejoin["V9: " to-string registers/V9/val]]
                text "" react [face/text: rejoin["VA: " to-string registers/VA/val]]
                text "" react [face/text: rejoin["VB: " to-string registers/VB/val]]
                text "" react [face/text: rejoin["VC: " to-string registers/VC/val]]
                text "" react [face/text: rejoin["VD: " to-string registers/VD/val]]
                text "" react [face/text: rejoin["VE: " to-string registers/VE/val]]
                text "" react [face/text: rejoin["VF: " to-string registers/VF/val]]
            ]
            panel [
                display: base 640x320 draw [image screen 0x0 640x320]
            ]
        ]
        panel [
            across
            ram-display: panel 620x180 [
                below
                row-1: panel [
                    origin 0x0
                    space 0x0
                    across
                    byte-1x1: text "0x00"
                    byte-2x1: text "0x00"
                    byte-3x1: text "0x00"
                    byte-4x1: text "0x00"
                    byte-5x1: text "0x00"
                    byte-6x1: text "0x00"
                    byte-7x1: text "0x00"
                    byte-8x1: text "0x00"
                ]
                row-2: panel [
                    origin 0x0
                    space 0x0
                    across
                    byte-1x2: text "0x00"
                    byte-2x2: text "0x00"
                    byte-3x2: text "0x00"
                    byte-4x2: text "0x00"
                    byte-5x2: text "0x00"
                    byte-6x2: text "0x00"
                    byte-7x2: text "0x00"
                    byte-8x2: text "0x00"
                ]
                row-3: panel [
                    origin 0x0
                    space 0x0
                    across
                    byte-1x3: text "0x00"
                    byte-2x3: text "0x00"
                    byte-3x3: text "0x00"
                    byte-4x3: text "0x00"
                    byte-5x3: text "0x00"
                    byte-6x3: text "0x00"
                    byte-7x3: text "0x00"
                    byte-8x3: text "0x00"
                ]
                row-4: panel [
                    origin 0x0
                    space 0x0
                    across
                    byte-1x4: text "0x00"
                    byte-2x4: text "0x00"
                    byte-3x4: text "0x00"
                    byte-4x4: text "0x00"
                    byte-5x4: text "0x00"
                    byte-6x4: text "0x00"
                    byte-7x4: text "0x00"
                    byte-8x4: text "0x00"
                ]
            ]
            scroll-bar: scroller 20x180 [
                current-scroll: face/data
                current-ram-display-index: to-integer ((round (current-scroll * 511)) * 8 + 1) ;--1 to 4096, steps of 8
                fill-ram-display current-ram-display-index
            ]
        ]
    ]
    fill-ram-display: func [
        start-pos [integer!]
    ][
        repeat i 4 [
            repeat j 8 [
                current-byte-name: rejoin ["byte-" to-string j "x" to-string i]
                current-display-byte: to-word current-byte-name

                current-byte-val: rejoin ["0x" to-string to-hex/size to-integer pick ram (start-pos + i + j) 2] ;-format byte values
                set in get current-display-byte 'text current-byte-val
            ]
        ]
    ]

    fill-ram-display current-ram-display-index

    update-display: func [] [
        ;update screen display
        display/draw: compose [image screen 0x0 (display/size)]
        show display
    ]

    view/options/no-wait window [flags: [resize]] ;--allow interpreter loop to handle events

    forever [
        do-events/no-wait
        wait 0.01

        if none? window/state [
            break
        ]

        process-instruction
        update-display
    ]
][
    window: layout [
        title "RED-8"
        size 640x320
        
        display: base 640x320 draw [image screen 0x0 640x320]
    ]

    update-display: func [] [
        display/draw: compose [image screen 0x0 (display/size)]
        show display
    ]

    window/actors: context [ ;--set event handelers
        on-resize: func [
            face 
            event
        ] [
            display/size: face/size
            update-display
        ]
    ]

    view/options/no-wait window [flags: [resize]] ;--allow interpreter loop to handle events

    forever [
        do-events/no-wait
        wait 0.01

        if none? window/state [
            break
        ]

        process-instruction
        update-display
    ]
]