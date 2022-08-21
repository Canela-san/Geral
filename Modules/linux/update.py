import os
print('Executando update geral')
print('Permita o acesso ao root:')
os.system('sudo echo Permisao recebida!')
os.system('sudo apt-get update -y')
os.system('sudo apt-get full-upgrade -y')
os.system('sudo apt-get autoremove -y')
os.system('sudo apt-get clean')
