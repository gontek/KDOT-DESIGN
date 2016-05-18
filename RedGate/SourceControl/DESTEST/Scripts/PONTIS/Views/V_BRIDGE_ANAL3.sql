CREATE OR REPLACE FORCE VIEW pontis.v_bridge_anal3 (brkey,ykey,hindex,suff_rating,deck,sup,sub,culv) AS
select brkey,
                ykey,
                hindex,
                suff_rating,
                DECODE (rating_deck,
                        '0',to_number( rating_deck),
                        '1',to_number( rating_deck),
                        '2',to_number( rating_deck),
                        '3',to_number( rating_deck),
                        '4',to_number( rating_deck),
                        '5',to_number( rating_deck),
                        '6',to_number( rating_deck),
                        '7',to_number( rating_deck),
                        '8',to_number( rating_deck),
                        '9',to_number( rating_deck),
                        -1)
                as deck,
                DECODE (rating_sup,
                        '0',to_number( rating_sup),
                        '1',to_number( rating_sup),
                        '2',to_number( rating_sup),
                        '3',to_number( rating_sup),
                        '4',to_number( rating_sup),
                        '5',to_number( rating_sup),
                        '6',to_number( rating_sup),
                        '7',to_number( rating_sup),
                        '8',to_number( rating_sup),
                        '9',to_number( rating_sup),
                        -1)
                as sup,
                DECODE (rating_sub,
                        '0',to_number( rating_sub),
                        '1',to_number( rating_sub),
                        '2',to_number( rating_sub),
                        '3',to_number( rating_sub),
                        '4',to_number( rating_sub),
                        '5',to_number( rating_sub),
                        '6',to_number( rating_sub),
                        '7',to_number( rating_sub),
                        '8',to_number( rating_sub),
                        '9',to_number( rating_sub),
                        -1)
                as sub,
                DECODE (rating_culv,
                        '0',to_number( rating_culv),
                        '1',to_number( rating_culv),
                        '2',to_number( rating_culv),
                        '3',to_number( rating_culv),
                        '4',to_number( rating_culv),
                        '5',to_number( rating_culv),
                        '6',to_number( rating_culv),
                        '7',to_number( rating_culv),
                        '8',to_number( rating_culv),
                        '9',to_number( rating_culv),
                        -1)
                as culv
            from futmetric f
            where f.sckey = (select optionval from PON_COPTIONS where optionname = 'BRIDGEANALSCEN');