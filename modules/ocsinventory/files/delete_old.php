<?php
//====================================================================================
// OCS INVENTORY
// FIND AND DELETE HARDWARE NOT UPDATED SINCE A VARIABLE NUMBER OF DAYS
//====================================================================================
//Modified on $Date: 18-11-2010 09:59:31 $$Author: Steeve Govindapillai
//Link: http://forums.ocsinventory-ng.org/viewtopic.php?id=2719
 
require('dbconfig.inc.php');
 
define("DB_NAME", "ocsweb");            // Database name
$_SESSION["SERVER_READ"] = $_SESSION["SERVEUR_SQL"];
$_SESSION["SERVER_WRITE"] =  $_SESSION["SERVEUR_SQL"];
 
// Number of day since last hardware update to consider for deletion.
$delay = 30;
 
dbconnect();
 
 
$res = @mysql_query('SELECT ID FROM hardware where LASTDATE<=\''.date('Y-m-d h:i:s', mktime()-$delay*24*3600).'\' ORDER BY LASTDATE', $_SESSION['readServer']);
if (mysql_num_rows($res))
    while ($row=mysql_fetch_array($res))
        deleteDid($row['ID'], false, true);
else
    echo "no records deleted."."\n"; 
 
function dbconnect() {
    $db = DB_NAME;
 
    $link=mysql_connect($_SESSION["SERVER_READ"],$_SESSION["COMPTE_BASE"],$_SESSION["PSWD_BASE"]);
    if(!$link) {
        echo "ERROR: MySql connection problem".mysql_error()."\n";
        die();
    }
    if( ! mysql_select_db($db,$link)) {
        echo "Error executing SELECT\n";
        die();
    }
 
    $link2=@mysql_connect($_SESSION["SERVER_WRITE"],$_SESSION["COMPTE_BASE"],$_SESSION["PSWD_BASE"]);
    if(!$link2) {
        echo "ERROR: MySql connection problem".mysql_error($link2)."\n" ;
        die();
    }
 
    if( ! @mysql_select_db($db,$link2)) {
        echo "Error executing SELECT\n";
        die();
    }
 
    $_SESSION["writeServer"] = $link2;    
    $_SESSION["readServer"] = $link;
    return $link2;
}
 
 
/**
  * Deleting function
  * @param id Hardware identifier to be deleted
  * @param checkLock Tells wether or not the locking system must be used (default true)
  * @param traceDel Tells wether or not the deleted entities must be inserted in deleted_equiv for tracking purpose (default true)
  */
function deleteDid($id, $checkLock = true, $traceDel = true, $silent=false) {
    global $l;
    //If lock is not user OR it is used and available
    if( ! $checkLock || lock($id) ) {    
        $resId = mysql_query("SELECT deviceid,name FROM hardware WHERE id='$id'",$_SESSION["readServer"]) or die(mysql_error());
        $valId = mysql_fetch_array($resId);
        $idHard = $id;
        $did = $valId["deviceid"];
        if( $did ) {    
            //Deleting a network device
            if( strpos ( $did, "NETWORK_DEVICE-" ) === false ) {
                $resNetm = @mysql_query("SELECT macaddr FROM networks WHERE hardware_id=$idHard", $_SESSION["writeServer"]) or die(mysql_error());
                while( $valNetm = mysql_fetch_array($resNetm)) {
                    @mysql_query("DELETE FROM netmap WHERE mac='".$valNetm["macaddr"]."';", $_SESSION["writeServer"]) or die(mysql_error());
                }        
            }
            //deleting a regular computer
            if( $did != "_SYSTEMGROUP_" and $did != '_DOWNLOADGROUP_') {
                $tables=Array("accesslog","accountinfo","bios","controllers","drives",
                "inputs","memories","modems","monitors","networks","ports","printers","registry",
                "slots","softwares","sounds","storages","videos","devices","download_history","download_servers","groups_cache");    
            }
            elseif($did == "_SYSTEMGROUP_" or $did == '_DOWNLOADGROUP_'){//Deleting a group
                $tables=Array("devices");
                $del_groups_server_cache="DELETE FROM download_servers WHERE group_id='".$idHard."'";
                mysql_query($del_groups_server_cache, $_SESSION["writeServer"]) or die(mysql_error());
                mysql_query("DELETE FROM groups WHERE hardware_id=$idHard", $_SESSION["writeServer"]) or die(mysql_error());
                $resDelete = mysql_query("DELETE FROM groups_cache WHERE group_id=$idHard", $_SESSION["writeServer"]) or die(mysql_error());
                $affectedComputers = mysql_affected_rows( $_SESSION["writeServer"] );
 
            }
 
            if( !$silent )
                echo "deleting record ".$valId["name"]."\n";
 
            foreach ($tables as $table) {
                mysql_query("DELETE FROM $table WHERE hardware_id=$idHard;", $_SESSION["writeServer"]) or die(mysql_error());        
            }
            mysql_query("delete from download_enable where SERVER_ID=".$idHard, $_SESSION["writeServer"]) or die(mysql_error($_SESSION["writeServer"]));
 
            mysql_query("DELETE FROM hardware WHERE id=$idHard;", $_SESSION["writeServer"]) or die(mysql_error());
            //Deleted computers tracking
            if($traceDel && mysql_num_rows(mysql_query("SELECT IVALUE FROM config WHERE IVALUE>0 AND NAME='TRACE_DELETED'", $_SESSION["writeServer"]))){
                mysql_query("insert into deleted_equiv(DELETED,EQUIVALENT) values('$did',NULL)", $_SESSION["writeServer"]) or die(mysql_error());
 
 
            }
        }
        //Using lock ? Unlock
        if( $checkLock ) 
            unlock($id);
    }
    else
        errlock();
}
 
?>
