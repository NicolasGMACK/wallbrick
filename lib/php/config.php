<?php
// Defina os parâmetros do seu banco de dados
$servername = "localhost"; // ou o IP do servidor
$username = "root"; // seu usuário do banco de dados
$password = ""; // senha do banco de dados
$dbname = "wallbrick"; // nome do banco de dados

// Cria a conexão
$conn = new mysqli($servername, $username, $password, $dbname);

// Verifica se a conexão falhou
if ($conn->connect_error) {
    die("Conexão falhou: " . $conn->connect_error);
}
?>
