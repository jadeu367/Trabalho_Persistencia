
db = db.getSiblingDB("marketplace");

db.produtos.find().forEach(function(produto) {

    // Comandos Redis sem mensagens adicionais
    print("SADD marca:" + produto.marca.id +
          ":produtos " + produto._id);

    print("HSET produto:" + produto._id +
          " nome " + JSON.stringify(produto.nome) +
          " preco " + produto.preco +
          " marca " + JSON.stringify(produto.marca.nome) +
          " categoria " + JSON.stringify(produto.categoria));

});
