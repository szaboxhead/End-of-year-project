<?php
session_start();
require 'db.php';
$errors = [];

if (isset($_GET['token'])) {
    $token = $_GET['token'];

    // Ellenőrizd, hogy a token létezik-e
    $pdo = db();
    $stmt = $pdo->prepare("SELECT * FROM players_pyr WHERE reset_token = :token");
    $stmt->execute(['token' => $token]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $password = $_POST['password'] ?? '';
            $password2 = $_POST['password2'] ?? '';
            
            // Jelszó érvényesítés
            if (strlen($password) < 8 || strlen($password) > 255) {
                $errors[] = "The length of the password must be between 8 and 255 characters.";
            } elseif (!preg_match('/[A-Z]/', $password)) {
                $errors[] = "The password must contain at least 1 uppercase letter.";
            } elseif (!preg_match('/[a-z]/', $password)) {
                $errors[] = "The password must contain at least 1 lowercase letter.";
            } elseif (!preg_match('/[0-9]/', $password)) {
                $errors[] = "The password must contain at least 1 number.";
            } elseif (!preg_match('/[^\w\s]/', $password)) {
                $errors[] = "The password must contain at least 1 special character.";
            } 
            // Ellenőrizd, hogy a két jelszó megegyezik
            elseif ($password === $password2) {
                //$errors[] = "Both passwords need to be the same!";
                // Hasheljük a jelszót
                $hashedPassword = password_hash($password, PASSWORD_BCRYPT);
    
                // Frissítsük a jelszót az adatbázisban
                $stmt = $pdo->prepare("UPDATE players_pyr SET password = :password, reset_token = NULL WHERE reset_token = :token");
                $stmt->execute(['password' => $hashedPassword, 'token' => $token]);
    
                echo "<div style='color: green; position:fixed; border: 1px solid green; border-radius: 5px; margin-top: -25em; font-weight: bold; background-color: #fff; width:35%; text-align:center'><div class='closebtn' onclick='removeAlert(this)';'>&times;</div>Your password has been successfully reset.</div>";
            } else {
                $errors[] = "Passwords do not match.";
            }
        }
    } else {
        $errors[] = "Invalid token.";
    }
}    
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DELVE-PCG Password Reset</title>
    <link rel="stylesheet" href="./css/password_reset.css">
    <link rel="shortcut icon" href="./img/favico2.png" type="image/png">
    <script async src="./js/script_registration.js"></script>
</head>
<body>
<div id="logo">
    <img src="./img/DELVE-PCG_logo2.png" alt="DELVE_PCG_logo" >
</div>
<div>
<h2 style="text-align: center">Enter your new password</h2>
<form method="post" action="reset_password.php?token=<?php echo $_GET['token']; ?>">

    <div class="input-field">
        <input type="password" name="password" id="password" required>
        <label for="password">New Password:</label>
        </div>
    <div>
    <label class="container" >
        <input type="checkbox" checked id="password1check">
      <svg class="eye" xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 576 512"><path d="M288 32c-80.8 0-145.5 36.8-192.6 80.6C48.6 156 17.3 208 2.5 243.7c-3.3 7.9-3.3 16.7 0 24.6C17.3 304 48.6 356 95.4 399.4C142.5 443.2 207.2 480 288 480s145.5-36.8 192.6-80.6c46.8-43.5 78.1-95.4 93-131.1c3.3-7.9 3.3-16.7 0-24.6c-14.9-35.7-46.2-87.7-93-131.1C433.5 68.8 368.8 32 288 32zM144 256a144 144 0 1 1 288 0 144 144 0 1 1 -288 0zm144-64c0 35.3-28.7 64-64 64c-7.1 0-13.9-1.2-20.3-3.3c-5.5-1.8-11.9 1.6-11.7 7.4c.3 6.9 1.3 13.8 3.2 20.7c13.7 51.2 66.4 81.6 117.6 67.9s81.6-66.4 67.9-117.6c-11.1-41.5-47.8-69.4-88.6-71.1c-5.8-.2-9.2 6.1-7.4 11.7c2.1 6.4 3.3 13.2 3.3 20.3z"></path></svg>
      <svg class="eye-slash" xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 640 512"><path d="M38.8 5.1C28.4-3.1 13.3-1.2 5.1 9.2S-1.2 34.7 9.2 42.9l592 464c10.4 8.2 25.5 6.3 33.7-4.1s6.3-25.5-4.1-33.7L525.6 386.7c39.6-40.6 66.4-86.1 79.9-118.4c3.3-7.9 3.3-16.7 0-24.6c-14.9-35.7-46.2-87.7-93-131.1C465.5 68.8 400.8 32 320 32c-68.2 0-125 26.3-169.3 60.8L38.8 5.1zM223.1 149.5C248.6 126.2 282.7 112 320 112c79.5 0 144 64.5 144 144c0 24.9-6.3 48.3-17.4 68.7L408 294.5c8.4-19.3 10.6-41.4 4.8-63.3c-11.1-41.5-47.8-69.4-88.6-71.1c-5.8-.2-9.2 6.1-7.4 11.7c2.1 6.4 3.3 13.2 3.3 20.3c0 10.2-2.4 19.8-6.6 28.3l-90.3-70.8zM373 389.9c-16.4 6.5-34.3 10.1-53 10.1c-79.5 0-144-64.5-144-144c0-6.9 .5-13.6 1.4-20.2L83.1 161.5C60.3 191.2 44 220.8 34.5 243.7c-3.3 7.9-3.3 16.7 0 24.6c14.9 35.7 46.2 87.7 93 131.1C174.5 443.2 239.2 480 320 480c47.8 0 89.9-12.9 126.2-32.5L373 389.9z"></path></svg>
      </label>  
    </div>
    <div class="input-field">
        <input type="password" name="password2" id="password2" required>
        <label for="password2">Password Again:</label>
      </div>
    <div>
        <label class="container">
        <input type="checkbox" checked id="password2check"> 
      <svg class="eye" xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 576 512"><path d="M288 32c-80.8 0-145.5 36.8-192.6 80.6C48.6 156 17.3 208 2.5 243.7c-3.3 7.9-3.3 16.7 0 24.6C17.3 304 48.6 356 95.4 399.4C142.5 443.2 207.2 480 288 480s145.5-36.8 192.6-80.6c46.8-43.5 78.1-95.4 93-131.1c3.3-7.9 3.3-16.7 0-24.6c-14.9-35.7-46.2-87.7-93-131.1C433.5 68.8 368.8 32 288 32zM144 256a144 144 0 1 1 288 0 144 144 0 1 1 -288 0zm144-64c0 35.3-28.7 64-64 64c-7.1 0-13.9-1.2-20.3-3.3c-5.5-1.8-11.9 1.6-11.7 7.4c.3 6.9 1.3 13.8 3.2 20.7c13.7 51.2 66.4 81.6 117.6 67.9s81.6-66.4 67.9-117.6c-11.1-41.5-47.8-69.4-88.6-71.1c-5.8-.2-9.2 6.1-7.4 11.7c2.1 6.4 3.3 13.2 3.3 20.3z"></path></svg>
      <svg class="eye-slash" xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 640 512"><path d="M38.8 5.1C28.4-3.1 13.3-1.2 5.1 9.2S-1.2 34.7 9.2 42.9l592 464c10.4 8.2 25.5 6.3 33.7-4.1s6.3-25.5-4.1-33.7L525.6 386.7c39.6-40.6 66.4-86.1 79.9-118.4c3.3-7.9 3.3-16.7 0-24.6c-14.9-35.7-46.2-87.7-93-131.1C465.5 68.8 400.8 32 320 32c-68.2 0-125 26.3-169.3 60.8L38.8 5.1zM223.1 149.5C248.6 126.2 282.7 112 320 112c79.5 0 144 64.5 144 144c0 24.9-6.3 48.3-17.4 68.7L408 294.5c8.4-19.3 10.6-41.4 4.8-63.3c-11.1-41.5-47.8-69.4-88.6-71.1c-5.8-.2-9.2 6.1-7.4 11.7c2.1 6.4 3.3 13.2 3.3 20.3c0 10.2-2.4 19.8-6.6 28.3l-90.3-70.8zM373 389.9c-16.4 6.5-34.3 10.1-53 10.1c-79.5 0-144-64.5-144-144c0-6.9 .5-13.6 1.4-20.2L83.1 161.5C60.3 191.2 44 220.8 34.5 243.7c-3.3 7.9-3.3 16.7 0 24.6c14.9 35.7 46.2 87.7 93 131.1C174.5 443.2 239.2 480 320 480c47.8 0 89.9-12.9 126.2-32.5L373 389.9z"></path></svg>
      </label>
        </div>
        <button type="submit">Submit new password</button>   

</form>


<?php
    if (!empty($errors)) {
        foreach ($errors as $error) {
            echo "<div class='alert alert-error' style='color: red'><div class='closebtn' onclick='removeAlert(this)';'>
            &times;</div>$error</div>";}
        }
      // Hibaüzenetek megjelenítése
?>
</div>

</body>
</html>