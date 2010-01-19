<?php
/**
 * LICENSE
 *
 * This source file is subject to the new BSD license that is bundled
 * with this package in the file LICENSE.txt.
 *
 * This license is also available via the world-wide-web at
 * http://itdapps.ncsu.edu/bsd.txt
 *
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to itappdev@ncsu.edu so we can send you a copy immediately.
 *
 * @package    Ot_Filter_Ucwords
 * @category   filter
 * @copyright  Copyright (c) 2007 NC State University Office of      
 *             Information Technology
 * @license    http://itdapps.ncsu.edu/bsd.txt  BSD License
 * @version    SVN: $Id: $
 */

/**
 * Capitalizes words.
 *
 * @package    Ot_Filter_Ucwords
 * @category   Filter
 * @copyright  Copyright (c) 2007 NC State University Office of      
 *             Information Technology
 */
class Ot_Filter_Ucwords implements Zend_Filter_Interface
{
    /**
     * Class constructor
     *
     *
     * @return void
     */
    public function __construct()
    {
    }

    /**
     * Defined by Zend_Filter_Interface
     *
     * Returns the string $value, with each word uppercased
     *
     * @param  string $value
     * @return string
     */
    public function filter($value)
    {
		return ucwords($value);
    }
}