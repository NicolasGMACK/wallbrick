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
    if (empty($_POST['email']) || empty($_POST['senha'])) {
        echo json_encode(["status" => "erro", "message" => "Por favor, preencha todos os campos."]);
        exit;
    }

    // Receber os dados do formulário
    $email = $_POST['email'];
    $senha = $_POST['senha'];

    // Consultar o banco de dados
    $stmt = $conn->prepare("SELECT CLI_VAR_SENHA FROM tbl_cliente WHERE CLI_VAR_EMAIL = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($hashSenha);
        $stmt->fetch();

        // Verificar a senha
        if (password_verify($senha, $hashSenha)) {
            echo json_encode(["status" => "sucesso", "message" => "Login realizado com sucesso!"]);
        } else {
            echo json_encode(["status" => "erro", "message" => "Senha incorreta."]);
        }
    } else {
        echo json_encode(["status" => "erro", "message" => "Usuário não encontrado."]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "erro", "message" => "Método não permitido."]);
}

// Fechar conexão com o banco
$conn->close();
?>
