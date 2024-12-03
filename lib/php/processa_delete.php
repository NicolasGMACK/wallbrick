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
if (!isset($_POST['id']) || empty($_POST['id'])) {
    echo json_encode(["status" => "erro", "message" => "ID do produto é obrigatório."]);
    exit;
}

// Sanitizar e obter o ID do produto
$id = (int) $_POST['id'];

// Deletar o produto do banco
$sql = "DELETE FROM tbl_produto WHERE PRO_INT_COD = $id";

if ($conn->query($sql) === TRUE) {
    if ($conn->affected_rows > 0) {
        echo json_encode(["status" => "sucesso", "message" => "Produto deletado com sucesso."]);
    } else {
        echo json_encode(["status" => "erro", "message" => "Nenhum produto encontrado com o ID informado."]);
    }
} else {
    echo json_encode(["status" => "erro", "message" => "Erro ao deletar o produto: " . $conn->error]);
}

// Fechar conexão
$conn->close();
?>
