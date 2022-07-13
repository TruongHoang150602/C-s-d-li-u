<!DOCTYPE html>
<html>
<head>
	<title>Đăng nhập</title>
	<link rel="stylesheet" type="text/css" href="asset/css/dangnhap.css">
</head>
<body>
     <form action="login.php" method="post">
		<div class="logo" style="text-align: center;">
		<img src="./asset/img/logo.png" alt="" style="width: 40px;">
	</div>
		
     	<h2>Đăng nhập</h2>
		<?php if (isset($_GET['success'])) { ?>
               <p class="success"><?php echo $_GET['success']; ?></p>
        <?php } ?>
     	<?php if (isset($_GET['error'])) { ?>
     		<p class="error"><?php echo $_GET['error']; ?></p>
     	<?php } ?>
     	<label>Tài khoản</label>
     	<input type="text" name="uname" placeholder="Tài khoản"><br>

     	<label>Mật khẩu</label>
     	<input type="password" name="password" placeholder="Mật khẩu"><br>

     	<button type="submit">Đăng nhập</button>
          <a href="signup.php" class="ca">Tạo tài khoản</a>
     </form>
</body>
</html>