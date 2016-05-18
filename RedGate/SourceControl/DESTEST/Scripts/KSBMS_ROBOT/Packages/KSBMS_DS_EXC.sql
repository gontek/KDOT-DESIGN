CREATE OR REPLACE PACKAGE ksbms_robot.ksbms_ds_exc
IS
   exc_ds_application_exception             EXCEPTION;
   en_ds_application_exception     CONSTANT PLS_INTEGER := -20000;
   PRAGMA exception_init (exc_ds_application_exception,  -20000);

   FUNCTION ds_application_exception
      RETURN PLS_INTEGER;

   exc_building_concatenated_keys           EXCEPTION;
   en_building_concatenated_keys   CONSTANT PLS_INTEGER := -20100;
   PRAGMA exception_init (exc_building_concatenated_keys,  -20100);

   FUNCTION building_concatenated_keys
      RETURN PLS_INTEGER;
END ksbms_ds_exc;

 
/