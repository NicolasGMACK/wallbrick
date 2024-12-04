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

// Verificar se todos os campos necessários estão presentes
if (!isset($data['nome'], $data['quantidade'], $data['medida'], $data['preco'], $data['cnpj_fornecedor'])) {
    echo json_encode(["status" => "erro", "message" => "Campos obrigatórios ausentes."]);
    exit;
}

// Sanitizar os dados recebidos
$nome = $conn->real_escape_string($data['nome']);
$quantidade = (int)$data['quantidade'];
$medida = $conn->real_escape_string($data['medida']);
$preco = (float)$data['preco'];
$cnpj_fornecedor = $conn->real_escape_string($data['cnpj_fornecedor']);

// Verificar se o fornecedor existe
$fornecedorQuery = "SELECT FBR_VAR_CNPJ FROM tbl_fabricante WHERE FBR_VAR_CNPJ = '$cnpj_fornecedor'";
$fornecedorResult = $conn->query($fornecedorQuery);

if ($fornecedorResult->num_rows === 0) {
    echo json_encode(["status" => "erro", "message" => "Fornecedor com o CNPJ $cnpj_fornecedor não encontrado."]);
    exit;
}

// Inserir os dados no banco
$sql = "INSERT INTO tbl_produto (PRO_VAR_NOME, PRO_INT_QUANTIDADE, PRO_VAR_MEDIDA, PRO_DEC_PRECO, FBR_VAR_CNPJ) 
        VALUES ('$nome', $quantidade, '$medida', $preco, '$cnpj_fornecedor')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "sucesso", "message" => "Produto cadastrado com sucesso."]);
} else {
    echo json_encode(["status" => "erro", "message" => "Erro ao cadastrar o produto: " . $conn->error]);
}

// Fechar conexão
$conn->close();
?>
