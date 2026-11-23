// R5 - Visualizacoes e ranking
print('INCR visualizacoes:PROD001');
print('INCR visualizacoes:PROD001');
print('INCR visualizacoes:PROD002');
print('ZINCRBY ranking:produtos 2 PROD001');
print('ZINCRBY ranking:produtos 1 PROD002');
print('ZRANGE ranking:produtos 0 -1 WITHSCORES');
print('ZREVRANGE ranking:produtos 0 -1 WITHSCORES');
