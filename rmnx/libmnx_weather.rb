
module Weather
	module Const
		A_ARTIFICIAL = 1
		A_BELOWGROUNDS = 2
		A_INTERIOR = 4

		S_WINTER = 1
		S_SPRING = 2
		S_SUMMER = 4
		S_FALL = 8

		P_CLEAR = 1
		P_C = 1
		P_RAIN = 2
		P_R = 2
		P_DOWNPOUR = 4
		P_D = 4
		P_SNOW = 8
		P_S = 8
		P_SLEET = 16
		P_L = 16
		P_FOG = 32
		P_F = 32
		P_HAIL = 64
		P_H = 64
		P_HSNOW = 128
		P_N = 128
		P_THUNDERSTORM = 256
		P_T = 256
		P_SANDSTORM = 512
		P_A = 512

		P_INDOOR = 2048

		T_XCOLD = 1
		T_X = 1
		T_COLD = 2
		T_C = 2
		T_MODERATE = 4
		T_M = 4
		T_WARM = 8
		T_W = 8
		T_HOT = 16
		T_H =16
		# unused:
		T_VHOT = 32
		T_V = 32

		W_FAIR = 1
		W_F = 1
		W_VARIES = 2
		W_V = 2
		W_STORM = 4
		W_S = 4
		W_NONE = 32
	end

	module Tables
		include Weather::Const
        WEATHER_TABLES = {
                S_WINTER => [
                        [T_X, W_FAIR, P_CLEAR],
                        [T_M, W_VARIES, P_CLEAR],
                        [T_MODERATE, W_FAIR, P_FOG],
                        [T_MODERATE, W_FAIR, P_RAIN],
                        [T_MODERATE, W_FAIR, P_DOWNPOUR],
                        [T_MODERATE, W_FAIR, P_HAIL],
                        [T_COLD, W_FAIR, P_CLEAR],
                        [T_COLD, W_FAIR, P_FOG],
                        [T_COLD, W_FAIR, P_SNOW],
                        [T_COLD, W_FAIR, P_HSNOW],
                        [T_COLD, W_FAIR, P_SLEET],
                        [T_COLD, W_FAIR, P_CLEAR],
                        [T_COLD, W_FAIR, P_HSNOW],
                        [T_COLD, W_FAIR, P_SLEET],
                        [T_XCOLD, W_FAIR, P_CLEAR],
                        [T_XCOLD, W_FAIR, P_SNOW],
                        [T_XCOLD, W_FAIR, P_CLEAR],
                        [T_XCOLD, W_FAIR, P_SNOW]
                ],
                S_SPRING => [
                        [T_W, W_V, P_C],
                        [T_W, W_V, P_R],
                        [T_W, W_V, P_D],
                        [T_W, W_S, P_C],
                        [T_W, W_S, P_T],
                        [T_M, W_V, P_C],
                        [T_M, W_F, P_F],
                        [T_M, W_V, P_R],
                        [T_M, W_V, P_D],
                        [T_M, W_V, P_H],
                        [T_M, W_S, P_C],
                        [T_M, W_S, P_D],
                        [T_M, W_S, P_H],
                        [T_C, W_V, P_C],
                        [T_C, W_F, P_F],
                        [T_C, W_V, P_S],
                        [T_C, W_V, P_N],
                        [T_C, W_V, P_L],
                        [T_C, W_S, P_C],
                        [T_C, W_S, P_N],
                        [T_C, W_S, P_L]
                ],
                S_SUMMER => [
                        [T_H, W_F, P_C],
                        [T_H, W_S, P_A],
                        [T_W, W_F, P_C],
                        [T_W, W_F, P_R],
                        [T_W, W_F, P_D],
                        [T_W, W_S, P_T],
                        [T_M, W_V, P_C],
                        [T_M, W_F, P_F],
                        [T_M, W_V, P_R],
                        [T_M, W_V, P_D],
                        [T_M, W_V, P_H],
                        [T_C, W_V, P_C],
                        [T_C, W_F, P_F],
                        [T_C, W_V, P_S],
                        [T_C, W_V, P_N],
                        [T_C, W_V, P_L]
                ],
                S_FALL => [
                        [T_H, W_F, P_C],
                        [T_H, W_S, P_A],
                        [T_W, W_V, P_C],
                        [T_W, W_V, P_R],
                        [T_W, W_V, P_D],
                        [T_W, W_S, P_C],
                        [T_W, W_S, P_T],
                        [T_M, W_V, P_C],
                        [T_M, W_F, P_F],
                        [T_M, W_V, P_R],
                        [T_M, W_V, P_D],
                        [T_M, W_V, P_H],
                        [T_M, W_S, P_C],
                        [T_M, W_S, P_D],
                        [T_M, W_S, P_H],
                        [T_C, W_V, P_C],
                        [T_C, W_F, P_F],
                        [T_C, W_V, P_S],
                        [T_C, W_V, P_N],
                        [T_C, W_V, P_L],
                        [T_C, W_S, P_C],
                        [T_C, W_S, P_N],
                        [T_C, W_S, P_L],
                        [T_X, W_V, P_C],
                        [T_X, W_V, P_S]
                ]

        }
	end

	module Probabilities
		include Weather::Const
        PROBABILITY = {
                S_WINTER => {
                        'river' => [
                                1..4,5..9,
                                10..15,16..18,
                                19..23,24..26,
                                27..39,40..50 ,
                                51..65 ,66..72 ,
                                73..77 ,
                                78     ,
                                79..83 ,
                                84..85 ,
                                86..90 ,
                                91..93 ,
                                94..98 ,
                                99..100,
                        ],
                        'open' => [
                                1..2 ,
                                3..6 ,
                                7..9 ,
                                10..12,
                                13..15 ,
                                16..17 ,
                                18..36 ,
                                37..43,
                                44..58,
                                59..65,
                                66..71,
                                72..73,
                                74..79,
                                80..81,
                                82..88,
                                89..91,
                                92..97,
                                98..100,
                        ],
                        'north' => [
                                1    ,
                                2..3,
                                4  ,
                                5..6,
                                7  ,
                                8 ,
                                9..20,
                                21..29,
                                30..42 ,
                                43..38 ,
                                49..55 ,
                                56..59 ,
                                60..65 ,
                                66..68 ,
                                69..77 ,
                                78..88 ,
                                89..95 ,
                                96..100,
                        ],
                        'desert' => [
                        ],
                },



                S_SPRING => {
                        'river' => [
                                1..7,8..14,15..19,20..25,26..30,31..36,37..50,51..59,60..63,64..67,68..71,72..76,
                                77..79,80..83,84..87,88..92,93..94,95,96..97,98..99,100,
                        ],
                        'open' => [
                                1..6,7..12,13..16,17..21,22..25,36..31,32..38,39..51,52..55,56..59,60..63,64..66,67..69,
                                70..74,75..77,78..86,87..89,90..92,93..95,96..97,98..100
                        ],
                        'north' => [
                                1..4,5..7,8..9,10..13,14..16,17..24,25..30,31..37,38..40,41..45,46..53,54..56,
                                57..61,62..68,69..76,77..88,89..91,92..94,95..97,98..99,100
                        ],
                        'desert' => [
                        ],
                },


                S_SUMMER => {
                        'river' => [
                                1..9, 10, 11..30, 31..39, 40..45, 46..54, 55..74, 74..84, 85..93, 94..97, 98..100,
                                nil,nil,nil,nil,nil
                        ],
                        'open' => [
                                1..8,9..10,11..27,28..36,37..41,42..50,51..71,72..76,77..86,87..90,91..93,94..95,
                                96..97,98..99,nil,100
                        ],
                        'north' => [
                                nil,nil,1..17,18..23,24..25,26..35,36..49,50..57,58..67,68..73,74..77,78..84,
                                85..90,91..98,99..100
                        ],
                        'desert' => [
                        ],
                },

                S_FALL => {
                        'river' => [
                                1..3,4,5..13,14..17,18..19,20..21,22..26,27..34,35..44,45..54,55..56,57..58,59..63,
                                64..65,66..67,68..76,77..84,85..90,91..92,93..94,95..96,97..98,99..100,nil,nil
                        ],
                        'open' => [
                                1..3,4..5,6..12,13..17,18..19,20..22,23..28,29..35,36..39,40..48,49..51,52..53,
                                54..59,60..61,62..63,64..73,74..77,78..84,85..87,88..89,90..92,93..94,95..96,97..99,100
                        ],
                        'north' => [
                                nil,nil,1..3,4..5,6,7..8,9..15,16..23,24..29,30..37,38..40,41..43,44..45,46..48,49..51,
                                52..61,62..66,67..76,77..79,80..81,82..85,86..88,89..90,91..98,99..10
                        ],
                        'desert' => [
                        ],
                },
        }

	end
end
