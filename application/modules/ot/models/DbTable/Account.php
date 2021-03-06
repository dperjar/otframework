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
 * @package    Ot_Account
 * @category   Model
 * @copyright  Copyright (c) 2007 NC State University Office of
 *             Information Technology
 * @license    BSD License
 * @version    SVN: $Id: $
 */

/**
 * Model to interact with user profiles
 *
 * @package    Ot_Account
 * @category   Model
 * @copyright  Copyright (c) 2007 NC State University Office of
 *             Information Technology
 *
 */
class Ot_Model_DbTable_Account extends Ot_Db_Table
{
    /**
     * Name of the table in the database
     *
     * @var string
     */
    protected $_name = 'tbl_ot_account';

    /**
     * The minimum length for a password
     */
    protected $_minPasswordLength = 5;

    /**
     * The maximum length for a generated password
     */
    protected $_maxPasswordLength = 20;

    /**
     * Primary key of the table
     *
     * @var string
     */
    protected $_primary = 'accountId';

    /**
     * Formats the resultset returned by the database
     *
     * @param unknown_type $data
     */
    private function _addExtraData($data) {

        if (get_class($data) == 'Zend_Db_Table_Row') {
            $data = (object) $data->toArray();
        }

        if(empty($data)) {
            return $data;
        }

        $rolesDb = new Ot_Model_DbTable_AccountRoles();

        $where = $rolesDb->getAdapter()->quoteInto('accountId = ?', $data->accountId);

        $roles = $rolesDb->fetchAll($where);

        $roleList = array();
        foreach ($roles as $r) {
            $roleList[] = $r['roleId'];
        }

        $data->role = $roleList;

        return $data;
    }

    public function fetchAll($where = null, $order = null, $count = null, $offset = null) {
        try {
            $result = parent::fetchAll($where, $order, $count, $offset);
        } catch (Exception $e) {
            throw $e;
        }

        if($result->count() > 0) {
            foreach ($result as $r) {
                $ret[] = $this->_addExtraData($r);
            }

            return $ret;
        } else {
            return null;
        }
    }

    public function find() {
        $result = parent::find(func_get_args());
        return $this->_addExtraData($result);
    }

    /**
     * inserts a new user and also takes care of account_roles if $data['role'] is set
     */
    public function insert(array $data)
    {
        $inTransaction = false; //whether or not we're in a transaction prior to this
        $dba = $this->getAdapter();
            try {
                $dba->beginTransaction();
            } catch (Exception $e) {
                $inTransaction = true;
            }
          
            $roleIds = array();
            if(isset($data['role']) && count($data['role']) > 0) {
                $roleIds = (array)$data['role'];
                unset($data['role']);
            }
            try {
                $accountId = parent::insert($data);
            } catch(Exception $e) {
                
                if (!$inTransaction) {
                    $dba->rollback();
                }
                
                throw new Ot_Exception('Account insert failed.');
            }
           
            if (count($roleIds) > 0) {
                $accountRoles = new Ot_Model_DbTable_AccountRoles();

                foreach($roleIds as $r) {
                    $accountRoles->insert(array(
                        'accountId' => $accountId,
                        'roleId'    => $r,
                    ));
                }
            }
            
        if (!$inTransaction) {
            $dba->commit();
        }
            
        return $accountId;
    }

    /**
     * updates the row
     * if you supply an array of role ids, it will update them correctly in the account_roles table
     */
    public function update(array $data, $where)
    {
        $rolesToAdd = array();
        if (isset($data['role']) && count($data['role']) > 0) {
            $rolesToAdd = (array)$data['role'];
            unset($data['role']);
        }
        $updateCount = parent::update($data, $where);
        if(count($rolesToAdd) < 1) {
            return $updateCount;
        }
        $accountRoles = new Ot_Model_DbTable_AccountRoles();
        $accountRolesDba = $accountRoles->getAdapter();

        $accountId = $data['accountId'];

        if(isset($rolesToAdd) && count($rolesToAdd) > 0 && $accountId) {
            try {
                $where = $accountRolesDba->quoteInto('accountId = ?', $accountId);
                $accountRoles->delete($where);
                foreach($rolesToAdd as $roleId) {
                    $d = array(
                        'accountId' => $accountId,
                        'roleId' => $roleId,
                    );
                    $accountRoles->insert($d);
                }
            } catch(Exception $e) {
                throw $e;
            }
        }
        return $updateCount;
    }

    public function delete($where)
    {
        $inTransaction = false; //whether or not we're in a transaction prior to this
        $dba = $this->getAdapter();
        
        try {
            $dba->beginTransaction();
        } catch (Exception $e) {
            $inTransaction = true;
        }
        
        $thisAccount = $this->fetchRow($where)->toArray();
        
        try {
            $deleteCount = parent::delete($where);
        } catch(Exception $e) {
                
            if (!$inTransaction) {
                $dba->rollback();
            }

            throw new Ot_Exception('Account insert failed.');
        }
        
        $accountRoles = new Ot_Model_DbTable_AccountRoles();
        
        try {
            $accountRoles->delete($where);
        } catch(Exception $e) {

            if (!$inTransaction) {
                $dba->rollback();
            }

            throw new Ot_Exception('Account insert failed.');
        }
        
        $apiApps = new Ot_Model_DbTable_ApiApp();
        
        try {
            $apiApps->deleteAppsForAccountId($thisAccount['accountId']);
        } catch(Exception $e) {

            if (!$inTransaction) {
                $dba->rollback();
            }

            throw new Ot_Exception('Account insert failed.');
        }
        
        if (!$inTransaction) {
            $dba->commit();
        }
        
        return $deleteCount;
    }

    public function getAccount($username, $realm)
    {
        $where = $this->getAdapter()->quoteInto('username = ?', $username)
               . ' AND '
               . $this->getAdapter()->quoteInto('realm = ?', $realm);

        $result = $this->fetchAll($where);

        if (count($result) != 1) {
            return null;
        }
        return $result[0];
    }

    public function generatePassword()
    {
        return substr(md5(microtime()), 2, 2 + $this->_minPasswordLength);
    }

    public function generateApiCode()
    {
        return md5(microtime() * 34);
    }

    public function verify($accessCode)
    {
        $where = $this->getAdapter()->quoteInto('apiCode = ?', $accessCode);
        $this->_messages[] = $where;
        $result = $this->fetchAll($where, null, 1);

        if (count($result) != 1) {
            throw new Exception('Code not found');
        }

        return $result[0];
    }

    public function getAccountsForRole($roleId, $order = null, $count = null, $offset = null)
    {
        $rolesDb = new Ot_Model_DbTable_AccountRoles();

        $where = $rolesDb->getAdapter()->quoteInto('roleId = ?', $roleId);

        $roles = $rolesDb->fetchAll($where)->toArray();
        $accountIds = array();
        foreach ($roles as $role) {
            $accountIds[] = $role['accountId'];
        }

        if(count($accountIds) > 0) {
            $where = $this->getAdapter()->quoteInto('accountId IN (?)', $accountIds);
            return $this->fetchAll($where, $order, $count, $offset);
        } else {
            return null;
        }
    }
    
    /**
     * 
     * @param string $unityId
     * @param array $newRoleId - integer or array of integers for the new role Ids
     */
    public function changeAccountRoleForUnityId($unityId, $newRoleId)
    {
        $thisAccount = $this->getAccount($unityId, 'wrap');
        $accountRoles = new Ot_Model_DbTable_AccountRoles();
 
        if (!is_null($thisAccount)) {
            $data = array(
                'accountId' => $thisAccount->accountId,
                'role'      => $newRoleId
            );
            
            $newRoleId = (array)$newRoleId;
            
            $dba = $this->getAdapter();
            $dba->beginTransaction();
            
            try {
                $this->update($data, null);
                
                $dba->commit();
                return;
            } catch (Exception $e) {
            $dba->rollBack();
                throw $e;
            }
        } else {
            throw new Exception('Account not found');
        }
        
    }
    
    public function createNewUserForUnityId($unityId, $roleId)
    {    
        $thisAccount = $this->getAccount($unityId, 'wrap');
        $accountRoles = new Ot_Model_DbTable_AccountRoles();
        
        if (is_null($thisAccount)) {
            
            $data = array (
                'username'  => $unityId, 
                'realm'     => 'wrap',
                'password'  => md5($this->generatePassword()),
                'timezone'  => 'America/New_York',
                'role'      => $roleId,
            );

            $dba = $this->getAdapter();
            $dba->beginTransaction();
            
            $accountRolesDba = $accountRoles->getAdapter();
            
            try {
                $newAccountId = $this->insert($data);
                
                $dba->commit();
                return $newAccountId;
                
            } catch (Exception $e) {
            $dba->rollBack();
                throw $e;
            }
        } else {
            throw new Exception('Account already exists');
        }
    }
    
    public function importForm(array $default = array())
    {
        $form = new Zend_Form();
        $form->setAction('')
             ->setMethod('post')
             ->setAttrib('id', 'noteForm')
             ->setDecorators(array(
                 'FormElements',
                 array('HtmlTag', array('tag' => 'div', 'class' => 'zend_form')),
                 'Form',
             ));
                                               
        $text = $form->createElement('textarea', 'text', array('label' => 'Enter a comma separated list of Unity IDs:'));
        $text->addFilter('StringTrim')
              ->setAttrib('id', 'wysiwyg')
              ->setAttrib('style', 'width: 650px; height: 200px;')
              ->setValue((isset($default['text'])) ? $default['text'] : '');
        
        $roleList = array();
        $otRole = new Ot_Model_DbTable_Role();
        $allRoles = $otRole->fetchAll();
        foreach ($allRoles as $r) {
            $roleList[$r->roleId] = $r->name;
        }
             
        $newRoleId = $form->createElement('multicheckbox', 'newRoleId', array('label' => 'Choose a role for all accounts listed above: '));
        $newRoleId->setRequired(true);
        $newRoleId->setMultiOptions($roleList);
        $newRoleId->setValue((isset($default['newRoleId'])) ? $default['newRoleId'] : '');
        
        $form->addElements(array($text, $newRoleId));
        
        $submit = $form->createElement('submit', 'saveButton', array('label' => 'Submit'));
        $submit->setDecorators(array(
            array('ViewHelper', array('helper' => 'formSubmit'))
        ));
        
        $cancel = $form->createElement('button', 'cancel', array('label' => 'Cancel'));
        $cancel->setAttrib('id', 'cancel');
        $cancel->setDecorators(array(
            array('ViewHelper', array('helper' => 'formButton'))
        ));        
                            
        $form->setElementDecorators(array(
                 'ViewHelper',
                 'Errors',      
                 array('HtmlTag', array('tag' => 'div', 'class' => 'elm')), 
                 array('Label', array('tag' => 'span')),      
             ))->addElements(array($submit, $cancel));
             
        return $form;
    }

    public function changeRoleForm(array $default = array())
    {
        $form = new Zend_Form();
        $form->setAction('')
             ->setMethod('post')
             ->setAttrib('id', 'noteForm')
             ->setDecorators(array(
                 'FormElements',
                 array('HtmlTag', array('tag' => 'div', 'class' => 'zend_form')),
                 'Form',
             ));
                                               
        $text = $form->createElement('textarea', 'text', array('label' => ' Enter a comma separated list of Unity IDs:'));
        $text->addFilter('StringTrim')
             ->setAttrib('id', 'wysiwyg')
             ->setAttrib('style', 'width: 650px; height: 200px;')
             ->setValue((isset($default['text'])) ? $default['text'] : '');
        
        $roleList = array();
        $otRole = new Ot_Model_DbTable_Role();
        $allRoles = $otRole->fetchAll();
        foreach ($allRoles as $r) {
            $roleList[$r->roleId] = $r->name;
        }
             
        $newRoleId = $form->createElement('multicheckbox', 'newRoleId', array('label' => 'Choose new role for the accounts listed above: '));
        $newRoleId->setRequired(true);
        $newRoleId->setMultiOptions($roleList);
        $newRoleId->setValue((isset($default['newRoleId'])) ? $default['newRoleId'] : '');
              
        $form->addElements(array($text, $newRoleId));
        
        $submit = $form->createElement('submit', 'saveButton', array('label' => 'Submit'));
        $submit->setDecorators(array(
            array('ViewHelper', array('helper' => 'formSubmit'))
        ));
        
        $cancel = $form->createElement('button', 'cancel', array('label' => 'Cancel'));
        $cancel->setAttrib('id', 'cancel');
        $cancel->setDecorators(array(
               array('ViewHelper', array('helper' => 'formButton'))
        ));        
                            
        $form->setElementDecorators(array(
             'ViewHelper',
             'Errors',      
             array('HtmlTag', array('tag' => 'div', 'class' => 'elm')),
             array('Label', array('tag' => 'span')),
         ))->addElements(array($submit, $cancel));
             
        return $form;
    }

    public function masqueradeForm(array $default = array())
    {
        $acl    = Zend_Registry::get('acl');

        $form = new Zend_Form();
        $form->setAttrib('id', 'account')->setDecorators(
            array('FormElements', array('HtmlTag', array('tag' => 'div', 'class' => 'zend_form')), 'Form')
        );

        $authAdapter = new Ot_Model_DbTable_AuthAdapter();
        $adapters    = $authAdapter->fetchAll(null, 'displayOrder');

        // Realm Select box
        $realmSelect = $form->createElement('select', 'realm', array('label' => 'Login Method'));
        foreach ($adapters as $adapter) {
            $realmSelect->addMultiOption(
                $adapter->adapterKey,
                $adapter->name . (!$adapter->enabled ? ' (Disabled)' : '')
            );
        }
        $realmSelect->setValue((isset($default['realm'])) ? $default['realm'] : '');

        // Create and configure username element:
        $username = $form->createElement('text', 'username', array('label' => 'model-account-username'));
        $username->setRequired(true)
                 ->addFilter('StringTrim')
                 ->addFilter('Alnum')
                 ->addFilter('StripTags')
                 ->addValidator('StringLength', false, array(3, 64))
                 ->setAttrib('maxlength', '64')
                 ->setValue((isset($default['username'])) ? $default['username'] : '');

        $submit = $form->createElement('submit', 'submit', array('label' => 'Masquerade'));
        $submit->setDecorators(
            array(
                array('ViewHelper', array('helper' => 'formSubmit'))
            )
        );

        $form->addElements(array($realmSelect, $username, $submit));

        return $form;
    }
    
    public function form($default = array(), $signup = false)
    {
        $acl = Zend_Registry::get('acl');

        $form = new Zend_Form();
        $form->setAttrib('id', 'account')->setDecorators(
            array('FormElements', array('HtmlTag', array('tag' => 'div', 'class' => 'zend_form')), 'Form')
        );

        $authAdapter = new Ot_Model_DbTable_AuthAdapter;
        $adapters    = $authAdapter->fetchAll(null, 'displayOrder');

        // Realm Select box
        $realmSelect = $form->createElement('select', 'realm', array('label' => 'Login Method'));
        foreach ($adapters as $adapter) {
            $realmSelect->addMultiOption(
                $adapter->adapterKey,
                $adapter->name . (!$adapter->enabled ? ' (Disabled)' : '')
            );
        }
        $realmSelect->setValue((isset($default['realm'])) ? $default['realm'] : '');

        // Create and configure username element:
        $username = $form->createElement('text', 'username', array('label' => 'model-account-username'));
        $username->setRequired(true)
                 ->addFilter('StringTrim')
                 ->addFilter('Alnum')
                 ->addFilter('StripTags')
                 ->addValidator('StringLength', false, array(3, 64))
                 ->setAttrib('maxlength', '64')
                 ->setValue((isset($default['username'])) ? $default['username'] : '');

        // First Name
        $firstName = $form->createElement('text', 'firstName', array('label' => 'model-account-firstName'));
        $firstName->setRequired(true)
                  ->addFilter('StringToLower')
                  ->addFilter('StringTrim')
                  ->addFilter('StripTags')
                  ->addFilter(new Ot_Filter_Ucwords())
                  ->setAttrib('maxlength', '64')
                  ->setValue((isset($default['firstName'])) ? $default['firstName'] : '');

        // Last Name
        $lastName = $form->createElement('text', 'lastName', array('label' => 'model-account-lastName'));
        $lastName->setRequired(true)
                 ->addFilter('StringTrim')
                 ->addFilter('StringToLower')
                 ->addFilter('StripTags')
                  ->addFilter(new Ot_Filter_Ucwords())
                 ->setAttrib('maxlength', '64')
                 ->setValue((isset($default['lastName'])) ? $default['lastName'] : '');

        // Password field
        $password = $form->createElement('password', 'password', array('label' => 'model-account-password'));
        $password->setRequired(true)
                 ->addValidator('StringLength', false, array($this->_minPasswordLength, $this->_maxPasswordLength))
                 ->addFilter('StringTrim')
                 ->addFilter('StripTags');

        // Password confirmation field
        $passwordConf = $form->createElement('password', 'passwordConf', array('label' => 'model-account-passwordConf'));
        $passwordConf->setRequired(true)
                     ->addValidator('StringLength', false, array($this->_minPasswordLength, $this->_maxPasswordLength))
                     ->addValidator('Identical', false, array('token' => 'password'))
                     ->addFilter('StringTrim')
                     ->addFilter('StripTags');

        // Email address field
        $email = $form->createElement('text', 'emailAddress', array('label' => 'model-account-emailAddress'));
        $email->setRequired(true)
              ->addFilter('StringTrim')
              ->addValidator('EmailAddress')
              ->setValue((isset($default['emailAddress'])) ? $default['emailAddress'] : '');

        $timezone = $form->createElement('select', 'timezone', array('label' => 'model-account-timezone'));
        $timezone->addMultiOptions(Ot_Model_Timezone::getTimezoneList());
        $timezone->setValue(
            (
                isset($default['timezone'])
                && $default['timezone'] != ''
            )
            ? $default['timezone'] : date_default_timezone_get()
        );

        // Role select box
        $roleSelect = $form->createElement('multiCheckbox', 'roleSelect');
        $roleSelect->setRequired(true);

        $roles = $acl->getAvailableRoles();
        foreach ($roles as $r) {
            $roleSelect->addMultiOption($r['roleId'], $r['name']);
        }

        $roleSelect->setValue((isset($default['role'])) ? $default['role'] : '');

        $roleSelect->setAttrib('class', 'roleSelect');

        if ($signup) {
            $form->addElements(array($username, $password, $passwordConf, $firstName, $lastName, $email, $timezone));
        } else {
            $me = false; // bool value for if you're trying to edit your own account
            // Is this even necessary? Someone that can edit account probably is a super admin,
            // so why restrict this? They could just create a new user, change their permissions,
            // then log in as the new account to switch their main account's permissions.

            if (isset($default['accountId'])
                && $default['accountId'] == Zend_Auth::getInstance()->getIdentity()->accountId) {
                $me = true;
            }

            if (!$me) {
                $form->addElements(array($realmSelect, $username));
            }

            $form->addElements(array($firstName, $lastName, $email, $timezone));

            if (!$me) {
                $form->addElement($roleSelect);
            }
        }

        $subformElements = array();

        $loginOptions = Zend_Registry::get('applicationLoginOptions');

        if (isset($loginOptions['accountPlugin'])) {
            $acctPlugin = new $loginOptions['accountPlugin'];

            if (isset($default['accountId'])) {
                $subform = $acctPlugin->editSubForm($default['accountId']);
            } else {
                $subform = $acctPlugin->addSubForm();
            }

            foreach ($subform->getElements() as $e) {
                $form->addElement($e);
                $subformElements[] = $e->getName();
            }
        }

        $custom = new Ot_Model_Custom();

        if (isset($default['accountId'])) {
            $attributes = $custom->getData('Ot_Profile', $default['accountId'], 'Zend_Form');
        } else {
            $attributes = $custom->getAttributesForObject('Ot_Profile', 'Zend_Form');
        }

        $attributeNames = array();
        foreach ($attributes as $a) {
            $form->addElement($a['formRender']);
            if(isset($a['attribute'])) {
                $attributeNames[] = 'custom_' . $a['attribute']['attributeId'];
            } else {
                $attributeNames[] = 'custom_' . $a['attributeId'];
            }
        }

        $submit = $form->createElement('submit', 'submit', array('label' => 'form-button-save'));
        $submit->setDecorators(
            array(
                array('ViewHelper', array('helper' => 'formSubmit'))
            )
        );

        $cancel = $form->createElement('button', 'cancel', array('label' => 'form-button-cancel'));
        $cancel->setDecorators(
            array(
                array('ViewHelper', array('helper' => 'formButton'))
            )
        );

        $form->setElementDecorators(
            array(
                'ViewHelper',
                'Errors',
                array('HtmlTag', array('tag' => 'div', 'class' => 'elm')),
                array('Label', array('tag' => 'span')),
            )
        )->addElements(array($submit, $cancel));


        if(!$signup) {
            $form->addDisplayGroup(array_merge(array(
                    'realm',
                    'username',
                    'firstName',
                    'lastName',
                    'emailAddress',
                    'timezone'), $subformElements, $attributeNames, array(
                        'submit',
                        'cancel'))
                , 'general', array('legend' => 'General Information'));

            $general = $form->getDisplayGroup('general');
            $general->setDecorators(array(
                'FormElements',
                'Fieldset',
                   array('HtmlTag', array('tag' => 'div', 'class' => 'general'))
            ));
        }


        if(!$signup && !$me) {
            $form->addDisplayGroup(array('roleSelect'), 'roles', array('legend' => 'User Access Roles'));
            $role = $form->getDisplayGroup('roles');
            $role->setDecorators(array(
                'FormElements',
                'Fieldset',
                array('HtmlTag', array('tag' => 'div', 'class' => 'accessRoles'))
            ));
        }
/*
        if(count($attributeNames) > 0 && 1) {
            $form->addDisplayGroup($attributeNames, 'specialAttributes', array('legend' => 'Special Attributes'));
            $attrGroup = $form->getDisplayGroup('specialAttributes');
            $attrGroup->setDecorators(array(
                'FormElements',
                'Fieldset',
                array('HtmlTag', array('tag' => 'div', 'class' => 'specialAttributes'))
            ));
        }
        */
        if (isset($default['accountId'])) {
            $accountId = $form->createElement('hidden', 'accountId');
            $accountId->setValue($default['accountId']);
            $accountId->setDecorators(
                array(
                    array('ViewHelper', array('helper' => 'formHidden'))
                )
            );

            $form->addElement($accountId);
        }

        if ($signup) {

            // Realm hidden box
            $realmHidden = $form->createElement('hidden', 'realm');
            $realmHidden->setValue($default['realm']);
            $realmHidden->setDecorators(array(array('ViewHelper', array('helper' => 'formHidden'))));

            $form->addElement($realmHidden);
        }

        return $form;
    }
}