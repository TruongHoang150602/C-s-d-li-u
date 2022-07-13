<?php 
session_start();
include './connect.php';
if (isset($_SESSION['id']) && isset($_SESSION['hovaten'])) {
  $id=$_SESSION['id'];
?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Document</title>
  <link rel="stylesheet" href="asset/css/trangchu.css" />
  <link rel="stylesheet" href="asset/css/datphong.css" />
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
    
    <div class="table-actor" style="width: 800px;">
    <?php if (isset($_GET['error'])) { ?>
     		<p class="error"><?php echo $_GET['error']; ?></p>
     	<?php } ?>

          <?php if (isset($_GET['success'])) { ?>
               <p class="alert alert-success"><?php echo $_GET['success']; ?></p>
          <?php } ?>
    
                      <?php
                         $sql="SELECT * FROM phong WHERE trangthai='Trống' ORDER BY phong_id asc";
                         $result = pg_query($conn,$sql);
                         if(pg_num_rows($result) == 0){
                            echo 'Hiện không có phòng trống!';
                         }
                         else{
                         $i=0;
                      
                         while($item=pg_fetch_array($result)){
                                if($i%3==0){ ?>
                                     <div class="places-list row">
                                    <?php  }
                          ?>
                            <div class="col col-third">
                                <img src="./asset/img/234762091.jpg" alt="" class="place-img">
                                <div class="place-body">
                                    <h3 class="place-heading"><?php echo $item['phong_id']; ?></h3>
                                    <p class="place-time"><?php echo $item['giaphong']; ?> VNĐ/đêm</p>
                                    <p class="place-desc">Loại phòng: <?php echo $item['loaiphong']; ?></p>
                                    <p class="place-desc" style="min-height: 64px;">Mô tả: <?php echo $item['tiennghi']; ?></p>
                                    <a href="./KH_formdatphong.php?id=<?php echo $id; ?>&phong_id=<?php echo $item['phong_id']; ?>">
                                    <button class="place-buy-btn">Đặt ngay</button>
                                    </a>
                                    
                                </div>
                            </div>
                            <?php      
                            if($i%3==2){ ?>
                                     </div>
                                    <?php  }
                                    $i++;
                         }
                         if($i%3!=0){ ?>
                          </div>
                         <?php  }
                        }
                        ?>

                         
                        
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