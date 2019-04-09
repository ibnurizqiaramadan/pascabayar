-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versi server:                 10.1.22-MariaDB - mariadb.org binary distribution
-- OS Server:                    Win32
-- HeidiSQL Versi:               10.0.0.5460
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Membuang struktur basisdata untuk db_pem_listrik_pb
CREATE DATABASE IF NOT EXISTS `db_pem_listrik_pb` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `db_pem_listrik_pb`;

-- membuang struktur untuk table db_pem_listrik_pb.pelanggan
CREATE TABLE IF NOT EXISTS `pelanggan` (
  `idpelanggan` varchar(50) NOT NULL,
  `nometer` varchar(15) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `JK` enum('Laki-Laki','Perempuan') NOT NULL,
  `Tempat_lhr` varchar(50) NOT NULL,
  `Tanggal_lhr` date NOT NULL,
  `No_ktp` varchar(50) NOT NULL,
  `No_Telpon` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `kodetarif` varchar(11) NOT NULL,
  `kodepos` varchar(11) NOT NULL,
  `stat` enum('A','D') NOT NULL DEFAULT 'A',
  PRIMARY KEY (`idpelanggan`),
  KEY `kodetarif` (`kodetarif`),
  CONSTRAINT `pelanggan_ibfk_1` FOREIGN KEY (`kodetarif`) REFERENCES `tarif` (`kodetarif`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Pengeluaran data tidak dipilih.
-- membuang struktur untuk table db_pem_listrik_pb.pembayaran
CREATE TABLE IF NOT EXISTS `pembayaran` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idpenggunaan` varchar(50) NOT NULL,
  `idpelanggan` varchar(50) NOT NULL,
  `tanggal` datetime NOT NULL,
  `bulan` datetime NOT NULL,
  `biayaadmin` double NOT NULL,
  `jumlahbayar` double NOT NULL,
  `hai` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idpenggunaan` (`idpenggunaan`),
  CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`idpenggunaan`) REFERENCES `tagihan` (`idpenggunaan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Pengeluaran data tidak dipilih.
-- membuang struktur untuk table db_pem_listrik_pb.penggunaan
CREATE TABLE IF NOT EXISTS `penggunaan` (
  `idpenggunaan` varchar(50) NOT NULL,
  `idpelanggan` varchar(50) DEFAULT NULL,
  `bulan` date NOT NULL,
  `tahun` year(4) NOT NULL,
  `meterawal` int(11) NOT NULL,
  `meterakhir` int(11) NOT NULL,
  `stat` enum('A','D') NOT NULL DEFAULT 'A',
  `status` enum('Terbayar','Belum Terbayar') NOT NULL DEFAULT 'Belum Terbayar',
  PRIMARY KEY (`idpenggunaan`),
  KEY `idpelanggan` (`idpelanggan`),
  CONSTRAINT `penggunaan_ibfk_1` FOREIGN KEY (`idpelanggan`) REFERENCES `pelanggan` (`idpelanggan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Pengeluaran data tidak dipilih.
-- membuang struktur untuk table db_pem_listrik_pb.tagihan
CREATE TABLE IF NOT EXISTS `tagihan` (
  `idpenggunaan` varchar(50) NOT NULL DEFAULT 'Belum Terbayar',
  `idpelanggan` varchar(50) NOT NULL,
  `bulan` datetime NOT NULL,
  `tahun` year(4) NOT NULL,
  `jumlahmeter` int(11) NOT NULL,
  `status` enum('Terbayar','Belum Terbayar') NOT NULL DEFAULT 'Belum Terbayar',
  `stat` enum('A','D') NOT NULL DEFAULT 'A',
  PRIMARY KEY (`idpenggunaan`),
  KEY `idpelanggan` (`idpelanggan`),
  KEY `idpenggunaan` (`idpenggunaan`),
  CONSTRAINT `tagihan_ibfk_1` FOREIGN KEY (`idpenggunaan`) REFERENCES `penggunaan` (`idpenggunaan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Pengeluaran data tidak dipilih.
-- membuang struktur untuk table db_pem_listrik_pb.tarif
CREATE TABLE IF NOT EXISTS `tarif` (
  `kodetarif` varchar(11) NOT NULL,
  `daya` varchar(10) NOT NULL,
  `tarifperkwh` double NOT NULL,
  PRIMARY KEY (`kodetarif`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Pengeluaran data tidak dipilih.
-- membuang struktur untuk table db_pem_listrik_pb.t_user
CREATE TABLE IF NOT EXISTS `t_user` (
  `iduser` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `level` enum('Admin','User') NOT NULL,
  PRIMARY KEY (`iduser`)
) ENGINE=InnoDB AUTO_INCREMENT=180010 DEFAULT CHARSET=latin1;

-- Pengeluaran data tidak dipilih.
-- membuang struktur untuk trigger db_pem_listrik_pb.tagihan
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tagihan` AFTER INSERT ON `penggunaan` FOR EACH ROW BEGIN
	INSERT INTO tagihan (
	idpenggunaan,
	idpelanggan,
	bulan,
	tahun,
	jumlahmeter,
	status,
	stat)
VALUES(
	new.idpenggunaan,
	new.idpelanggan,
	DATE_ADD(new.bulan, INTERVAL 1 MONTH),
	new.tahun,
	new.meterakhir-new.meterawal,
	"Belum Terbayar",
	"A");
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
