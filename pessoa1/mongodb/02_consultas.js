
db = db.getSiblingDB("marketplace");

// 1. Listar todos os produtos
print("TODOS OS PRODUTOS");
printjson(db.produtos.find().toArray());

// 2. Consultar celulares
print("PRODUTOS DA CATEGORIA CELULAR");
printjson(
    db.produtos.find({
        categoria: "Celular"
    }).toArray()
);

// 3. Consultar livros
print("PRODUTOS DA CATEGORIA LIVRO");
printjson(
    db.produtos.find({
        categoria: "Livro"
    }).toArray()
);

// 4. Consultar produtos da Samsung
print("PRODUTOS DA MARCA SAMSUNG");
printjson(
    db.produtos.find({
        "marca.id": "MAR001"
    }).toArray()
);

// 5. Consultar celulares com 8GB de RAM
print("CELULARES COM 8GB DE RAM");
printjson(
    db.produtos.find({
        categoria: "Celular",
        "atributos.memoria_ram": "8GB"
    }).toArray()
);
