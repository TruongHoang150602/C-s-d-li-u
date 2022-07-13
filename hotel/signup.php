<!DOCTYPE html>
<html>
<head>
	<title>Đăng kí</title>
	<link rel="stylesheet" type="text/css" href="asset/css/dangnhap.css">
</head>
<body>
     <form action="signup-check.php" method="post">
     	<h2>Đăng kí</h2>
     	<?php if (isset($_GET['error'])) { ?>
     		<p class="error"><?php echo $_GET['error']; ?></p>
     	<?php } ?>

          <?php if (isset($_GET['success'])) { ?>
               <p class="success"><?php echo $_GET['success']; ?></p>
          <?php } ?>

          <label>Họ và tên</label>
          <?php if (isset($_GET['name'])) { ?>
               <input class="name" type="text" 
                      name="name" 
                      placeholder="Họ và tên"
                      value="<?php echo $_GET['name']; ?>"><br>
          <?php }else{ ?>
               <input  class="name" type="text" 
                      name="name" 
                      placeholder="Họ và tên"><br>
          <?php }?>
               <div class="ngaysinh" style="float: left;width: 50%;margin-left: 4px;">
               <label>Ngày sinh</label>
     	     <input type="date"  name="dob">
               </div>
               <div class="gender" style="float: right;width: 45%;line-height: 104px;padding-left: 44px;">
               <input type="radio" name="gioitinh" value="nam" class="gioitinh" >Nam
     	     <input type="radio" name="gioitinh" value="nữ" class="gioitinh">Nữ
               </div>
               <br>
     	
          <label>Tài khoản</label>
          <?php if (isset($_GET['uname'])) { ?>
               <input type="text" 
                      name="uname" 
                      placeholder="Tài khoản"
                      value="<?php echo $_GET['uname']; ?>"><br>
          <?php }else{ ?>
               <input type="text" 
                      name="uname" 
                      placeholder="Tài khoản"><br>
          <?php }?>


     	<label>Mật khẩu</label>
     	<input type="password" name="password" placeholder="Mật khẩu"><br>

          <label>Nhập lại mật khẩu</label>
          <input type="password" 
                 name="re_password" 
                 placeholder="Mật khẩu"><br>
        
                 <label>Số điện thoại</label>
          <?php if (isset($_GET['sdt'])) { ?>
               <input type="text" 
                      name="phone_number" 
                      placeholder="Số điện thoại"
                      value="<?php echo $_GET['name']; ?>"><br>
          <?php }else{ ?>
               <input type="text" 
                      name="sdt" 
                      placeholder="Số điện thoại"><br>
          <?php }?>    

     	<button type="submit">Đăng kí</button>
          <a href="index.php" class="ca">Đã có tài khoản?</a>
     </form>
</body>
</html>