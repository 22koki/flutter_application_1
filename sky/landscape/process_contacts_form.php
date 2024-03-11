<?php

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $name = htmlspecialchars($_POST["name"]);
    $email = htmlspecialchars($_POST["email"]);
    $message = htmlspecialchars($_POST["message"]);

    // You can perform additional validation or processing here

    // Example: Send an email (adjust as needed)
    $to = "wahomeimani@gmail.com";  // Replace with your email address
    $subject = "New Contact Form Submission";
    $headers = "From: $email";

    $mailBody = "Name: $name\n";
    $mailBody .= "Email: $email\n";
    $mailBody .= "Message:\n$message";

    mail($to, $subject, $mailBody, $headers);

    // Redirect back to the contact page
    header("Location: contact.html");  // Replace with your contact page URL
    exit();
}

// If the form wasn't submitted through POST, redirect to the form page
header("Location: contact.html");  // Replace with your contact page URL
exit();
?>
