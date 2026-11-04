Red [
    Title: "RED-8"
    Author: "greywolfcode"
    File: "%save-handler.red"
    Tabs: 4
    Rights:  "Copyright (C) 2026 greywolfcode. All rights reserved."
	License: {
		Distributed under the MIT License.
		See ./LICENSE
	}
]

#include %lib\toml.red

config-handler: object [
    default: #[  ;--fallback argument
        program-data #[
            path ""
        ]
    ]
    current-config: copy default
    config-path: %config.toml

    map-to-object: func [
        data [map!]
        /local output key value
    ][
        output: make block! []
        foreach [key value] data [
            if map? value [ ;--recursively convert inner maps
                value: config-handler/map-to-object value
            ]
            append output to set-word! key
            append/only output value
        ]

        object output ;--return value
    ]

    read-config: does [
        config-data: default
        either exists? config-path [
            config-data: toml/load config-path
        ][
            config-handler/write-config ;--create new save using default
        ]

        current-config: config-data
        config-data ;--return value
    ]
    write-config: does [
        print config-handler/map-to-object current-config 
        toml/save config-path config-handler/map-to-object current-config 
    ]
    edit-save: func [
        key
        value
    ] [
        put current-config key value

        current-config ;--return new config data
    ]
]