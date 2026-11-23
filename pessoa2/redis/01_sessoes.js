// R3 - Sessao com expiracao de 30 minutos
print('SET sessao:USR001 "usuario=USR001" EX 1800');
print('TTL sessao:USR001');
print('GET sessao:USR001');
