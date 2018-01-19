<?php

/**
 * filesys
 */
class MyFileSys
{
    private $m_dir = null;

    // 构造函数
    function __construct($dir = null)
    {
        if (empty($dir)) {
            $dir = $_SERVER["File_DIR"];
        }
        if (empty($dir)) {
            $dir = null;
        } else {
            $dir = str_replace("\\", "/", $dir);
            if (substr($dir, -1, 1) != "/") {
                $dir .= "/";
            }
        }
        $this->m_dir = $dir;
    }

    // 检查路径
    private function CheckPath($path)
    {
        if (empty($this->m_dir) or empty($path)) {
            return false;
        }
        $dlen = strlen($this->m_dir);
        $plen = strlen($path);
        $sub = substr($path, 0, $dlen);
        if ($plen <= $dlen or $sub != $this->m_dir) {
            return false;
        }
        return true;
    }

    // 级联 创建目录
    public function mk_dir($dir)
    {
        if (empty($dir))
            return false;

        if (!is_dir($dir)) {
            if (!$this->mk_dir(dirname($dir))) {
                return false;
            }
            if (!mkdir($dir))
                return false;
        }

        return true;
    }

    // 写文件
    private function MyWriteFile($path, $data)
    {
        if (empty($path) or empty($data)) {
            return false;
        }
        if ($this->CheckPath($path) == false) {
            return false;
        }
        if (!$this->mk_dir(dirname($path))) {
            return false;
        }
        if (@file_put_contents($path, $data) > 0) {
            return true;
        } else {
            return false;
        }
    }

    // 读文件
    private function MyReadFile($path)
    {
        if ($this->CheckPath($path) == false) {
            return null;
        }

        if (file_exists($path)) {
            return file_get_contents($path);
        }
        return null;
    }

    // 删除文件
    private function MyDelFile($path)
    {
        if ($this->CheckPath($path) == false) {
            return false;
        }

        if (file_exists($path) and unlink($path) == false) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * @dese  增加文件
     * @param $fileNmae
     * @param $uid
     * @param $data
     * @return null|string
     */
    public function addImg($fileName, $uid, $data)
    {
        if (empty($uid) or empty($data) or empty($data)) {
            return null;
        }

        $dir = $this->foundImgDir($fileName, $uid);
        if (empty($dir)) {
            return null;
        }

        $fmd5 = md5($data);
        $name = $fmd5;
        $path = $dir . $name;
        $cnt = 0;
        while (file_exists($path)) {
            $cnt++;
            $name = $fmd5 . "_" . $cnt;
            $path = $dir . $name;
        }
        if ($this->MyWriteFile($path, $data) == true) {
            return $uid . "/{$fileName}/" . $name;
        } else {
            return null;
        }
    }

    /**
     * @dese  获取文件
     * @param $fileNmae
     * @param $uid
     * @param $name
     * @return null|string
     */
    public function getfile($uid, $name, $fileMd5 = '')
    {
        if (empty($uid) or empty($name)) {
            return null;
        }
        $path = $this->m_dir . $name;
        if (!is_file($path)) {
            return false;
        }
        $data = $this->MyReadFile($path);

        if ($fileMd5) {
            if ($fileMd5 == md5($data)) {
                return null;
            }
        }

        return $data;
    }

    /**
     * @dese  删除文件
     * @param $fileNmae
     * @param $uid
     * @param $name
     * @return bool
     */
    public function delImg($uid, $name)
    {
        if (empty($uid) or empty($name)) {
            return false;
        }

        $path = $this->m_dir . $name;

        if (!is_file($path)) {
            return false;
        }

        return $this->MyDelFile($path);
    }

    /**
     * @dese  创建文件路径
     * @param $fileName
     * @param $uid
     * @return null|string
     */
    public function foundImgDir($fileName, $uid)
    {
        if (empty($this->m_dir) or empty($uid)) {
            return null;
        }
        return $this->m_dir . $uid . "/{$fileName}/";
    }
}

?>
