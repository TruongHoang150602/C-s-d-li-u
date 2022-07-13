
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
<?php
    include 'connect.php';
    $sql = "SELECT *  FROM nhanvien";
    
    if(isset($_POST['chucvu']) && isset($_POST['sort']) && isset($_POST['name'])){
        function validate($data){
            $data = trim($data);
            $data = stripslashes($data);
            $data = htmlspecialchars($data);
            return $data;
        }
        $sort = validate($_POST['sort']);
        $chucvu = validate($_POST['chucvu']);
        $name = validate($_POST['name']);
        
       
        if(!empty($chucvu) && !empty($name)){
            $sql .= " WHERE chucvu='$chucvu' AND hovaten ILIKE '%$name%'";
        }
        elseif(!empty($name)){
            $sql .= " WHERE hovaten ILIKE '%$name%' ";
        }
        elseif(!empty($chucvu)){
            $sql .= " WHERE chucvu='$chucvu'";
        }
        if(!empty($sort)){
          if($sort==="1") $sql .=" ORDER BY nv_id asc ";
          else $sql .=" ORDER BY nv_id desc ";
      }

    }
    $result = pg_query($conn,$sql);
    
?>
    

    <div class="table-actor" style="width: 1000px;">
    <?php if (isset($_GET['error'])) { ?>
     		<p class="error"><?php echo $_GET['error']; ?></p>
     	<?php } ?>

          <?php if (isset($_GET['success'])) { ?>
               <p class="alert alert-success alert-dismissible fade show"><?php echo $_GET['success']; ?></p>
          <?php } ?>
    <a href="QL_NV_them.php">
    <button class="btn btn-primary" style="width: 160px;margin-bottom: 16px;">Thêm nhân viên</button>
    </a>
    <form action="QL_NV_danhsach.php" method="post" style="text-align: center; margin-bottom: 8px;">
    <select  name="sort" style="padding: 4px;">
        <option value=""> Sắp xếp </option>
        <option value="1"> Tăng dần </option>
        <option value="0"> Giảm dần </option>
    </select>
    <input type="text" name="name" placeholder=" Nhập tên tìm kiếm ">
    <select  name="chucvu" style="padding: 4px;">
        <option value=""> Chức vụ </option>
        <option value="Quản lí"> Quản lí </option>
        <option value="Lễ tân"> Lễ tân </option>
        <option value="Kế toán"> Kế toán </option>
        <option value="Nhân viên phục vụ"> Nhân viên phục vụ </option>
        <option value="Bảo vệ"> Bảo vệ </option>
    </select>
        <button type="submit" class="btn btn-primary" style="width: 80px;">Lọc</button>
    </form>

    <table class="table table-bordered">
    
    <tr id=table-title>
        <?php
            echo "<td>" . "ID" . "</td>";
            echo "<td>" . "Họ và tên" . "</td>";
            echo "<td>" . "Giới tính" . "</td>";
            echo "<td>" . "Ngày sinh" . "</td>";
            echo "<td>" . "Số điện thoại" . "</td>";
            echo "<td>" . "Chức vụ" . "</td>";
            echo "<td>" . "Chỉnh sửa" . "</td>";
            echo "<td>" . "Xóa" . "</td>";
        ?>
    </tr>
        <?php
            while($item=pg_fetch_array($result)){?>
                <tr>
                <td> <?php echo $item['nv_id'] ?> </td>
                <td> <?php echo $item['hovaten'] ?> </td>
                <td> <?php echo $item['gioitinh'] ?> </td>
                <td> <?php echo $item['ngaysinh'] ?> </td>
                <td> <?php echo $item['sdt'] ?> </td>
                <td> <?php echo $item['chucvu'] ?> </td>
                <td style="text-align: center;">

                    <a href="QL_NV_chinhsua.php?id=<?php echo $item['nv_id']; ?>"><i class="ti-pencil"></i></a>
                    </td>
                <td style="text-align: center;"><a href="QL_NV_xoa.php?id=<?php echo $item['nv_id']; ?>"><i class="ti-trash"></i></a>
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