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
<?php

    $query = "SELECT * from bill Order by trangthai asc";
    $result = pg_query($conn,$query);
    
    if (!$result) {
        echo "An error occurred.\n";
        exit;
    }

    echo "<br>";
    echo "<table class='table'>
    <thead class='thead-dark'>
    <tr>
    <th scope='col'>Mã hóa đơn</th>
    <th scope='col'>ID khách hàng</th>
    <th scope='col'>Tên khách hàng</th>
    <th scope='col'>Số điện thoại</th>
    <th scope='col'>Tên phòng</th>
    <th scope='col'>Thời gian lấy phòng</th>
    <th scope='col'>Số đêm ở</th>
    <th scope='col'>Tổng thanh toán</th>
    <th scope='col'>Trạng thái</th>
    <th scope='col'>Thời gian giao dich</th>

    <th scope='col'>Xuất hóa đơn</th>
    </tr>";
    echo "</thead>";
    while($row = pg_fetch_assoc($result)){
        $kh_id = $row['kh_id'];
        echo "<tr>";
          echo "<td align='left' width='200'>" . $row['mahoadon'] . "</td>";
          echo "<td align='left' width='200'>" . $row['kh_id'] . "</td>";
          echo "<td align='left' width='200'>" . $row['hovaten'] . "</td>";
          echo "<td align='left' width='200'>" . $row['sdt'] . "</td>";
          echo "<td align='left' width='200'>" . $row['phong_id'] . "</td>";
          echo "<td align='left' width='200'>" . $row['tg_layphong'] . "</td>";
          echo "<td align='left' width='200'>" . $row['sodem'] . "</td>";
          echo "<td align='left' width='200'>" . $row['tongtien'] . "</td>";
          echo "<td align='left' width='200'>" . $row['trangthai'] . "</td>";
          echo "<td align='left' width='200'>" . $row['tg_giaodich'] . "</td>";
          ?>
          <td style="align-items: left;" width=200><button type='button' class='btn btn-success'><a style='color: white' style='text-decoration:none' target='_blank' href='LT_inhoadon.php?mahoadon=<?php echo $row['mahoadon'];?>'> In Hoa Don</a></button></td>
         <?php 
        echo "</tr>";
    }
    echo "</table>";
?>

</body>
<script src="asset/css/trangchu.js"></script>

</html>
<?php 
}else{
     header("Location: index.php");
     exit();
}
 ?>