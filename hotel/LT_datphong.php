<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./asset/css/dangnhap.css">
    <title>Nhân viên đặt</title>
</head>
<style>
input[type=submit] {
  width: 100%;
  background-color: #4CAF50;
  color: white;
  padding: 14px 20px;
  margin: 8px 0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
input[type=radio] {
    height: 1em;
    width: 1em;
}
</style>
<body>

<div>
<h2 style="margin-bottom:0ch;" align="center">Đặt phòng</h2>
  <?php 
    include './connect.php';
    $phong=$_GET['phongid'];
  ?>
  <form method="post">
    
    <label for="phong"><h3 style="font-weight:bolder" >Phòng: <?php echo $phong ?></h3></label><br>

    <!-- <label for="name">Phòng</label>
    <input type="text" id="room" name="room" value="<?php echo $phong ?>" disabled="disabled"> -->

    <label for="name">Họ và tên</label>
    <input type="text" id="name" name="name" placeholder="Tên khách hàng...">

    <div class="ngaysinh" style="float: left;width: 50%;margin-left: 4px;">
        <label>Ngày sinh</label>
        <input type="date"  name="dob">
    </div>
    <div class="gender" style="float: right;width: 45%;line-height: 104px;padding-left: 44px;">
        <input type="radio" name="gender" value="nam" class="gioitinh" >Nam
     	<input type="radio" name="gender" value="nữ" class="gioitinh">Nữ
    </div>
    <br>
    <label for="phone">Số điện thoại</label>
    <input type="text" id="phone" name="phone">
    <label for="night">Số đêm</label>
    <input type="text" id="night" name="night">

    <input type="submit" name="submit" value="Submit">
    <a href="./LT_QL_phong.php">Trở lại</a>
  </form>
</div>
<?php 
if (isset($_POST['submit'])){

    $name = $_POST['name'];
    $dob = $_POST['dob'];
    $phone = $_POST['phone'];
    $night = $_POST['night'];
    $gender = $_POST['gender'];
    
    $sql="INSERT INTO hoadon(phong_id,sodem) VALUES ('$phong','$night')";
    pg_query($conn,$sql);
    $sql="INSERT INTO khachhang(hovaten,gioitinh,ngaysinh,sdt) VALUES ('$name','$gender','$dob','$phone')";
    pg_query($conn,$sql);


}
?>
</body>
</html>