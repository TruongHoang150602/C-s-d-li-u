<?php
   
	// make a database connection
    $host        = "host = localhost";
    $port        = "port = 5432";
    $dbname      = "dbname = hotel";
    $credentials = "user = ad_hotel password=123456";

    $conn = pg_connect( "$host $port $dbname $credentials"  );
    
?>