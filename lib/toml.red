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
    serialize: function [
        data [object!]
    ][
        output: copy ""
        foreach key words-of data [
            value: get in data key
            case [ 
                string? value [append output rejoin [key " = ^"" value "^""]]
                integer? value [append output rejoin [key " = " value ]]
                float? value [append output rejoin [key " = " value ]]
                logic? value [append output rejoin [key " = " value ]]
                object? value [append output rejoin ["^/[" key "]^/" toml/serialize value]]
            ]

            append output "^/"
        ]

        output ;--return value
    ]
    save: func [
        file [file!]
        data [object!]
    ][
        toml-data: toml/serialize data
        write file toml-data
    ]
]