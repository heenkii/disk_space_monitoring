## Настройка

ansible-vault create vault.yml
ansible_become_password: "password"

Заполнить данные в inventory.ini

## Развертка скрипта на сервере

ansible-playbook -i inventory.ini deploy_disk_monitor.yml --ask-vault-pass

## Скопировать логи

ansible-playbook -i inventory.ini deploy_disk_monitor.yml --tags fetch_log --ask-vault-pass

## (Дополнительно) Удалить скрипт

ansible-playbook -i inventory.ini remove_disk_monitor.yml --ask-vault-pass
