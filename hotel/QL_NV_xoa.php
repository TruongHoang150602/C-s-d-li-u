<?php
     include '/xampp/htdocs/hotel/connect.php';
     $id=$_GET['id'];
     pg_query($conn,"DELETE FROM nhanvien WHERE nv_id='$id'");
     header("Location: QL_NV_danhsach.php")
?>