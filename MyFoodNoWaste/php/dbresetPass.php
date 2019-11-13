<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

function randomPassword($chars){
    $random = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*_';
    return substr(str_shuffle($random),0,15);
}

$tempass = randomPassword();
$tempassha = sha1($tempass);

$sql = "UPDATE user SET PASSWORD='$tempassha' WHERE EMAIL = '$email'";

$sqls = "SELECT * FROM user WHERE EMAIL = '$email' AND VERIFT = '1'";
$result = $conn->query($sqls);

if ($conn -> query($sql)==TRUE && $result->num_rows >0){
    sendEmail($email,$tempass);
    echo "The password had been sent to your mail. Please check your mail.";
}else{
    echo "Email doesn't exist";
}

function sendEmail($userEmail, $tpw){
    $to         = $userEmail;
    $subject    = 'Reset Password for My Food Never Waste';
    $message    = 'Your temporary password is: '.$tpw;
    $headers    = 'From: noreply@myFoodNeverWaste.com.my' . "\r\n".
    'Reply-To: '.$userEmail . "r\n\" .
    'X-Mailer: PHP/' . phpversion();
    mail($to, $subject, $message, $headers);
}
?>




