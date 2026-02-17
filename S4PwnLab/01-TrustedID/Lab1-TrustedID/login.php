<?php
session_start();
require "db.php";
$message='';
if($_SERVER['REQUEST_METHOD']==='POST'){
    $u=$_POST['username']??''; $p=$_POST['password']??'';
    $stmt=$conn->prepare("SELECT id FROM users WHERE username=? AND password=?");
    $stmt->bind_param("ss",$u,$p);
    $stmt->execute();
    $res=$stmt->get_result();
    if($res->num_rows>0){
        $_SESSION['user_id']=$res->fetch_assoc()['id'];
        header("Location: vuln.php"); exit;
    } else { $message="Invalid credentials"; }
    $stmt->close();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login</title>
<style>
body{font-family:Segoe UI,Tahoma,sans-serif;background:#e0e8f0;display:flex;justify-content:center;align-items:center;height:100vh;margin:0;}
.card{background:#fff;width:420px;padding:30px;border-radius:12px;box-shadow:0 8px 20px rgba(0,0,0,0.05);}
h2{text-align:center;margin-bottom:25px;color:#2c3e50;font-weight:600;}
input{width:100%;padding:12px;margin:8px 0;border:1px solid #ccc;border-radius:6px;background:#f9f9f9;font-size:14px;box-sizing:border-box;}
button{width:100%;padding:12px;margin-top:8px;background:#2f6fed;color:#fff;border:none;border-radius:6px;font-weight:600;cursor:pointer;font-size:14px;box-sizing:border-box;}
button:hover{background:#2555b4;}
.message{color:#c0392b;text-align:center;margin-top:10px;font-size:14px;}
.info{font-size:14px;text-align:center;color:#34495e;margin-top:10px;}
</style>
</head>
<body>
<div class="card">
<h2>Login</h2>
<form method="POST">
<input type="text" name="username" placeholder="Username" required>
<input type="password" name="password" placeholder="Password" required>
<button type="submit">Login</button>
<?php if($message): ?><div class="message"><?php echo $message; ?></div><?php endif; ?>
<div class="info">Test Credentials:<br>Username: test | Password: test</div>
</form>
</div>
</body>
</html>
