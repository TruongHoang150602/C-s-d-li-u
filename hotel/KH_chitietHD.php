
<?php 
session_start();

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

<?php
     include '/xampp/htdocs/hotel/connect.php';
     $id=$_GET['id'];
     $result=pg_query($conn,"SELECT * FROM bill WHERE mahoadon='$id'");
     $row=pg_fetch_assoc($result);
?>
<form class="form">

<label> Mã hóa đơn : <?php echo $row['mahoadon']; ?></label><br>
        <label> Mã khách hàng : <?php echo $row['kh_id']; ?></label><br>
        <label> Họ và tên : <?php echo $row['hovaten']; ?></label><br>
        <label> Số điện thoại : <?php echo $row['sdt']; ?></label><br>
        <label> Phòng : <?php echo $row['phong_id']; ?></label><br>
        <label> Giá phòng : <?php echo $row['giaphong']." VNĐ/đêm    "; ?></label><br>
        <label> Số đêm : <?php echo $row['sodem']; ?></label><br>
        <label> Chi phí phát sinh : <?php echo $row['chiphi']. " VNĐ"; ?></label><br>
        <label> Tổng tiền:   <?php echo $row['tongtien'] . " VNĐ";; ?></label><br>
        <label> Thời gian đặt : <?php echo $row['tg_datphong']; ?></label><br>
        <label> Ngày lấy phòng : <?php echo $row['tg_layphong']; ?></label><br>

     
     <a href="./KH_trangchu.php" class="ca">
          Trở lại
     </a>
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