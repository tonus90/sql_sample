use vk

alter table users change column birthdate birthday date; 
alter table friend_requests change column `status` `status` enum('requested', 'approved', 'unfriended', 'declined') default 'requested';
alter table users change column create_at created_at datetime default now();
alter table comments change column create_at created_at datetime default current_timestamp;
alter table likes_photo change column create_at created_at datetime default current_timestamp;
alter table likes_post change column create_at created_at datetime default current_timestamp;
alter table likes_user change column create_at created_at datetime default current_timestamp;
alter table messages change column create_at created_at datetime default current_timestamp;
alter table photo change column create_at created_at datetime default current_timestamp;
alter table posts change column create_at created_at datetime default current_timestamp;

insert into likes_photo (from_user_id, to_photo_id) values (44,13), (36, 13), (11,13); -- �������� ������ � ��, � ��� ��� ���� 44, 36, 11 �������� ���� 13, ���� ��������� ��� ���� ,
																					   -- �� � ���� 13 �������� ��� ����� �� ����� 44, ���� ������� ��������� ���� ���������, ���� �� ���� ����������



alter table likes_photo drop primary key; -- ���������� ��������� ������ ������ ������� ���� ���� id, ���� ����������� ��������� �����, ����� ����� ������� ���������
alter table vk.likes_photo add primary key(from_user_id, to_photo_id); -- ������ ��������� ����, ����� �� ���� ������ ����� ���� ��� ���� ����� �������������
alter table likes_photo change column id id bigint null; -- ������� ��� ������ id, � �������� ������ ���� ����� ���� �������
insert into likes_photo (from_user_id, to_photo_id) values (66,11); -- �������� ������ � �����, ��� ��������� ���������� ������� ������� ��� � ���� ������ Duplicate entry

CREATE TABLE `t_temp`  -- ���� ��������� ����� ���������� ������� ������ 12 ���� ���, ����� ��������� �� ��� ��� ��������. ��� ����� ������ �������� �� �������� ���������� �� ������ 28
as  (
   SELECT id
   FROM likes_photo
   GROUP BY from_user_id, to_photo_id
);
delete from likes_photo where likes_photo.id not in (select id from t_temp);

-- INSERT ... 

insert into communities (name) 
select name from snet.communities;
-- ������� ������������ - ����
INSERT INTO users 
set
	firstname='�����',
	lastname='�������',
	email='dcolquita@ucla.edu',
	phone=9744906651,
	gender='m',
	birthday='1990-09-18',
	hometown='������',
	pass='1487c1cf7c24df739fc97460a2c791a2432df062';

-- INSERT ... select

insert into communities (name) 
select name from snet0611.communities;

-- select

select from_user_id, to_post_id from likes_post -- ������� ��� ����� ������� ������ ���� � id 105
	where from_user_id = 105;

select * from users 
	where id=105; -- ���������� ������ ����� � id = 105, ������� ������ ����� �� ����������� �������
	
select from_user_id, to_post_id from likes_post -- 
	where to_post_id = 11; -- ������� id ���� �������������, ������� ������� ���� � id=11
	
select * from posts 
	where id=11;	-- ����������, ��� ����������� � ����� � id=11
	
select to_post_id, count(*) from likes_post group by to_post_id; -- ������� id ���� ������ � ������������ ������ � �������

select to_post_id, count(*) from likes_post group by to_post_id having count(*) > 60; -- ������� id ���� ������, � ������� ����� 60 ������ (����-2�����)

select * from likes_photo limit 10; -- ������� 10 ������� �� �������

select * from likes_photo limit 100 offset 250; -- ���������� ������ 10 ������� (offset), � �������� 10 (limit)

select * from likes_photo limit 100 offset 250; -- ���� ����� ��� � ����� ����

select * from likes_photo limit 250, 100; -- select * from users limit 8 offset 3;

-- �������� ������ ���� � �� �������� �������������
select filename, user_id, description from photo;

-- order by ������ ��� ��������� ���� � ��� �������� �� �������������
select filename, user_id, description from photo order by user_id; -- asc ���� ����� �� ����������� �� ��������� �-� 1-10

select filename, user_id, description from photo order by user_id desc; -- �� �������� - desc

-- ����� ��������� order by �� ���������� ��������, ���� �������� � ����� �� ������� ����� ���������, �� ����� ���� ���������� �� ������� �������
select filename, user_id, description from photo order by user_id, filename desc; -- ����� ������� ����������� ���������� ��� ������� ������� ��������

-- �� �����������, ����� ������ ��� �� ������� ������-��, �� ����� �������� ������ � �������� ��� �����

select 'hello'; -- � ������� ������ ������������  ����� ����������� ����� ������ ���������� � ��, ��� ���������

-- ������ ������� ����� ������ �������������� �������� ��� � ������� ��� � ���� �� ����
select 3*8;

-- ������� ������ ������������, ��������� ����, �� �������� ������ ���������� ����� ����� � ������� as ��� ����� ����� ������ ��� as
select concat(from_user_id, ' ', to_photo_id) as likes from likes_photo order by from_user_id;

-- ��� �������� �� ���������� ��������� � ��� ��� ������������ ���� � ����� ��� ���� ����� �� ��� ���� ���� VK
select concat(lastname, ' ', substring(firstname, 1, 1), '.') as persons from users; -- �������� ��� subctring(����� ������� �����, � ������� ������� ��������, ������� �������� ���������)

select distinct hometown from users; -- �������� �������������� ������� ��� ����������, ��� ���� ����� �� ��� ���� ���� VK


-- ������ �������� � ������� where
select * from users where hometown = 'ex'; -- ������� ���� ������� ��� ����� ex

-- ������� ������� ���������� �������
select lastname, firstname, hometown from users 
	where hometown = 'ex' or hometown = 'amet' or hometown = 'vel'; -- ����������� where � ���
	
select lastname, firstname, hometown, gender from users
	where hometown = 'vel' or gender = 'm'; -- ����������� � where

select lastname, firstname, hometown, gender from users
	where hometown = 'amet' and gender = 'm'; -- ������� ������ �� amet
	

-- ����� ����� ������������� �� ��������� �� �����
select lastname, firstname, hometown from users where hometown != 'vel'; -- ����� �� vel
select lastname, firstname, hometown from users where hometown <> 'ex';

select lastname, firstname, birthday from users where birthday >= '1988-01-01'; -- 88�� ���

select lastname, firstname, birthday from users where birthday >= '1988-01-01' and birthday <= '1990-01-01';
select lastname, firstname, birthday from users where birthday between '1985-01-01' and 
'1991-01-01'; 

