<?php 
session_start();
include "connect.php";

if (isset($_POST['uname']) && isset($_POST['password'])
    && isset($_POST['name']) && isset($_POST['re_password']) && isset($_POST['sdt']) 
	&& isset($_POST['dob']) && isset($_POST['gioitinh'])) {

	function validate($data){
       $data = trim($data);
	   $data = stripslashes($data);
	   $data = htmlspecialchars($data);
	   return $data;
	}
	$uname = validate($_POST['uname']);
	$pass = validate($_POST['password']);

	$re_pass = validate($_POST['re_password']);
	$name = validate($_POST['name']);
	$ngaysinh = validate($_POST['dob']);
    $sdt = validate($_POST['sdt']);
	$user_data = 'uname='. $uname. '&name='. $name;
	$gioitinh = $_POST['gioitinh'];

	if (empty($uname)) {
		header("Location: signup.php?error=Nhập tài khoản &$user_data");
	    exit();
	}else if(empty($pass)){
        header("Location: signup.php?error=Nhập mật khẩu&$user_data");
	    exit();
	}
	else if(empty($re_pass)){
        header("Location: signup.php?error= Nhập lại mật khẩu &$user_data");
	    exit();
	}

	else if(empty($name)){
        header("Location: signup.php?error=Nhập họ và tên &$user_data");
	    exit();
	}
    else if(empty($sdt)){
        header("Location: signup.php?error= Nhập số điện thoại &$user_data");
	    exit();
	}
	else if(empty($ngaysinh)){
        header("Location: signup.php?error= Nhập ngày sinh &$user_data");
	    exit();
	}
	else if(empty($gioitinh)){
        header("Location: signup.php?error=Nhập giới tính &$user_data");
	    exit();
	}
	else if($pass !== $re_pass){
        header("Location: signup.php?error= Nhập lại mật khẩu không chính xác &$user_data");
	    exit();
	}

	else{

		// hashing the password

	    $sql1 = "SELECT * FROM taikhoan WHERE uname='$uname'";
		$result1 = pg_query($conn, $sql1);
		$sql2 = "SELECT * FROM taikhoan WHERE sdt='$sdt'";
		$result2 = pg_query($conn, $sql2);
		if (pg_num_rows($result1) > 0) {
			header("Location: signup.php?error=Tài khoản đã tồn tại!&$user_data");
	        exit();
		}elseif(pg_num_rows($result2) > 0){
			header("Location: signup.php?error=Số điện thoại đã được sử dụng!&$user_data");
	        exit();
		}
		else {
           $sql3 = "INSERT INTO taikhoan(hovaten,gioitinh,ngaysinh, uname, pass,sdt) VALUES('$name','$gioitinh','$ngaysinh', '$uname','$pass', $sdt )";
           $result3 = pg_query($conn, $sql3);
           if ($result3) {
           	 header("Location: index.php?success=Tạo tài khoản thành công");
	         exit();
           }else {
	           	header("Location: signup.php?error= Lỗi đăng kí &$user_data");
		        exit();
           }
		}
	}
	
}else{
	header("Location: signup.php");
	exit();
}