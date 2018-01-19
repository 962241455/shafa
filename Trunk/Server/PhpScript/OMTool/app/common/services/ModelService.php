<?php
/**
 * User: lhb
 * Date: 15-01-13
 * Time: 上午09:36
 */

namespace common\services;


class ModelService {

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

} 