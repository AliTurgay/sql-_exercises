--RFM Analizi

--RFM, "Recency", "Frequency" ve "Monetary" kelimelerinin baş harflerinden oluşur.

--Recency, müşterinin son alışveriş tarihinin üzerinden geçen gün sayısını ifade eder.
--Frequency, müşterinin ne sıklıkla alışveriş yaptığını ifade eder. 
--Monetary, müşterinin yaptığı harcamaların toplam tutarını ifade eder.


--Recency, müşterinin son alışveriş tarihinin üzerinden geçen gün sayısını ifade eder.
-- Recency hesaplamak için, müşterinin son alışveriş tarihinden bugünün tarihini çıkarın. Bu, müşterinin son alışverişinin ne kadar süre önce yapıldığını gösterir.
-- Örneğin, müşteri A son alışverişini 60 gün önce yaptıysa, Recency değeri 60'dır.


-- Frequency, müşterinin ne sıklıkla alışveriş yaptığını ifade eder. Yani müşteri ortalama kaç gün aralıklarla alışveriş yapıyor.
-- Bazı şirketler de müşterilerin şu ana kadarki sipariş/alışveriş sayısını frequency olarak kabul eder.
-- Örneğin, müşteri A toplamda 10 alışveriş yapmışsa, Frequency değeri 10'dur.


-- Monetary, müşterinin yaptığı harcamaların toplam tutarını ifade eder.
-- Monetary hesaplamak için, müşterinin yaptığı toplam harcamayı hesaplayın.
-- Örneğin, müşteri A toplamda 500 TL harcamışsa, Monetary değeri 500'dür.


-- Her bir müşteri için RFM skorunu hesaplamak için, Recency, Frequency ve Monetary değerlerine puanlar verin. Bu puanlar genellikle 1-5 arasındadır, ancak isteğe bağlı olarak farklı aralıklar da kullanılabilir.
-- Örneğin, Recency değeri 60 olan müşteri A'ya 1 puan, Frequency değeri 10 olan müşteri A'ya 4 puan ve Monetary değeri 500 olan müşteri A'ya 3 puan verilirse, RFM skoru 1-4-3 olacaktır.

-- RFM skorlarına göre müşterileri segmentlere ayırın. Bu segmentler, müşterilerin değerlerine ve ihtiyaçlarına göre farklı pazarlama stratejileri belirlemek için kullanılabilir.
-- Örneğin, RFM skoru 4-5-5 olan müşteriler, en değerli müşteriler olarak kabul edilebilir ve onlara özel indirimler veya promosyonlar sunulabilir.



--RFM analizi yaparken,ödeme işlemi sorunsuz olarak tamamlanan alışverişler baz alınır. 

--Recency 
--Önce her müşterinin son rezervasyon tarihini getirin.
select 
contactid,
max(bookingdate) as son_rezrv_date
from booking
group by contactid
order by 1





--Daha sonra her müşterinin son sipariş tarihi ile bugünün tarihi arasında kaç gün var hesaplayın.
with tablo as (
select 
contactid,
	max(bookingdate) as son_date
from booking
group by contactid 
	)
	select contactid,
	son_date,
	current_date - son_date as recency
	from tablo
	order by 1 asc




--Burda bugün '2021-05-27' gibi hesap yapıldı, çünkü içerideki max(bookingdate) = '2021-05-27'
WITH max_bd as (
SELECT contactid, 
	max(bookingdate) as last_booking_date
	FROM booking as b INNER JOIN payment as p ON p.bookingid=b.id 
	WHERE p.paymentstatus='ÇekimBaşarılı' 
	group by 1 
	order by 1
)
select  contactid,
        last_booking_date,
        '2021-05-27'::date-last_booking_date as recency
from max_bd
;


--Frequency
--Her müşterinin bugüne kadarki başarılı rezervasyon sayısını getirin.

select 
contactid,
count(distinct b.id) as frequency 
from booking as b join payment as py on b.id=py.bookingid
where py.paymentstatus ='ÇekimBaşarılı'
group by 1
order by 1


select *
from payment




--Monetary
--Her müşterinin bugüne kadarki başarılı toplam ödeme tutarını getirin.
select contactid,
sum(amount) as monetary 
from  booking as b join payment as py on b.id=py.bookingid
where py.paymentstatus = 'ÇekimBaşarılı'
group by 1
order by 1




------------
WITH recency_ AS (
        WITH max_bd AS (
                SELECT contactid,
                       max(bookingdate) AS last_booking_date
                  FROM booking AS b
                 INNER JOIN payment AS p
                    ON p.bookingid = b.id
                 WHERE p.paymentstatus = 'ÇekimBaşarılı'
                 GROUP BY 1
                 ORDER BY 1
               ) SELECT contactid,
               last_booking_date,
               ('2021-05-27'::date - last_booking_date) AS recency
          FROM max_bd
       ),
frequency_ AS (
        SELECT contactid,
               count(DISTINCT b.id) AS frequency
          FROM booking AS b
         INNER JOIN payment AS p
            ON p.bookingid = b.id
         WHERE p.paymentstatus = 'ÇekimBaşarılı'
         GROUP BY 1
         ORDER BY 1
       ),
monetary_ AS (
        SELECT b.contactid,
               sum(p.amount) AS monetary
          FROM payment AS p
         INNER JOIN booking AS b
            ON p.bookingid = b.id
         WHERE paymentstatus = 'ÇekimBaşarılı'
         GROUP BY 1
       )
	   

SELECT 

    r.contactid,
	
    r.recency,
    NTILE(5) OVER (ORDER BY recency desc) as recency_point,
	
    f.frequency,
    CASE WHEN f.frequency= 1 THEN 1
    WHEN f.frequency= 2 THEN 2
    WHEN f.frequency= 3 THEN 3
    WHEN f.frequency= 4 THEN 4
    WHEN f.frequency>= 5 THEN 5 END as frequency_point,

    m.monetary,
    NTILE(5) OVER (ORDER BY monetary ) as monetary_point
	
FROM recency_ as r 
INNER JOIN frequency_ as f ON r.contactid=f.contactid
INNER JOIN monetary_ as m ON m.contactid=r.contactid
;

-----------------------------------

with recency_ as (
with tablo as (
select 
contactid,
	max(bookingdate) as son_date
from booking
group by contactid 
	)
	select contactid,
	son_date,
	current_date - son_date as recency
	from tablo
	order by 1 asc
),

frequency_ as(
select 
contactid,
count(distinct b.id) as frequency 
from booking as b join payment as py on b.id=py.bookingid
where py.paymentstatus ='ÇekimBaşarılı'
group by 1
order by 1
			 ),
			 
monetary_ as (
	select contactid,
sum(amount) as monetary 
from  booking as b join payment as py on b.id=py.bookingid
where py.paymentstatus = 'ÇekimBaşarılı'
group by 1
order by 1 
)


select 

r.contactid,
r.recency ,
NTILE(5) OVER (ORDER BY recency desc) as recency_point,


f.frequency,
    CASE WHEN f.frequency= 1 THEN 1
    WHEN f.frequency= 2 THEN 2
    WHEN f.frequency= 3 THEN 3
    WHEN f.frequency= 4 THEN 4
    WHEN f.frequency>= 5 THEN 5 END as frequency_point,

m.monetary,
    NTILE(5) OVER (ORDER BY monetary ) as monetary_point


FROM recency_ as r 
INNER JOIN frequency_ as f ON r.contactid=f.contactid
INNER JOIN monetary_ as m ON m.contactid=r.contactid




















 