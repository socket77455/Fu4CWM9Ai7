-- phpMyAdmin SQL Dump
-- version 3.5.8.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 27, 2014 at 06:57 PM
-- Server version: 5.1.73
-- PHP Version: 5.3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `cnrsf`
--

-- --------------------------------------------------------

--
-- Table structure for table `playerbans`
--

CREATE TABLE IF NOT EXISTS `playerbans` (
  `ban_id` int(6) NOT NULL AUTO_INCREMENT,
  `banned_by` varchar(24) NOT NULL,
  `banned_for` varchar(128) NOT NULL,
  `player_banned` varchar(24) NOT NULL,
  `player_ip` varchar(15) NOT NULL,
  PRIMARY KEY (`ban_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7971 ;

-- --------------------------------------------------------

--
-- Table structure for table `playerdata`
--

CREATE TABLE IF NOT EXISTS `playerdata` (
  `playerName` varchar(30) NOT NULL,
  `playerPass` varchar(500) NOT NULL,
  `playerScore` varchar(10) NOT NULL DEFAULT '0',
  `playerMoney` varchar(10) NOT NULL DEFAULT '0',
  `playerIP` varchar(20) NOT NULL DEFAULT '0',
  `playerLevel` int(3) NOT NULL DEFAULT '0',
  `playerKills` int(10) NOT NULL DEFAULT '0',
  `playerDeaths` int(10) NOT NULL DEFAULT '0',
  `playerRobberies` int(10) NOT NULL DEFAULT '0',
  `playerJailTime` int(10) NOT NULL DEFAULT '0',
  `playerTimesJailed` int(10) NOT NULL DEFAULT '0',
  `playerWantedLevel` int(10) NOT NULL DEFAULT '0',
  `playerVIP` int(3) NOT NULL DEFAULT '0',
  `playerMuteTime` int(10) NOT NULL DEFAULT '0',
  `playerXP` int(8) NOT NULL DEFAULT '0',
  `playerJob` int(3) NOT NULL DEFAULT '-1',
  `playerCopBanned` int(1) NOT NULL DEFAULT '0',
  `playerArmyBanned` int(1) NOT NULL DEFAULT '0',
  `playerFightStyle` int(2) NOT NULL DEFAULT '0',
  `playerID` int(10) NOT NULL AUTO_INCREMENT,
  `playerHitValue` int(10) NOT NULL DEFAULT '0',
  `playerAdminJailed` int(1) NOT NULL DEFAULT '0',
  `playerBank` int(100) NOT NULL DEFAULT '0',
  `copTutorial` int(1) NOT NULL DEFAULT '0',
  `lastLogged` varchar(100) NOT NULL DEFAULT 'Never',
  `playerHelper` int(1) NOT NULL DEFAULT '0',
  `playerWeed` int(3) NOT NULL DEFAULT '0',
  `firstLogged` int(20) NOT NULL,
  `vipExpires` int(20) NOT NULL DEFAULT '-1',
  `statTrucks` int(4) NOT NULL DEFAULT '0',
  `vipweapon` int(3) NOT NULL DEFAULT '0',
  `arrestStat` int(4) NOT NULL DEFAULT '0',
  `moneybagStat` int(3) NOT NULL DEFAULT '0',
  `rules_read` int(1) NOT NULL DEFAULT '0',
  `spawnHouse` int(3) NOT NULL DEFAULT '-1',
  `statHits` int(3) NOT NULL DEFAULT '0',
  `streetRobberies` int(4) NOT NULL DEFAULT '0',
  `streetRapes` int(4) NOT NULL DEFAULT '0',
  `playersTied` int(4) NOT NULL DEFAULT '0',
  `playersKidnapped` int(4) NOT NULL DEFAULT '0',
  `copDetains` int(4) NOT NULL DEFAULT '0',
  `copKills` int(4) NOT NULL DEFAULT '0',
  `playerRope` int(4) NOT NULL DEFAULT '0',
  `playerBobbyPins` int(4) NOT NULL DEFAULT '0',
  `playerScissors` int(4) NOT NULL DEFAULT '0',
  `playerExplosives` int(4) NOT NULL DEFAULT '0',
  `forkliftCompleted` int(4) NOT NULL DEFAULT '0',
  `bankRobs` int(4) NOT NULL DEFAULT '0',
  `innocentKills` int(3) NOT NULL DEFAULT '0',
  `aInnocentKills` int(3) NOT NULL DEFAULT '0',
  `customSkin` int(3) NOT NULL DEFAULT '-1',
  `busCompleted` int(3) NOT NULL DEFAULT '0',
  `dm_kills` int(4) NOT NULL DEFAULT '0',
  `dm_deaths` int(4) NOT NULL DEFAULT '0',
  `cookies` int(4) NOT NULL DEFAULT '0',
  `backpack` int(1) NOT NULL DEFAULT '0',
  `sweepCompleted` int(3) NOT NULL DEFAULT '0',
  `weaponSkill` int(1) NOT NULL DEFAULT '0',
  `bombsDefused` int(3) NOT NULL DEFAULT '0',
  `rTokens` int(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`playerID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=104737 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
