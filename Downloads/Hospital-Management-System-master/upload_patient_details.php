<?php
// Include database connection
include 'db_connect.php';

// Retrieve form data
$lab_results = $_POST['lab_results'];
$xray_results = $_POST['xray_results'];
$diagnosis = $_POST['diagnosis'];
$prescription = $_POST['prescription'];
$xray_image = $_FILES['xray_image']['name'];

// Handle file upload
$target_dir = "uploads/";
$target_file = $target_dir . basename($_FILES["xray_image"]["name"]);
move_uploaded_file($_FILES["xray_image"]["tmp_name"], $target_file);

// Insert into database
$sql = "UPDATE patreg SET lab_results='$lab_results', xray_results='$xray_results', diagnosis='$diagnosis', prescription='$prescription', xray_image='$xray_image' WHERE pid=$patient_id";
mysqli_query($conn, $sql);
?>
