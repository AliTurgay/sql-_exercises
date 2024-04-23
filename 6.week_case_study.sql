-- Veri Setinin Notları:
-- • Müşterileri contactID temsil ediyor.
-- • Sepet sayısı için bookingID, yolcu sayısı için passengerID baz alınmalıdır. (Bir sepette birden fazla
-- yolcu(passengerID) olabilirken sadece bir contactID olabilir.)
-- • Üye olmayan müşterilerin, üyelik tarihi boş bırakılmıştır.
-- • paymentstatusler için iadeler başarılı veya başarısız sayılmamalıdır.


-- 1. Ekteki excel dosyasını kullanarak DB yapısı ve diagramını oluşturunuz.


-- 2. 
-- a. Müşteri(contactId) bazında toplam satış adetlerini, tutarları ve ortalama sepet tutarı
select contactid,
count(distinct b.id) as total_booking,
sum(amount) as sum_amount,
sum(amount)/count(distinct b.id) as avg_basket_amount
from booking as b join payment as py on b.Id = py.bookingid
where paymentstatus = 'ÇekimBaşarılı'
group by 1;

-- b. 2020 yılında aylık olarak; environment kırılımlarında toplam yolcu ve sepet sayılarını
select date_trunc('month', bookingdate) as month_of_booking,
environment,

count(ps.id) as number_of_passenger,
count(distinct b.id) as number_of_basket

from booking as b join passenger as ps on b.id = ps.bookingid

where b.bookingdate between '2020-01-01' and '2020-12-31'
group by 1,2
order by 1,2


-- c. Ödeme yapılan ay ve Kart Tipi ödeme başarı oranlarını hesaplayarak, grafikte gösteriniz.

select date_trunc('month', paymentdate) as month_of_payment,
cardtype,
paymentstatus,
count(distinct id) as number_of_payment
from payment
where paymentstatus != 'İade'
group by 1,2,3
order by 1,2,3






--Not : timestamp tipindeki veriyi ay formatı şeklinde görmek için şunu kullanın : date_trunc('month',column_name)
--Not : timestamp tipindeki veriyi yıl formatı şeklinde görmek için şunu kullanın : date_trunc('year',column_name)













