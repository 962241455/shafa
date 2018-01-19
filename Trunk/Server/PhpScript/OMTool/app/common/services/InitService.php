<?php
/*
 * 模型服务基类
 * 
 */
namespace common\services;

use yii\data\Pagination;
use yii\helpers\Json;
use common\util\Helper;

class InitService {
    /*
     * @var object 服务的模型
     */

    protected static $instances = [];

    private function __construct() {

    }

    /**
     * @return static service instance
     */
    public static function service() {
        $className = get_called_class();
        if(!isset(self::$instances[$className]))
            self::$instances[$className] = new static();
        return self::$instances[$className];
    }
    /**
     * 查询数据列表
     * @param obj $modelName
     * @param type $where  字符串或数组array('id=1',array('id=2','AND'))
     * @param type $order
     * @param type $fields
     * @param type $opt   CDbCriteria配置 array('group'=>'id')
     * @param type $page_rows 每页记录数
     * @return type
     */
    public function mlists($modelName, $where = '', $orderby = '', $fields = '*', $opt = array(), $page_rows = 10) {
        $query = $modelName::find()->where($where);
        $countQuery = clone $query;
        $pages = new Pagination(['totalCount' => $countQuery->count()]);
        $pages->pageSize = isset($_GET["rows"])?intval($_GET["rows"]):$page_rows; //每页记录数
        $models = $query->offset($pages->offset)
            ->select($fields)
            ->limit($pages->limit)
            ->orderBy($orderby)
            ->all();
            
        if($fields!='*' && $fields){
            $fields = explode(',',$fields);
        }
        $data = array('total'=>$pages->totalCount, 'rows' => array());
        foreach($models as &$row){
            if(is_array($fields)){
                $temp = array();
                foreach($fields as $k=>$v){
                    $temp[$v] = $row->$v;
                }
            }else{
                $temp = $row->attributes;
            }
			$data['rows'][] = $temp;
            
        }
        return $data;
    }

}