<?php
header('Content-Type: application/json');

// Permitir requisições de qualquer origem
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Configurações do banco de dados
$host = "localhost";
$usuario = "root";
$senha = "";
$banco = "wallbrick";

// Criar conexão com o banco
$conn = new mysqli($host, $usuario, $senha, $banco);

// Verificar conexão
if ($conn->connect_error) {
    die(json_encode(["status" => "erro", "message" => "Erro ao se conectar ao banco: " . $conn->connect_error]));
}

// Verificar se a requisição é do tipo POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Verificar se os campos necessários foram enviados
    if (empty($_POST['nome']) || empty($_POST['email']) || empty($_POST['senha'])) {
        echo json_encode(["status" => "erro", "message" => "Por favor, preencha todos os campos."]);
        exit;
    }

    // Receber os dados do formulário
    $nome = $_POST['nome'];
    $email = $_POST['email'];
    $senha = password_hash($_POST['senha'], PASSWORD_DEFAULT); // Hash da senha

    // Preparar e executar a inserção no banco de dados
    $stmt = $conn->prepare("INSERT INTO tbl_usuario (USU_VAR_NOME, USU_VAR_EMAIL, USU_VAR_SENHA) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $nome, $email, $senha);

    if ($stmt->execute()) {
        echo json_encode(["status" => "sucesso", "message" => "Cadastro realizado com sucesso!"]);
    } else {
        echo json_encode(["status" => "erro", "message" => "Erro ao salvar no banco: " . $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "erro", "message" => "Método não permitido."]);
}

// Fechar conexão com o banco
$conn->close();
?>
