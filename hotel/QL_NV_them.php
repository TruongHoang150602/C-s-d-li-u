
<?php 
session_start();
include '/xampp/htdocs/hotel/connect.php';
     if (isset($_SESSION['id']) && isset($_SESSION['hovaten'])) {

 ?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Document</title>
  <link rel="stylesheet" href="asset/css/dangnhap.css" />
  <link rel="stylesheet" href="asset/css/themify-icons/themify-icons.css" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  

<body>


<form method="POST" class="form">
     <h2>Sửa thành viên</h2>
     <?php if (isset($_GET['error'])) { ?>
     		<p class="error"><?php echo $_GET['error']; ?></p>
     	<?php } ?>

          <?php if (isset($_GET['success'])) { ?>
               <p class="success"><?php echo $_GET['success']; ?></p>
          <?php } ?>
     <label> Họ và tên : <input type="text" value="" name="name"></label><br/>
     <label> Giới tính : <input type="text" value="" name="gender"></label><br/>
     <label> Ngày sinh : <input type="text" value="" name="dob"></label><br/>
     <label> Số điện thoại : <input type="text" value="" name="sdt"></label><br/>
     <label> Chức vụ : <input type="text" value="" name="chucvu"></label><br/>

     <button type="submit" name="update">Xác nhận</button>
     <a href="QL_NV_danhsach.php" class="ca">Trở lại?</a>
<?php
if (isset($_POST['update'])){
     $name=$_POST['name'];
     $gender=$_POST['gender'];
     $dob=$_POST['dob'];
     $sdt=$_POST['sdt'];
     $chucvu=$_POST['chucvu'];
// Create connection

// Check connection

$sql = "INSERT INTO nhanvien(hovaten,gioitinh,ngaysinh,sdt,chucvu) VALUES ('$name','$gender','$dob','$sdt','$chucvu');";
if(pg_query($conn,$sql)==true){
     header("Location: QL_NV_danhsach.php?success=Thêm thành công");
     exit();
}else{
     header("Location: QL_NV_them.php?error=Thêm thất bại");
     exit();
}


}
?>
</form>
</body>
<script src="asset/css/trangchu.js"></script>

</html>
<?php 
}else{
     header("Location: index.php");
     exit();
}
 ?>