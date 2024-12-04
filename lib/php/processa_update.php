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

// Coletar dados enviados no corpo da requisição
$dados = json_decode(file_get_contents("php://input"), true);

// Verificar se os dados necessários foram enviados
if (!isset($dados['id']) || !isset($dados['nome']) || !isset($dados['quantidade']) || !isset($dados['medida']) || !isset($dados['preco'])) {
    echo json_encode(["status" => "erro", "message" => "Dados incompletos"]);
    exit;
}

$id = intval($dados['id']);
$nome = $conn->real_escape_string($dados['nome']);
$quantidade = intval($dados['quantidade']);
$medida = $conn->real_escape_string($dados['medida']);
$preco = floatval($dados['preco']);

// Utilizando prepared statements para evitar injeção SQL
$sql = "UPDATE tbl_produto 
        SET PRO_VAR_NOME = ?, PRO_INT_QUANTIDADE = ?, PRO_VAR_MEDIDA = ?, PRO_DEC_PRECO = ? 
        WHERE PRO_INT_COD = ?";

$stmt = $conn->prepare($sql);
if ($stmt === false) {
    die(json_encode(["status" => "erro", "message" => "Erro na preparação da consulta: " . $conn->error]));
}

// Bind dos parâmetros
$stmt->bind_param("sisdi", $nome, $quantidade, $medida, $preco, $id);

// Executa a consulta
if ($stmt->execute()) {
    echo json_encode(["status" => "sucesso", "message" => "Produto atualizado com sucesso"]);
} else {
    echo json_encode(["status" => "erro", "message" => "Erro ao atualizar produto: " . $stmt->error]);
}

// Fechar a declaração e a conexão
$stmt->close();
$conn->close();
?>
