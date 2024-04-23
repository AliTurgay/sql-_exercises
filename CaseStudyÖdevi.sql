-- Veri Setinin Notları:
-- • Müşterileri contactID temsil ediyor. = telefon num
-- • Sepet sayısı için bookingID, yolcu sayısı için passengerID baz alınmalıdır. (Bir sepette birden fazla passıd= ali , esma
-- yolcu(passengerID) olabilirken sadece bir contactID olabilir.)
-- • Üye olmayan müşterilerin, üyelik tarihi boş bırakılmıştır.
-- • paymentstatusler için iadeler başarılı veya başarısız sayılmamalıdır.




-- 1. Ekteki excel dosyasını kullanarak DB yapısı ve diagramını oluşturunuz.
-- 2. 
-- a. Müşteri bazında toplam satış adetlerini, tutarları ve ortalama bilet fiyatlarını
select contactid,
count(distinct b.id) as toplam_satıs_Adedi,
sum(amount) as toplam_tutar ,
sum(amount)/count (distinct b.contactid) as ort_bilet
from booking as b join payment as py on b.id= py.bookingid
where paymentstatus = 'ÇekimBaşarılı'
group by 1



-- b. 2020 yılında aylık olarak; environment kırılımlarında toplam yolcu ve sepet sayılarını
select date_trunc ('month', bookingdate) as aylar ,
environment,
count(ps.id) as toplam_yolcu,
count(distinct b.id) as sepet_sayısı
from booking as b join passenger as ps on b.id=ps.bookingid
where b.bookingdate between '2020-01-01' and '2020-12-31'
group by 1 , 2
order by 1 , 2


SELECT *
FROM PASSENGER


-- c. Ödeme yapılan ay ve Kart Tipi ödeme başarı oranlarını hesaplayarak, grafikte gösteriniz.
select paymentstatus,
cardtype,
date_trunc('month', paymentdate ),
count (distinct id)  number_of_payment
from payment
where paymentstatus != 'iade'
group by 1,2,3

SELECT *
FROM PAYMENT

--Not : timestamp tipindeki veriyi ay formatı şeklinde görmek için şunu kullanın : date_trunc('month',column_name)
--Not : timestamp tipindeki veriyi yıl formatı şeklinde görmek için şunu kullanın : date_trunc('year',column_name)


select * from booking;

--date_trunc('month',column_name)

select date_trunc('month',bookingdate),
       bookingdate
from booking

;

select date_trunc('month',bookingdate),
       bookingdate
from booking
where bookingdate>='2020-01-01 00:00:00' AND bookingdate<'2021-01-01 00:00:00'
;


select date_trunc('month',bookingdate),
       date_trunc('year',bookingdate),
       to_char(bookingdate,'YYYY'),
       bookingdate
from booking
where bookingdate>='2020-01-01 00:00:00' AND bookingdate<'2021-01-01 00:00:00'
;
select count(id),
       bookingdate
from booking
group by 2
;

select distinct company from booking;

select distinct membersales from booking;

select distinct userid from booking;

select distinct userregisterdate from booking;

select distinct environemnt from booking;

select * from passenger;

select * from payment;

select distinct cardtype from payment;

select distinct paymentstatus from payment;


