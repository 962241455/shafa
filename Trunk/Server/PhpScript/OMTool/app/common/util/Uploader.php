<?php


namespace common\util;

class Uploader
{
    private $fileField;            //文件域名
    private $file;                 //文件上传对象
    private $config;               //配置信息
    private $oriName;              //原始文件名
    private $fileName;             //新文件名
    private $fullName;             //完整文件名,即从当前配置目录开始的URL
    private $fileSize;             //文件大小
    private $fileType;             //文件类型
    private $stateInfo;            //上传状态信息,
    private $stateMap = array(    //上传状态映射表，国际化用户需考虑此处数据的国际化
        "SUCCESS" ,                //上传成功标记，在UEditor中内不可改变，否则flash判断会出错
        "文件大小超出 upload_max_filesize 限制" ,
        "文件大小超出 MAX_FILE_SIZE 限制" ,
        "文件未被完整上传" ,
        "没有文件被上传" ,
        "上传文件为空" ,
        "POST" => "文件大小超出 post_max_size 限制" ,
        "SIZE" => "文件大小超出网站限制" ,
        "TYPE" => "不允许的文件类型" ,
        "DIR" => "目录创建失败" ,
        "IO" => "输入输出错误" ,
        "UNKNOWN" => "未知错误" ,
        "MOVE" => "文件保存时出错"
    );

    /**
     * 构造函数
     * @param string $fileField 表单名称
     * @param array $config  配置项
     * @param bool $base64  是否解析base64编码，可省略。若开启，则$fileField代表的是base64编码的字符串表单名
     */
    public function __construct( $fileField , $config , $base64 = false )
    {
        $this->fileField = $fileField;
        $this->config = $config;
        $this->stateInfo = $this->stateMap[ 0 ];
        $this->upFile( $base64 );
    }

    /**
     * 上传文件的主处理方法
     * @param $base64
     * @return mixed
     */
    private function upFile( $base64 )
    {
        //处理base64上传
        if ( "base64" == $base64 ) {
            $content = $_POST[ $this->fileField ];
            $this->base64ToImage( $content );
            return;
        }

        //处理普通上传
        $file = $this->file = $_FILES[ $this->fileField ];
        if ( !$file ) {
            $this->stateInfo = $this->getStateInfo( 'POST' );
            return;
        }
        if ( $this->file[ 'error' ] ) {
            $this->stateInfo = $this->getStateInfo( $file[ 'error' ] );
            return;
        }
        if ( !is_uploaded_file( $file[ 'tmp_name' ] ) ) {
            $this->stateInfo = $this->getStateInfo( "UNKNOWN" );
            return;
        }

        $this->oriName = $file[ 'name' ];
        $this->fileSize = $file[ 'size' ];
        $this->fileType = $this->getFileExt();

        if ( !$this->checkSize() ) {
            $this->stateInfo = $this->getStateInfo( "SIZE" );
            return;
        }
    
        if ( !$this->checkType() ) {
            $this->stateInfo = $this->getStateInfo( "TYPE" );
            return;
        }
        
        if ( !$this->checkMimeType() ) {
            $this->stateInfo = $this->getStateInfo( "TYPE" );
            return;
        }
        $this->fullName = $this->getFolder() . '/' . $this->getName();
        if ( $this->stateInfo == $this->stateMap[ 0 ] ) {
            if ( !move_uploaded_file( $file[ "tmp_name" ] , $this->fullName ) ) {
                $this->stateInfo = $this->getStateInfo( "MOVE" );
            }
            $imageType = array(".gif", ".png", ".jpg", ".jpeg", ".bmp");
            if (in_array($this->fileType, $imageType) && $this->config['width'] > 0 or $this->config['height'] > 0) {
                $this->makeThumb($this->fullName);
            }
        }
    }

    /**
     * 处理base64编码的图片上传
     * @param $base64Data
     * @return mixed
     */
    private function base64ToImage( $base64Data )
    {
        $img = base64_decode( $base64Data );
        $this->fileName = REQUEST_TIME . rand( 1 , 10000 ) . ".png";
        $this->fullName = $this->getFolder() . '/' . $this->fileName;
        if ( !file_put_contents( $this->fullName , $img ) ) {
            $this->stateInfo = $this->getStateInfo( "IO" );
            return;
        }
        $this->oriName = "";
        $this->fileSize = strlen( $img );
        $this->fileType = ".png";
    }

    /**
     * 获取当前上传成功文件的各项信息
     * @return array
     */
    public function getFileInfo()
    {
        return array(
            "originalName" => $this->oriName ,
            "name" => $this->fileName ,
            "url" => $this->fullName ,
            "size" => $this->fileSize ,
            "type" => $this->fileType ,
            "state" => $this->stateInfo
        );
    }

    /**
     * 上传错误检查
     * @param $errCode
     * @return string
     */
    private function getStateInfo( $errCode )
    {
        return !isset($this->stateMap[ $errCode ]) ? $this->stateMap[ "UNKNOWN" ] : $this->stateMap[ $errCode ];
    }

    /**
     * 重命名文件
     * @return string
     */
    private function getName()
    {
        return $this->fileName = time() . rand( 1 , 10000 ) . $this->getFileExt();
    }

    /**
     * 文件类型检测
     * @return bool
     */
    private function checkType()
    {
        return in_array( $this->getFileExt() , $this->config[ "allowFiles" ] );
    }

    /**
     * 文件大小检测
     * @return bool
     */
    private function  checkSize()
    {
        return $this->fileSize <= ( $this->config[ "maxSize" ] * 1024 );
    }

    /**
     * 获取文件扩展名
     * @return string
     */
    private function getFileExt()
    {
        return strtolower( strrchr( $this->file[ "name" ] , '.' ) );
    }

    /**
     * 按照日期自动创建存储文件夹
     * @return string
     */
    private function getFolder()
    {
        $pathStr = $this->config[ "savePath" ];
        if ( strrchr( $pathStr , "/" ) != "/" ) {
            $pathStr .= "/";
        }
        $pathStr .= date( "Ymd" );
        if ( !file_exists( $pathStr ) ) {
            if ( !mkdir( $pathStr , 0777 , true ) ) {
                return false;
            }
        }
        return $pathStr;
    }

    /**
     * 按比例缩放
     */
    private function makeThumb($filename)
    {
        // 设置最大宽高
        $width = $this->config['width'];
        $height = $this->config['height'];

        // Content type
        //header('Content-Type: image/jpeg');

        // 获取新尺寸
        list($width_orig, $height_orig) = getimagesize($filename);
        if(!$width) $width = $width_orig;
        if(!$height) $height = $height_orig;

        //原图宽或高大于最大宽高时缩放
        if ($width_orig > $width or $height_orig > $height) {
            $ratio_orig = $width_orig / $height_orig;

            if ($width / $height > $ratio_orig) {
                $width = $height * $ratio_orig;
            } else {
                $height = $width / $ratio_orig;
            }

            // 重新取样
            $image_p = imagecreatetruecolor($width, $height);
            switch($this->file['type']){
                case "image/gif":
                    $image = imagecreatefromgif($filename);
                    imagecopyresampled($image_p, $image, 0, 0, 0, 0, $width, $height, $width_orig, $height_orig);
                    // 输出
                    imagegif($image_p, $filename);
                    break;
                case "image/png":
                    $image = imagecreatefrompng($filename);
                    imagecopyresampled($image_p, $image, 0, 0, 0, 0, $width, $height, $width_orig, $height_orig);
                    // 输出
                    imagepng($image_p, $filename);
                    break;
                default:
                    $image = imagecreatefromjpeg($filename);
                    imagecopyresampled($image_p, $image, 0, 0, 0, 0, $width, $height, $width_orig, $height_orig);
                    // 输出
                    imagejpeg($image_p, $filename, 100);
                    break;
            }

        }
    }

    /**
     * 获取mime类型
     * @return string|null
     */
    private function getMimeType()
    {
        if (!extension_loaded('fileinfo')) {
            return $this->file[ "type" ];
        }
        $info = finfo_open(FILEINFO_MIME_TYPE);
        
        if ($info) {
            $result = finfo_file($info, $this->file[ "tmp_name" ]);
            finfo_close($info);
            if ($result !== false) {
                return $result;
            }
        }
        return null;
    }

    /**
     * 检测mime类型
     */
    private function checkMimeType()
    {
        $mimes = array(
            'hqx'    =>    'application/mac-binhex40',
            'cpt'    =>    'application/mac-compactpro',
            'csv'    =>    array('text/x-comma-separated-values', 'text/comma-separated-values', 'application/octet-stream', 'application/vnd.ms-excel', 'text/x-csv', 'text/csv', 'application/csv', 'application/excel', 'application/vnd.msexcel'),
            'bin'    =>    'application/macbinary',
            'dms'    =>    'application/octet-stream',
            'lha'    =>    'application/octet-stream',
            'lzh'    =>    'application/octet-stream',
            'exe'    =>    array('application/octet-stream', 'application/x-msdownload'),
            'class'    =>    'application/octet-stream',
            'psd'    =>    'application/x-photoshop',
            'so'    =>    'application/octet-stream',
            'sea'    =>    'application/octet-stream',
            'dll'    =>    'application/octet-stream',
            'oda'    =>    'application/oda',
            'pdf'    =>    array('application/pdf', 'application/x-download'),
            'ai'    =>    'application/postscript',
            'eps'    =>    'application/postscript',
            'ps'    =>    'application/postscript',
            'smi'    =>    'application/smil',
            'smil'    =>    'application/smil',
            'mif'    =>    'application/vnd.mif',
            'xls'    =>    array('application/excel', 'application/vnd.ms-excel', 'application/msexcel', 'application/vnd.ms-office'),
            'ppt'    =>    array('application/powerpoint', 'application/vnd.ms-powerpoint'),
            'wbxml'    =>    'application/wbxml',
            'wmlc'    =>    'application/wmlc',
            'dcr'    =>    'application/x-director',
            'dir'    =>    'application/x-director',
            'dxr'    =>    'application/x-director',
            'dvi'    =>    'application/x-dvi',
            'gtar'    =>    'application/x-gtar',
            'gz'    =>    'application/x-gzip',
            'php'    =>    'application/x-httpd-php',
            'php4'    =>    'application/x-httpd-php',
            'php3'    =>    'application/x-httpd-php',
            'phtml'    =>    'application/x-httpd-php',
            'phps'    =>    'application/x-httpd-php-source',
            'js'    =>    'application/x-javascript',
            'swf'    =>    'application/x-shockwave-flash',
            'sit'    =>    'application/x-stuffit',
            'tar'    =>    'application/x-tar',
            'tgz'    =>    array('application/x-tar', 'application/x-gzip-compressed'),
            'xhtml'    =>    'application/xhtml+xml',
            'xht'    =>    'application/xhtml+xml',
            'zip'    =>  array('application/x-zip', 'application/zip', 'application/x-zip-compressed'),
            'mid'    =>    'audio/midi',
            'midi'    =>    'audio/midi',
            'mpga'    =>    'audio/mpeg',
            'mp2'    =>    'audio/mpeg',
            'mp3'    =>    array('audio/mpeg', 'audio/mpg', 'audio/mpeg3', 'audio/mp3'),
            'aif'    =>    'audio/x-aiff',
            'aiff'    =>    'audio/x-aiff',
            'aifc'    =>    'audio/x-aiff',
            'ram'    =>    'audio/x-pn-realaudio',
            'rm'    =>    'audio/x-pn-realaudio',
            'rpm'    =>    'audio/x-pn-realaudio-plugin',
            'ra'    =>    'audio/x-realaudio',
            'rv'    =>    'video/vnd.rn-realvideo',
            'wav'    =>    'audio/x-wav',
            'bmp'    =>    'image/bmp',
            'gif'    =>    'image/gif',
            'jpeg'    =>    array('image/jpeg', 'image/pjpeg'),
            'jpg'    =>    array('image/jpeg', 'image/pjpeg'),
            'jpe'    =>    array('image/jpeg', 'image/pjpeg'),
            'png'    =>    array('image/png',  'image/x-png'),
            'tiff'    =>    'image/tiff',
            'tif'    =>    'image/tiff',
            'css'    =>    'text/css',
            'html'    =>    'text/html',
            'htm'    =>    'text/html',
            'shtml'    =>    'text/html',
            'txt'    =>    'text/plain',
            'text'    =>    'text/plain',
            'log'    =>    array('text/plain', 'text/x-log'),
            'rtx'    =>    'text/richtext',
            'rtf'    =>    'text/rtf',
            'xml'    =>    'text/xml',
            'xsl'    =>    'text/xml',
            'mpeg'    =>    'video/mpeg',
            'mpg'    =>    'video/mpeg',
            'mpe'    =>    'video/mpeg',
            'qt'    =>    'video/quicktime',
            'mov'    =>    'video/quicktime',
            'avi'    =>    'video/x-msvideo',
            'movie'    =>    'video/x-sgi-movie',
            'doc'    =>    'application/msword',
            'docx'    =>    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'xlsx'    =>    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'word'    =>    array('application/msword', 'application/octet-stream'),
            'xl'    =>    'application/excel',
            'eml'    =>    'message/rfc822',
            'json' => array('application/json', 'text/json')
        );
        
        $mime_type = $this->getMimeType();
        if($this->fileType){
            $type = ltrim($this->fileType,'.');
            
            if (!isset($mimes[$type])) {
                return false;
            }
            
            if (is_array($mimes[$type])) {
                return in_array($mime_type, $mimes[$type]);
            }else{
                return ($mime_type == $mimes[$type]) ? true : false;
            }
            
        }
        return false;
    }
}