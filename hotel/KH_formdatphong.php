<?php
include './connect.php';
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
     <h2>Đặt phòng</h2>
     <?php if (isset($_GET['error'])) { ?>
     		<p class="error"><?php echo $_GET['error']; ?></p>
     	<?php } ?>

          <?php if (isset($_GET['success'])) { ?>
               <p class="success"><?php echo $_GET['success']; ?></p>
          <?php } ?>
     <label>Ngày lấy phòng : </label><input type="date" name="date"><br/>
     <label>Số đêm : </label><input type="text" value="" name="night"><br/>
     

     <button type="submit" name="update"> Đặt phòng </button>
     <a href="KH_datphong.php" class="ca">Trở lại?</a>
<?php
if (isset($_POST['update'])){
     $date=$_POST['date'];
     $night=$_POST['night'];
     $id=$_GET['id'];
     $phong_id=$_GET['phong_id'];
// Create connection

// Check connection

$sql = "INSERT INTO hoadon(kh_id,phong_id,tg_layphong,sodem) VALUES ('$id','$phong_id','$date','$night');";
if(pg_query($conn,$sql)==true){
     header("Location: KH_datphong.php?success=Đặt phòng thành công");
     exit();
}else{
     header("Location: KH_formdatphong.php?error= Thất bại ");
     exit();
}


}
?>
</form>
</body>
<script src="asset/css/trangchu.js"></script>

</html>