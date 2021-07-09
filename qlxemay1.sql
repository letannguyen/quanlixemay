-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th4 09, 2021 lúc 03:09 AM
-- Phiên bản máy phục vụ: 8.0.21
-- Phiên bản PHP: 7.4.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `qlxemay`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_doanhthutheokhoangthoigian` (IN `fromdate` DATE, IN `todate` DATE)  BEGIN
	select sum(tongtien) from phieuxuat where ngayxuat between `fromdate` and `todate`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_doanhthutheonam` (IN `year` INT)  BEGIN
	select month(ngayxuat) as thang,sum(tongtien)  from phieuxuat a
where year(ngayxuat) = year
group by thang
order by thang;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_soluongnhap` (`nam` INT, `thang` INT)  BEGIN
	select xe.tenxe as tenxe,sum(phieunhapchitiet.soluong) as soluongnhap,sum(phieunhap.tongtien)
	from phieunhap inner join phieunhapchitiet
	on phieunhap.maphieunhap = phieunhapchitiet.maphieunhap
	inner join xe
	on phieunhapchitiet.maxe = xe.maxe
    where year(ngaynhap) = nam and month(ngaynhap) = thang
	group by tenxe
	order by soluongnhap desc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_soluongxe` (`nam` INT, `thang` INT)  BEGIN
	SELECT xe.tenxe  as tenxe,
SUM(phieuxuatchitiet.soluong) as soluongban, sum(tongtien)as tongtienban
FROM xe inner join phieuxuatchitiet
on xe.maxe =phieuxuatchitiet.maxe
inner join phieuxuat
on phieuxuat.maphieuxuat=phieuxuatchitiet.maphieuxuat
where year(ngayxuat) = nam and month(ngayxuat)=thang
GROUP BY tenxe
ORDER BY soluongban DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TK_DoanhthuKH` ()  BEGIN
	select  khachhang.makh,hoten,sum(tongtien) as Tongtien ,ngayxuat
	from khachhang inner join phieuxuat 
	on khachhang.makh = phieuxuat.makh
	group by hoten
	order by Tongtien desc limit 3  ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Tk_KH` ()  BEGIN
	select  khachhang.makh,hoten,sum(tongtien) as Tongtien ,ngayxuat
	from khachhang inner join phieuxuat 
	on khachhang.makh = phieuxuat.makh
	
    group by hoten
	order by Tongtien desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TK_TheoThang` (`thang` INT, `nam` INT)  BEGIN
	select  khachhang.makh,hoten,sum(tongtien) as Tongtien ,ngayxuat
	from khachhang inner join phieuxuat 
	on khachhang.makh = phieuxuat.makh
	where month(ngayxuat) = thang and year(ngayxuat)= nam
    group by hoten
	order by Tongtien desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tongtien` (`nam` INT)  BEGIN
select	nhanvien.manv , nhanvien.hoten,sum(phieuxuat.tongtien) as tongtien, count(phieuxuat.maphieuxuat) as sohoadonban
from nhanvien inner join phieuxuat on nhanvien.manv=phieuxuat.manv
where year(phieuxuat.ngayxuat)= nam 
group by manv
order by tongtien desc;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hangxe`
--

CREATE TABLE `hangxe` (
  `mahang` varchar(10) NOT NULL,
  `tenhang` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `hangxe`
--

INSERT INTO `hangxe` (`mahang`, `tenhang`) VALUES
('Honda', 'Honda'),
('SYM', 'SYM'),
('Yamaha', 'Yamaha');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khachhang`
--

CREATE TABLE `khachhang` (
  `makh` varchar(10) NOT NULL,
  `hoten` varchar(50) DEFAULT NULL,
  `gioitinh` bit(1) DEFAULT NULL,
  `diachi` varchar(50) DEFAULT NULL,
  `sodt` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `khachhang`
--

INSERT INTO `khachhang` (`makh`, `hoten`, `gioitinh`, `diachi`, `sodt`) VALUES
('KH01', 'Tran Ngoc Han', b'0', '23/5 Nguyễn Trãi, tp Đà Nẵng', '0909081010'),
('KH02', 'Tran Ngoc Linh', b'0', '45 Nguyen Canh Chan, tp Đà Nẵng', '0973452564'),
('KH03', 'Nguyen Van Tam', b'1', '34 Truong Dinh, tp Da Nang', '0128362728'),
('KH04', 'Ngo Thanh Tuan', b'1', '20 Hung Vuong, tp Da Nang', '0978645352'),
('KH05', 'Nguyễn Văn C', b'1', '48 Trần Phú, tp Đà Nẵng', '0909989876'),
('KH06', 'Lê Văn D', b'1', '3 Hùng Vương, tp Đà Nẵng', '0912233445'),
('KH07', 'Trần Linh Đan', b'0', '1 Hàm Nghi, tp Đà Nẵng', '0998765432'),
('KH08', 'Huỳnh Văn Thành', b'1', '53 Trần Bạch Đằng, tp Đà Nẵng', '0965674367'),
('KH09', 'AlexD', b'1', '72 Lê Cơ, tp Đà Nẵng', '0898765342'),
('KH10', 'Nguyễn Văn Quốc', b'1', '32 Đống Đa', '0987657463'),
('KH11', 'Trần Thị Ngân', b'0', '3 Yên Bái, tp Đà Nẵng', '0898765432'),
('KH12', 'Lê Vy', b'0', '148 Lê Thanh Nghị, tp Đà nẵng', '0967453627'),
('KH13', 'Trần Phương Vy', b'0', '45 Lê Nổ, tp Đà Nẵng', '0989959493'),
('KH14', 'Nguyễn Văn Tân', b'1', '5 Hải Hồ, tp Đà Nẵng', '0986757473'),
('KH15', 'Nguyễn Phương', b'1', '90 Đống Đa, tp Đà Nẵng', '0321454784'),
('kh31', 'cuong duc', b'1', 'tranphu', '0782212121');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `mauxe`
--

CREATE TABLE `mauxe` (
  `mamau` varchar(10) NOT NULL,
  `tenmau` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `mauxe`
--

INSERT INTO `mauxe` (`mamau`, `tenmau`) VALUES
('black', 'màu đen'),
('red', 'màu đỏ'),
('white', 'màu trắng'),
('yellow', 'màu vàng');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nhacc`
--

CREATE TABLE `nhacc` (
  `mancc` varchar(10) NOT NULL,
  `tenncc` varchar(50) DEFAULT NULL,
  `diachi` varchar(200) NOT NULL,
  `sdt` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `nhacc`
--

INSERT INTO `nhacc` (`mancc`, `tenncc`, `diachi`, `sdt`) VALUES
('Head', 'Honda Quốc Tiến', '', ''),
('TienThu', 'CÔNG TY TNHH TIẾN na', 'hoa phuoc', '0909999444'),
('VNV', 'Yamaha Town Vân Ngọc Vân', '', '');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nhanvien`
--

CREATE TABLE `nhanvien` (
  `manv` varchar(10) NOT NULL,
  `hoten` varchar(50) DEFAULT NULL,
  `matkhau` varchar(50) DEFAULT NULL,
  `vaitro` bit(1) DEFAULT NULL,
  `sodt` varchar(10) DEFAULT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `nhanvien`
--

INSERT INTO `nhanvien` (`manv`, `hoten`, `matkhau`, `vaitro`, `sodt`, `email`) VALUES
('a', 'nguyen van a', '123456', b'1', '0989787878', 'nguyenvana@fpt.edu.vn'),
('b', 'nguyen van b', '123456', b'0', '0987654321', 'nguyenvanb@fpt.edu.vn'),
('nguyenlt', 'Lê Tấn Nguyên', '123456', b'0', '0989876541', 'nguyenlt@fpt.edu.vn'),
('quocnv', 'Nguyễn Văn Quốc', '123456', b'0', '0989786756', 'quocnv@fpt.edu.vn'),
('tan1', 'taan', '1234', b'1', '0905906113', 'quangtan1197@gmail.com'),
('vietdc', 'Dương Cường Việt', '123456', b'1', '0909080202', 'vietdc@fpt.edu.vn');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieunhap`
--

CREATE TABLE `phieunhap` (
  `maphieunhap` varchar(20) NOT NULL,
  `manv` varchar(10) DEFAULT NULL,
  `mancc` varchar(10) DEFAULT NULL,
  `ngaynhap` date DEFAULT NULL,
  `tongtien` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `phieunhap`
--

INSERT INTO `phieunhap` (`maphieunhap`, `manv`, `mancc`, `ngaynhap`, `tongtien`) VALUES
('PN20201203080036', 'a', 'Head', '2020-12-03', 6000),
('PN20201203080124', 'a', 'Head', '2020-12-03', 2400),
('PN20201205080110', 'a', 'Head', '2020-12-05', 6000),
('PN20201215143617', 'nguyenlt', 'Head', '2020-12-15', 9600),
('PN20201215144530', 'vietdc', 'TienThu', '2020-12-15', 7200),
('PN20201215144648', 'quocnv', 'VNV', '2020-12-11', 21000),
('PN20201215165515', 'b', 'TienThu', '2020-12-15', 7200);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieunhapchitiet`
--

CREATE TABLE `phieunhapchitiet` (
  `maphieunhap` varchar(20) NOT NULL,
  `maxe` varchar(10) NOT NULL,
  `soluong` int DEFAULT NULL,
  `gianhap` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `phieunhapchitiet`
--

INSERT INTO `phieunhapchitiet` (`maphieunhap`, `maxe`, `soluong`, `gianhap`) VALUES
('PN20201203080036', 'ab03', 2, 2000),
('PN20201203080036', 'ab04', 3, 2000),
('PN20201203080124', 'ab03', 3, 2000),
('PN20201203080124', 'husky02', 1, 2400),
('PN20201205080110', 'ab03', 2, 2000),
('PN20201205080110', 'ab04', 3, 2000),
('PN20201215143617', 'ex01', 3, 3000),
('PN20201215143617', 'husky02', 4, 2400),
('PN20201215143617', 'siri01', 4, 1200),
('PN20201215144530', 'ab03', 3, 2000),
('PN20201215144530', 'husky03', 5, 2400),
('PN20201215144530', 'siri02', 6, 1200),
('PN20201215144648', 'ab03', 4, 2000),
('PN20201215144648', 'ab04', 6, 2000),
('PN20201215144648', 'ex02', 6, 3000),
('PN20201215144648', 'husky03', 7, 2400),
('PN20201215165515', 'ex01', 3, 3000),
('PN20201215165515', 'husky03', 3, 2400);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieuxuat`
--

CREATE TABLE `phieuxuat` (
  `maphieuxuat` varchar(20) NOT NULL,
  `manv` varchar(10) DEFAULT NULL,
  `makh` varchar(10) DEFAULT NULL,
  `ngayxuat` date DEFAULT NULL,
  `tongtien` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `phieuxuat`
--

INSERT INTO `phieuxuat` (`maphieuxuat`, `manv`, `makh`, `ngayxuat`, `tongtien`) VALUES
('HD20201121000041', 'vietdc', 'KH03', '2020-11-21', 4800),
('HD20201121001906', 'a', 'KH01', '2020-11-21', 7200),
('HD20201121082401', 'b', 'KH03', '2020-11-21', 14000),
('HD20201123145146', 'a', 'KH02', '2020-11-23', 12800),
('HD20201123145206', 'a', 'KH04', '2020-11-23', 5600),
('HD20201124111244', 'vietdc', 'KH03', '2020-11-24', 13200),
('HD20201124111722', 'vietdc', 'KH03', '2020-11-24', 4800),
('HD20201124112050', 'a', 'KH01', '2020-11-24', 5600),
('HD20201127082926', 'vietdc', 'KH03', '2020-12-01', 15600),
('HD20201127083227', 'b', 'KH01', '2020-10-27', 8800),
('HD20201201090236', 'a', 'KH04', '2019-12-03', 5600),
('HD20201205080157', 'a', 'KH01', '2020-12-05', 10400),
('HD20201215145630', 'nguyenlt', 'KH12', '2019-11-15', 21600),
('HD20201215145722', 'b', 'KH13', '2019-10-15', 6400),
('HD20201215145813', 'a', 'KH01', '2020-09-10', 6400),
('HD20201215145827', 'b', 'KH04', '2020-08-10', 9600),
('HD20201215145842', 'vietdc', 'KH07', '2020-07-10', 2400),
('HD20201215145851', 'vietdc', 'KH08', '2020-06-10', 15600),
('HD20201215165122', 'quocnv', 'KH13', '2020-12-15', 8800),
('HD20210104090201', 'a', 'KH01', '2021-01-04', 4800);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieuxuatchitiet`
--

CREATE TABLE `phieuxuatchitiet` (
  `maphieuxuat` varchar(20) NOT NULL,
  `maxe` varchar(10) NOT NULL,
  `soluong` int DEFAULT NULL,
  `giaban` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `phieuxuatchitiet`
--

INSERT INTO `phieuxuatchitiet` (`maphieuxuat`, `maxe`, `soluong`, `giaban`) VALUES
('HD20201121000041', 'ab03', 1, 2400),
('HD20201121000041', 'husky03', 1, 2800),
('HD20201121001906', 'husky02', 1, 2800),
('HD20201121001906', 'siri02', 3, 1600),
('HD20201121082401', 'husky03', 1, 2800),
('HD20201121082401', 'husky02', 4, 2800),
('HD20201123145146', 'siri01', 4, 1600),
('HD20201123145146', 'siri01', 4, 1600),
('HD20201123145206', 'husky03', 1, 2800),
('HD20201123145206', 'husky03', 1, 2800),
('HD20201124111244', 'ab03', 1, 2400),
('HD20201124111244', 'siri01', 1, 1600),
('HD20201124111244', 'husky02', 1, 2800),
('HD20201124111244', 'siri02', 1, 1600),
('HD20201124111244', 'ab04', 2, 2400),
('HD20201124111722', 'ab03', 2, 2400),
('HD20201124112050', 'husky03', 2, 2800),
('HD20201127082926', 'ab03', 3, 2400),
('HD20201127082926', 'husky02', 3, 2800),
('HD20201127083227', 'ab03', 1, 2400),
('HD20201127083227', 'siri01', 4, 1600),
('HD20201201090236', 'ab03', 1, 2400),
('HD20201201090236', 'siri01', 2, 1600),
('HD20201205080157', 'ab03', 3, 2400),
('HD20201205080157', 'siri01', 2, 1600),
('HD20201215145630', 'ab04', 4, 2400),
('HD20201215145630', 'ex01', 3, 4000),
('HD20201215145722', 'ab04', 1, 2400),
('HD20201215145722', 'ex01', 1, 4000),
('HD20201215145813', 'ab03', 1, 2400),
('HD20201215145813', 'ex02', 1, 4000),
('HD20201215145827', 'ex01', 1, 4000),
('HD20201215145827', 'husky02', 2, 2800),
('HD20201215145842', 'ab04', 1, 2400),
('HD20201215145851', 'ab04', 4, 2400),
('HD20201215145851', 'husky03', 1, 2800),
('HD20201215145851', 'siri02', 2, 1600),
('HD20201215165122', 'siri01', 1, 1600),
('HD20201215165122', 'ab04', 3, 2400),
('HD20210104090201', 'ab04', 1, 2400),
('HD20210104090201', 'ab03', 1, 2400);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `xe`
--

CREATE TABLE `xe` (
  `maxe` varchar(10) NOT NULL,
  `tenxe` varchar(50) DEFAULT NULL,
  `mamau` varchar(10) DEFAULT NULL,
  `mahang` varchar(10) DEFAULT NULL,
  `soluong` int DEFAULT NULL,
  `gianhap` double DEFAULT NULL,
  `giaban` double DEFAULT NULL,
  `hinh` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `xe`
--

INSERT INTO `xe` (`maxe`, `tenxe`, `mamau`, `mahang`, `soluong`, `gianhap`, `giaban`, `hinh`) VALUES
('ab03', 'Air Blade', 'red', 'Honda', 18, 2000, 2400, 'Airblack.jpg'),
('ab04', 'Air Blade', 'black', 'Honda', 13, 2000, 2400, 'Airblack.jpg'),
('chó', 'chó quốc', 'black', 'SYM', 20, 2000, 3000, '3b8ad2c7b1be2caf24321c852103598a.jpg'),
('ex01', 'Exciter150', 'black', 'Yamaha', 20, 3000, 4000, 'exciter (2).jpg'),
('ex02', 'Exciter150', 'red', 'Yamaha', 35, 3000, 4000, 'exciter (2).jpg'),
('husky02', 'Husky125', 'yellow', 'SYM', 12, 2400, 2800, 'b.png'),
('husky03', 'Husky125', 'black', 'Honda', 14, 2400, 2800, 'b.png'),
('quoc', 'quoc', 'black', 'Honda', 12, 12, 23, 'Ducati.jpg'),
('siri01', 'Sirius', 'red', 'Yamaha', 6, 1200, 1600, 'Sirius.jpg'),
('siri02', 'Sirius', 'black', 'Yamaha', 12, 1200, 1600, 'Sirius.jpg');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `hangxe`
--
ALTER TABLE `hangxe`
  ADD PRIMARY KEY (`mahang`);

--
-- Chỉ mục cho bảng `khachhang`
--
ALTER TABLE `khachhang`
  ADD PRIMARY KEY (`makh`);

--
-- Chỉ mục cho bảng `mauxe`
--
ALTER TABLE `mauxe`
  ADD PRIMARY KEY (`mamau`);

--
-- Chỉ mục cho bảng `nhacc`
--
ALTER TABLE `nhacc`
  ADD PRIMARY KEY (`mancc`);

--
-- Chỉ mục cho bảng `nhanvien`
--
ALTER TABLE `nhanvien`
  ADD PRIMARY KEY (`manv`);

--
-- Chỉ mục cho bảng `phieunhap`
--
ALTER TABLE `phieunhap`
  ADD PRIMARY KEY (`maphieunhap`),
  ADD KEY `fk01_pn` (`manv`),
  ADD KEY `fk02_pn` (`mancc`);

--
-- Chỉ mục cho bảng `phieunhapchitiet`
--
ALTER TABLE `phieunhapchitiet`
  ADD PRIMARY KEY (`maphieunhap`,`maxe`),
  ADD KEY `fk02_pnct` (`maxe`);

--
-- Chỉ mục cho bảng `phieuxuat`
--
ALTER TABLE `phieuxuat`
  ADD PRIMARY KEY (`maphieuxuat`),
  ADD KEY `fk01_px` (`manv`),
  ADD KEY `fk02_px` (`makh`);

--
-- Chỉ mục cho bảng `phieuxuatchitiet`
--
ALTER TABLE `phieuxuatchitiet`
  ADD KEY `maxe` (`maxe`),
  ADD KEY `maphieuxuat` (`maphieuxuat`);

--
-- Chỉ mục cho bảng `xe`
--
ALTER TABLE `xe`
  ADD PRIMARY KEY (`maxe`),
  ADD KEY `fk01_xe` (`mamau`),
  ADD KEY `fk02_xe` (`mahang`);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `phieunhap`
--
ALTER TABLE `phieunhap`
  ADD CONSTRAINT `fk01_pn` FOREIGN KEY (`manv`) REFERENCES `nhanvien` (`manv`),
  ADD CONSTRAINT `fk02_pn` FOREIGN KEY (`mancc`) REFERENCES `nhacc` (`mancc`);

--
-- Các ràng buộc cho bảng `phieunhapchitiet`
--
ALTER TABLE `phieunhapchitiet`
  ADD CONSTRAINT `fk01_pnct` FOREIGN KEY (`maphieunhap`) REFERENCES `phieunhap` (`maphieunhap`),
  ADD CONSTRAINT `fk02_pnct` FOREIGN KEY (`maxe`) REFERENCES `xe` (`maxe`);

--
-- Các ràng buộc cho bảng `phieuxuat`
--
ALTER TABLE `phieuxuat`
  ADD CONSTRAINT `fk01_px` FOREIGN KEY (`manv`) REFERENCES `nhanvien` (`manv`),
  ADD CONSTRAINT `fk02_px` FOREIGN KEY (`makh`) REFERENCES `khachhang` (`makh`);

--
-- Các ràng buộc cho bảng `phieuxuatchitiet`
--
ALTER TABLE `phieuxuatchitiet`
  ADD CONSTRAINT `fk03_pxct` FOREIGN KEY (`maphieuxuat`) REFERENCES `phieuxuat` (`maphieuxuat`) ON DELETE CASCADE,
  ADD CONSTRAINT `phieuxuatchitiet_ibfk_1` FOREIGN KEY (`maxe`) REFERENCES `xe` (`maxe`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `xe`
--
ALTER TABLE `xe`
  ADD CONSTRAINT `fk01_xe` FOREIGN KEY (`mamau`) REFERENCES `mauxe` (`mamau`),
  ADD CONSTRAINT `fk02_xe` FOREIGN KEY (`mahang`) REFERENCES `hangxe` (`mahang`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
