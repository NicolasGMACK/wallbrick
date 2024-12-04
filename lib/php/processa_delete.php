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

// Verificar se o código do produto foi enviado corretamente
if (!isset($data['codigo']) || empty($data['codigo']) || !is_numeric($data['codigo'])) {
    echo json_encode(["status" => "erro", "message" => "Código do produto é obrigatório e deve ser um número."]);
    exit;
}

// Sanitizar o código do produto
$codigo = (int) $data['codigo']; // Garantindo que o valor seja um inteiro

// Deletar o produto do banco
$sql = "DELETE FROM tbl_produto WHERE PRO_INT_COD = $codigo";

if ($conn->query($sql) === TRUE) {
    if ($conn->affected_rows > 0) {
        echo json_encode(["status" => "sucesso", "message" => "Produto deletado com sucesso."]);
    } else {
        echo json_encode(["status" => "erro", "message" => "Nenhum produto encontrado com o código informado."]);
    }
} else {
    echo json_encode(["status" => "erro", "message" => "Erro ao deletar o produto: " . $conn->error]);
}

// Fechar conexão
$conn->close();
?>
