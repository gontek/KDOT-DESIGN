CREATE OR REPLACE FUNCTION pontis.f_cvt_dec_string_latlong (
   the_decimal_latlong   IN   NUMBER,
   the_type_ref          IN   VARCHAR2,
   the_dec_plcs          IN   PLS_INTEGER,
   the_min_latlong       IN   NUMBER,
   the_max_latlong       IN   NUMBER,
   the_fmt_string        IN   VARCHAR2
)
   RETURN VARCHAR2
IS
   
/*
-- ARM 3/12/2002
-- takes decimal degrees, checks value reasonableness always, checks min/max lat long range optionally, takes optional format string argument for display..
-- returns (formatted) string e.g. DDMMSSSS, ddmmss
-- usage

   Select  f_cvt_dec_string_latlong( LONGITUDE, 'LONG' ) FROM DUAL;
   Select  f_cvt_dec_string_latlong( LONGITUDE, 'LONG',4 ) FROM DUAL; -- format with 4 digits of seconds

    select  f_cvt_dec_string_latlong( LONGITUDE, 'LONG',-2 ) FROM DUAL; -- format with  00 seconds (-2 causes all to be rounded off);

   Select  f_cvt_dec_string_latlong( LONGITUDE, 'LONG',2, 140,160 ) FROM DUAL; -- format with 2 digits of seconds, longitude must be between 140 and 160 inclusive

   Select  f_cvt_dec_string_latlong( LONGITUDE, 'LONG',4, 140,160,'FMT' ) FROM DUAL; -- format with 2 digits of seconds, longitude must be between 140 and 160 inclusive,
   value looks like nndnn'nn"


Does not accept lat > 90 or long > 180.  Negatives are OK.

*/


   ll_degrees           PLS_INTEGER; -- holds integerized degrees result
   ll_minutes           PLS_INTEGER; -- holds integerized minutes  result
   lr_seconds           FLOAT; -- holds decimal seconds result
   lr_floatpart         FLOAT; -- holds remainders while being resolved
   ls_latlong           VARCHAR2 (40); -- holds result string of lat long
   lb_check_range       BOOLEAN       := FALSE; -- when true, bother to check range.
   ls_deg_fmt           VARCHAR2 (3)  := '009';
   ls_min_fmt           VARCHAR2 (2)  := '09';
   ls_sec_fmt           VARCHAR2 (23) := '09';
  
-- exceptions
   null_convert_value   EXCEPTION; -- why bother at all if null
   out_of_bounds        EXCEPTION; -- >90 LAT or > 180 long
   bad_convert_type     EXCEPTION; -- second arg not LAT or LONG
   failed_range_check   EXCEPTION; -- when passed value isn't within the allowed solution domain for lat long e.g. outside state lat/long limits
   bad_range_limits     EXCEPTION; -- outside of boundaries passed to function, if checking
   too_much_precision   EXCEPTION;
BEGIN
   
-- no null degrees allowed
   IF the_decimal_latlong IS NULL
   THEN
      RAISE null_convert_value;
/*ADVICE(61): An exception is raised and handled in the same scope [554] */

   END IF;

   IF the_dec_plcs > 18
   THEN
      RAISE too_much_precision;
/*ADVICE(68): An exception is raised and handled in the same scope [554] */

   END IF;

   
-- argument for convert must be in set of LAT or LONG
-- make sure valid convert type
-- Instr(char, search_string, startpos, occurrence)
   IF    NOT (INSTR ('|LAT|LONG|', the_type_ref, 1) > 0)
      OR the_type_ref IS NULL
   THEN
      RAISE bad_convert_type;
/*ADVICE(80): An exception is raised and handled in the same scope [554] */

   END IF;

   
-- check that range limits are not backwards.
   IF      the_min_latlong IS NOT NULL
       AND the_max_latlong IS NOT NULL
       AND the_min_latlong >=
                            the_max_latlong -- gotta be some range interval > 0
   THEN
      RAISE bad_range_limits;
/*ADVICE(92): An exception is raised and handled in the same scope [554] */

   ELSE
      -- only if both bounds are passed, and min < max 
      lb_check_range := TRUE;
   END IF;

   
-- make sure valid value e.g. within reasonable limits for LAT LONG

   IF the_type_ref = 'LAT'
   THEN -- latitude
      IF ABS (the_decimal_latlong) > 90
      THEN
         RAISE out_of_bounds;
/*ADVICE(107): An exception is raised and handled in the same scope [554] */

      END IF;

      IF lb_check_range
      THEN
         -- verify between range limits for LAT
         IF    the_decimal_latlong < the_min_latlong
            OR the_decimal_latlong > the_max_latlong
         THEN
            RAISE failed_range_check;
/*ADVICE(118): An exception is raised and handled in the same scope [554] */

         END IF;
      END IF;
   ELSE
      IF ABS (the_decimal_latlong) > 180
      THEN
         RAISE out_of_bounds;
/*ADVICE(126): An exception is raised and handled in the same scope [554] */

      END IF;

      IF lb_check_range
      THEN
         -- do something to check  - verify that range is also within bounds for LONG
         IF    the_decimal_latlong < the_min_latlong
            OR the_decimal_latlong > the_max_latlong
         THEN
            RAISE failed_range_check;
/*ADVICE(137): An exception is raised and handled in the same scope [554] */

         END IF;
      END IF;
   END IF;

   
-- wrap all with NVL to force 0
   ll_degrees := NVL (TRUNC (the_decimal_latlong), 0);
   lr_floatpart := MOD (the_decimal_latlong, 1) * 60; -- universal truth (mod of 1 is whatever TRUNC left over)
   ll_minutes := NVL (TRUNC (lr_floatpart), 0);
   lr_seconds :=
             NVL (ROUND (MOD (lr_floatpart, 1) * 60, NVL (the_dec_plcs, 2)), 0); -- we only hold 2 degrees precision by default, or more may be passed

   -- leading zeroes always, but depends on LAT or LONG
   IF the_fmt_string IS NULL
   THEN
      IF the_type_ref = 'LAT'
      THEN
         ls_deg_fmt := '09'; --0-90
      ELSE
         ls_deg_fmt := '009'; -- 0- 180
      END IF;

      IF      the_dec_plcs IS NOT NULL
          AND the_dec_plcs > 0
      THEN
         ls_sec_fmt := '09.';

         FOR ith
/*ADVICE(167): This definition hides another one [556] */
                 IN 1 .. the_dec_plcs
         LOOP
            ls_sec_fmt := REPLACE (TRIM (   ls_sec_fmt
                                         || '9'), ' '
/*ADVICE(172): In Oracle 8 strings of zero length are not equivalent to a NULL
              [111] */
                                                         );
         END LOOP;
      END IF;

      ls_latlong :=    TRIM (TO_CHAR (ll_degrees, ls_deg_fmt))
                    || TRIM (TO_CHAR (ll_minutes, ls_min_fmt))
                    || TRIM (TO_CHAR (lr_seconds, ls_sec_fmt));
   ELSE
      -- ENHANCEMENT, format to match format string  e.g. dddmm'ss"
      ls_latlong :=    TRIM (TO_CHAR (ll_degrees, ls_deg_fmt))
                    || 'd'
                    || TRIM (TO_CHAR (ll_minutes, ls_min_fmt))
                    || ''''
                    || TRIM (TO_CHAR (lr_seconds, ls_sec_fmt))
                    || '"';
   END IF;

   RETURN ls_latlong;
EXCEPTION
   WHEN null_convert_value
   THEN
      RETURN 'Null Lat/Long Value';
   WHEN too_much_precision
   THEN
      RETURN 'Precision exceed 18 decimal places';
   WHEN bad_range_limits
   THEN
      RETURN 'BAD_RANGE_LIMITS';
   WHEN failed_range_check
   THEN
      RETURN 'VALUE OUTSIDE RANGE LIMITS';
   WHEN bad_convert_type
   THEN
      RETURN 'BAD CONVERT_TYPE';
   WHEN out_of_bounds
   THEN
      RETURN 'BAD LAT LONG VALUE';
   WHEN OTHERS
   THEN
      RETURN 'UNKNOWN ERROR OCCURRED';
END f_cvt_dec_string_latlong;
/*ADVICE(215): ADVICE SUMMARY

Count  Recommendation
-----  --------------
    1  [111]  In Oracle 8 strings of zero length are not equivalent
              to a NULL

                  PL/SQL treats any zero-length string like a null. This
                  includes values returned by character functions and boolean
                  expressions.
                  According to the ANSI SQL 1992 Transitional standard, a
                  zero-length or empty string is not the same as NULL. The
                  Oracle database server may comply fully with this aspect of
                  the standard in the future.Therefore, it is recommended that
                  applications ensure that empty strings values and NULL are
                  not treated equivalently.
                  To concatenate an expression that might be null, use the NVL
                  function to explicitly convert the expression to a
                  zero-length string.

    1  [553]  Unreferenced variable

                  You have defined a parameter in the parameter list, but it
                  is not used inside the program. This can occur as the result
                  of deprecations in code over time, but you should make sure
                  that this situation does not reflect a problem. And you
                  should remove the declaration to avoid maintenance errors in
                  the future.

    8  [554]  An exception is raised and handled in the same scope

                  While it is perfectly legitimate to raise an exception and
                  then trap that exception in the same scope, developers
                  sometimes do this when they misuse the exception handling
                  mechanism as a kind of GOTO command. One good indicator of
                  this problem may be found in the declaration of the
                  exception. If the name of the exception describes an action
                  as opposed to an error, then there is a very good chance
                  that exceptions are being misused.

    1  [556]  This definition hides another one

                  The element has already been declared in a higher scope. (Is
                  it a FOR LOOP variable ?)
                  Any references to it in the current scope will reference the
                  latest definition.

 */

 
/