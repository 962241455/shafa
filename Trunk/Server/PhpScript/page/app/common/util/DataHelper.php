<?php
namespace common\util;
class DataHelper {

    /**
     * @param CDbConnection $conn
     * @param string $sql
     * @param array $params
     * @return array
     */
    public static function queryAll($conn,$sql,$params=null) {
        $cmd = $conn->createCommand($sql);
        if(is_array($params))
            $cmd->params = $params;
        return $cmd->queryAll();
    }

    /**
     * @param CDbConnection $conn
     * @param string $sql
     * @param int $page
     * @param int $pageSize
     * @param array $params
     * @return array
     */
    public static function queryPage($conn, $sql, $page=1, $pageSize=6, $params=null) {
        $recordCount = self::queryScalar($conn, "select count(*) from ($sql) as tmp", $params);
        if($recordCount==0)
            return array('total'=>0,'rows'=>array());
        $totalPage = intval($recordCount / $pageSize);
        if($recordCount%$pageSize!=0) $totalPage++;
        if($page<1 || $page>$totalPage)
            return array('total'=>$recordCount, 'rows'=>array());
        $offset = ($page-1)*$pageSize;
        $data = array('total'=>$recordCount);
        $data['rows'] = self::queryAll($conn, "$sql limit $offset,$pageSize", $params);
        return $data;
    }

    /**
     * @param CDbConnection $conn
     * @param string $sql
     * @param array $params
     * @return mixed
     */
    public static function queryScalar($conn, $sql, $params=null) {
        $cmd = $conn->createCommand($sql);
        if(is_array($params))
            $cmd->params = $params;
        return $cmd->queryScalar();
    }

    /**
     * @param CDbConnection $conn
     * @param string $sql
     * @param array $params
     * @return array
     */
    public static function queryRow($conn, $sql, $params=null) {
        $cmd = $conn->createCommand($sql);
        if(is_array($params))
            $cmd->params = $params;
        return $cmd->queryRow();
    }

    /**
     * @param CDbConnection $conn
     * @param string $sql
     * @param array $params
     * @param bool $retLastInsertId
     * @return integer number of rows affected by the execution | lastInsertId
     */
    public static function execute($conn, $sql, $params=null, $retLastInsertId=false) {
        $cmd =$conn->createCommand($sql);
        $affectedRows = is_array($params) ? $cmd->execute($params) : $cmd->execute();
        return $retLastInsertId ? $conn->lastInsertID : $affectedRows;
    }

}