<?php
// Include database connection
include 'db_connect.php';

// Retrieve form data
$payment_status = $_POST['payment_status'];

// Insert into database
$sql = "INSERT INTO patreg (/* other columns */, payment_status) VALUES (/* other values */, '$payment_status')";
mysqli_query($conn, $sql);
?>