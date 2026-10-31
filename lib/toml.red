Red [
    Title: "RED-8"
    Author: "greywolfcode"
    File: "%main.red"
    Tabs: 4
    Rights:  "Copyright (C) 2026 greywolfcode. All rights reserved."
	License: {
		Distributed under the MIT License.
		See ../LICENSE
	}
]

toml: object [ ;--in toml "namespace"
    serialize: func [
        data [object!]
    ][
        output: ""
        foreach key words-of data [
            value: get in data key
            case [ 
                string? value [append output rejoin [key " = ^"" value "^""]]
            ]

            append output "^/"
        ]

        output ;--return value
    ]
]

;--Test Code
;--TODO: Remove later
a: object [
    asl: "asdf"
    asdf: "sadfgasg"
]
print toml/serialize a