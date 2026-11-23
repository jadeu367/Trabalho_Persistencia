// R4 - Carrinho de compras
print('HSET carrinho:USR001 PROD001 2 PROD002 1');
print('HGETALL carrinho:USR001');
print('HINCRBY carrinho:USR001 PROD001 1');
print('HDEL carrinho:USR001 PROD002');
print('HGETALL carrinho:USR001');
