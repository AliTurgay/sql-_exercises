--Aynı gün hem üye olup hem rezervasyon yapan müşterilerin ay kırılımında analizini yapınız.
--Aynı ay hem üye olup hem rezervasyon yapan müşterilerin ay kırılımında analizini yapınız.

--Müşteri kümesi için:
select *
from passenger


SELECT * FROM booking
WHERE date_trunc('day' , userregisterdate) = date_trunc('day' , bookingdate)
;

SELECT * FROM booking
WHERE userregisterdate::date = bookingdate::date
;

SELECT * FROM booking
WHERE to_char( userregisterdate, 'YYYY-MM-DD') = to_char( bookingdate, 'YYYY-MM-DD') 
;

--Hatırlatma
SELECT 
bookingdate,
bookingdate::date,
date_trunc('day' , bookingdate)
FROM booking
;

WITH customers as 
(
SELECT contactid FROM booking
WHERE date_trunc('day' , userregisterdate) = date_trunc('day' , bookingdate)
)

Select  to_char(bookingdate,'YYYY-MM') as booking_month,
to_char(bookingdate,'MM') as booking_month_,
COUNT(DISTINCT c.contactid) as customer_count,
COUNT(b.id) as booking_count,
SUM(p.amount) as total_amount
from customers as c  inner join booking as b ON b.contactid=c.contactid
inner join payment as p ON b.id=p.bookingid
GROUP BY 1,2
ORDER BY 1


--Aynı gün hem üye olup hem başarılı ödeme yapan müşterilerin ay kırılımında analizini yapınız.
--Aynı ay hem üye olup hem başarılı ödeme yapan müşterilerin ay kırılımında analizini yapınız.


--RFM Analizinin recency adımı.
--Recency: Müşterilerin son işlem tarihinin üzerinden geçen gün.
--Müşterileri son rezervasyon tarihinin üzerinden geçen güne göre sınıflandırınız.

-- age: İki tarih arasındaki farkı döndürür.
SELECT AGE('2022-06-02 12:30:15', '2022-06-01 12:30:15'::TIMESTAMP);

-- current_date: Bugünün tarihini döndürür.
SELECT current_date;
select bookingdate::date,current_date from booking limit 10 

-- 0-250 , 250-500, 500-1000, 1000+

WITH max_date as 
(SELECT 
contactid,
MAX(bookingdate)::date as max_date
FROM booking
group by 1)


SELECT 
COUNT(contactid) as customer_count,
case 
when (current_date-max_date)>=0 AND (current_date-max_date)<=250 THEN '0-250'
when (current_date-max_date)>250 AND (current_date-max_date)<=500 THEN '250-500'
when (current_date-max_date)>500 AND (current_date-max_date)<=1000 THEN '500-1000'
when (current_date-max_date)>1000 THEN '1000+' END AS recency
FROM max_date
GROUP BY 2;


--Yolcuları yaşlarına göre sınıflandırıp ortalama ödeme tutarı en yüksek olandan en düşük olana göre sıralayınız.
--10 yaş artacak şekilde sınıflandırabilirsiniz.

--Yolcular en çok hangi yaş grubunda rezervasyon yaptırmaktadır?

-- age: İki tarih arasındaki farkı döndürür.
SELECT AGE('2022-06-02 12:30:15', '2022-06-01 12:30:15'::TIMESTAMP); 

-- 22-32 , 32-42 , 42-52....

SELECT DISTINCT
id as passenger_id,
(current_date - dateofbirth)/365 as age,
EXTRACT ( YEAR FROM (AGE (current_date , dateofbirth ) )) as age_
FROM passenger
;

SELECT 

case 
when ((current_date - dateofbirth)/365) < 22  THEN '<22'
when ((current_date - dateofbirth)/365) BETWEEN 22 AND 32 THEN '22-32'
when ((current_date - dateofbirth)/365) BETWEEN 33 AND 42 THEN '33-42'
when ((current_date - dateofbirth)/365) BETWEEN 43 AND 52 THEN '43-52'
when ((current_date - dateofbirth)/365) BETWEEN 53 AND 62 THEN '53-62'
ELSE '63+' END AS age_segment,
COUNT(bookingid) as booking_count,
COUNT(distinct id) as passenger_count

FROM passenger

GROUP BY 1 
ORDER BY 2 desc;


--Ödemesi ile rezervasyonu aynı gün olan müşteriler, toplam müşterilerin yüzde kaçını oluşturmaktadır?

--Müşteri kümesi için:
SELECT contanctid
  FROM booking AS b
  LEFT JOIN payment AS p
    ON b.id = p.bookingid
 WHERE date(b.bookingdate) = date(p.paymentdate);



WITH contancts AS (
        SELECT count(DISTINCT b.contanctid) AS same_day_payment_contacts,
               ( SELECT count(DISTINCT contanctid)
                  FROM booking
               ) AS all_contacts
          FROM booking AS b
          LEFT JOIN payment AS p
            ON b.id = p.bookingid
         WHERE date(b.bookingdate) = date(p.paymentdate)
           AND p.paymentstatus = 'ÇekimBaşarılı'
       ) 
SELECT all_contacts,
       same_day_payment_contacts,
       round ((same_day_payment_contacts * 1.0 / all_contacts * 1.0) , 2) AS percentile
  FROM contancts
  


  
--Cinsiyet ve yaş grubu kırılımında ödeme tipi başarı oranını hesaplayın.
--Burada cinsiyet bilgisi yolcu(passenger) için var fakat ödeme bilgisi müşteri(contact) için var, o yüzden istenilen outputu veremiyoruz, soruyu aşağıdaki gibi değiştiriyorum:

--Cinsiyet ve yaş grubu kırılımında rezervasyon sayısını ve bu rezervasyonların tüm rezervasyonlardaki oranını hesaplayın.

WITH all_data AS (
        SELECT CASE WHEN ((CURRENT_DATE - dateofbirth) / 365) BETWEEN 22 AND 32 THEN '22-32'
                    WHEN ((CURRENT_DATE - dateofbirth) / 365) BETWEEN 33 AND 42 THEN '33-42'
                    WHEN ((CURRENT_DATE - dateofbirth) / 365) BETWEEN 43 AND 52 THEN '43-52'
                    WHEN ((CURRENT_DATE - dateofbirth) / 365) BETWEEN 53 AND 62 THEN '53-62'
                    WHEN ((CURRENT_DATE - dateofbirth) / 365) BETWEEN 63 AND 72 THEN '63-72'
                    ELSE '73+'
                     END AS age_segment,
               gender,
               count(DISTINCT bookingid) AS booking_count,
               (SELECT count(id)  FROM booking) AS total_booking_count
          FROM passenger
         GROUP BY 1,
                  2
         ORDER BY 2
       )
SELECT age_segment,
       gender,
       booking_count,
       total_booking_count,
       round( (booking_count * 1.0 / total_booking_count * 1.0) ,4 ) as percentage
  FROM all_data

--Üyelik durumu ve company kırılımında ortalama ödeme tutarını, rezervasyon sayısını ve toplam yolcu sayısını hesaplayın.

SELECT membersales,
       company,
       round(avg(py.amount),2) AS avg_amount,
       count(DISTINCT b.id) AS booking_count,
       count(DISTINCT p.id) AS passenger_count
  FROM booking AS b
  LEFT JOIN passenger AS p
    ON b.id = p.bookingid
  LEFT JOIN payment AS py
    ON b.id = py.bookingid
 GROUP BY 1,
          2





