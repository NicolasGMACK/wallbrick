<?php
header('Content-Type: application/json');

// Permitir requisições de qualquer origem
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
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

// Verificar se os dados foram enviados corretamente
$input = file_get_contents("php://input");
$data = json_decode($input, true);

if (json_last_error() !== JSON_ERROR_NONE) {
    echo json_encode(["status" => "erro", "message" => "Erro no formato do JSON: " . json_last_error_msg()]);
    exit;
}

// Sanitizar os dados recebidos
$cnpj = $conn->real_escape_string($data['cnpj']);
$nome = $conn->real_escape_string($data['nome']);
$telefone = $conn->real_escape_string($data['telefone']);

// Inserir os dados no banco
$sql = "INSERT INTO tbl_fabricante (FBR_VAR_CNPJ, FBR_VAR_NOME, FBR_VAR_FONE) 
        VALUES ('$cnpj', '$nome', '$telefone')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "sucesso", "message" => "Fornecedor cadastrado com sucesso."]);
} else {
    echo json_encode(["status" => "erro", "message" => "Erro ao cadastrar o fornecedor: " . $conn->error]);
}

// Fechar conexão
$conn->close();
?>
