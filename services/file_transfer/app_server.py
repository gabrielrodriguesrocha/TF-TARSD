import json
from bottle import request, route, run, static_file
import sys

@route('/upload', method='POST')
def service_post():
	#Carrega do body da requisição o arquivo json recebido
	file_recv = request.files.get('file')
	filename = file_recv.filename
	#Printa o arquivo recebido
	print('File Received:')
	print(filename)

	file_recv.save("/usr/src/app", overwrite=True)
	

@route('/download', method='POST')
def service_get():
	filename = request.forms.get('name')
	return static_file(filename, root='/usr/src/app')



run(host='0.0.0.0',port=80,debug=True)
