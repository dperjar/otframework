-- phpMyAdmin SQL Dump
-- version 3.2.0
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 15, 2010 at 10:52 AM
-- Server version: 5.1.32
-- PHP Version: 5.3.0

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `otframework`
--

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_account_attributes`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_account_attributes` (
  `accountId` int(10) unsigned NOT NULL DEFAULT '0',
  `age` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ot_tbl_account_attributes`
--

INSERT INTO `ot_tbl_account_attributes` (`accountId`, `age`) VALUES
(31, '');

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_api_log`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_api_log` (
  `apiLogId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userId` varchar(16) NOT NULL DEFAULT '',
  `function` varchar(64) NOT NULL DEFAULT '',
  `args` text NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '',
  `priority` varchar(16) NOT NULL DEFAULT '',
  `priorityName` varchar(64) NOT NULL DEFAULT '',
  `timestamp` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`apiLogId`),
  KEY `userId` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ot_tbl_api_log`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_account`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_account` (
  `accountId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `realm` varchar(64) NOT NULL DEFAULT '',
  `password` varchar(128) NOT NULL DEFAULT '',
  `apiCode` varchar(255) NOT NULL DEFAULT '',
  `role` int(10) unsigned NOT NULL DEFAULT '0',
  `emailAddress` varchar(255) NOT NULL DEFAULT '',
  `firstName` varchar(64) NOT NULL DEFAULT '',
  `lastName` varchar(64) NOT NULL DEFAULT '',
  `timezone` varchar(32) NOT NULL DEFAULT '',
  `lastLogin` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`accountId`),
  UNIQUE KEY `username` (`username`,`realm`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=32 ;

--
-- Dumping data for table `ot_tbl_ot_account`
--

INSERT INTO `ot_tbl_ot_account` (`accountId`, `username`, `realm`, `password`, `apiCode`, `role`, `emailAddress`, `firstName`, `lastName`, `timezone`, `lastLogin`) VALUES
(31, 'admin', 'local', '21232f297a57a5a743894a0e4a801fc3', '', 3, 'admin@admin.com', 'Admin', 'Mcadmin', 'America/New_York', 1263564691);

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_auth_adapter`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_auth_adapter` (
  `adapterKey` varchar(24) NOT NULL,
  `class` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `displayOrder` int(11) NOT NULL,
  PRIMARY KEY (`adapterKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ot_tbl_ot_auth_adapter`
--

INSERT INTO `ot_tbl_ot_auth_adapter` (`adapterKey`, `class`, `name`, `description`, `enabled`, `displayOrder`) VALUES
('local', 'Ot_Auth_Adapter_Local', 'Local Auth', 'Authentication using a local ID and Password created by the user.', 1, 1),
('wrap', 'Ot_Auth_Adapter_Wrap', 'NCSU Wrap', 'Authentication using your Unity ID and Password', 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_bug`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_bug` (
  `bugId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL DEFAULT '',
  `submitDt` int(10) unsigned NOT NULL DEFAULT '0',
  `reproducibility` enum('always','sometimes','never') NOT NULL DEFAULT 'always',
  `severity` enum('minor','major','crash') NOT NULL DEFAULT 'minor',
  `priority` enum('low','medium','high','critical') NOT NULL DEFAULT 'low',
  `status` enum('new','ignore','escalated','fixed') NOT NULL DEFAULT 'new',
  PRIMARY KEY (`bugId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ot_tbl_ot_bug`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_bug_text`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_bug_text` (
  `bugTextId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bugId` int(10) unsigned NOT NULL DEFAULT '0',
  `accountId` int(10) unsigned NOT NULL DEFAULT '0',
  `postDt` int(10) unsigned NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  PRIMARY KEY (`bugTextId`),
  KEY `bugId` (`bugId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ot_tbl_ot_bug_text`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_cron_status`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_cron_status` (
  `name` varchar(255) NOT NULL DEFAULT '',
  `status` enum('enabled','disabled') NOT NULL DEFAULT 'enabled',
  `lastRunDt` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ot_tbl_ot_cron_status`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_custom_attribute`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_custom_attribute` (
  `attributeId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `objectId` varchar(64) NOT NULL DEFAULT '',
  `label` varchar(255) NOT NULL DEFAULT '',
  `type` enum('text','textarea','radio','checkbox','select','ranking','multicheckbox','multiselect') CHARACTER SET utf8 NOT NULL DEFAULT 'text',
  `options` text NOT NULL,
  `required` binary(1) NOT NULL DEFAULT '\0',
  `direction` enum('vertical','horizontal') NOT NULL DEFAULT 'vertical',
  `order` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`attributeId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `ot_tbl_ot_custom_attribute`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_custom_attribute_value`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_custom_attribute_value` (
  `objectId` varchar(64) NOT NULL DEFAULT '',
  `parentId` varchar(255) NOT NULL DEFAULT '',
  `attributeId` int(11) NOT NULL DEFAULT '0',
  `value` text NOT NULL,
  PRIMARY KEY (`objectId`,`parentId`,`attributeId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ot_tbl_ot_custom_attribute_value`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_email_queue`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_email_queue` (
  `queueId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attributeName` varchar(128) NOT NULL DEFAULT '',
  `attributeId` int(10) unsigned NOT NULL DEFAULT '0',
  `zendMailObject` blob NOT NULL,
  `queueDt` int(10) unsigned NOT NULL DEFAULT '0',
  `sentDt` int(10) unsigned NOT NULL DEFAULT '0',
  `status` enum('waiting','sent','error') NOT NULL DEFAULT 'waiting',
  PRIMARY KEY (`queueId`),
  KEY `attributeName` (`attributeName`),
  KEY `attributeId` (`attributeId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ot_tbl_ot_email_queue`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_image`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_image` (
  `imageId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source` longblob NOT NULL,
  `alt` varchar(64) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `contentType` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`imageId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ot_tbl_ot_image`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_log`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_log` (
  `logId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accountId` int(10) unsigned NOT NULL DEFAULT '0',
  `role` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `request` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `sid` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `timestamp` int(10) unsigned NOT NULL DEFAULT '0',
  `message` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `priority` int(10) unsigned NOT NULL DEFAULT '0',
  `priorityName` varchar(64) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `attributeName` varchar(128) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `attributeId` varchar(64) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`logId`),
  KEY `userId` (`accountId`),
  KEY `attributeName` (`attributeName`),
  KEY `attributeId` (`attributeId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=32 ;

--
-- Dumping data for table `ot_tbl_ot_log`
--

INSERT INTO `ot_tbl_ot_log` (`logId`, `accountId`, `role`, `request`, `sid`, `timestamp`, `message`, `priority`, `priorityName`, `attributeName`, `attributeId`) VALUES
(1, 31, '3', '/login', '0ui8ot8v4c4jd30fl4bgqi9o33', 1263318628, 'User Logged In', 6, 'INFO', 'accountId', '31'),
(2, 31, '3', '/login', '9p5qj2tsgfq5964eaivpg8q6n0', 1263564691, 'User Logged In', 6, 'INFO', 'accountId', '31'),
(3, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263566690, 'Attribute Choose your favorite colors added', 6, 'INFO', 'objectId', 'Ot_Profile'),
(4, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263566690, 'Choose your favorite colors added', 6, 'INFO', 'attributeId', '1'),
(5, 31, '3', '/account/edit/accountId/31', '9p5qj2tsgfq5964eaivpg8q6n0', 1263567554, 'Account was modified.', 6, 'INFO', 'accountId', '31'),
(6, 31, '3', '/account/edit/accountId/31', '9p5qj2tsgfq5964eaivpg8q6n0', 1263567719, 'Account was modified.', 6, 'INFO', 'accountId', '31'),
(7, 31, '3', '/account/edit/accountId/31', '9p5qj2tsgfq5964eaivpg8q6n0', 1263567860, 'Account was modified.', 6, 'INFO', 'accountId', '31'),
(8, 31, '3', '/account/edit/accountId/31', '9p5qj2tsgfq5964eaivpg8q6n0', 1263567865, 'Account was modified.', 6, 'INFO', 'accountId', '31'),
(9, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568075, 'Attribute Choose some foods added', 6, 'INFO', 'objectId', 'Ot_Profile'),
(10, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568075, 'Choose some foods added', 6, 'INFO', 'attributeId', '2'),
(11, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568096, 'Attribute How awesome are beans? added', 6, 'INFO', 'objectId', 'Ot_Profile'),
(12, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568096, 'How awesome are beans? added', 6, 'INFO', 'attributeId', '3'),
(13, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568106, 'Attribute What is your favorite movie? added', 6, 'INFO', 'objectId', 'Ot_Profile'),
(14, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568106, 'What is your favorite movie? added', 6, 'INFO', 'attributeId', '4'),
(15, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568113, 'Attribute Type some stuff added', 6, 'INFO', 'objectId', 'Ot_Profile'),
(16, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568113, 'Type some stuff added', 6, 'INFO', 'attributeId', '5'),
(17, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568129, 'Attribute Pick one added', 6, 'INFO', 'objectId', 'Ot_Profile'),
(18, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568129, 'Pick one added', 6, 'INFO', 'attributeId', '6'),
(19, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568143, 'Attribute Check me added', 6, 'INFO', 'objectId', 'Ot_Profile'),
(20, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568143, 'Check me added', 6, 'INFO', 'attributeId', '7'),
(21, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568157, 'Attribute How many times? added', 6, 'INFO', 'objectId', 'Ot_Profile'),
(22, 31, '3', '/ot/custom/add/objectId/Ot_Profile', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568157, 'How many times? added', 6, 'INFO', 'attributeId', '8'),
(23, 31, '3', '/account/edit/accountId/31', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568539, 'Account was modified.', 6, 'INFO', 'accountId', '31'),
(24, 31, '3', '/ot/custom/delete/attributeId/1', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568584, 'Attribute and all values were deleted', 6, 'INFO', 'objectAttributeId', '1'),
(25, 31, '3', '/ot/custom/delete/attributeId/2', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568589, 'Attribute and all values were deleted', 6, 'INFO', 'objectAttributeId', '2'),
(26, 31, '3', '/ot/custom/delete/attributeId/3', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568592, 'Attribute and all values were deleted', 6, 'INFO', 'objectAttributeId', '3'),
(27, 31, '3', '/ot/custom/delete/attributeId/4', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568597, 'Attribute and all values were deleted', 6, 'INFO', 'objectAttributeId', '4'),
(28, 31, '3', '/ot/custom/delete/attributeId/5', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568613, 'Attribute and all values were deleted', 6, 'INFO', 'objectAttributeId', '5'),
(29, 31, '3', '/ot/custom/delete/attributeId/6', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568617, 'Attribute and all values were deleted', 6, 'INFO', 'objectAttributeId', '6'),
(30, 31, '3', '/ot/custom/delete/attributeId/7', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568622, 'Attribute and all values were deleted', 6, 'INFO', 'objectAttributeId', '7'),
(31, 31, '3', '/ot/custom/delete/attributeId/8', '9p5qj2tsgfq5964eaivpg8q6n0', 1263568626, 'Attribute and all values were deleted', 6, 'INFO', 'objectAttributeId', '8');

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_nav`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_nav` (
  `id` int(11) NOT NULL DEFAULT '0',
  `parent` int(11) NOT NULL DEFAULT '0',
  `display` varchar(255) NOT NULL DEFAULT '',
  `module` varchar(255) NOT NULL DEFAULT '',
  `controller` varchar(255) NOT NULL DEFAULT '',
  `action` varchar(255) NOT NULL DEFAULT '',
  `link` varchar(255) NOT NULL DEFAULT '',
  `target` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ot_tbl_ot_nav`
--

INSERT INTO `ot_tbl_ot_nav` (`id`, `parent`, `display`, `module`, `controller`, `action`, `link`, `target`) VALUES
(1, 0, 'Home', 'default', 'index', '', 'index/index', '_self'),
(2, 0, 'Admin', 'ot', 'index', 'index', '', ''),
(3, 2, 'Access', 'ot', 'index', 'index', '', '_self'),
(4, 3, 'Registered Applications', 'ot', 'oauth', 'all-consumers', 'ot/oauth/all-consumers', '_self'),
(5, 3, 'User Access Roles', 'ot', 'acl', 'index', 'ot/acl/index', '_self'),
(6, 3, 'Users', 'ot', 'account', 'all', 'account/all', '_self'),
(7, 2, 'Configuration', 'ot', 'index', 'index', '', ''),
(8, 7, 'App Config', 'ot', 'config', 'index', 'ot/config/index', '_self'),
(9, 7, 'App Triggers', 'ot', 'trigger', 'index', 'ot/trigger/index', '_self'),
(10, 7, 'Authentication Types', 'ot', 'auth', 'index', 'ot/auth/', '_self'),
(11, 7, 'Custom Fields', 'ot', 'custom', 'index', 'ot/custom/index', '_self'),
(12, 7, 'Debug Mode', 'ot', 'debug', 'index', 'ot/debug', '_self'),
(13, 7, 'Maintenance Mode', 'ot', 'maintenance', 'index', 'ot/maintenance', '_self'),
(14, 7, 'Navigation Editor', 'ot', 'nav', 'index', 'ot/nav/index', '_self'),
(15, 7, 'Themes', 'ot', 'theme', 'index', 'ot/theme/index', '_self'),
(16, 2, 'Bug Reports', 'ot', 'bug', '', 'ot/bug', '_self'),
(17, 2, 'Caching', 'ot', 'cache', '', 'ot/cache', '_self'),
(18, 2, 'Cron Jobs', 'ot', 'cron', 'index', 'ot/cron/index', '_self'),
(19, 2, 'Database Backup', 'ot', 'backup', '', 'ot/backup', '_self'),
(20, 2, 'Email Queue', 'ot', 'emailqueue', 'index', 'ot/emailqueue/index', '_self'),
(21, 2, 'Logs', 'ot', 'log', 'index', 'ot/log/index', '_self'),
(22, 2, 'Version Information', 'ot', 'index', 'index', 'ot/index/index', '_self');

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_oauth_client_token`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_oauth_client_token` (
  `consumerId` varchar(32) NOT NULL DEFAULT '',
  `accountId` int(10) unsigned NOT NULL DEFAULT '0',
  `token` varchar(255) NOT NULL DEFAULT '',
  `tokenSecret` varchar(255) NOT NULL DEFAULT '',
  `tokenType` enum('request','access') NOT NULL DEFAULT 'request',
  PRIMARY KEY (`consumerId`,`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ot_tbl_ot_oauth_client_token`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_oauth_server_consumer`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_oauth_server_consumer` (
  `consumerId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '',
  `imageId` int(10) unsigned NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `website` varchar(255) NOT NULL DEFAULT '',
  `registeredAccountId` int(10) unsigned NOT NULL DEFAULT '0',
  `callbackUrl` varchar(255) NOT NULL DEFAULT '',
  `consumerKey` varchar(255) NOT NULL DEFAULT '',
  `consumerSecret` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`consumerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ot_tbl_ot_oauth_server_consumer`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_oauth_server_nonce`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_oauth_server_nonce` (
  `nonceId` int(11) NOT NULL AUTO_INCREMENT,
  `consumerId` int(11) NOT NULL DEFAULT '0',
  `token` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `timestamp` bigint(20) NOT NULL DEFAULT '0',
  `nonce` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`nonceId`),
  UNIQUE KEY `osn_consumer_key` (`consumerId`,`token`,`timestamp`,`nonce`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ot_tbl_ot_oauth_server_nonce`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_oauth_server_token`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_oauth_server_token` (
  `tokenId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `consumerId` int(10) unsigned NOT NULL DEFAULT '0',
  `accountId` int(10) unsigned NOT NULL DEFAULT '0',
  `token` varchar(128) NOT NULL DEFAULT '',
  `tokenSecret` varchar(128) NOT NULL DEFAULT '',
  `tokenType` enum('request','access') NOT NULL DEFAULT 'request',
  `requestDt` int(10) unsigned NOT NULL DEFAULT '0',
  `authorized` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tokenId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `ot_tbl_ot_oauth_server_token`
--


-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_role`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_role` (
  `scope` enum('application','remote') NOT NULL DEFAULT 'application',
  `roleId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `inheritRoleId` int(10) unsigned NOT NULL DEFAULT '0',
  `editable` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`roleId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `ot_tbl_ot_role`
--

INSERT INTO `ot_tbl_ot_role` (`scope`, `roleId`, `name`, `inheritRoleId`, `editable`) VALUES
('application', 1, 'guest', 0, 1),
('application', 2, 'administrator', 0, 0),
('application', 3, 'oit_ot_staff', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_role_rule`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_role_rule` (
  `ruleId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `roleId` int(11) NOT NULL DEFAULT '0',
  `type` enum('allow','deny') NOT NULL DEFAULT 'allow',
  `resource` varchar(64) NOT NULL DEFAULT '',
  `privilege` varchar(64) NOT NULL DEFAULT '',
  `scope` enum('application','remote') NOT NULL DEFAULT 'application',
  PRIMARY KEY (`ruleId`),
  KEY `scope` (`scope`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=352 ;

--
-- Dumping data for table `ot_tbl_ot_role_rule`
--

INSERT INTO `ot_tbl_ot_role_rule` (`ruleId`, `roleId`, `type`, `resource`, `privilege`, `scope`) VALUES
(8, 2, 'allow', '*', '*', 'application'),
(9, 3, 'allow', '*', '*', 'application'),
(111, 2, 'allow', '*', '*', 'remote'),
(233, 3, 'allow', '*', '*', 'remote'),
(234, 1, 'allow', 'getVersions', '*', 'remote'),
(235, 1, 'deny', 'getConfigOption', '*', 'remote'),
(236, 1, 'deny', 'getMyAccount', '*', 'remote'),
(237, 1, 'deny', 'updateMyAccount', '*', 'remote'),
(238, 1, 'deny', 'getAccount', '*', 'remote'),
(239, 1, 'deny', 'updateAccount', '*', 'remote'),
(240, 1, 'deny', 'getCronJobs', '*', 'remote'),
(241, 1, 'deny', 'setCronJobStatus', '*', 'remote'),
(242, 1, 'deny', 'getBugReports', '*', 'remote'),
(243, 1, 'allow', 'describe', '*', 'remote'),
(342, 1, 'allow', 'ot_bug', 'add', 'application'),
(343, 1, 'allow', 'ot_bug', 'index', 'application'),
(344, 1, 'allow', 'ot_api', '*', 'application'),
(345, 1, 'allow', 'ot_cron', '*', 'application'),
(346, 1, 'allow', 'default_index', '*', 'application'),
(347, 1, 'allow', 'error_error', '*', 'application'),
(348, 1, 'allow', 'ot_image', '*', 'application'),
(349, 1, 'allow', 'ot_login', '*', 'application'),
(350, 1, 'allow', 'ot_oauthserver', 'access-token', 'application'),
(351, 1, 'allow', 'ot_oauthserver', 'request-token', 'application');

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_trigger_action`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_trigger_action` (
  `triggerActionId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `triggerId` varchar(64) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `helper` varchar(64) NOT NULL DEFAULT '',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`triggerActionId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `ot_tbl_ot_trigger_action`
--

INSERT INTO `ot_tbl_ot_trigger_action` (`triggerActionId`, `triggerId`, `name`, `helper`, `enabled`) VALUES
(14, 'Login_Index_Signup', 'Signup for an account', 'Ot_Trigger_Plugin_Email', 1),
(15, 'Login_Index_Forgot', 'User forgot password', 'Ot_Trigger_Plugin_Email', 1),
(16, 'Admin_Account_Create_Password', 'Admin created account', 'Ot_Trigger_Plugin_Email', 1),
(17, 'Admin_Account_Create_NoPassword', 'When a WRAP account gets created', 'Ot_Trigger_Plugin_Email', 1);

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_trigger_helper_email`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_trigger_helper_email` (
  `triggerActionId` int(11) NOT NULL DEFAULT '0',
  `to` varchar(255) NOT NULL DEFAULT '',
  `from` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  PRIMARY KEY (`triggerActionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ot_tbl_ot_trigger_helper_email`
--

INSERT INTO `ot_tbl_ot_trigger_helper_email` (`triggerActionId`, `to`, `from`, `subject`, `body`) VALUES
(14, '[[emailAddress]]', 'webapps_admin@ncsu.edu', 'Thanks for signing up!', 'Hey [[firstName]]!  Welcome to The System.\r\n\r\nYour user id:  [[username]]\r\nYou password: [[password]]'),
(15, '[[emailAddress]]', 'admin@webapps.ncsu.edu', 'Your password has been reset', 'Thanks [[firstName]] [[lastName]]\r\n\r\nYou password for [[username]] has been reset.  Go here [[resetUrl]] to change your password.'),
(16, '[[emailAddress]]', 'admin@webapps.ncsu.edu', 'You''ve been given an account', 'Hey [[firstName]], You''ve been given a(n) [[role]] account!\r\n\r\n[[username]]\r\n[[password]]'),
(17, '[[emailAddress]]', 'admin@webapps.ncsu.edu', 'You''ve got a new account!', 'Hey [[firstName]] [[lastName]]\r\n\r\nYou''ve been given a new [[role]] [[loginMethod]] account.\r\n\r\nYour username is [[username]]');

-- --------------------------------------------------------

--
-- Table structure for table `ot_tbl_ot_trigger_helper_emailqueue`
--

CREATE TABLE IF NOT EXISTS `ot_tbl_ot_trigger_helper_emailqueue` (
  `triggerActionId` int(11) NOT NULL DEFAULT '0',
  `to` varchar(255) NOT NULL DEFAULT '',
  `from` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(255) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  PRIMARY KEY (`triggerActionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ot_tbl_ot_trigger_helper_emailqueue`
--

