# devops-netology
new line
one more line
another line

terraform/.gitignore

**/.terraform/* -игнорирование данного скрытого каталога со всеми его вложениями в любом месте репозитория

*.tfstate 
*.tfstate.*  -игнорирование любых файлов с маркером tfstate

crash.log -игнор только этот файл
crash.*.log -игнор все лог файлы с пометкой crash

*.tfvars
*.tfvars.json -игнорирование файлов с подобными расширениями

override.tf
override.tf.json -игнор только данные файлы

*_override.tf
*_override.tf.json -игнор все файлы с данными параметрами в имени

.terraformrc
terraform.rc -игнор только данные файлы
