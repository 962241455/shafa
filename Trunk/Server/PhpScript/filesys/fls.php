<?php
require_once dirname(__FILE__) . DIRECTORY_SEPARATOR . 'MyFileSys.php';

function recv()
{
    $dir = $_SERVER["File_DIR"];
    $data = file_get_contents('php://input');
    $bodyfile = $_SERVER["Req_Body_File"];

    $uid = null;
    $name = null;
    $action = null;
    $fileMd5 = null;

    if (array_key_exists("action", $_GET)) {
        $action = $_GET["action"];
    }
    if (array_key_exists("uid", $_GET)) {
        $uid = $_GET["uid"];
    }
    if (array_key_exists("name", $_GET)) {
        $name = $_GET["name"];
    }
    if (array_key_exists("md5", $_GET)) {
        $fileMd5 = $_GET["md5"];
    }
    if (is_null($uid) or empty($dir)) {
        return null;
    }
    $dir = str_replace("\\", "/", $_SERVER["File_DIR"]);
    if (substr($dir, -1, 1) != "/") {
        $dir .= "/";
    }

    $myfls = new MyFileSys($dir);
    $return = null;
    $type = 0;
    if ($action == "test") {
        phpinfo();
    } elseif ($action == "AddCloth") {
        $return = $myfls->addImg('Cloth', $uid, $data);
    } elseif ($action == "DelCloth") {
        $return = $myfls->delImg($uid, $name);
    } elseif ($action == "GetCloth") {
        $type = 1;
        $return = $myfls->getfile($uid, $name);
    } elseif ($action == "AddHeadImg") {
        $return = $myfls->addImg('HeadImg', $uid, $data);
    } elseif ($action == "DelHeadImg") {
        $return = $myfls->delImg($uid, $name);
    } elseif ($action == "GetHeadImg") {
        $type = 1;
        $return = $myfls->getfile($uid, $name, $fileMd5);
    } else {
        return json_encode(array('code' => 1, 'message' => 'not register action ' . $action, 'result' => ""));
    }
    $ret = '';
    if ($type == 1) {
        return $return;
    } else {
        if ($return) {
            $ret = array('code' => 0, 'message' => 'success', 'result' => $return);
        } else {
            $ret = array('code' => 1, 'message' => 'write failed', 'result' => "");
        }
    }

    return json_encode($ret);
}

echo @recv();

?>
