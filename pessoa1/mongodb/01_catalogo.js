
// ==========================================
// MARKETPLACE
// REQUISITO R2 - MONGODB
// ==========================================

db = db.getSiblingDB("marketplace");

// Criar coleção caso não exista
if (!db.getCollectionNames().includes("produtos")) {
    db.createCollection("produtos");
}

// Limpar dados anteriores para repetir os testes
db.produtos.deleteMany({});

// Inserir catálogo
db.produtos.insertMany([

    // CELULAR
    {
        _id: "CEL001",
        nome: "Smartphone Galaxy",
        marca: {
            id: "MAR001",
            nome: "Samsung"
        },
        categoria: "Celular",
        preco: 1500.00,
        atributos: {
            memoria_ram: "8GB",
            armazenamento: "256GB",
            tela: "6.5 polegadas"
        }
    },

    // LIVRO
    {
        _id: "LIV001",
        nome: "Engenharia de Software",
        marca: {
            id: "MAR002",
            nome: "Editora Exemplo"
        },
        categoria: "Livro",
        preco: 80.00,
        atributos: {
            isbn: "9781234567890",
            paginas: 350,
            autor: "Autor Exemplo"
        }
    },

    // CAMISETA
    {
        _id: "CAM001",
        nome: "Camiseta Básica",
        marca: {
            id: "MAR003",
            nome: "Marca Exemplo"
        },
        categoria: "Camiseta",
        preco: 59.90,
        atributos: {
            tamanho: "M",
            cor: "Preto",
            material: "Algodão"
        }
    }

]);

// Índices para pesquisa
db.produtos.createIndex({ categoria: 1 });
db.produtos.createIndex({ "marca.id": 1 });

// Conferir inserção
print("Produtos cadastrados:");
printjson(db.produtos.find().toArray());
    