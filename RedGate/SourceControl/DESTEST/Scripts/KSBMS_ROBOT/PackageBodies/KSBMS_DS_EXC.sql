CREATE OR REPLACE PACKAGE BODY ksbms_robot.ksbms_ds_exc
IS
   FUNCTION ds_application_exception
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN en_ds_application_exception;
   END ds_application_exception;

   FUNCTION building_concatenated_keys
      RETURN PLS_INTEGER
   IS
   BEGIN
      RETURN en_building_concatenated_keys;
   END building_concatenated_keys;
END ksbms_ds_exc;
/