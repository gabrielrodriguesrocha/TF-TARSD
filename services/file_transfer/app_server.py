import json
from bottle import request, route, run, static_file
import sys

#Carrega o banco
db = TinyDB('db.json', sort_keys=True, indent=4, separators=(',', ': '))
#Define a tabela
service_table = db.table('service')

@route('/upload', method='POST')
def service_post():
	#Carrega do body da requisição o arquivo json recebido
	filename = request.forms.get('name')
	file_content = request.files.get('file')
	#Printa o arquivo recebido
	print('File Received:')
	print(filename)
	
	f = open(filename, "w")
	f.write(file_content)
	f.close()

@route('/download')
def service_get():
	filename = request.forms.get('name')
	return static_file(filename, root='/usr/src/app')



run(host='0.0.0.0',port=80,debug=True)