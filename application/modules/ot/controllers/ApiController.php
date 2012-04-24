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
 * @package    Api_IndexController
 * @category   Controller
 * @copyright  Copyright (c) 2007 NC State University Office of      
 *             Information Technology
 * @license    http://itdapps.ncsu.edu/bsd.txt  BSD License
 * @version    SVN: $Id: $
 */

/**
 * Handles calls to the API
 *
 * @package    
 * @subpackage Api_IndexController
 * @category   Controller
 * @copyright  Copyright (c) 2007 NC State University Office of      
 *             Information Technology
 */
class Ot_ApiController extends Zend_Controller_Action
{

    public function init()
    {
        set_time_limit(0);
        
        $this->_helper->layout->disableLayout();
        $this->_helper->viewRenderer->setNeverRender();
        
        parent::init();
    }
    
    public function indexAction()
    {
        $register = new Ot_Api_Register();
        
        $params = $this->_getAllParams();
        
        $endpoint = $params['endpoint'];

        if (!is_null($endpoint)) {
            
            $thisEndpoint = $register->getApiEndpoint($endpoint);

            if (!is_null($thisEndpoint)) {
                
                if ($this->_request->isPost()) {
                    $thisEndpoint->getMethod()->post($params);
                } else if ($this->_request->isPut()) {
                    $thisEndpoint->getMethod()->put($params);
                } else if ($this->_request->isDelete()) {
                    $thisEndpoint->getMethod()->delete($params);
                } else {
                    $thisEndpoint->getMethod()->get($params);
                }
                
            } else {
                throw new Ot_Exception('API endpoint could not be found');
            }

            return;
        }
    }
    
    
    /*
    protected $_class = 'Internal_Api';
        
    protected $_parameters = array();
        
    public function indexAction()
    {
        $api = new Ot_Api();
        $allMethods = $api->describe();

        $this->view->api = $allMethods;
        
        $this->_helper->pageTitle('ot-api-index:title');
    }
    
    public function sampleAction()
    {
        
    }
        
    public function soapAction()
    {
        $this->_helper->viewRenderer->setNeverRender();
        $this->_helper->layout->disableLayout();
        
        $server = new SoapServer(null, array('uri' => "soapservice"));
        $server->setClass('Ot_Api_Soap');
        $server->handle();
    }
    
    public function xmlAction()
    {
        $this->_helper->viewRenderer->setNeverRender();
        $this->_helper->layout->disableLayout();
        
        $access = new Ot_Api_Access();
        
        $request = Oauth_Request::fromRequest();
        
        if (!$access->validate($request, $this->_request->getParam('method'))) {
            return $access->raiseError($access->getMessage(), Ot_Api_Access::API_XML);
        }
        
        $server = new Zend_Rest_Server();
        $server->setClass($this->_class);
        $server->handle($request->getParameters()); 
    }
    
    public function jsonAction()
    {
        $this->_helper->viewRenderer->setNeverRender();
        $this->_helper->layout->disableLayout();
        
        $access = new Ot_Api_Access();
 
        $request = Oauth_Request::fromRequest();
        
        if (!$access->validate($request, $this->_request->getParam('method'))) {
            return $access->raiseError($access->getMessage(), Ot_Api_Access::API_JSON);
        }
                
        $server = new Zend_Rest_Server();

        $server->setClass($this->_class);
        $server->returnResponse(true); // if this is true, it doesn't send headers or echo, and returns the response instead
        
        $jsoncallback = "";
        
        if ($request->getParameter('jsoncallback') != '') {
            $htmlEntityFilter = new Zend_Filter_HtmlEntities();
            $jsoncallback = $htmlEntityFilter->filter($request->getParameter('jsoncallback'));
        }
        
        $response = $server->handle($request->getParameters());
        
        if (!headers_sent()) {
        	// headers haven't been sent yet, but there's a Content-Type: text/xml in there because 
        	// we're using zend rest server to grab xml to parse to json
        	$headers = $server->getHeaders();
            foreach ($headers as $header) {
            	if($header == 'Content-Type: text/xml') {
            	   $header = 'Content-Type: application/json';
            	}
                header($header);
            }
        }

        if ($jsoncallback == "") {
            echo Zend_Json::fromXml($response);
        } else {
            echo $jsoncallback . '(' . Zend_Json::fromXml($response) . ')';
        }
    }
    */
}
