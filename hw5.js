// ФИО: Мацыкина А.C.

//Подсчитайте число элементов в созданной коллекции тегов в bd movies
db.movie.find().count()
//91106

//Подсчитайте число фильмов с конкретным тегом - Adventure
db.movie.find({"tag_name" : "Adventure"}).count()
//3496

//Используя группировку данных ($ groupby) вывести топ-3 самых распространенных тегов
db.movie.aggregate([ {$group: {_id: "$tag_name", tag_count: {$sum: 1}}}, {$sort: {tag_count: -1}}, {$limit: 3} ])
//{ "_id" : "Drama", "tag_count" : 20265 }
//{ "_id" : "Comedy", "tag_count" : 13182 }
//{ "_id" : "Thriller", "tag_count" : 7624 }
