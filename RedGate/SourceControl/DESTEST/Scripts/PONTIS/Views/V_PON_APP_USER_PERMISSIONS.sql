CREATE OR REPLACE FORCE VIEW pontis.v_pon_app_user_permissions (userkey,groupkey,userid,first_name,last_name,agency,phone,email,status,rolekey,rolename,permissionkey,permissionname,granted) AS
SELECT DISTINCT u.userkey,g.groupkey, u.userid, u.first_name,u.last_name,u.agency,u.phone, u.email,
                   u.status,r.rolekey,r.rolename,p.permissionkey,p.permissionname,rp.granted
            FROM   PON_APP_USERS u
                   LEFT JOIN PON_APP_USERS_ROLES ur ON u.userkey = ur.userkey
                   LEFT JOIN PON_APP_ROLES r ON ur.rolekey = r.rolekey
                   LEFT JOIN PON_APP_USERS_GROUPS ug ON u.userkey = ug.userkey
                   LEFT JOIN PON_APP_GROUPS g ON g.groupkey = ug.groupkey
                   LEFT JOIN PON_APP_ROLES_PERMISSIONS rp ON rp.rolekey = r.rolekey
                   LEFT JOIN PON_APP_PERMISSIONS p ON p.permissionkey = rp.permissionkey;