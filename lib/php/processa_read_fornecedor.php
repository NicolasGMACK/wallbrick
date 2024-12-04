<?php
header('Content-Type: application/json');

// Permitir requisições de qualquer origem
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
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

// Consulta para buscar os fornecedores
$sql = "SELECT FBR_VAR_CNPJ, FBR_VAR_NOME, FBR_VAR_FONE FROM tbl_fabricante";
$result = $conn->query($sql);

// Verifica se há registros
if ($result->num_rows > 0) {
    $fornecedores = [];
    while ($row = $result->fetch_assoc()) {
        $fornecedores[] = $row; // Adiciona cada registro ao array
    }

    // Retorna os dados em formato JSON
    echo json_encode(["status" => "sucesso", "data" => $fornecedores]);
} else {
    echo json_encode(["status" => "sucesso", "data" => [], "message" => "Nenhum fornecedor encontrado."]);
}

// Fechar conexão
$conn->close();
?>
