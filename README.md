<img src="https://img.shields.io/badge/Swift-UIKit-brightgreen">

# Hitchhiking

### Данный проект является курсовым в рамках обучения в школе [TeachMeSkills](https://teachmeskills.by) "iOS разработчик".

## Описание

Hitchhiking - это приложение для удобного поиска попуток и попутчиков по Беларуси, которое позволяет пользователям зарегистрироваться, войти в свою учетную запись и создавать или искать поездки. Приложение использует Firebase Authentication для аутентификации пользователей и Firebase Realtime Database для сохранения данных.

## Возможности 

- Регистрация нового пользователя и вход в учетную запись с использованием Firebase Authentication.
- Восстановление пароля через электронную почту с помощью Telegram бота для связи с разработчиками.
- Поиск поездок по дате и по городам из точки А в точку Б. Обязательной к заполнению является только дата, города - по желанию. Поэтому есть возможность посмотреть все поездки на определённую дату, и так же посмотреть все поездки из какого то города или в какой город в определённую дату.
- Создание новых поездок с указанием  имени водителя, даты, города отправления, города прибытия, контактного телефона и количества свободных мест.
- Просмотр списка доступных поездок с подробной информацией, включая город отправления, город назначения, дату, имя и контактный телефон водителя, и так же количество доступных мест.

## Архитектура

- MVP

## Технологии

- Swift
- UIKit
- Firebase Authentication
- Firebase realtime Database
- NSLayoutConstraint
- Telegram API

## Скриншоты

Все скриншоты были сделаны в симуляторе iPhone 14Pro.

![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/Login.png)  |  ![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/Registration.png) |  ![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/ForgotPassword.png)  |  ![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/WrongEmailAlert.png) |  ![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/SearchTrip.png)  |  ![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/SearchFrom.png) |  ![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/SearchTo.png)  |  ![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/NothingFoundAlert.png) |  ![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/CreateTrip.png)  |  ![](https://github.com/cl-1899/hitchhiking/blob/main/Screenshots/TripResults.png)

### Планируется доработка приложения

 - Более расширенный фунционал при регистрации (Apple Id, Gmail, по номеру телефона через смс)  
 - Автоматическое восстановление пароля (в данный момент только через помощь разработчика)  
 - Настройки (добавление в личный кабинет личной информации)  
 - Возможность бронирования поездки сразу в приложении без звонка  
 - Добавление карты в приложение  
 - После добавления карты реализовать предложения выбора промежуточных городов по пути водителю при создании поездки. 
