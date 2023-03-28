# Домашнее задание к лекции 2.«Условные конструкции. Операции сравнения»

## Задача №1
Задачи на [hackerrank](https://www.hackerrank.com/domains/python):  
Решить задачу на hackerrank ["Python If-Else"](https://www.hackerrank.com/challenges/py-if-else/problem).  

#### Ответ

```python
n = 3
if n % 2 == 0:
    if 2 < n < 5:
        print('Not Weird')
    elif 6 < n < 20:
        print('Weird')
    elif 21 < n:
        print('Not Weird')
else:
    print('Weird')       



n = 24
if n % 2 == 0:
    if 2 < n < 5:
        print('Not Weird')
    elif 6 < n < 20:
        print('Weird')
    elif 21 < n:
        print('Not Weird')
else:
    print('Weird')       
```

## Задача №2
На лекции мы рассматривали пример для военкомата. Сейчас мы знаем про его рост. Расширить это приложение следующими условиями:
1. Проверка на возраст призывника.
2. Количество детей.
3. Учится ли он сейчас.

#### Ответ

```python
height = 175
age = 25
kids = 1
studies = 'Нет'

if 18 <= age <= 27 and kids < 3 and studies == 'Нет':
  if height < 170:
    print('В танкисты')
  elif height < 180:
    print('На флот')
  elif height < 200:
    print('В десантники')
  else:
    print('В другие войска')
else:
  print('Непригоден')
```

## Задание №3
Разработать приложение для определения знака зодиака по дате рождения.  
Пример:  
```
Введите месяц: март
Введите число: 6

Вывод:
Рыбы
```

## Задание №4
К следующей лекции прочитать про циклы [for](https://foxford.ru/wiki/informatika/tsikl-for-v-python) и
 [while](https://foxford.ru/wiki/informatika/tsikl-while-v-python).

---
Инструкция по выполнению домашнего задания:

1. Зарегистрируйтесь на сайте [Repl.IT](https://repl.it/).
2. Перейдите в раздел **my repls**.
3. Нажмите кнопку **Start coding now!**, если приступаете впервые, или **New Repl**, если у вас уже есть работы.
4. В списке языков выберите Python.
5. Код пишите в левой части окна.
6. Посмотреть результат выполнения файла можно, нажав на кнопку **Run**. Результат появится в правой части окна.


*Никаких файлов прикреплять не нужно.*
