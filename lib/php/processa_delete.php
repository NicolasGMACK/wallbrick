<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

$host = "localhost";
$usuario = "root";
$senha = "";
$banco = "wallbrick";

// Criar conexão com o banco
$conn = new mysqli($host, $usuario, $senha, $banco);

// Verificar conexão
if ($conn->connect_error) {
    echo json_encode(["status" => "erro", "message" => "Erro ao se conectar ao banco: " . $conn->connect_error]);
    exit;
}

// Receber dados da requisição (JSON)
$data = json_decode(file_get_contents("php://input"), true);

// Validar entrada
if (!isset($data['codigo']) || !is_numeric($data['codigo'])) {
    echo json_encode(["status" => "erro", "message" => "Código inválido ou ausente"]);
    exit;
}

$codigoProduto = (int) $data['codigo']; // Garantir que seja tratado como inteiro

// Preparar a query para exclusão
$sql = "DELETE FROM tbl_produto WHERE PRO_INT_COD = ?";

if ($stmt = $conn->prepare($sql)) {
    $stmt->bind_param("i", $codigoProduto); // 'i' para integer
    if ($stmt->execute()) {
        echo json_encode(["status" => "sucesso", "message" => "Produto excluído com sucesso"]);
    } else {
        echo json_encode(["status" => "erro", "message" => "Erro ao excluir o produto: " . $stmt->error]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "erro", "message" => "Erro na preparação da query: " . $conn->error]);
}

$conn->close();
?>
