<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];

$sql = "UPDATE user SET VERIFY = '1' WHERE EMAIL = '$email'";
if ($conn->query($sql) === TRUE) {
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>