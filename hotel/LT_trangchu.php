<?php 
session_start();
include './connect.php';
if (isset($_SESSION['id']) && isset($_SESSION['hovaten'])) {

 ?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Document</title>
  <link rel="stylesheet" href="asset/css/trangchu.css" />
  <link rel="stylesheet" href="asset/css/themify-icons/themify-icons.css" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  
</head>
<header>
    <div class="header_flex">
      <div class="header_item">
        <div class="header_left">

          
          <!-- Header Sidebar -->
          <div class="header_sidebar">
            <div class="header_close">
            </div>
            <div class="header_links">
              
              <ul id="nav">
                <li><img src="./asset/img/logo.png" alt="" style="width: 40px;"></li>
                <li><a href="LT_trangchu.php"><i class="ti-home"></i> Trang chủ</a></li>
                <li><a href="LT_QL_phong.php"> Quản lí phòng</a></li>
                <li><a href="./LT_QL_hoadon.php"> Quản lí hóa đơn</a></li>
              </ul>
            </div>
          </div>
          <!-- End of Header Sidebar -->
          
        </div>
        <div class="header_right">
          <ul id="nav">
            <li>
          <i class="ti-user"></i>
          <?php echo " ". $_SESSION['hovaten'];; ?>
            <ul class="subnav">
                        <li><a href="TK_chinhsuathongtin.php"> Chỉnh sửa thông tin</a></li>
                        <li><a href="TK_doimatkhau.php">Đổi mật khẩu</a></li>
                        <li><a href="logout.php">Thoát</a></li>
                    </ul>
              </li>
            </ul>
        </div>
      </div>
    </div>
  </header>
<body>
<img  src="./asset/img/1246280_16061017110043391702.jpg" alt="" style="width:100%;">

</body>
<script src="asset/css/trangchu.js"></script>

</html>
<?php 
}else{
     header("Location: index.php");
     exit();
}
 ?>