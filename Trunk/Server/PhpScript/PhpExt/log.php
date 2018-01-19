<?php
ini_set('date.timezone','Asia/Shanghai');
error_reporting(E_ERROR);

//以下为日志
class Log
{
	private static $instance = null;
	
	private $maxlevel = 15;
	private $file = null;
	private $handle = null;

	public function __construct()
	{
		//$this->$file = "../logs/".date('Y-m-d').'.log';
		$this->$file = dirname ( __FILE__ ) . DIRECTORY_SEPARATOR . '../logs/error.log';
		$this->handle = fopen($this->$file, 'a');
	}
	
	public function __destruct()
	{
		fclose($this->handle);
	}


	private function getLevelStr($level)
	{
		switch ($level)
		{
		case 1:
			return 'debug';
		break;
		case 2:
			return 'info';	
		break;
		case 4:
			return 'warn';
		break;
		case 8:
			return 'error';
		break;
		default:
				
		}
	}
	
	protected function write($level, $msg)
	{
		if(($level & $this->maxlevel) == $level )
		{
			$msg = '['.date('Y-m-d H:i:s').']['.$this->getLevelStr($level).'] '.$msg."\n";
			fwrite($this->handle, $msg, 4096);
		}
	}

	private static function writelog($level, $msg)
	{
		if(!self::$instance instanceof self)
		{
			self::$instance = new self();
		}
		self::$instance->write($level, $msg);
	}
	
	public static function DEBUG($msg)
	{
		self::writelog(1, $msg);
	}
	
	public static function INFO($msg)
	{
		self::writelog(2, $msg);
	}
	
	public static function WARN($msg)
	{
		self::writelog(4, $msg);
	}
	
	public static function ERROR($msg)
	{
		$debugInfo = debug_backtrace();
		$stack = "";
		foreach($debugInfo as $key => $val){
			if(array_key_exists("file", $val)){
				$stack .= "\n    file:" . $val["file"];
			}
			if(array_key_exists("line", $val)){
				$stack .= ",line:" . $val["line"];
			}
			if(array_key_exists("function", $val)){
				$stack .= ",function:" . $val["function"];
			}
		}
		self::writelog(8, $msg . $stack);
	}
}
?>
