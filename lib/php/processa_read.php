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

// Consulta para buscar os produtos
$sql = "SELECT
            p.PRO_INT_COD,
            p.PRO_VAR_NOME, 
            p.PRO_INT_QUANTIDADE, 
            p.PRO_VAR_MEDIDA, 
            p.PRO_DEC_PRECO, 
            f.FBR_VAR_NOME
        FROM 
            tbl_produto p
        LEFT JOIN 
            tbl_fabricante f 
        ON 
            p.FBR_VAR_CNPJ = f.FBR_VAR_CNPJ";

$result = $conn->query($sql);

// Verifica se há registros
if ($result->num_rows > 0) {
    $usuarios = [];
    while ($row = $result->fetch_assoc()) {
        $usuarios[] = $row; // Adiciona cada registro ao array
    }

    // Retorna os dados em formato JSON
    echo json_encode(["status" => "sucesso", "data" => $usuarios]);
} else {
    echo json_encode(["status" => "sucesso", "data" => [], "message" => "Nenhum produto encontrado."]);
}

// Fechar conexão
$conn->close();
?>
