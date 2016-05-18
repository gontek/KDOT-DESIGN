CREATE OR REPLACE PACKAGE BODY ksbms_robot.KSBMS_EXC
IS
FUNCTION application_exception RETURN PLS_INTEGER
IS BEGIN RETURN en_application_exception; END application_exception;
FUNCTION general_cvt_exception RETURN PLS_INTEGER
IS BEGIN RETURN en_general_cvt_exception; END general_cvt_exception;
FUNCTION generic_exception RETURN PLS_INTEGER
IS BEGIN RETURN en_generic_exception; END generic_exception;

FUNCTION bad_cvt_factor RETURN PLS_INTEGER
IS BEGIN RETURN en_bad_cvt_factor; END bad_cvt_factor;
FUNCTION null_cvt_factor RETURN PLS_INTEGER
IS BEGIN RETURN en_null_cvt_factor; END null_cvt_factor;
FUNCTION cvt_factor_missing RETURN PLS_INTEGER
IS BEGIN RETURN en_cvt_factor_missing; END cvt_factor_missing;
FUNCTION too_many_datadict_rows RETURN PLS_INTEGER
IS BEGIN RETURN en_too_many_datadict_rows; END too_many_datadict_rows;
FUNCTION bad_cvt_input_value RETURN PLS_INTEGER
IS BEGIN RETURN en_bad_cvt_input_value; END bad_cvt_input_value;
FUNCTION null_cvt_input_value RETURN PLS_INTEGER
IS BEGIN RETURN en_null_cvt_input_value; END null_cvt_input_value;
FUNCTION fileio_general_exception RETURN PLS_INTEGER
IS BEGIN RETURN en_fileio_general_exception; END fileio_general_exception;
FUNCTION fileio_open_file RETURN PLS_INTEGER
IS BEGIN RETURN en_fileio_open_file; END fileio_open_file;
FUNCTION fileio_close_file RETURN PLS_INTEGER
IS BEGIN RETURN en_fileio_close_file; END fileio_close_file;
FUNCTION fileio_write_file RETURN PLS_INTEGER
IS BEGIN RETURN en_fileio_write_file; END fileio_write_file;
FUNCTION fileio_read_file RETURN PLS_INTEGER
IS BEGIN RETURN en_fileio_read_file; END fileio_read_file;
FUNCTION fileio_sysfile_create RETURN PLS_INTEGER
IS BEGIN RETURN en_fileio_sysfile_create; END fileio_sysfile_create;
FUNCTION cvt_trigger_upd_failed RETURN PLS_INTEGER
IS BEGIN RETURN en_cvt_trigger_upd_failed; END cvt_trigger_upd_failed;
FUNCTION cvt_trigger_insert_failed RETURN PLS_INTEGER
IS BEGIN RETURN en_cvt_trigger_insert_failed; END cvt_trigger_insert_failed;
FUNCTION download_script_failed RETURN PLS_INTEGER
IS BEGIN RETURN en_download_script_failed; END download_script_failed;
FUNCTION msginfo_general RETURN PLS_INTEGER
IS BEGIN RETURN en_msginfo_general; END msginfo_general;
FUNCTION fw_general RETURN PLS_INTEGER
IS BEGIN RETURN en_fw_general; END fw_general;
FUNCTION bms_util_general RETURN PLS_INTEGER
IS BEGIN RETURN en_bms_util_general; END bms_util_general;
FUNCTION err_general  RETURN PLS_INTEGER
IS BEGIN RETURN en_err_general ; END err_general ;
FUNCTION bms_exc_general RETURN PLS_INTEGER
IS BEGIN RETURN en_bms_exc_general; END bms_exc_general;
FUNCTION fileio_file_not_exist RETURN PLS_INTEGER
IS BEGIN RETURN en_fileio_file_not_exist; END fileio_file_not_exist;
FUNCTION bad_nbisync_value RETURN PLS_INTEGER
IS BEGIN RETURN en_bad_nbisync_value; END bad_nbisync_value;
FUNCTION trg_nbisync_cols_upd RETURN PLS_INTEGER
IS BEGIN RETURN en_trg_nbisync_cols_upd; END trg_nbisync_cols_upd;
FUNCTION trg_nbisync_cols_ins RETURN PLS_INTEGER
IS BEGIN RETURN en_trg_nbisync_cols_ins; END trg_nbisync_cols_ins;
FUNCTION pontis_version_error RETURN PLS_INTEGER
IS BEGIN RETURN en_pontis_version_error; END pontis_version_error;
FUNCTION null_cvt_result RETURN PLS_INTEGER
IS BEGIN RETURN en_null_cvt_result; END null_cvt_result;
FUNCTION zero_cvt_result RETURN PLS_INTEGER
IS BEGIN RETURN en_zero_cvt_result; END zero_cvt_result;
FUNCTION bad_cvt_dec_plcs RETURN PLS_INTEGER
IS BEGIN RETURN en_bad_cvt_dec_plcs; END bad_cvt_dec_plcs;
END KSBMS_EXC;
/