CREATE OR REPLACE FUNCTION insert_nhan_vien() RETURNS character AS 
$$
	DECLARE repeatNV varchar(6);
	DECLARE maNV varchar(6);
BEGIN
	IF ((SELECT COUNT(nv_id) FROM nhanvien) = 0)
    THEN
        maNV='1';
	ELSE
        maNV = cast(cast((SELECT MAX(RIGHT(nhanvien.nv_id, 6)) FROM nhanvien) as integer)+1 as varchar);
    END IF;
	    repeatNV = (SELECT REPEAT('0', 6- length(maNV)));
        RETURN CONCAT('NV',repeatNV,maNV);
END;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION insert_khach_hang() RETURNS character AS 
$$
	
	DECLARE repeatKH varchar(6);
	DECLARE maKH varchar(6);
  
BEGIN
	IF ((SELECT COUNT(kh_id) FROM khachhang) =0 )
    THEN
        maKH='1';
	ELSE
       maKH = cast(cast((SELECT MAX(RIGHT(khachhang.kh_id, 6)) FROM khachhang) as integer)+1 as varchar);
    END IF;
	    repeatKH = (SELECT REPEAT('0', 6- length(maKH)));
        RETURN CONCAT('KH',repeatKH,maKH);
END;

$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION insert_hoa_don() RETURNS character AS 
$$
	DECLARE repeatHD varchar(6);
	DECLARE maHD varchar(6);
BEGIN
IF ((SELECT COUNT(mahoadon) FROM hoadon) = 0)
    THEN
        maHD = '1';
    ELSE
        maHD = cast(cast((SELECT MAX(RIGHT(hoadon.mahoadon, 6)) FROM hoadon) as integer)+1 as varchar);
    END IF;
        repeatHD = (SELECT REPEAT('0', 6-character_length(maHD)));
        RETURN CONCAT('HD',repeatHd,maHD);
END;
$$ LANGUAGE plpgsql ;

CREATE TABLE hoadon
(
    mahoadon character(8) NOT NULL DEFAULT insert_hoa_don(),
    kh_id character(8)  NOT NULL DEFAULT insert_khach_hang(),
    phong_id character varying(5) COLLATE pg_catalog."default" NOT NULL,
    TG_datphong date DEFAULT CURRENT_TIMESTAMP,
    TG_layphong date NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sodem int NOT NULL,
    chiphi double precision DEFAULT 0,
    TG_giaodich date ,
    trangthai character varying(100) COLLATE pg_catalog."default" DEFAULT 'Chưa thanh toán'::character varying, 
    hinhthucthanhtoan character varying(100) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    note text COLLATE pg_catalog."default",
    CONSTRAINT hd_pk PRIMARY KEY (mahoadon),
    CONSTRAINT hd_chk_tt CHECK (trangthai='Chưa thanh toán' OR trangthai='Đã thanh toán' OR trangthai='Đã hủy')	,
    CONSTRAINT hd_chk_sd CHECK (sodem>0 AND sodem<30)

);


CREATE TABLE khachhang
(
    kh_id character(8)  NOT NULL DEFAULT insert_khach_hang(),
    hovaten character varying(30) COLLATE pg_catalog."default" NOT NULL,
	gioitinh character varying(5) COLLATE pg_catalog."default" NOT NULL,
	ngaysinh date DEFAULT CURRENT_TIMESTAMP, 
    sdt character varying(15) NOT NULL,
    CONSTRAINT kh_pk PRIMARY KEY (kh_id),
    CONSTRAINT kh_chk_gioitinh CHECK (gioitinh::text = 'nam'::text OR gioitinh::text = 'nữ'::text)	
);

CREATE TABLE nhanvien
(
    nv_id character(8) NOT NULL DEFAULT insert_nhan_vien() UNIQUE,
    hovaten character varying(30) COLLATE pg_catalog."default" NOT NULL,
    gioitinh character varying(5) COLLATE pg_catalog."default" NOT NULL,
    ngaysinh date DEFAULT CURRENT_TIMESTAMP, 
    sdt character varying(15) COLLATE pg_catalog."default" NOT NULL,
    chucvu character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT nv_pk PRIMARY KEY (nv_id),
    CONSTRAINT nv_chk_gioitinh CHECK (gioitinh::text = 'nam'::text OR gioitinh::text = 'nữ'::text)
);

CREATE TABLE phong
(
    phong_id character varying(5) COLLATE pg_catalog."default" NOT NULL UNIQUE,
    trangthai character varying(10) COLLATE pg_catalog."default" DEFAULT 'Trống'::character varying,
    giaphong double precision NOT NULL,
    loaiphong character varying(10) COLLATE pg_catalog."default" NOT NULL,
    dientich double precision NOT NULL,
    tiennghi text COLLATE pg_catalog."default",
    CONSTRAINT p_pk PRIMARY KEY (phong_id)
);

CREATE TABLE taikhoan
(
    id character(8) NOT NULL DEFAULT insert_khach_hang(),
    chucvu character varying(100) NOT NULL DEFAULT 'Khách hàng',
    hovaten character varying(30) COLLATE pg_catalog."default" NOT NULL,
    gioitinh character varying(5) COLLATE pg_catalog."default" NOT NULL,
	ngaysinh date DEFAULT CURRENT_TIMESTAMP, 
    uname character varying(30) COLLATE pg_catalog."default" NOT NULL UNIQUE,
    pass character varying(30) COLLATE pg_catalog."default" NOT NULL DEFAULT '123456'::character varying,
    sdt character varying(15) NOT NULL UNIQUE,
    CONSTRAINT tk_pk PRIMARY KEY (id,uname),
    CONSTRAINT tk_chk_chucvu CHECK (chucvu::text = 'Quản lí'::text OR chucvu::text = 'Lễ tân'::text OR chucvu::text = 'Khách hàng'::text OR chucvu::text = 'Kế toán'::text),
    CONSTRAINT tk_chk_age CHECK (( DATE_PART('year', CURRENT_DATE) - DATE_PART('year', ngaysinh)) >18)
);

CREATE OR REPLACE FUNCTION khach_dat_phong() RETURNS trigger AS 
$$
	BEGIN
 	UPDATE phong SET trangthai = 'Bận'
 	WHERE phong.phong_id=NEW.phong_id;
       
    RETURN NEW;
END;
$$ LANGUAGE plpgsql ;



CREATE OR REPLACE FUNCTION khach_tra_phong() RETURNS trigger AS 
$$
BEGIN
    UPDATE phong SET trangthai = 'Trống'
 	WHERE phong.phong_id=OLD.phong_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION khach_tao_tk() RETURNS trigger AS 
$$
	
BEGIN
       
    INSERT INTO khachhang(kh_id, hovaten, gioitinh,ngaysinh, sdt) 
    VALUES(NEW.id,NEW.hovaten,NEW.gioitinh,NEW.ngaysinh,NEW.sdt);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION khach_update_tk() RETURNS trigger AS 
$$
	
BEGIN
       
    UPDATE khachhang
    SET hovaten=NEW.hovaten,ngaysinh=NEW.ngaysinh,gioitinh=NEW.gioitinh,sdt=NEW.sdt
    WHERE kh_id=NEW.id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER datphong
    AFTER INSERT
    ON public.hoadon
    FOR EACH ROW
    WHEN (NEW.trangthai='Chưa thanh toán')
    EXECUTE FUNCTION khach_dat_phong();

CREATE OR REPLACE TRIGGER  huyphong
    AFTER UPDATE ON hoadon
    FOR EACH ROW
    WHEN (NEW.trangthai='Đã hủy' OR NEW.trangthai='Đã thanh toán')
    EXECUTE FUNCTION khach_tra_phong();

CREATE TRIGGER kh_tao_tk
    AFTER INSERT
    ON taikhoan
	FOR EACH ROW
    WHEN (NEW.id LIKE 'KH%')
    EXECUTE FUNCTION khach_tao_tk();

CREATE OR REPLACE FUNCTION xoa_tai_khoan() RETURNS trigger AS 
$$
BEGIN
    DELETE FROM taikhoan WHERE
    taikhoan.id=OLD.nv_id ;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql ;

CREATE TRIGGER updateTK
    BEFORE UPDATE
    ON nhanvien
	FOR EACH ROW
    WHEN (OLD.chucvu='Lễ Tân' OR OLD.chucvu='Quản lí')
    EXECUTE FUNCTION xoa_tai_khoan();
	
CREATE TRIGGER xoaTK
    BEFORE DELETE
    ON nhanvien
	FOR EACH ROW
    WHEN (OLD.chucvu='Lễ Tân' OR OLD.chucvu='Quản lí')
    EXECUTE FUNCTION xoa_tai_khoan();

CREATE TRIGGER updateTK
    AFTER UPDATE
    ON taikhoan
	FOR EACH ROW
    EXECUTE FUNCTION khach_update_tk();

CREATE VIEW thongke_nv AS
 SELECT nhanvien.chucvu,
    count(nhanvien.chucvu) AS soluong
   FROM nhanvien
  GROUP BY nhanvien.chucvu;

CREATE OR REPLACE VIEW bill AS
SELECT hoadon.mahoadon,
    khachhang.kh_id,
    khachhang.hovaten,
    khachhang.sdt,
    hoadon.phong_id,
    phong.giaphong,
    hoadon.sodem,
    hoadon.TG_datphong,
    hoadon.TG_layphong,
    hoadon.chiphi,
    phong.giaphong * hoadon.sodem + hoadon.chiphi AS "tongtien",
    hoadon.trangthai,
    hoadon.tg_giaodich
   FROM khachhang
     JOIN hoadon ON khachhang.kh_id = hoadon.kh_id
     JOIN phong ON hoadon.phong_id = phong.phong_id
     ORDER BY hoadon.mahoadon ASC;

create or replace view thongke_doanhthu as
SELECT sum(tongtien) as doanhthu ,extract(month from tg_giaodich) as thang
from bill
group by extract(month from tg_giaodich)

INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('101', 'Dùng' ,700000, 'Thường,Đơn', 15, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('102', 'Trống' ,700000, 'Thường,Đơn', 15, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('103', 'Dùng' ,700000, 'Thường,Đơn', 15, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('104', 'Trống' ,1200000, 'Thường,Đôi', 24, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('105', 'Dùng' ,1200000, 'Thường,Đôi', 24, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('201', 'Dùng' ,700000, 'Thường,Đơn', 15, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('202', 'Dùng' ,700000, 'Thường,Đơn', 15, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('203', 'Trống' ,1200000, 'Thường,Đôi', 24, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('204', 'Trống' ,1200000, 'Thường,Đôi', 24, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('205', 'Dùng' ,1200000, 'Thường,Đôi', 24, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('301', 'Dùng' ,1000000, 'VIP,Đơn', 20, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('302', 'Trống' ,1000000, 'VIP,Đơn', 20, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('303', 'Trống' ,1500000, 'VIP,Đôi', 30, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('304', 'Dùng' ,1500000, 'VIP,Đôi', 30, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('305', 'Trống' ,1500000, 'VIP,Đôi', 30, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('401', 'Dùng' ,1000000, 'VIP,Đơn', 20, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('402', 'Dùng' ,1000000, 'VIP,Đơn', 20, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('403', 'Trống' ,1500000, 'VIP,Đôi', 30, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('404', 'Dùng' ,1500000, 'VIP,Đôi', 30, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');
INSERT INTO phong(phong_id, trangthai, giaphong, loaiphong, dientich, tiennghi) VALUES ('405', 'Trống' ,1500000, 'VIP,Đôi', 30, 'Điều hòa,phòng vệ sinh riêng,wifi,nước uống,tủ lạnh,tivi,đồ ăn nhẹ');


INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Nguyễn Trọng Anh' ,'nam', '1987-03-18','0394080250', 'Quản lí');
INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Nguyễn Sỹ Bảo' ,'nam', '1995-04-13','0394080270', 'Kế toán');
INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Nguyễn Văn Đức' ,'nam', '1997-05-15','0395080270', 'Lễ tân');
INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Bùi Thị Thu Huyền' ,'nữ', '1999-03-12','0394080280', 'Lễ tân');
INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Hoàng Thị Linh' ,'nữ' , '1997-03-20','0394080290', 'Nhân viên phục vụ');
INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Nguyễn Thị Quỳnh Như' ,'nữ', '1997-02-18','0394040270', 'Nhân viên phục vụ');
INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Nguyễn Thị Trang' ,'nữ', '1994-05-18','0394030270', 'Nhân viên phục vụ');
INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Nguyễn Thị Thủy' ,'nữ', '1994-10-24','0394083270', 'Nhân viên phục vụ');
INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Nguyễn Thị Tuyết' ,'nữ', '1993-08-28','0394010270', 'Nhân viên phục vụ');
INSERT INTO nhanvien(hovaten, gioitinh, ngaysinh, sdt, chucvu) VALUES ('Nguyễn Trong Vinh' ,'nam', '1988-09-18','0397080270', 'Bảo vệ');



INSERT INTO taikhoan(id, chucvu, hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('NV000001', 'Quản lí', 'Nguyễn Trọng Anh' ,'nam', '1987-03-18','0394080250', 'nguyentronganh', '3865ggr');
INSERT INTO taikhoan(id, chucvu, hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('NV000003', 'Lễ tân', 'Nguyễn Văn Đức' ,'nam', '1997-05-15','0395080270', 'nguyenvaduc', '7shsh');
INSERT INTO taikhoan(id, chucvu, hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('NV000004', 'Lễ tân', 'Bùi Thị Thu Huyền' ,'nữ', '1999-03-12','0394080280', 'buithithuhuyen', 'yr746384');

INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Hoàng Anh' ,'nam', '1987-03-18','03940802501','lehoang','yuer68635');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Hoàng Anh' ,'nam', '1987-03-18','03940802520','hooanganh','yew874');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Trọng Anh' ,'nam', '1987-03-11','03940802503','tronganh','gidf7');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Thị Huế Anh' ,'nữ', '1987-03-28','03940802504','hueanh','kwhw233');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Sỹ Bảo' ,'nam', '1984-03-18','03940802507','sybao','h47hr');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Văn Bảo' ,'nam', '1997-03-18','03940802509','vanbao','uh6882g');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Trọng Bảo' ,'nam', '1977-03-18','0394080240','trongbao','iewi65');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Kim Cả' ,'nam', '1987-04-18','03940802530','kimca','oie7648');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Duy Chiến ' ,'nam', '1977-03-18','03940840250','duychien','ue7953');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Trọng Chiến' ,'nam', '1988-03-18','03940580250','trongchien','hei75h');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Trọng Duy' ,'nam', '1995-03-13','0394080302','trongduy','kjsrhf83');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Trọng Duy' ,'nam', '1995-04-13','0394040300','nguyentrongduy','dsir79o3');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Hoàng Văn Duy' ,'nam', '1995-03-18','0394080370','hoangvanduy','hhrwe8i3');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Cao Tuấn Dũng ' ,'nam', '1993-03-13','039408000','tuandung','khsr743');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Tiễn Dũng' ,'nam', '1995-03-18','0394280300','tiendung','uaei64');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Dung' ,'nữ', '1985-03-13','039470304','thidung','hds74q');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Thùy Dung' ,'nữ', '1985-03-18','03970300','thuydung','jaso8');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Kiều Dung' ,'nữ', '1985-04-13','037470300', 'kieudung','feret3');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Thị Dung' ,'nữ', '1985-03-13','039470300', 'nguyenthidung','kjs77h');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Cao Thị Hằng' ,'nữ', '1985-03-18','039470700', 'caothihang','kdsjkl89w');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Cao Thị Thu Hằng' ,'nữ', '1985-07-13','0398470800', 'caothithuhang','jks792');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Hằng' ,'nữ', '1985-03-18','0394708003', 'lethihang','liwe74w3');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Thu Hằng' ,'nữ', '1985-03-13','0394702800', 'lethithuhang','js7o9');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Thị Hằng' ,'nữ', '1987-03-14','0394708400', 'nguyenthihang','lpose743');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Thị Thu Hằng' ,'nữ', '1985-03-15','039570800', 'nguyenthithuhang','ljdx7');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Hiền' ,'nữ', '1985-03-17','039470830', 'lethihien',';lew805');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Thu Hiền' ,'nữ', '1985-03-19','0394570800', 'lethithuhien','kle7ew4');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Thị Hiền' ,'nữ', '1985-03-21','0394770800', 'nguyenthihien','estte45');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Huyền' ,'nữ', '1985-03-28','039470812', 'lethihuyen','srs5e43');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Thu Huyền' ,'nữ', '1985-03-13','0394340800', 'lethithuhuyen','awk645');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Thị Thu Huyền' ,'nữ', '1985-03-15','0394778800', 'thuhuyen','kzslu343');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Thị Huyền' ,'nữ', '1985-03-18','039470900', 'nguyenthihuyen','ksea732');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Thị Thu Huyền' ,'nữ', '1985-03-13','039470870', 'nguyeenthithuhuyen','i7ws4');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Văn Thị Hiền' ,'nữ', '1985-03-13','0394701230', 'vanthihien','kuis623');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Hoàng Thị Linh' ,'nữ', '1983-09-13','039472370', 'hoangthilinhlinh','ia6423');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Hoàng Thị Thùy Linh' ,'nữ', '1983-09-18','0345470370', 'hoangthithuylinh','si7ww23');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn  Thị Linh' ,'nữ', '1983-09-12','0394703470', 'nguyenthilinh','sil7675w');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Hoàng Thị Thùy Linh' ,'nữ', '1983-09-11','039890370', 'hoangthithuylin','sio6r');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Đình Mạnh' ,'nam', '1991-05-10','0394701124', 'ledinhmanh','is6w55');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Đình Mạnh' ,'nam', '1991-05-11','0394771121', 'nguyendinhmanh','jka7535');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn  Hữu Mạnh' ,'nam', '1991-05-12','0394781121', 'nguyenhuumanh','ls75w');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Sỹ Mạnh' ,'nam', '1991-05-15','0394701921', 'nguyensymanh','os857');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Trần Hữu Mạnh' ,'nam', '1991-04-10','0394701341', 'tranhuumanh','ilwew8');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Văn Nam' ,'nam', '1998-04-14','03943912321', 'levannam','ajkwre');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Sỹ Nam' ,'nam', '1998-03-10','0394451121', 'Nguyensynam','lsl7w6');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn Văn Nam' ,'nam', '1998-01-10','0394791121', 'Nguyenvannam','dfx7');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Hoàng Văn Nho' ,'nam', '1998-02-10','0394397821', 'hoangvawnnho','dtee46');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Nguyễn  Văn Nho' ,'nam', '1998-07-10','0394341121', 'nguyenvannho','et4578');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Lê Đình Phúc' ,'nam', '1997-04-18','0395391541', 'ledinhphuc','dys5e47');
INSERT INTO taikhoan(hovaten, gioitinh, ngaysinh, sdt, uname, pass) VALUES ('Trần Văn Phúc' ,'nam', '1997-04-20','0395391421', 'tranvanphuc','dt5d76');

INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000001', '101', '2022-04-03','2022-04-10', '2022-04-15', 5, 150000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000002', '102', '2022-04-10','2022-04-17', '2022-04-21', 4, 70000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000003', '103', '2022-04-13','2022-04-13', '2022-04-18', 5, 15000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000004', '104', '2022-04-03','2022-04-10', '2022-04-15', 7, 200000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000005', '105', '2022-04-05','2022-04-12', '2022-04-20', 8, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000006', '201', '2022-04-03','2022-04-10', '2022-04-15', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000007', '202', '2022-04-10','2022-04-17', '2022-04-21', 4, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000008', '203', '2022-04-13','2022-04-13', '2022-04-18', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000009', '204', '2022-04-03','2022-04-10', '2022-04-15', 7, 45000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000010', '205', '2022-04-05','2022-04-12', '2022-04-20', 8, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000011', '301', '2022-04-03','2022-04-10', '2022-04-15', 5, 47000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000012', '302', '2022-04-17','2022-04-17', '2022-04-21', 4, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000013', '303', '2022-04-13','2022-04-13', '2022-04-18', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000014', '304', '2022-04-10','2022-04-10', '2022-04-15', 7, 23000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000015', '305', '2022-04-12','2022-04-12', '2022-04-20', 8, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000016', '401', '2022-04-10','2022-04-10', '2022-04-15', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000017', '402', '2022-04-17','2022-04-17', '2022-04-21', 4, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000018', '403', '2022-04-13','2022-04-13', '2022-04-18', 5, 12000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000019', '404', '2022-04-10','2022-04-10', '2022-04-15', 7, 89000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000020', '405', '2022-04-12','2022-04-12', '2022-04-20', 8, 0, 'Đã thanh toán', 'Tiền mặt', NULL) ;
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000021', '101', '2022-05-10','2022-05-10', '2022-05-15', 5, 78000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000022', '102', '2022-05-17','2022-05-17', '2022-05-21', 4, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000023', '103', '2022-05-13','2022-05-13', '2022-05-18', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000024', '104', '2022-05-10','2022-05-10', '2022-05-15', 7, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000025', '105', '2022-05-12','2022-05-12', '2022-05-20', 8, 14000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000026', '201', '2022-05-10','2022-05-10', '2022-05-15', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000027', '202', '2022-05-17','2022-05-17', '2022-05-21', 4, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000028', '203', '2022-05-13','2022-05-13', '2022-05-18', 5, 54000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000029', '204', '2022-05-10','2022-05-10', '2022-05-15', 7, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000030', '205', '2022-05-12','2022-05-12', '2022-05-20', 8, 23000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000031', '301', '2022-05-03','2022-05-10', '2022-05-15', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000032', '302', '2022-05-17','2022-05-17', '2022-05-21', 4, 42000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000035', '303', '2022-05-13','2022-05-13', '2022-05-18', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000036', '304', '2022-05-10','2022-05-10', '2022-05-15', 7, 23000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000037', '305', '2022-05-05','2022-05-12', '2022-05-20', 8, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000038', '401', '2022-05-10','2022-05-10', '2022-05-15', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000039', '402', '2022-05-17','2022-05-17', '2022-05-21', 4, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000040', '403', '2022-05-13','2022-05-13', '2022-05-18', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000041', '404', '2022-05-10','2022-05-10', '2022-05-15', 7, 70000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000042', '405', '2022-05-12','2022-05-12', '2022-05-20', 8, 0, 'Đã thanh toán', 'Tiền mặt', NULL) ;
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000043', '101', '2022-06-10','2022-06-10', '2022-06-15', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000044', '102', '2022-06-17','2022-06-17', '2022-06-21', 4, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000045', '103', '2022-06-13','2022-06-13', '2022-06-18', 5, 45000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000046', '104', '2022-06-10','2022-06-10', '2022-06-15', 7, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000047', '105', '2022-06-12','2022-06-12', '2022-06-20', 8, 12000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000047', '201', '2022-06-10','2022-06-10', '2022-06-15', 5, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000049', '202', '2022-06-10','2022-06-17', '2022-06-21', 4, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000050', '203', '2022-06-13','2022-06-13', '2022-06-18', 5, 30000, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000024', '204', '2022-06-03','2022-06-10', '2022-06-15', 7, 0, 'Đã thanh toán', 'Tiền mặt', NULL);
INSERT INTO hoadon(kh_id, phong_id, TG_datphong, TG_layphong, TG_giaodich, sodem, chiphi, trangthai,  hinhthucthanhtoan, note) VALUES ('KH000016', '205', '2022-06-12','2022-06-12', '2022-06-20', 8, 15000, 'Đã thanh toán', 'Tiền mặt', NULL);
