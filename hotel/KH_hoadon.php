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
              <ul>
                <li><img src="./asset/img/logo.png" alt="" style="width: 40px;"></li>
              </ul>
            </div>
          </div>
          <!-- End of Header Sidebar -->
          
        </div>
        <div class="header_right" style="padding-top: 22px;">
        <div class="header_links">
  

              <ul id="nav">
              <li><a href="./KH_datphong.php">Đặt phòng</a></li>
              <li><a href="./KH_donhang.php"><i class="ti-shopping-cart"></i>Đơn hàng</a></li>
              <li><a href="./KH_hoadon.php"><i class="ti-clipboard"></i> Hóa đơn</a></li>
              <li>
                <a href="./TK_chinhsuathongtin.php"><i class="ti-user"></i>
                <?php echo $_SESSION['hovaten'];; ?></a>
                <ul class="subnav">
                  <li><a href="TK_chinhsuathongtin.php">Chỉnh sửa thông tin</a></li>
                  <li><a href="TK_doimatkhau.php">Đổi mật khẩu</a></li>
                  <li><a href="logout.php">Thoát</a></li>
              </ul>
            </li>
              
            </ul>
              </div>
        </div>
      </div>
    </div>
  </header>
<body>
    <div class="table-actor">
        <?php
            $id=$_SESSION['id'];
            $sql = "SELECT hoadon.mahoadon,phong.phong_id,phong.giaphong,hoadon.tg_layphong,hoadon.sodem,hoadon.trangthai
            FROM hoadon JOIN phong ON hoadon.phong_id=phong.phong_id WHERE hoadon.kh_id='$id'";
            $result=pg_query($conn,$sql);
        ?>
    <table class="table table-bordered" style="text-align: center;">
    
    <tr id=table-title>
        <?php
            echo "<td>" . "Phòng" . "</td>";
            echo "<td>" . "Giá tiền" . "</td>";
            echo "<td>" . "Ngày đến" . "</td>";
            echo "<td>" . "Số đêm" . "</td>";
            echo "<td>" . "Trạng thái" . "</td>";
            echo "<td>" . "Xem chi tiết" . "</td>";


        ?>
    </tr>
        <?php
            while($item=pg_fetch_array($result)){?>
            <tr>
          <td> <?php echo $item['phong_id'] ?> </td>
          <td> <?php echo $item['giaphong'] ?> </td>
          <td> <?php echo $item['tg_layphong'] ?> </td>
          <td> <?php echo $item['sodem'] ?> </td>
          <td> <?php echo $item['trangthai'] ?> </td>
          <td>
                <a href="./KH_chitietHD.php?id=<?php echo $item['mahoadon'];?>">
                    <i class="ti-eye"></i>
                </a>
                </td>
        </tr>
          <?php  
        }
           
        ?>
    </table>
    </div>
  
</body>
<script src="asset/css/trangchu.js"></script>

</html>
<?php 
}else{
     header("Location: index.php");
     exit();
}
 ?>