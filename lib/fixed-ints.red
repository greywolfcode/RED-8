Red [
    Title: "RED-8"
    Author: "greywolfcode"
    File: "%fixed-ints.red"
    Tabs: 4
    Rights:  "Copyright (C) 2026 greywolfcode. All rights reserved."
	License: {
		Distributed under the MIT License.
		See ../LICENSE
	}
]

int8!: object [
    val: integer!

    wrap: func [] [
        val: val and FFh
    ]

    add: func [
        operand [integer! object!]
    ][
        switch type? operand [
            integer! [val: val + operand]
            object! [val: val + operand/val] ;--assumes the new obejct will be an int8! or int16!
        ]
        wrap
    ]
    sub: func [
        operand [integer! object!]
    ][
        switch type? operand [
            integer! [val: val - operand]
            object! [val: val - operand/val] ;--assumes the new obejct will be an int8! or int16!
        ]
        wrap
    ]
    mult: func [
        operand [integer! object!]
    ][
        switch type? operand [
            integer! [val: val * operand]
            object! [val: val * operand/val] ;--assumes the new obejct will be an int8! or int16!
        ]
        wrap
    ]
    div: func [
        operand [integer! object!]
    ][
        switch type? operand [
            integer! [val: val / operand]
            object! [val: val / operand/val] ;--assumes the new obejct will be an int8! or int16!
        ]
        wrap
    ]
]

int16!: object [
    val: integer!

    wrap: func [] [
        val: val and FFFFh
    ]

    add: func [
        operand [integer! object!]
    ][
        switch type? operand [
            integer! [val: val + operand]
            object! [val: val + operand/val] ;--assumes the new obejct will be an int8! or int16!
        ]
        wrap
    ]
    sub: func [
        operand [integer! object!]
    ][
        switch type? operand [
            integer! [val: val - operand]
            object! [val: val - operand/val] ;--assumes the new obejct will be an int8! or int16!
        ]
        wrap
    ]
    mult: func [
        operand [integer! object!]
    ][
        switch type? operand [
            integer! [val: val * operand]
            object! [val: val * operand/val] ;--assumes the new obejct will be an int8! or int16!
        ]
        wrap
    ]
    div: func [
        operand [integer! object!]
    ][
        switch type? operand [
            integer! [val: val / operand]
            object! [val: val / operand/val] ;--assumes the new obejct will be an int8! or int16!
        ]
        wrap
    ]
]