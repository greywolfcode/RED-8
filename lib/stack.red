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

stack!: object [
    stack: []

    push: func [val] [
        append stack val
    ]
    pop: func [] [
        take/last stack ;--stack is last in, first out
    ]
    peek: func [] [
        last stack
    ]
    is-empty: func [] [
        output: false
        if length? stack <= 0 [
            output: true
        ]

        output ;--return value
    ]
]