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
                <li><a href="QL_trangchu.php"><i class="ti-home"></i> Trang chủ</a></li>
                <li><a href="QL_NV_danhsach.php"><i class="ti-user"></i> Quản lí nhân sự</a></li>
                <li><a href="QL_thongke.php"><i class="ti-bar-chart"></i> Thống kê</a></li>
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
  

    <div class="table-actor">
        <canvas id="myChart2"></canvas>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
      const doanhthu=[];
      <?php
        $sql="SELECT * FROM thongke_doanhthu ORDER BY thang asc ";
        $result = pg_query($conn,$sql);
        while($item=pg_fetch_array($result)){?>
          doanhthu.push("<?php echo $item['doanhthu'];?>"); 
        <?php  } 
      ?>
  const labels = [
    'April',
    'May',
    'June',
    'Jule',
  ];

  const data = {
    labels: labels,
    datasets: [{
      label: 'Doanh thu quý',
      backgroundColor: 'rgb(255, 99, 132)',
      borderColor: 'rgb(255, 99, 132)',
      data: doanhthu
    }]
  };

  const config = {
    type: 'line',
    data: data,
    options: {}
  };
</script>
<script>
  const myChart = new Chart(
    document.getElementById('myChart2'),
    config
  );
</script>



</body>

<script src="asset/css/trangchu.js"></script>

</html>
<?php 
}else{
     header("Location: index.php");
     exit();
}
 ?>