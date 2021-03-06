<?php
abstract class Ot_Var_Abstract
{
    protected $_name;
    protected $_label;
    protected $_description;
    protected $_defaultValue;
    protected $_options;
    protected $_value;
    
    private $_cryptKey;

    public function __construct($name = '', $label = '', $description = '', $defaultValue = '', $options = array())
    {
        $this->setName($name);
        $this->setLabel($label);
        $this->setDescription($description);
        $this->setDefaultValue($defaultValue);
        $this->setOptions($options);
        
        $this->_cryptKey = 'config_' . $this->getName();
    }

    public function setName($_name)
    {
        $this->_name = $_name;
        return $this;
    }

    public function getName()
    {
        return $this->_name;
    }

    public function setLabel($_label)
    {
        $this->_label = $_label;
        return $this;
    }

    public function getLabel()
    {
        return $this->_label;
    }

    public function setDescription($_description)
    {
        $this->_description = $_description;
        return $this;
    }

    public function getDescription()
    {
        return $this->_description;
    }

    public function setDefaultValue($defaultValue)
    {
        $this->_defaultValue = $defaultValue;
        return $this;
    }

    public function getDefaultValue()
    {
        return $this->_defaultValue;
    }

    public function setOptions($_options)
    {
        $this->_options = $_options;
        return $this;
    }

    public function getOptions()
    {
        return $this->_options;
    }
    
    abstract public function renderFormElement();

    public function setValue($value)
    {
        $model = new Ot_Model_DbTable_Var();

        $thisVar = $model->find($this->getName());

        $data = array(
            'varName' => $this->getName(),
            'value'   => $value,
        );

        if (is_null($thisVar)) {
            $model->insert($data);
        } else {
            $model->update($data, null);
        }

        $this->_value = $value;
    }

    public function getValue()
    {
        $model = new Ot_Model_DbTable_Var();

        $thisVar = $model->find($this->getName());

        if (is_null($thisVar)) {
            $this->_value = $this->getDefaultValue();
        } else {
            $this->_value = $thisVar['value'];
        }
        
        return $this->_value;
    }
    
    protected function _encrypt($string)
    {
        return base64_encode(mcrypt_encrypt(MCRYPT_RIJNDAEL_256, md5($this->_cryptKey), $string, MCRYPT_MODE_CBC, md5(md5($this->_cryptKey))));
    }
    
    protected function _decrypt($string)
    {
        return rtrim(mcrypt_decrypt(MCRYPT_RIJNDAEL_256, md5($this->_cryptKey), base64_decode($string), MCRYPT_MODE_CBC, md5(md5($this->_cryptKey))), "\0");
    }
}