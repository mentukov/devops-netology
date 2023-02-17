# Домашнее задание к занятию "7.Жизненный цикл ПО"

## Подготовка к выполнению
1. Получить бесплатную [JIRA](https://www.atlassian.com/ru/software/jira/free)
2. Настроить её для своей "команды разработки"
3. Создать доски kanban и scrum

## Основная часть
В рамках основной части необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить следующий жизненный цикл:
1. Open -> On reproduce
2. On reproduce -> Open, Done reproduce
3. Done reproduce -> On fix
4. On fix -> On reproduce, Done fix
5. Done fix -> On test
6. On test -> On fix, Done
7. Done -> Closed, Open

Остальные задачи должны проходить по упрощённому workflow:
1. Open -> On develop
2. On develop -> Open, Done develop
3. Done develop -> On test
4. On test -> On develop, Done
5. Done -> Closed, Open

Создать задачу с типом bug, попытаться провести его по всему workflow до Done. Создать задачу с типом epic, к ней привязать несколько задач с типом task, провести их по всему workflow до Done. При проведении обеих задач по статусам использовать kanban. Вернуть задачи в статус Open.
Перейти в scrum, запланировать новый спринт, состоящий из задач эпика и одного бага, стартовать спринт, провести задачи до состояния Closed. Закрыть спринт.
<img width="1133" alt="Снимок экрана 2023-02-17 в 19 19 16" src="https://user-images.githubusercontent.com/65667114/219639619-d57cbc01-2bad-4da7-8fcb-18f3b9f9930f.png">
<img width="1125" alt="Снимок экрана 2023-02-17 в 19 19 42" src="https://user-images.githubusercontent.com/65667114/219639706-aff84e6f-f065-47b4-8b67-ca451a6791cd.png">
<img width="1163" alt="Снимок экрана 2023-02-17 в 19 20 05" src="https://user-images.githubusercontent.com/65667114/219639792-a09c66c1-cdae-4852-84ef-e71afae31def.png">



Если всё отработало в рамках ожидания - выгрузить схемы workflow для импорта в XML. Файлы с workflow приложить к решению задания.
https://github.com/mentukov/devops-netology/blob/main/mnt-homeworks/09-ci-01-intro/for%20bug.xml
https://github.com/mentukov/devops-netology/blob/main/mnt-homeworks/09-ci-01-intro/for%20tasks.xml
---
