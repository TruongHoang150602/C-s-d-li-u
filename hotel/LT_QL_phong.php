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
<script>
    const dat_p = document.getElementById(datphong);
    dat_p.addEventListener("click",myFunction());
    function myFunction() {
        window.open('print_bill.php','_blank');
    }
</script>

    <div class="table-actor" style="width: 1000px;">
<?php 
    $query = "select * from phong order by phong_id";
    $result = pg_query($conn,$query);
    if(!$result){
        echo "An error occurred.\n";
        exit;
    }
echo "<div padding-top: 20px>";
    echo "<table class='table'>";
    echo "<thead class='thead-dark'>";
    echo "<tr>
        <th scope='col'>Số phòng</th>
        <th scope='col'>Giá phòng</th>
        <th scope='col'>Loại phòng</th>
        <th scope='col'>Diện tích</th>
        <th scope='col'>Tiện nghi</th>
        <th scope='col'>Trạng thái</th>
        <th scope='col'>Thao tác</th>
        </tr>";
    echo "</thead>";
    while($row = pg_fetch_assoc($result)){
        echo "<tr>";
          echo "<td align='left' width='200'>" . $row['phong_id'] . "</td>";
          echo "<td align='left' width='200'>" . $row['giaphong'] ." VNĐ". "</td>";
          echo "<td align='left' width='200'>" . $row['loaiphong'] . "</td>";
          echo "<td align='left' width='200'>" . $row['dientich'] ." m2". "</td>";
          echo "<td align='left' width='200'>" . $row['tiennghi'] . "</td>";
          echo "<td align='left' width='200'>" . $row['trangthai'] . "</td>";
          if($row['trangthai'] == 'Trống'){
        ?>
          <td style="align='center' width='200'"><a href="LT_datphong.php?phongid=<?php echo $row['phong_id']; ?>"><button type="button" class="btn btn-success">Đặt phòng</button></a></td>
        <?php
          }
          else{
        ?>
          <td style="align='center' width='200'"><a href="LT_xemphong.php?phongid=<?php echo $row['phong_id']; ?>"><button type="button" class="btn btn-success">Xem phòng</button></a></td>
            <?php
          }
          echo "</tr>";
    }
    echo "</table>";
echo "</div>";
?>
</div>
</body>


</html>
<?php 
}else{
     header("Location: index.php");
     exit();
}
 ?>