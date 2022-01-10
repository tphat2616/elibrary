insert into combo(name, book_id, song_id, label_id) 
    select 'test' || generate_series(1, 2000),
    trunc(random() * 7 + 1),
    trunc(random() * 400 + 2000),
    trunc(random() * 1673742 + 6737428);

-- using pg_trgm
explain analyze (select l.id, l.name, l.description, word_similarity('don', b.name) as acc, b.name as result
        from books as b
        join labels as l
        on b.label_id = l.id
        where b.name like '%don%'
        order by word_similarity('don', b.name) desc
        ) union
    (select l.id, l.name, l.description, word_similarity('don', s.name) as acc, s.name as result
        from songs as s
        join labels as l
        on s.label_id = l.id
        where s.name like '%don%'
        order by word_similarity('don', s.name) desc
        ) union
    (select l.id, l.name, l.description, word_similarity('don', c.name) as acc, c.name as result
        from combo as c
        join labels as l
        on c.label_id = l.id
        where c.name like '%don%'
        order by word_similarity('don', c.name) desc
        )
    order by acc desc
    limit 1;
-- using to_tsvector
explain analyze (select l.id, l.name, l.description, word_similarity('thinking', b.name) as acc, b.name as result
        from books as b
        join labels as l
        on b.label_id = l.id
        where to_tsquery('english', 'thinking') @@ to_tsvector('english', b.name)
        order by word_similarity('thinking', b.name) desc
        ) union
    (select l.id, l.name, l.description, word_similarity('thinking', s.name) as acc, s.name as result
        from songs as s
        join labels as l
        on s.label_id = l.id
        where to_tsquery('english', 'thinking') @@ to_tsvector('english', s.name)
        order by word_similarity('thinking', s.name) desc
        ) union
    (select l.id, l.name, l.description, word_similarity('thinking', c.name) as acc, c.name as result
        from combo as c
        join labels as l
        on c.label_id = l.id
        where to_tsquery('english', 'thinking') @@ to_tsvector('english', c.name)
        order by word_similarity('thinking', c.name) desc
        )
    order by acc desc
    limit 1;
-- List 10 most popular labels that are used to tag most.
explain analyze select l.id, l.name, l.description, sum(sub.tag_count) as sum
from labels as l
join
    (
        (select l.id, l.name, l.description, count(*) as tag_count
            from labels as l
            join books as b
            on l.id = b.label_id
            group by l.id
            order by tag_count
        ) union all
        (select l.id, l.name, l.description, count(*) as tag_count
            from labels as l
            join songs as s
            on l.id = s.label_id
            group by l.id
            order by tag_count
        ) union all
        (select l.id, l.name, l.description, count(*) as tag_count
            from labels as l
            join combo as c
            on l.id = c.label_id
            group by l.id
            order by tag_count
        )
    ) as sub
on sub.id = l.id
group by l.id
order by sum desc
limit 10;

-- Optimize
explain analyze select id, name, description, sum(tag_count) as sum from
    (
        (select l.id, l.name, l.description, count(*) as tag_count
            from labels as l
            join books as b
            on l.id = b.label_id
            group by l.id
            order by tag_count
        ) union all
        (select l.id, l.name, l.description, count(*) as tag_count
            from labels as l
            join songs as s
            on l.id = s.label_id
            group by l.id
            order by tag_count
        ) union all
        (select l.id, l.name, l.description, count(*) as tag_count
            from labels as l
            join combo as c
            on l.id = c.label_id
            group by l.id
            order by tag_count
        )
    ) as sub
    group by 1, 2, 3
    order by sum desc
    limit 10;