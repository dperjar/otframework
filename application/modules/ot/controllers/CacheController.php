<?php
/**
 * LICENSE
 *
 * This source file is subject to the new BSD license that is bundled
 * with this package in the file _LICENSE.txt.
 *
 * This license is also available via the world-wide-web at
 * http://itdapps.ncsu.edu/bsd.txt
 *
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to itappdev@ncsu.edu so we can send you a copy immediately.
 *
 * @package    Ot_CacheController
 * @category   Controller
 * @copyright  Copyright (c) 2007 NC State University Office of      
 *             Information Technology
 * @license    BSD License
 * @version    SVN: $Id: $
 */

/**
 * Allows the user to manage all application-wide configuration variables.
 *
 * @package    Ot_CacheController
 * @category   Controller
 * @copyright  Copyright (c) 2007 NC State University Office of      
 *             Information Technology
 */
class Ot_CacheController extends Zend_Controller_Action
{
    /**
     * Shows the cache management index page
     */
    public function indexAction()
    {
        $messages = array();
                
        $this->view->acl = array('clearCache' => $this->_helper->hasAccess('clear'));

        $this->view->messages = array_merge($this->_helper->messenger->getMessages(), $messages);
        $this->_helper->pageTitle('ot-cache-index:title');
    }
    
    /**
     * Clears the cache
     */
    public function clearAction()
    {
        $this->_helper->viewRenderer->setNeverRender();
        $this->_helper->layout->disableLayout();
        
        $post = Zend_Registry::get('postFilter');
        if(!$post->clearCache) {
            $this->_helper->messenger->addError('msg-info-cacheNotCleared');
            $this->_helper->redirector->gotoRoute(array('controller' => 'cache'), 'ot', true);
        }

        $cache = Zend_Registry::get('cache');
        $cache->clean(Zend_Cache::CLEANING_MODE_ALL);
        
        $logOptions = array('attributeName' => 'appConfig', 'attributeId' => '0');
            
        $this->_helper->log(Zend_Log::INFO, 'Cache was cleared', $logOptions);
        
        $this->_helper->messenger->addSuccess('msg-info-cacheCleared');
        
        $this->_helper->redirector->gotoRoute(array('controller' => 'cache'), 'ot', true);
    }
}