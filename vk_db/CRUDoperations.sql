alter table users change column birthdate birthday date; -- были ошибки в названии некоторых полей, до строки 10 исправляю
alter table friend_requests change column status status enum('requested', 'approved', 'unfriended', 'declined') default 'requested';
alter table users change column create_at created_at datetime default now();
alter table comments change column create_at created_at datetime default current_timestamp;
alter table likes_photo change column create_at created_at datetime default current_timestamp;
alter table likes_post change column create_at created_at datetime default current_timestamp;
alter table likes_user change column create_at created_at datetime default current_timestamp;
alter table messages change column create_at created_at datetime default current_timestamp;
alter table photo change column create_at created_at datetime default current_timestamp;
alter table posts change column create_at created_at datetime default current_timestamp;

insert into likes_photo (from_user_id, to_photo_id) values (44,13), (36, 13), (11,13); -- вставить запись в бд, о том что юзер 44, 36, 11 лайкнули фото 13, если исполнить два раза ,
																					   -- то у фото 13 появится два лайка от юзера 44, надо сделать первичный ключ составной, чтоб не было повторений



alter table likes_photo drop primary key; -- изначально пирвичным ключем данной таблицы было поле id, снял ограничение ервичного ключа, чтобы потом сделать составной
alter table vk.likes_photo add primary key(from_user_id, to_photo_id); -- сделал составной ключ, чтобы не было лайков одной фото два раза одним пользователем
alter table likes_photo change column id id bigint null; -- изменил тип данных id, в принципе данное поле можно было удалить
insert into likes_photo (from_user_id, to_photo_id) values (66,11); -- вставляю запись о лайке, при повторном выполнении данного запроса как и надо ошибка Duplicate entry

CREATE TABLE `t_temp`  -- были дубликаты после выполнения запроса строка 12 пару раз, когда первичнык не был еще измененн. для этого сделал операцию по удалению дубликатов до строки 28
as  (
   SELECT id
   FROM likes_photo
   GROUP BY from_user_id, to_photo_id
);
delete from likes_photo where likes_photo.id not in (select id from t_temp);

-- INSERT ... 

insert into communities (name) 
select name from snet.communities;
-- Добавил пользователя - себя
INSERT INTO users 
set
	firstname='Эмиль',
	lastname='Грабчук',
	email='dcolquita@ucla.edu',
	phone=9744906651,
	gender='m',
	birthday='1990-09-18',
	hometown='Москва',
	pass='1487c1cf7c24df739fc97460a2c791a2432df062';

-- INSERT ... select

insert into communities (name) 
select name from snet0611.communities;

-- select

select from_user_id, to_post_id from likes_post -- выбрать все посты которые лайкал юзер с id 105
	where from_user_id = 105;

select * from users 
	where id=105; -- посмотреть данные юзера с id = 105, который лайкал посты из предыдущего запроса
	
select from_user_id, to_post_id from likes_post -- 
	where to_post_id = 11; -- выбрать id всех пользователей, которые лайкали пост с id=11
	
select * from posts 
	where id=11;	-- посмотреть, что содержалось в посте с id=11
	
select to_post_id, count(*) from likes_post group by to_post_id; -- вывести id всех постов с количествами лайков к каждому

select to_post_id, count(*) from likes_post group by to_post_id having count(*) > 60; -- вывести id всех постов, у который болье 60 лайков (итог-2поста)

select * from likes_photo limit 10; -- выбрать 10 записей из таблицы

select * from likes_photo limit 100 offset 250; -- пропускаем первые 10 записей (offset), и выбираем 10 (limit)

select * from likes_photo limit 100 offset 250; -- тоже самое что и перед этим

select * from likes_photo limit 250, 100; -- select * from users limit 8 offset 3;

-- получить список фото и их описаний пользователей
select filename, user_id, description from photo;

-- order by список для просмотра фото и его описания по пользователям
select filename, user_id, description from photo order by user_id; -- asc тоже самое по возрастанию по умолчанию а-я 1-10

select filename, user_id, description from photo order by user_id desc; -- по убыванию - desc

-- можно прописать order by по нескольким столбцам, если значение в каком то столбце будет совпадать, то будет идти сортировка по другому столбцу
select filename, user_id, description from photo order by user_id, filename desc; -- можно сделать направление сортировки для каждого столбца отдельно

-- не обязательно, чтобы селект что то выбирал откуда-то, мы можем выводить данные в терминал как принт

select 'hello'; -- в больших дампах используется  чтобы отслеживать какие данные добавились и тд, что произошло

-- внутри селекта можно делать арифметические операции как в выборке так и сами по себе
select 3*8;

-- выводим список пользователь, лайкнутые фото, но название списка некрасивое нужел алиас с помощью as или можно через пробел без as
select concat(from_user_id, ' ', to_photo_id) as likes from likes_photo order by from_user_id;

-- как работать со строковыми функциями и как они вкладываются друг в друга ТУТ ТОЖЕ САМОЕ НО ДЛЯ МОЕЙ БАЗЫ VK
select concat(lastname, ' ', substring(firstname, 1, 1), '.') as persons from users; -- обрезали имя subctring(какой столбец берем, с какомго символа начинаем, сколько символов оставляем)

select distinct hometown from users; -- получить результирующую выборку без повторений, ТУТ ТОЖЕ САМОЕ НО ДЛЯ МОЕЙ БАЗЫ VK


-- мощный параметр в селекте where
select * from users where hometown = 'ex'; -- выбрать всех жителей где город ex

-- выбрать жителей нескольких городов
select lastname, firstname, hometown from users 
	where hometown = 'ex' or hometown = 'amet' or hometown = 'vel'; -- ограничения where с или
	
select lastname, firstname, hometown, gender from users
	where hometown = 'vel' or gender = 'm'; -- ограничение с where

select lastname, firstname, hometown, gender from users
	where hometown = 'amet' and gender = 'm'; -- выборка мужчин из amet
	

-- можно найти пользователей не москвичей не равно
select lastname, firstname, hometown from users where hometown != 'vel'; -- город НЕ vel
select lastname, firstname, hometown from users where hometown <> 'ex';

select lastname, firstname, birthday from users where birthday >= '1988-01-01'; -- 88ой год

select lastname, firstname, birthday from users where birthday >= '1988-01-01' and birthday <= '1990-01-01';
select lastname, firstname, birthday from users where birthday between '1985-01-01' and 
'1991-01-01'; 

