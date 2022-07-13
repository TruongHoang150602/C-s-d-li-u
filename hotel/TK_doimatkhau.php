
<?php 
session_start();
include './connect.php';
if (isset($_SESSION['id']) && isset($_SESSION['hovaten'])) {
    $id=$_SESSION['id']
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
     <h2>Đổi mật khẩu</h2>
     <?php if (isset($_GET['error'])) { ?>
     		<p class="error"><?php echo $_GET['error']; ?></p>
     	<?php } ?>

          <?php if (isset($_GET['success'])) { ?>
               <p class="success"><?php echo $_GET['success']; ?></p>
          <?php } ?>
     <label> Mật khẩu cũ : <input type="password" value="" name="pass"></label><br/>
     <label> Mật khẩu mới : <input type="password" value="" name="new_pass"></label><br/>
     <label> Nhập lại mật khẩu : <input type="password" value="" name="re_pass"></label><br/>
    

     <button type="submit" name="update">Xác nhận</button>
     <?php
        $result=pg_query($conn,"SELECT * FROM taikhoan WHERE id='$id'");
        $row=pg_fetch_assoc($result);
          if($row['chucvu']=='KHách hàng'){?>
               <a href="./KH_trangchu.php">Trở lại</a>
          <?php
          }else{?>
               <a href="./QL_trangchu.php">Trở lại</a>
          <?php
          }
     ?>
<?php
if (isset($_POST['update'])){

     $pass=$_POST['pass'];
     $new_pass=$_POST['new_pass'];
     $re_pass=$_POST['re_pass'];
  
     $result=pg_query($conn,"SELECT * FROM taikhoan WHERE id='$id' AND pass='$pass'");
    if(pg_num_rows($result)==0) {
        header("Location: TK_doimatkhau.php?error=Mật khẩu không chính xác");
        exit();
    }
    if($re_pass!=$new_pass) {
        header("Location: TK_doimatkhau.php?error=NHập lại mật khẩu mới không chính xác");
        exit();
    }

    $sql="UPDATE takhoan SET pass='$new_pass' WHERE id='$id'";
    pg_query($conn,$sql);
    header("Location: TK_doimatkhau.php?success=Đổi mật khẩu thành công ");
    $conn=NULL;


}
?>
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