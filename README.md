# Sensor de temperaturas dos núcleos da CPU

Arquivos InstallSensorTemératuraCPU.sh e InstallSensorTemératuraCPU: executar no terminal como root, use **sudo** ou **su**.

Localiza sensores de temperatura e mostra as temperaturas dos núcleos da CPU a partir do terminal. Pode ser usado no **conky** usando o seguinte comando:

      ${color}Temp [CPU X]:${alignr}${exec sensor_temparatura --cpuX}${color}

no arquivo de configuração: **.conkyrc** que fica no diretório **home**.

Sendo **X** o número do núcleo do processador: X=1 até X=n.

Use o comando: **sensor_temparatura --help** para ver a quantidade de sensores localizados. 

## Dependências

- shc
- libc6-dev
- dialog (A dependência **dialog** está disponível em diversas distribuições baseadas em Debian, caso não haja, será instalada.)
