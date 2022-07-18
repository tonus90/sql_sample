use shop

SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by FIELD(id, 5, 1, 2);

select AVG(TIMESTAMPDIFF(Year, birthday_at, NOW())) 
from users;

