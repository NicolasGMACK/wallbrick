<?php
header('Content-Type: application/json');

// Permitir requisições de qualquer origem
header('Access-Control-Allow-Origin: *');  // Permite todas as origens
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');  // Métodos permitidos
header('Access-Control-Allow-Headers: Content-Type, Authorization');  // Cabeçalhos permitidos

// Verifica se a requisição é POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['nome']) && isset($_POST['email']) && isset($_POST['senha'])) {
        // Recebe os dados
        $nome = $_POST['nome'];
        $email = $_POST['email'];
        $senha = password_hash($_POST['senha'], PASSWORD_DEFAULT);

        // Conecta ao banco
        $conn = new mysqli('localhost', 'root', '', 'wallbrick');
        if ($conn->connect_error) {
            die(json_encode(["status" => "erro", "message" => "Falha na conexão: " . $conn->connect_error]));
        }

        // Insere dados
        $stmt = $conn->prepare("INSERT INTO tbl_usuario (USU_VAR_NOME, USU_VAR_NIVEL, USU_VAR_SENHA) VALUES (?, ?, ?)");
        $stmt->bind_param("sss", $nome, $email, $senha);

        if ($stmt->execute()) {
            echo json_encode(["status" => "sucesso", "message" => "Cadastro realizado com sucesso!"]);
        } else {
            echo json_encode(["status" => "erro", "message" => "Erro: " . $stmt->error]);
        }

        // Fecha conexão
        $stmt->close();
        $conn->close();
    } else {
        echo json_encode(["status" => "erro", "message" => "Dados incompletos."]);
    }
} else {
    echo json_encode(["status" => "erro", "message" => "Método não permitido."]);
}
?>
