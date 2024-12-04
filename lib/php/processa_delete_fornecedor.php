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

// Receber o corpo da requisição (JSON)
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// Verificar se o CNPJ foi enviado corretamente
if (!isset($data['cnpj']) || empty($data['cnpj'])) {
    echo json_encode(["status" => "erro", "message" => "CNPJ do fornecedor é obrigatório."]);
    exit;
}

// Sanitizar o CNPJ
$cnpj = $conn->real_escape_string($data['cnpj']);

// Deletar o fornecedor do banco
$sql = "DELETE FROM tbl_fabricante WHERE FBR_VAR_CNPJ = '$cnpj'";

if ($conn->query($sql) === TRUE) {
    if ($conn->affected_rows > 0) {
        echo json_encode(["status" => "sucesso", "message" => "Fornecedor deletado com sucesso."]);
    } else {
        echo json_encode(["status" => "erro", "message" => "Nenhum fornecedor encontrado com o CNPJ informado."]);
    }
} else {
    echo json_encode(["status" => "erro", "message" => "Erro ao deletar o fornecedor: " . $conn->error]);
}

// Fechar conexão
$conn->close();
?>
