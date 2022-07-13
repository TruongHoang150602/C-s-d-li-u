<?php 
session_start(); 
include "connect.php";

if (isset($_POST['uname']) && isset($_POST['password'])) {

	function validate($data){
       $data = trim($data);
	   $data = stripslashes($data);
	   $data = htmlspecialchars($data);
	   return $data;
	}

	$uname = validate($_POST['uname']);
	$pass = validate($_POST['password']);

	if (empty($uname)) {
		header("Location: index.php?error=User Name is required");
	    exit();
	}else if(empty($pass)){
        header("Location: index.php?error=Password is required");
	    exit();
	}else{
		// hashing the password

        
		$sql = "SELECT * FROM taikhoan WHERE uname='$uname' AND pass='$pass'";

		$result = pg_query($conn, $sql);
		
		if (pg_num_rows ($result) === 1) {
			$row = pg_fetch_assoc($result);
            
            	$_SESSION['uname'] = $row['uname'];
            	$_SESSION['hovaten'] = 	$row['hovaten'];
            	$_SESSION['id'] = 		$row['id'];
				if($row['chucvu']=='Quản lí'){
					header("Location: QL_trangchu.php");
				}
				elseif($row['chucvu']=='Khách hàng'){
					header("Location: KH_trangchu.php");
				}
				elseif($row['chucvu']=='Lễ tân'){
					header("Location: LT_trangchu.php");
				}
            	
		        exit();

			
		}else{
			header("Location: index.php?error=Tài khoản hoặc mật khảu không chính xác");
	        exit();
		}
	}
	
}else{
	header("Location: index.php");
	exit();
}
