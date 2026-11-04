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
    Notes: {
        This library only supports basic toml (string, integer, float, boolean, and basic tables).
        It is meant to be used by its own output, and will break if used with malformed files.
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

    ;--function to incremnt int if it is below certain value
    inc: func [
        int [integer!]
        maximum [integer!]
    ][
        if int < maximum [int: int + 1]
        int ;--return value
    ]
    deserialize: function [
        data [string!]
    ][
        ;--Rules
        digit:   charset "0123456789"
        letters: charset [#"a" - #"z" #"A" - #"Z"]
        integer: [["-" some  digit] | some digit]
        float:   [integer "." some digit]
        logic:   ["true" | "false"]
        string:  ["^"" some letters "^""]
        key-seperator: [space | "="]
        newline: [#"^M" | #"^/"] ;--need to check for CR and LF

        output: make map! []
        current-map: output
        current-string: ""
        
        i: 1
        while [i < length? data] [ ;--i will be incremented to length of data during parsing
            current-char: to string! pick data i 

            while [(parse current-char newline) and (i <> length? data)] [
                i: inc i length? data
                current-char: to string! pick data i
            ]

            either current-char = "[" [ ;--new table
                i: inc i length? data
                current-char: to string! pick data i

                ;--find name for new table
                while [current-char <> "]"] [
                    current-string: rejoin [current-string current-char]
                    i: inc i length? data
                    current-char: to string! pick data i
                ]
                i: inc i length? data
                current-char: pick data i

                new-map: make map! []
                put current-map current-string new-map
                current-map: new-map
                current-string: ""
            ] [ ;--regular data
                ;--find key name
                while [(not parse current-char key-seperator) and (i <> length? data)] [ 
                    current-string: rejoin [current-string current-char]
                    i: inc i length? data
                    current-char: to string! pick data i
                ]
                
                key: current-string
                current-string: ""
                
                while [parse current-char key-seperator][ ;--remove extra spaces and key seperator
                    i: inc i length? data
                    current-char: to string! pick data i
                ] 

                ;--Find value
                while [(current-char <> "^/") and (i <> length? data)] [
                    current-string: rejoin [current-string current-char]
                    i: inc i length? data
                    current-char: to string! pick data i
                ]
                case [
                    parse current-string float [value: to float! current-string]
                    parse current-string integer [value: to integer! current-string]
                    parse current-string logic [value: to logic! current-string]
                    parse current-string string [value: copy/part at current-string 2 ((length? current-string) - 2)] ;--remove quotes
                ]
                put current-map key value

                current-string: ""
            ]
        ]
        
        output ;--return value
    ]
    load: func [
        file [file!]
    ][
        toml-data: read file
        output: toml/deserialize toml-data ;--return value
    ]
]