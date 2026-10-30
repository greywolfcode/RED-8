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
        operand [integer!]
    ][
        val: val + operand 
        wrap
    ]
    sub: func [
        operand [integer!]
    ][
        val: val - operand 
        wrap
    ]
    mult: func [
        operand [integer!]
    ][
        val: val * operand 
        wrap
    ]
    div: func [
        operand [integer!]
    ][
        val: val / operand 
        wrap
    ]

]