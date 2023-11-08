
select * from content 
select * from reactions
select * from reactiontypes


---DATA CLEANING

--renaming column name
use [SQL Tutorial]
exec sp_rename
'Reactions.[User ID]',
'User_id'

use [SQL Tutorial]
exec sp_rename
'Content.[Content ID]',
'content_id'

use [sql tutorial]
exec sp_rename
'content.type',
'content_type'

use[sql tutorial]
exec sp_rename
'reactions.type',
'reaction_type'


--removing special character
update content
set Category = replace(category,'"""','');

--deleting column
alter table content
drop column URL

--removing blank values from reactions table
delete from reactions
where type = '';
delete from reactions
where user_id = '';

--capitalizing category column name
update content
set category =
upper(substring(category, 1, 1)) + 
Lower(substring(category, 2, Len(category) -1))

select category from content 
group by category
order by category

--Data Analysis and problem solution

---top 5 performing categories by popularity
select top 5 co.Category, sum(r.score) as Total_score 
from Reactions as c 
inner join ReactionTypes as r
on c.reaction_type = r.type
inner join Content as co
on co.content_id = c.Content_id
group by co.Category
order by Total_score desc

---the categories that has above the average score of the top 5 best categories
select co.Category, sum(r.score) as Total_score 
from Reactions as c 
inner join ReactionTypes as r
on c.reaction_type = r.type
inner join Content as co
on co.content_id = c.Content_id
group by co.Category
--group by co.Category
having sum(r.score) >
	(select avg(total_score) as avg 
from
	(select top 5 co.Category, sum(r.score) as Total_score 
from Reactions as c 
inner join ReactionTypes as r
on c.reaction_type = r.type
inner join Content as co
on co.content_id = c.Content_id
group by co.Category
order by sum(r.score) desc) s)
order by total_score desc

---setiment by score
select sentiment, sum(Score) as Total_score from reactiontypes
group by sentiment
order by Total_score desc

---ContentType by score_popularity
select co.content_type, sum(r.score) as total_score
from content as co
inner join reactions as re
on co.content_id = re.content_id
inner join reactiontypes as r
on r.type = re.reaction_type
group by co.content_type
order by total_score desc

---ReactionType by score_popularity
select reactions.reaction_type, sum(reactiontypes.score) as total_score 
from reactions  
inner join reactiontypes 
on reactions.reaction_type = reactiontypes.type
where reactiontypes.score > 0
group by reactions.reaction_type
order by total_score desc

select * from content
select * from reactions
select * from reactiontypes

--count of likeness_likelihood by content_type and content_type
select c.content_type, r.reaction_type, count(r.reaction_type) as count_likeness_likelihood
from content as c
inner join reactions as r 
on c.content_id = r.content_id
--where content_type = 'audio' and reaction_type = 'hate'
group by c.content_type, r.reaction_type
order by c.content_type 

