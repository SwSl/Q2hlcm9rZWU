<?php
$c = array(
	'root',
	'');
$db = new PDO('mysql:host=localhost;dbname=perso', $c[0], $c[1]);
if (!isset($_SESSION["isLogged"])) {
	$user = mysql_real_escape_string(isset($_POST["user"]) ? $_POST["user"] : "");
	$pass = mysql_real_escape_string(isset($_POST["pass"]) ? $_POST["pass"] : "");
	if ($user != "" && $pass != "") {
		$db->query("SELECT 1 from users where user == '$user' and pass == '$pass'");
		if ($res->fetch())
			$_SESSION["isLogged"] = true;
	}
} else {
	// process update
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8"/>
	<title>Fake Epitech Perso Portal</title>
</head>
<body>
	<?php
	if (isset($_SESSION["isLogged"])) {
	?>
	<p>Welcome to the new private portal!</p>
	<?php
	} else {
	?>
	<form method="POST">
		<label for="user">User:</label>
		<input type="text" name="user" id="user" /><br />
		<label for="pass">Password:</label>
		<input type="password" name="pass" id="pass" /><br />
		<input type="submit" value="Log In" />
	</form>
	<?php
	}
	?>
</body>
</html>
